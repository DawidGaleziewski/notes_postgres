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

