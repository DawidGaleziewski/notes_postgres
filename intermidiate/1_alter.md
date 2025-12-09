Alter allow us to change the schema once it was created. We can alter tables that are already live in prod

```postgresql
CREATE TABLE fav_movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    oops VARCHAR(255)
);

--  Remove a column
ALTER TABLE fav_movies 
    DROP COLUMN oops;

--  Change data type of a column
ALTER TABLE fav_movies
    ALTER COLUMN description TYPE TEXT;

--  Add a new column
ALTER TABLE fav_movies
    ADD COLUMN how_much_i_love_it INTEGER;
```

PS. loading a sql file:
```postgresql
\i ./alter.sql
```