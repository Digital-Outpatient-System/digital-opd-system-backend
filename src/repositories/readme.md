## Direct SQL queries

Run SQL statements against your cloud database using its provider console or a database client. Examples below use PostgreSQL; replace `your_table` and column names with those in your schema.

```sql
-- Read
SELECT * FROM your_table WHERE id = $1;

-- Insert
INSERT INTO your_table (column_a, column_b)
VALUES ($1, $2)
RETURNING *;

-- Update
UPDATE your_table
SET column_a = $1
WHERE id = $2
RETURNING *;

-- Delete
DELETE FROM your_table
WHERE id = $1
RETURNING *;
```

Use parameterized queries for values supplied by users. Store cloud database credentials in environment variables or a secret manager, not in this file.
