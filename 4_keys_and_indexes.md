
## keys
We need columns that we will use to referance our tables in other tables (primary key)

PostgreSQL provides SERIAL datatype that increments automatically rows

```postgresql
CREATE TABLE users(
--     autoincremented. We dont have to put it on insert statments. It will be put automatically
    id SERIAL,
    name VARCHAR(100),
--     We call this a logical key.
    email VARCHAR(100) UNIQUE,
--     build on index for this. We will be using this the MOST. Best indexes are INTEGRES as they are very fast
    PRIMARY KEY(id)
);
```

### Postgres functions