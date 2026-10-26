#!/usr/bin/env python3
"""Replace known identity/contact fields in this project's exported demo data.

This is a schema-specific demonstration transformation, not a universal
anonymization guarantee for arbitrary medical or personal datasets.
"""
from pathlib import Path
import argparse
import json
import re
from validate_portable import mysql_rows, statements

ROOT = Path(__file__).resolve().parents[1]


def literal(value):
    if value is None:
        return 'NULL'
    if isinstance(value, (int, float)):
        return str(value)
    escaped = str(value).replace('\\', '\\\\').replace("'", "''")
    for a, b in [('\0','\\0'), ('\n','\\n'), ('\r','\\r'), ('\t','\\t')]:
        escaped = escaped.replace(a,b)
    return "'" + escaped + "'"


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args=parser.parse_args()
    if args.input.resolve()==args.output.resolve():
        parser.error('Input and output must be different files.')
    metadata=json.loads((ROOT/'docs/schema-metadata.json').read_text())
    columns={t['table']:[c['name'] for c in t['columns']] for t in metadata}
    output=[
        '-- PUBLIC DEMONSTRATION DATA: known personal/contact fields replaced.',
        '-- Person names, birth dates, staff registration numbers, supplier/contractor',
        '-- names and contact emails are artificial placeholders. Operational metrics',
        '-- are retained from the academic fictional/test dataset; not real Games data.',
        'USE olympicdb;', 'SET NAMES utf8mb4;',
        'SET @portfolio_old_fk_checks = @@FOREIGN_KEY_CHECKS;',
        'SET FOREIGN_KEY_CHECKS = 0;', 'START TRANSACTION;', '',
    ]
    changed={}
    for sql in statements(args.input.read_text()):
        match=re.match(r'INSERT INTO `([^`]+)` VALUES (.*)',sql,re.S)
        if not match:
            continue
        table=match[1]
        rows=mysql_rows(match[2])
        changed[table]=0
        for row in rows:
            record=dict(zip(columns[table],row))
            updates={}
            if table=='person':
                key=record['personId']
                updates={'firstName':f'DemoGiven{key}', 'lastName':f'DemoFamily{key}',
                         'dateOfBirth':f'{1990+key%20:04d}-01-01'}
            elif table=='medicalstaff':
                updates={'registrationNumber':f'DEMO-REG-{record["personId"]}'}
            elif table=='supplier':
                key=record['supplierId']
                updates={'supplierName':f'Demo Supplier {key}', 'contactEmail':f'supplier{key}@example.com'}
            elif table=='contractor':
                key=record['contractorId']
                updates={'contractorName':f'Demo Contractor {key}', 'contactEmail':f'contractor{key}@example.com'}
            if updates:
                changed[table]+=1
                for name,value in updates.items(): row[columns[table].index(name)]=value
        output.append(f'INSERT INTO `{table}` VALUES '+','.join('('+','.join(map(literal,row))+')' for row in rows)+';\n')
    output.extend(['COMMIT;', 'SET FOREIGN_KEY_CHECKS = @portfolio_old_fk_checks;', ''])
    args.output.write_text('\n'.join(output))
    print(json.dumps({'output':str(args.output),'identity_rows_replaced':{k:v for k,v in changed.items() if v}},indent=2))


if __name__=='__main__':
    main()
