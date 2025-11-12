
String fields 
```postgresql
CREATE TABLE datatypes(
--     Allolactes entire space. Faster for small strigs where length is known. I.E a GUID we know will be exactly 100 chars long
  guid CHAR(100), 
--     Allocates a variable amount of space. Depending on data length. Takes up less space
  first_name  VARCHAR(100) 
);

```


Text fields.
When we don't know the length
We generally don't use them for indexing. We store paragraphs or HTML pages this way

```postgresql
CREATE TABLE text_fields(
  article_html TEXT
);
```
Binary types

```postgresql
CREATE TABLE binary_fields(
    small_img BYTEA(255)
);
```

Integers
```postgresql
CREATE TABLE integer_fields(
--     -32 768 to 32 768
    age SMALLINT,
--     2 billion (miliardy). Mostly used
    tvp_budget INTEGER,   
--     10**18
    bigint BIGINT
);
```

Floats
```postgresql
CREATE TABLE float_fields(
--     only good for approximate values. It has only seven digitsd of accurecy
    avg_temperature REAL,
--     14 digits of accuracy
    star_force DOUBLE PRECISION,
--  Own digits of accurecy and after decimal
    custom NUMERIC(14,2)
);
```