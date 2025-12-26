``bqueries are a query inside a query.
They are not very efficient. But quire convinient
```postgresql
SELECT content FROM comment
WHERE account_id = (SELECT id FROM account WHERE username = 'dawid');
```

Most database admins will encourage you to do what you want withoiut subqueries.
This is because subqueries are a imperative way of doing something. DBS have a lot optimalisation going behind them and we are kinda throwing this away.

Subqueries are still more optimised then running two queries i.e from pyhton. As they will not require two db connections to do onew thing.

It is worth knowing that a subquery will create a temporary table. So we can query it.
I.E if we didnt have HAVING clasuse we could do something like this

```postgresql
SELECT operation_type, ct FROM (
-- 	THIS CREATES A TEMPORARY TABLE! WE CAN QUERY IT! HOW COOL IS THAT?
	SELECT count(operation_type) AS ct, operation_type  
	FROM account_operation
	WHERE order_date > NOW() - INTERVAL '30 days'
	GROUP BY operation_type 
) AS zap WHERE ct > 10 ORDER BY ct DESC
```