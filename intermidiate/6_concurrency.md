conncurrency on database happens mostly in online systems. For example when we have multiple ooperations on the same row.

## transactions and atomicity in postgres

PostgreSQL locks areas before it starts a sql command that may change the area of the database
All other access to that area must wait until the transaction is finished.
Locking mechanisms may be more costly then actual operations themselves

```postgresql
UPDATE  tracks SET count = count+1 
               WHERE id = 1;

-- ABOVE WIll first LOCK row 1
-- READ count FROM row 1
-- count = count + 1
-- WRITE count back to row 1
-- UNLOCK row 1
```

Insert statments will also be atomic. as they will need a unique key

## compound statments
ststaments that do more then one thing in one ststmanet. For concurency and efficiency

```postgresql
-- Inserts thing and return a thing. This is one atomic statment
INSERT INTO transactions (ammount, account_id, date_of_operation) 
    VALUES (100, 1, NOW())
    RETURNING *;

UPDATE posts 
    SET likes = likes + 1 
    WHERE id = 1
    RETURNING *;
```

## SQL error handling
We can do something similar to python try.. except.. blocks

```postgresql
INSERT INTO transactions (ammount, account_id, date_of_operation) VALUES
    (-100, 23, NOW())
     -- This block will happen only on conflict                                                             
    ON CONFLICT (account_id, date_of_operation, error_code)
    DO UPDATE SET ammount = ammount, error_code = 'ammount conflict'
RETURNING *;

```


# For practice:
```postgresql
-- Create tables
CREATE TABLE account(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL
);

CREATE TABLE mock_transactions(
    id SERIAL PRIMARY KEY,
    amount NUMERIC(14, 2) NOT NULL,
    account_id INT REFERENCES account(id),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- insert some mock data
INSERT INTO account(name) VALUES('Dawid'), ('Michal'), ('Kuba');
INSERT INTO mock_transactions (amount, account_id) VALUES(100, 1), (200, 2), (300, 3);

-- get inserted data back
INSERT INTO mock_transactions (amount, account_id) VALUES(100, 1), (200, 2), (300, 3) RETURNING *;

--  alter table so that we have a row that needs to be unique
ALTER TABLE mock_transactions ADD COLUMN error_code VARCHAR(128);
ALTER TABLE mock_transactions ADD COLUMN uniq VARCHAR(128) UNIQUE;

-- add a row with such a value
INSERT INTO mock_transactions (amount, account_id, uniq) VALUES(100, 1, 'b') RETURNING *;

-- test fallback - violate unique contraint on purpose
INSERT INTO mock_transactions (amount, account_id, uniq) VALUES(-1000, 1, 'b') 
--  This is super important to work. We specify exactly which rows we want to handle if they fail the constraint.                                                        
  ON CONFLICT (uniq)
  DO UPDATE SET account_id = 1, timestamp = NOW(), amount = 0, error_code = 'something went wrong!', uniq = 'c'
RETURNING *;
```


