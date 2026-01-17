```postgresql
INSERT INTO artist(name) SELECT DISTINCT artist FROM track RETURNING *;
INSERT INTO album (title) SELECT DISTINCT album FROM track;
```

Create a junction table (many to many)

```postgresql
INSERT INTO tracktoartist (track, artist) SELECT DISTINCT title, artist FROM track RETURNING*;
```


Update junction table
```postgresql
UPDATE tracktoartist SET track_id = (SELECT id FROM track WHERE track.title=tracktoartist.track) RETURNING *;
UPDATE tracktoartist SET artist_id = (SELECT id FROM artist WHERE artist.name = tracktoartist.artist) RETURNING *;

SELECT * FROM tracktoartist JOIN track ON tracktoartist.track_id=track.id;
UPDATE track SET album_id=(SELECT id FROM album WHERE track.album=album.title ) RETURNING *
```