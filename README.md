# Engineering Compliance SQL

A small SQL project built around a fictional "engineering compliance"
database — engineers, training records, and project allocations — designed
to demonstrate core SQL concepts with realistic, messy data (i.e. not every
engineer has completed every training, which is the point).

## Why this project

I built this to sharpen my SQL fundamentals, particularly JOIN behaviour
and how NULLs work — the kind of thing that's easy to get wrong under
interview pressure but matters a lot in real compliance/reporting work
(this schema is loosely inspired by the kind of compliance reporting I
built at Siemens Energy using Alteryx).

## Files

- `schema.sql` — table definitions (engineers, projects, trainings,
  training_records, project_allocations)
- `sample_data.sql` — fictional sample data with intentional gaps
  (some engineers have no training records at all)
- `queries.sql` — a set of annotated queries, from fundamentals to
  more advanced concepts

## What's covered

1. **INNER JOIN vs LEFT JOIN** — and why a LEFT JOIN returns `NULL`
   (not `0`, not an empty string) for unmatched rows
2. **COUNT(column) vs COUNT(\*)** after a LEFT JOIN, and why it matters
3. **Finding missing records** using `IS NULL` after a LEFT JOIN
4. A **compliance report** query — engineers missing a training
   required for their department
5. **GROUP BY + HAVING**
6. **Subqueries**
7. **UNION vs UNION ALL**
8. **Window functions** (`RANK() OVER (PARTITION BY ...)`)

## How to run it

Any SQLite-compatible tool will work. Example using Python:

```python
import sqlite3

conn = sqlite3.connect(':memory:')
cur = conn.cursor()

with open('schema.sql') as f:
    cur.executescript(f.read())
with open('sample_data.sql') as f:
    cur.executescript(f.read())

cur.execute("SELECT * FROM engineers")
print(cur.fetchall())
```

Or with the `sqlite3` CLI:

```bash
sqlite3 practice.db < schema.sql
sqlite3 practice.db < sample_data.sql
sqlite3 practice.db
sqlite> .read queries.sql
```

## Note on the data

All names, projects, and records in `sample_data.sql` are fictional —
this project doesn't use or reference any real company data.
