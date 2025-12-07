Baisc inner join statment on a key

```postgresql
SELECT * FROM track JOIN artist ON track.artist_id = artist.id;
```

If we want to select a specific atribute of a entity we do it with dot notation.
INNNER statment is optional
```postgresql
SELECT track.title, artist.name, artist.surname FROM track INNER JOIN artist ON track.artist_id = artist.id;
```

## CROSS JOIN
Cross join will just deiplay every comibination of tables. IT WILL NOT match between foreign key and prim key

```postgresql
SELECT track.title, artist.name, artist.surname FROM track CROSS JOIN artist;
```

Multiple inner joins

```postgresql
SELECT * 
FROM track
	JOIN genre ON track.genre_id = genre.id
	JOIN artist ON track.artist_id = artist.id
```