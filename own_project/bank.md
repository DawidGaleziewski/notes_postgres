Database name: bank

sample data:
"Data operacji","Data waluty","Typ transakcji","Kwota","Waluta","Saldo po transakcji","Opis transakcji","","","","","","",""
"2025-12-07","2025-12-06","P�atno�� kart�","-12.87","PLN","+6255.79","Tytu�: 000483849 74838490339599601149536 ","Lokalizacja: Adres: WIKTOR MARKIEWICZ WA 01 Miasto: WARSZAWA Kraj: POLSKA","Data wykonania operacji: 2025-12-06","Oryginalna kwota operacji: 12.87","Numer karty: 425125******4436","","",""
"2025-12-07","2025-12-06","P�atno�� kart�","-15.00","PLN","+6268.66","Tytu�: 000483849 74838490339599593291015 ","Lokalizacja: Adres: PIEKARNIA K. i A. CI 08 Miasto: WARSZAWA Kraj: POLSKA","Data wykonania operacji: 2025-12-06","Oryginalna kwota operacji: 15.00","Numer karty: 425125******4436","","",""
"2025-12-07","2025-12-05","P�atno�� kart�","-122.99","PLN","+6283.66","Tytu�: 010066928 74056285339108147901282 ","Lokalizacja: Adres: APPLE.COM/BILL Miasto: APPLE.COM/BIL Kraj: IRLANDIA","Data wykonania operacji: 2025-12-05","Oryginalna kwota operacji: 122.99","Numer karty: 425125******4436","","",""
"2025-12-07","2025-12-05","P�atno�� kart�","-139.64","PLN","+6406.65","Tytu�:  74988855339496348150616 ","Lokalizacja: Adres: JMP S.A. BIEDRONKA 3259 Miasto: WARSZAWA Kraj: POLSKA","Data wykonania operacji: 2025-12-05","Oryginalna kwota operacji: 139.64","Numer karty: 425125******4436","","",""
"2025-12-06","2025-12-06","P�atno�� web - kod mobilny","-100.00","PLN","+6546.29","Tytu�: 00000092374658452  ","Numer telefonu: 48509956560","Lokalizacja: Adres: Urzad Dzielnicy Ursus","'Operacja: 00000092374658452","Numer referencyjny: 00000092374658452","","",""

Agregated data schema
```postgresql
CREATE TABLE transactions_dump(
  id SERIAL PRIMARY KEY,
--     Timestamp would be better, But we don't have hours from PKO
  transaction_date DATE,
  value_date DATE,
  transaction_type VARCHAR(128) NOT NULL,
  amount NUMERIC(19,4) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  balance_after_transaction NUMERIC(19,4) NOT NULL,
  description VARCHAR(1256) NOT NULL,
    transaction_location VARCHAR(526) NOT NULL,
    original_transaction_amount NUMERIC(19,4) NOT NULL,
    card_number VARCHAR(32) NOT NULL
);
```

connect to lacal db as a superuser
```bash
sudo -u postgres psql bank
```

```postgresql
\COPY transactions_dump (
  transaction_date,
  value_date,
  transaction_type,
  amount,
  currency,
  balance_after_transaction,
  description,
  transaction_location,
  original_transaction_amount,
  card_number
) FROM './own_project/op2.csv' 
DELIMITER ',' 
CSV 
ENCODING 'LATIN1';
```

```postgresql
 SELECT c1 FROM super_raw_stage
```

Cleaning data. Transforming it from tempt data into normal data.

```postgresql
INSERT INTO transactions_dump (
    transaction_date,
    value_date,
    transaction_type,
    amount,
    currency,
    balance_after_transaction,
    description,
    transaction_location,
    original_transaction_amount,
    card_number
)
SELECT
    -- Core Fields (Direct Mapping and Cleaning)
    c1::DATE,
    c2::DATE,
    -- Handle corrupted Polish characters (based on your original data)
    REPLACE(c3, 'Patno', 'Płatność'),
    c4::NUMERIC(19,4),
    c5,
    TRIM(BOTH '+' FROM c6)::NUMERIC(19,4), -- Remove '+' from balance
    
    -- Dynamic Fields (Extraction & Merging)
    
    -- DESCRIPTION (from c7)
    CASE
        WHEN c3 LIKE 'P%kart%' THEN SPLIT_PART(c7, 'Tytuł: ', 2)
        WHEN c3 LIKE 'P%web%' THEN SPLIT_PART(c7, 'Tytuł: ', 2)
        ELSE c7 
    END AS description,

    -- LOCATION (from c8/c9)
    CASE
        WHEN c3 LIKE 'P%kart%' THEN SPLIT_PART(c8, 'Lokalizacja: ', 2)
        WHEN c3 LIKE 'P%web%' THEN SPLIT_PART(c9, 'Lokalizacja: ', 2)
        ELSE NULL
    END AS transaction_location,

    -- ORIGINAL AMOUNT (from c10)
    CASE
        WHEN c3 LIKE 'P%kart%' THEN SPLIT_PART(c10, 'Oryginalna kwota operacji: ', 2)::NUMERIC(19,4)
        ELSE ABS(c4::NUMERIC(19,4))
    END AS original_transaction_amount,

    -- CARD NUMBER (from c11)
    CASE
        WHEN c3 LIKE 'P%kart%' THEN SPLIT_PART(c11, 'Numer karty: ', 2)
        ELSE 'N/A'
    END AS card_number
FROM super_raw_stage;
```

Check how moner was earned:
```postgresql
SELECT SUM(amount) FROM account_operation WHERE amount > 0;
```

Check top 10 spending of money
```postgresql
SELECT  amount, description  FROM account_operation ORDER BY amount DESC LIMIT 10;
```

New shcema for account operations
```postgresql
CREATE TABLE account_operations (
    operation_id SERIAL PRIMARY KEY, -- PostgreSQL uses SERIAL for auto-incrementing integer Primary Keys
    order_date DATE NOT NULL,
    execution_date DATE NOT NULL,
    operation_type VARCHAR(100),
    description TEXT,
    amount NUMERIC(10, 2) NOT NULL, -- NUMERIC is the standard type for exact precision (like DECIMAL)
    amount_currency CHAR(3) NOT NULL,
    ending_balance NUMERIC(10, 2),
    balance_currency CHAR(3)
);
```


```postgresql
SELECT
    amount
FROM
    account_operations
WHERE
    amount < 0 -- Filter for money paid out (negative amounts)
    AND description ILIKE '%MARIKA%'; -- Filter for 'Marika' in the description (case-insensitive)
```


```postgresql
SELECT  SUM(amount)  FROM account_operation WHERE description LIKE '%MARIKA%';
SELECT  SUM(amount)  FROM account_operation WHERE description LIKE '%MARIKA%' AND amount < 0;
```