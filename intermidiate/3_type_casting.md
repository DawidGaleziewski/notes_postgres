## Casting
We can cast types (change to different type by :: operator)
```postgresql
SELECT NOW()::DATE;
SELECT NOW()::TEXT;
SELECT NOW()::VARCHAR(246)
```

Or we can use CAST
```postgresql
SELECT CAST(NOW() AS TEXT);
SELECT CAST(NOW() AS DATE);
```

## Interval and formating data in a table

```postgresql
SELECT INTERVAL '2 days', INTERVAL '20 minutes', INTERVAL '2 hours'
```


## Basic date arithmetics

We can add or subtract some time using intervals

```postgresql
SELECT NOW() - INTERVAL '2 days', NOW() - INTERVAL '20 minutes', NOW() - INTERVAL '2 hours', NOW() + '10 days'
```

# truncating date
We can get rid of some of the date accurecy in postgresql

```postgresql
SELECT DATE_TRUNC('day', NOW()) 
```

# sudo tables
Databases have sudo tables that are not visible to regular users.
I.E they store all timezones:
```postgresql
SELECT * FROM pg_timezone_names
```

Not all queries that retuen same results are same fast. Some queries (table scans) are slower. When for example a query has to first retrive a lot of rows, and then look at a lot of those rows.
To mitigate thi we want to use indexes. So for example if we use a field "email" that is beeing indexed. This will make the operation a lot faster
Also most times it will be slower when we use TRUC date ten when we cast date. (some internal SQL optimisation for postgres)

```postgresql
SELECT * FROM account_operation
         WHERE order_date > NOW() - INTERVAL '30 days'
```
