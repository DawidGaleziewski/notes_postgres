
BEGIN opens a transaction. And ROLLBACK will cancel the whole transaction.

We also lock the row with FOR UPDATE. ROLLBACK does undo it.

Commit serves similar purpose but it will just commit all the changes.


```postgresql
-- we can think about begin as a temporary scratchpad
BEGIN;
SELECT id, name FROM account WHERE name = 'Dawid' 
--     FOR UPDATE will lock the row from updates. It will still allow to read it
     FOR UPDATE OF account;
-- time passes
UPDATE account SET name = 'Falkon' WHERE id = 1;
INSERT INTO mock_transactions (amount, account_id) VALUES(100, 1);
-- Rollback will delete all previous changes
ROLLBACK;
```

```postgresql
BEGIN;
SELECT id, name FROM account WHERE name = 'Dawid' 
     FOR UPDATE OF account;
UPDATE account SET name = 'Falkon' WHERE id = 1;
INSERT INTO mock_transactions (amount, account_id) VALUES(100, 1);
-- will commit the transaction changes
COMMIT;
```