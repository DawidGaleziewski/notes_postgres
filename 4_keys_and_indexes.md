
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
98% of usage will be date for:
NOW()

### Indexes 
Like shortcuts for data
As table gets large. Scanning all the datya to find a single row will be very costly

We can use data structure to greatly shorten the scan. I.e using shortuts, hashes, trees.

#### B tree indexes (binary tree or block trees)
We divide the data into blocks. We create a index that stores a data on where (in which block) the data is stored.
It is O(log(n)) to find a single row

#### Hashes
Maps large data sets to small data sets (keys). A single int can serve as an index to an array
Diffrent hasing algorithms perfgorm different calculations to stransform string into ints. Some examples are sha1, sha256, md5.
Very fast. But only good for exact matches. Not good for finding ranges or partial matches.