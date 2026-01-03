# stored procedures

Stored procedures are a reusable code for sql.

There are muliple language choices for writing those. They are not very portable thererefore often it is dicoureged to use them uncless company has one kind of DB.

However they are quite good when optimizing performance or multiple SQl queries that run together often.

They can also be used when we want to have more complex constraints. (i.e only one of tweo fields can be null
)

Stored procedures can use multiple programing languages.
One of them is PL/pgSQL.

## trigger functions


```postgresql

```
```postgresql
-- OR REPLACE is so that we wont get error that function already exists.
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
--     $$ is used to define long text block. Similat to: '
-- for PL/pgSQL body of a function is basically a text that will be ineterpreted later
    -- PL/pgSQl requires us to define returned type. This is why we do the casting
    -- TRIGGER is a pointer in memory to a row structure. It tells database that we are going to modify row in memory and once we are done modified row will be returned so it can be stored back. It is something like a flag for database engine, telling that  the function  is part of event handling system.
RETURNS TRIGGER AS $$ 
BEGIN
--     We actually need to return NEW. Due to the fact this will be used in BEFORE trigger. NEW will infor the databse it should update the row. we could also RETURN NULL to skip the operation or return OLD to return old row.
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON fav
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
```

Excersises
```postgresql
CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

SELECT query, result, created_at FROM pg4e_debug;

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

ALTER TABLE pg4e_debug ADD COLUMN neon833 VARCHAR(4096);
```

Creating procedure:

```postgresql
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
	BEGIN
		NEW.updated_at = NOW();
		RETURN NEW;
	END;
$$ LANGUAGE 'plpgsql';



CREATE TRIGGER set_updated_timestamp_on_update
BEFORE UPDATE ON mock_transactions
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

```
