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
11:07