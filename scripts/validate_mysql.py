#!/usr/bin/env python3
"""Run packaged queries and integrity checks against an existing MySQL demo DB."""
from pathlib import Path
import argparse
import json
import os
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--docker', action='store_true', help='Use the included Docker Compose service.')
    args = parser.parse_args()
    if args.docker:
        command = ['docker', 'compose', 'exec', '-T', 'db', 'sh', '-c',
                   'MYSQL_PWD="$MYSQL_ROOT_PASSWORD" exec mysql --batch --raw --default-character-set=utf8mb4 -uroot olympicdb']
    else:
        if not shutil.which('mysql'):
            parser.error('mysql client not found. Install MySQL 8 client or use --docker.')
        command = ['mysql', '--protocol=TCP', '--batch', '--raw', '--default-character-set=utf8mb4',
                   '--host='+os.environ.get('MYSQL_HOST','127.0.0.1'),
                   '--port='+os.environ.get('MYSQL_PORT','3306'),
                   '--user='+os.environ.get('MYSQL_USER','root'), 'olympicdb']

    def run(sql):
        return subprocess.run(command, input=sql, text=True, capture_output=True, cwd=ROOT, check=True).stdout

    metadata = json.loads((ROOT/'docs/schema-metadata.json').read_text())
    expected = json.loads((ROOT/'evidence/portable-validation.json').read_text())
    # Missing tables and incomplete imports must fail, even if some reports return rows.
    for table in metadata:
        name = table['table']
        output = run(f'SELECT COUNT(*) AS n FROM `{name}`;')
        actual = int(output.strip().splitlines()[-1])
        if actual != expected['row_counts'][name]:
            raise SystemExit(f'{name}: expected {expected["row_counts"][name]} demo rows, found {actual}')
    checks = run((ROOT/'checks/01_foreign_keys.sql').read_text())
    violations = [line for line in checks.strip().splitlines()[1:] if int(line.rsplit('\t',1)[1]) != 0]
    if violations:
        raise SystemExit('Foreign-key violations:\n'+'\n'.join(violations))
    print('PASS: all 41 domain tables have expected demo row counts; no orphan references.')
    for path in sorted((ROOT/'queries').glob('*.sql')):
        output = run(path.read_text())
        if not output.strip():
            raise SystemExit(f'{path.name} returned no tabular output')
        print(f'PASS: {path.name}')
    print('\nQuality review (informational; inspect any non-zero counts):')
    print(run((ROOT/'checks/02_quality_review.sql').read_text()))
    print('MySQL runtime checks completed. Report outputs still require business review.')


if __name__ == '__main__':
    try:
        main()
    except subprocess.CalledProcessError as exc:
        raise SystemExit(exc.stderr or str(exc)) from exc
