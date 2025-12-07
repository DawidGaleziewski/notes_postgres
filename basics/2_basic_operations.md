
```postgresql
CREATE TABLE pg4e_debug (
    id SERIAL,
    query VARCHAR(4096),
    result VARCHAR(4096),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);
```

```postgresql
CREATE TABLE pg4e_result (
    id SERIAL,
    link_id INTEGER UNIQUE,
    score FLOAT,
    title VARCHAR(4096),
    note VARCHAR(4096),
    debug_log VARCHAR(8192),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);
```

```postgresql
CREATE TABLE ages(
  name VARCHAR(128),
  age INTEGER  
);
```

Basic CRUD
```postgresql
DELETE FROM ages;
INSERT INTO ages (name, age) VALUES ('Atli', 32);
```

Important DELETE concept
SQL is not a procedural language. That meens that when we have FROM we basically use a loop

```postgresql
-- This will delete all rows in the table
DELETE FROM ages;

DELETE FROM ages WHERE name = 'Atli';
```

Updating values
Same principle as with DELETE it does it foe every record
```postgresql
UPDATE users SET name = 'John' WHERE email = 'john@gmail.com';
```

Select
```postgresql
SELECT * FROM ages WHERE name='Charles'
```

Ordering data
```postgresql
SELECT * FROM ages ORDER BY age DESC;
SELECT * FROM ages ORDER BY age ASC;
```

Using wildcards
It is important to know that using wildacrds like this, is not very efficient. the query will first have to pull all the data, and after that it will be able to  filter it by the wildcard. Unlike the where that uses db INDEXES (aka it will do a full table scan)
```postgresql
SELECT * FROM ages WHERE name LIKE '%e%';
```


We can limit numbner of retuned records
```postgresql
SELECT * FROM ages LIMIT 2;
```

We can move by number of records (skip first number of records). This is more effiuciant then first fetchiung the data and discarding it.
```postgresql
SELECT * FROM ages LIMIT 2 OFFSET 1;
```

Counting rows. Again it is quicker then doing it via app
```postgresql
SELECT COUNT(*) FROM ages;
```