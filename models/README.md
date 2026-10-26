# MySQL Workbench models

Both historical structural versions are included:

- `Model_0521_Newone.mwb` — later-dated filename; no independent version-control history was supplied.
- `Model17-05update.mwb` — earlier filename, retained for structural comparison.

Document author metadata containing a student identifier was replaced with the team name and lock files were removed for public publication. They are structurally preserved derivatives, not byte-identical originals. Unchanged originals remain in a private source package.

Both contain 40 table definitions. Neither includes `roomconversion`, which appears in the database backup. The organized executable database contains 41 domain tables; its schema and generated dictionary are the current reference.

Open the `.mwb` files in MySQL Workbench. To obtain an exact current model, reverse engineer a new Workbench model from the imported execution schema.

`docs/erd.dot` contains a schema-derived Graphviz representation of all 46 foreign-key relationships. With Graphviz installed, `dot -Tsvg docs/erd.dot -o erd.svg` renders it. Rendering was not available in the preparation environment.
