Another way of removing vertical replication.

DISTINCT - Only returns unique rows in a result set. and row will only appear once

DISTINCT ON - limits duplicate removal to a set of colums

```postgresql
SELECT DISTINCT operation_type FROM account_operation
-- This will return only unique genres
SELECT DISTINCT genre FROM music

-- This is rather niche. It will only get unique on genre and tolarate duplicates in other dows

SELECT DISTINCT ON (genre) artist, length FROM music
```

GROUP BY - combined with aggregate functions like COUNT(), MAX(), SUM(), AVE(). It will fire the aggregate function when it encounters duplicate. So it is like DISTINCT + aggregate function.


Very useful  for when we want to see how many of a category we have in a db
```postgresql
SELECT COUNT(operation_type), operation_type  FROM account_operation GROUP BY operation_typ;
SELECT COUNT(operation_type), operation_type  FROM account_operation GROUP BY operation_type  ORDER BY COUNT(operation_type) DESC;
```

We can also filter things out before we group by.
```postgresql
SELECT COUNT(operation_type), operation_type  FROM account_operation
WHERE amount > 100
GROUP BY operation_type  ORDER BY COUNT(operation_type) DESC;

SELECT COUNT(operation_type), operation_type  FROM account_operation
WHERE execution_date > NOW() - INTERVAL '30 days'
GROUP BY operation_type  ORDER BY COUNT(operation_type) DESC;
```

## HAVING
HAVING is like a second WHERE clouse. WHere you can use it AFTER GROUP BY to filter out the resoults of the group by

```postgresql
SELECT COUNT(operation_type), operation_type  FROM account_operation
GROUP BY operation_type
HAVING COUNT(operation_type) > 100;

--  With where when we want to first filter out resoults that we will then group by
SELECT COUNT(operation_type), operation_type  FROM account_operation
WHERE execution_date > NOW() - INTERVAL '30 days'
GROUP BY operation_type
HAVING COUNT(operation_type) > 10
ORDER BY COUNT(operation_type) DESC;
```



