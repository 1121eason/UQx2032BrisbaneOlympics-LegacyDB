#!/usr/bin/env python3
"""Dependency-free structural and query smoke check using SQLite adapters.

This checks the packaged data and reporting logic. It is NOT a MySQL execution
test: MySQL types, collations, privileges, SQL modes and optimizer differ.
"""
from pathlib import Path
import csv
import json
import re
import sqlite3

ROOT = Path(__file__).resolve().parents[1]


def statements(text):
    """Split this repository's SQL while respecting strings and SQL comments."""
    buf, quote, i = [], None, 0
    while i < len(text):
        c = text[i]
        if quote:
            buf.append(c)
            if c == '\\' and i + 1 < len(text):
                i += 1
                buf.append(text[i])
            elif c == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    i += 1
                    buf.append(text[i])
                else:
                    quote = None
        elif text.startswith('--', i) and (i + 2 == len(text) or text[i + 2].isspace()):
            end = text.find('\n', i)
            i = len(text) if end < 0 else end
            buf.append('\n')
            continue
        elif text.startswith('/*', i):
            end = text.find('*/', i + 2)
            if end < 0:
                raise ValueError('Unterminated block comment')
            i = end + 2
            continue
        elif c in "'\"`":
            quote = c
            buf.append(c)
        elif c == ';':
            if ''.join(buf).strip():
                yield ''.join(buf).strip()
            buf = []
        else:
            buf.append(c)
        i += 1
    if quote:
        raise ValueError('Unterminated SQL quote')
    if ''.join(buf).strip():
        yield ''.join(buf).strip()


def mysql_rows(values):
    """Parse mysqldump VALUES literals without executing them as Python."""
    rows, row, token, quoted, was_quoted, i = [], [], [], False, False, 0
    escapes = {'0': '\0', 'n': '\n', 'r': '\r', 't': '\t', 'b': '\b', 'Z': '\x1a'}

    def finish():
        value = ''.join(token)
        if was_quoted:
            return value
        value = value.strip()
        if value.upper() == 'NULL':
            return None
        if re.fullmatch(r'-?\d+', value):
            return int(value)
        return float(value)

    while i < len(values):
        c = values[i]
        if quoted:
            if c == '\\':
                i += 1
                token.append(escapes.get(values[i], values[i]))
            elif c == "'":
                if i + 1 < len(values) and values[i + 1] == "'":
                    token.append("'")
                    i += 1
                else:
                    quoted = False
            else:
                token.append(c)
        elif c == "'":
            quoted, was_quoted = True, True
        elif c == '(':
            row, token, was_quoted = [], [], False
        elif c in ',)':
            if c == ',' and not token and not was_quoted:
                i += 1
                continue
            row.append(finish())
            token, was_quoted = [], False
            if c == ')':
                rows.append(row)
        elif not (was_quoted and c.isspace()):
            token.append(c)
        i += 1
    return rows


def adapt(sql, variables):
    for key, value in variables.items():
        sql = re.sub(r'@' + re.escape(key) + r'\b', value, sql)
    sql = re.sub(r'CAST\((mwc\.logDate) AS DATETIME\)', r"datetime(\1)", sql, flags=re.I)
    sql = re.sub(r'CREATE OR REPLACE SQL SECURITY INVOKER VIEW', 'CREATE VIEW', sql, flags=re.I)
    return sql


def main():
    db = sqlite3.connect(':memory:')
    db.create_function('CONCAT', -1, lambda *args: None if None in args else ''.join(map(str, args)))
    tables = json.loads((ROOT/'docs/schema-metadata.json').read_text())
    ddl = (ROOT/'database/01_schema.sql').read_text()
    for name, body in re.findall(r'CREATE TABLE `([^`]+)` \((.*?)\) ENGINE=', ddl, re.S):
        lines = []
        for line in body.splitlines():
            if re.match(r'\s*KEY ', line):
                continue
            line = re.sub(r'UNIQUE KEY `[^`]+`', 'UNIQUE', line)
            line = re.sub(r' AUTO_INCREMENT\b', '', line)
            lines.append(line)
        db.execute(f'CREATE TABLE `{name}` (' + '\n'.join(lines) + ')')
    row_counts = {}
    for statement in statements((ROOT/'database/02_demo_data.sql').read_text()):
        m = re.match(r'INSERT INTO `([^`]+)` VALUES (.*)', statement, re.S)
        if m:
            rows = mysql_rows(m[2])
            db.executemany(f'INSERT INTO `{m[1]}` VALUES ({",".join("?" for _ in rows[0])})', rows)
    for table in tables:
        row_counts[table['table']] = db.execute(f'SELECT COUNT(*) FROM `{table["table"]}`').fetchone()[0]
    orphans = db.execute('PRAGMA foreign_key_check').fetchall()
    assert not orphans, f'Orphan references: {orphans[:10]}'
    for sql in statements((ROOT/'database/03_views.sql').read_text()):
        if not sql.upper().startswith('USE '):
            db.execute(adapt(sql, {}))
    (ROOT/'evidence').mkdir(exist_ok=True)
    query_results = []
    for path in sorted((ROOT/'queries').glob('*.sql')):
        variables, index = {}, 0
        for sql in statements(path.read_text()):
            if sql.upper().startswith('USE '):
                continue
            variable = re.fullmatch(r'SET @(\w+)\s*=\s*(.*)', sql, re.S)
            if variable:
                variables[variable[1]] = variable[2]
                continue
            cursor = db.execute(adapt(sql, variables))
            if cursor.description:
                rows = cursor.fetchall()
                index += 1
                filename = f'{path.stem}_result_{index}.csv'
                with (ROOT/'evidence'/filename).open('w', newline='') as handle:
                    writer = csv.writer(handle)
                    writer.writerow([c[0] for c in cursor.description])
                    writer.writerows(rows)
                query_results.append({'query':path.name, 'result_set':index,'rows':len(rows),'file':filename})
    report = {
        'engine': 'SQLite ' + sqlite3.sqlite_version,
        'validation_scope': 'Portable structural and adapted-query smoke test; not MySQL runtime validation.',
        'domain_tables':len(tables),
        'foreign_keys':sum(len(t['foreign_keys']) for t in tables),
        'orphan_foreign_keys':len(orphans),
        'total_rows':sum(row_counts.values()),
        'row_counts':row_counts,
        'query_results':query_results,
        'mysql_runtime_validation':'not_run_in_preparation_environment',
        'adaptations':['MySQL session variables substituted with literal dates.', 'MySQL datatypes/index syntax adapted for SQLite.', 'CAST(date AS DATETIME) adapted to SQLite datetime(date).', 'CONCAT registered as a SQLite function.', 'Views created without MySQL security clauses.'],
    }
    (ROOT/'evidence/portable-validation.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ['engine','domain_tables','foreign_keys','orphan_foreign_keys','total_rows','query_results','mysql_runtime_validation']},indent=2))


if __name__ == '__main__':
    main()
