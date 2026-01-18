# WHERE clause operators
- LIKE / ILIKE / NOT LIKE / NOT ILIKE
- SIMILAR TO / NOT SIMILAR TO

```postgresql
CREATE TABLE textfun (
    content TEXT
);

-- create b-tree index which is good for things like sorting, ranges 
CREATE INDEX textfun_b ON textfun (content);

-- checking how much data is taken by index compared to space. Idea of index is that we are trading space for speed
SELECT pg_relation_size('textfun'), pg_indexes_size('textfun');
```

Creasting mock data
```postgresql
INSERT INTO textfun (content)
-- way of using if else in postgres
SELECT (
            CASE WHEN (random() < 0.5)
            THEN 'https://www.google.com/?id='
            ELSE 'https://www.youtube.com/?id='
            END
           ) || generate_series(1000, 20000000) ;
```


Generally speaking indexing a long text field is NOT the greatest idea as it will grow exponentially.


```postgresql
SELECT content FROM textfun WHERE content LIKE '%06%'
```

## text transformations
```postgresql
SELECT LEFT(CONTENT, 2) FROM textfun WHERE content LIKE '%06%';
SELECT upper(content) FROM textfun WHERE content LIKE '%06%';
-- This seems super useful
SELECT split_part(CONTENT, '/', 3) FROM textfun WHERE content LIKE '%06%';
SELECT translate(CONTENT, '.com', '.dev') FROM textfun WHERE content LIKE '%06%';
```


Analyzing performance of the script.
There are huge diffrences when using a b-tree index on text fields depending on query used
```postgresql
-- Qickest as this can be using index (about 0.06sek)
EXPLAIN ANALYZE SELECT * FROM textfun WHERE content LIKE '06%';
-- This can be 1000 times slower
EXPLAIN ANALYZE SELECT * FROM textfun WHERE content LIKE '%06%';
-- ILIKE (ignores case) is realy bad and can be even 3x slower then sequential scan
EXPLAIN ANALYZE SELECT * FROM textfun WHERE content ILIKE '%06%';
-- even with sequential scans we can optimize the qyery by LIMIT
EXPLAIN ANALYZE SELECT * FROM textfun WHERE content ILIKE '%06%' LIMIT 1;

-- IN will use one of few provided options. This is also a index scan
EXPLAIN ANALYZE SELECT * FROM textfun WHERE CONTENT IN ('https://www.google.com/?id=1000', 'https://www.google.com/?id=1010')

-- subqueries generally will have quite bad performance. However ptoblem here is that we run two scans. First is the seq scan and second one is index scan. So it still won't be to good
EXPLAIN ANALYZE SELECT * FROM textfun WHERE CONTENT IN (SELECT content FROM textfun WHERE CONTENT LIKE '10%')
```