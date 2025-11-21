we can use  \copy psql command to copy data from csv into db

```bash
\copy track_raw(title,artist,album,count,rating,len) FROM 'library.csv' WITH DELIMITER ',' CSV;
 SELECT count(*) from track_raw
```