
```postgresql
CREATE TABLE artist(
--     serial will make this unique and auto incremented
    id SERIAL,
-- for logical key we add UNIQUE. So only one name
    name VARCHAR(128) UNIQUE,
--     This will be a primary key. Thanks to it it will be indexed by db
    PRIMARY KEY(id)
);

CREATE TABLE album(
    id SERIAL,
    title VARCHAR(128),
--     This id how we create a foreign key. By using REFERENCES + table(id)
--     OND DELATE CASCADE will remove this row if the object we referance the foreign key with will be deleted
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE
);

CREATE TABLE genre(
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE track(
    id SERIAL,
    title VARCHAR(128),
    len INTEGER,
    rating INTEGER,
    count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genre(id) on DELETE CASCADE,
--     Combination of album and its id must be unique
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);
```

# aditional info. Once you crteate  all this you can ask postgres about details and schema, indexes, foreign keys etc by 
\d track