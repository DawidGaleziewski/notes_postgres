Sometimes we just want to generate a lot of data for testing purposes

```postgresql
SELECT random(), repeat('test ', 3);
SELECT generate_series(1, 200);
```

We can join our statments ussing || which is used to concatenate
```postgresql
SELECT generate_series(1, 200) AS id, 'https://shop/cart/' || trunc(random() * 100)  || '?cupon=' || repeat('cashing!', 5)
```