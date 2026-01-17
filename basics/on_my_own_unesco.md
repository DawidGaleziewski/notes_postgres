```postgresql
DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
```

```postgresql
Name EN,Name FR,Name ES,Name RU,Name AR,Name ZH,Short Description EN,Short Description FR,Short Description ES,Short Description RU,Short Description AR,Short Description ZH,Description EN,Justification EN,Date inscribed,Secondary dates,Danger,Date end,Danger list,Area hectares,Cultural Criteria,Natural Criteria,Criteria,Category,Category ID,States Names,ISO Codes,Region,Region Code,Transboundary,Main Image,Images,UUID,ID,Coordinates,Components,Components Count
```

```bash
Data copy to table
\copy unesco_sites(
    name_en, 
    description_en, 
    justification_en, 
    date_inscribed, 
    coordinates, 
    area_hectares, 
    category, 
    states_names, 
    region, 
    iso_codes
) 
FROM './mock_data/whc001.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');
```

```postgresql

CREATE TABLE unesco_sites (
    id SERIAL PRIMARY KEY, -- Using their ID or a serial
    uuid UUID UNIQUE,
    name_en TEXT NOT NULL,
    name_fr TEXT,
    name_es TEXT,
    name_ru TEXT,
    name_ar TEXT,
    name_zh TEXT,
    short_description_en TEXT,
    short_description_fr TEXT,
    short_description_es TEXT,
    short_description_ru TEXT,
    short_description_ar TEXT,
    short_description_zh TEXT,
    description_en TEXT,
    justification_en TEXT,
    date_inscribed INTEGER, -- Usually a year (e.g., 1978)
    secondary_dates TEXT,
    danger BOOLEAN DEFAULT FALSE,
    date_end TEXT,
    danger_list TEXT,
    area_hectares NUMERIC, -- Use Numeric for precise measurements
    cultural_criteria TEXT,
    natural_criteria TEXT,
    criteria TEXT,
    category TEXT,
    category_id TEXT,
    states_names TEXT,
    iso_codes VARCHAR(10), -- e.g., "us", "fr"
    region TEXT,
    region_code TEXT,
    transboundary INTEGER, -- 0 or 1
    main_image TEXT,
    images TEXT,
    coordinates TEXT, -- Or use POINT type if using PostGIS
    components TEXT,
    components_count INTEGER
);
```

```postgresql
ALTER TABLE unesco_sites DROP COLUMN id;
ALTER TABLE unesco_sites ADD COLUMN uuid UUID UNIQUE;
ALTER TABLE unesco_sites ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE unesco_sites ALTER COLUMN transboundary TYPE TEXT;
ALTER TABLE unesco_sites ALTER COLUMN iso_codes TYPE TEXT;
```

```postgresql
SELECT DISTINCT category FROM unesco_sites;
```

```postgresql
CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);
```

```postgresql
INSERT INTO category (name) SELECT DISTINCT category FROM unesco_sites;
```

```postgresql
ALTER TABLE unesco_sites DROP COLUMN category;
```

```postgresql
CREATE TABLE region(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE
);

INSERT INTO region (name) SELECT DISTINCT region FROM unesco_sites;
```

```postgresql
ALTER TABLE unesco_sites DROP COLUMN name_fr, DROP COLUMN name_es, DROP COLUMN name_ru, DROP COLUMN name_ar, DROP COLUMN name_zh;
```

```postgresql
CREATE TABLE state(
    id SERIAL PRIMARY KEY, 
    name VARCHAR(128) UNIQUE
);

INSERT INTO state (name) SELECT DISTINCT states_names FROM unesco_sites;
ALTER table state ALTER COLUMN name TYPE VARCHAR(2560);

```

```postgresql
CREATE TABLE iso(
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE
);

INSERT INTO iso (name) SELECT DISTINCT iso_codes FROM unesco_sites;
```

```postgresql
CREATE TABLE unesco(
    id SERIAL PRIMARY KEY,
    name VARCHAR(2560) UNIQUE,
    year INTEGER,
    category_id INT REFERENCES category(id),
    region_id INT REFERENCES region(id),
    state_id INT REFERENCES state(id),
    iso_id INT REFERENCES iso(id)
);

ALTER TABLE unesco_sites ADD COLUMN category_id INT REFERENCES category(id);
ALTER TABLE unesco_sites ADD COLUMN region_id INT REFERENCES region(id);
ALTER TABLE unesco_sites ADD COLUMN state_id INT REFERENCES state(id);
ALTER TABLE unesco_sites ADD COLUMN iso_id INT REFERENCES iso(id);

UPDATE unesco_sites SET category_id = (SELECT id FROM category WHERE unesco_sites.category = category.name);

SELECT category, category.name FROM unesco_sites JOIN category ON category.id = unesco_sites.category_id;

UPDATE unesco_sites SET region_id = (SELECT id FROM region WHERE unesco_sites.region = region.name);

UPDATE unesco_sites SET state_id = (SELECT id FROM state WHERE unesco_sites.states_names = state.name);

UPDATE unesco_sites SET iso_id = (SELECT id FROM iso WHERE unesco_sites.iso_codes = iso.name);


INSERT INTO unesco 
  (name, year, category_id, region_id, state_id, iso_id)
  SELECT name_en, date_inscribed, category_id, region_id, state_id, iso_id FROM unesco_sites;
```

```postgresql
SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  WHERE unesco.name NOT LIKE '%Aksum%' 
   	AND unesco.name NOT LIKE '%Aldabra Atoll%'
   	AND unesco.name NOT LIKE '%Ancient Ferrous Metallurgy Sites of Burkina Faso%'
   	AND unesco.name NOT LIKE '%Andrefana Dry Forests%'
  ORDER BY region.name, unesco.name
  LIMIT 3;

-- Only Khomani Cultural Landscape sites
SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  WHERE unesco.name LIKE '%Khomani Cultural Landscape%' 
  ORDER BY region.name, unesco.name
  LIMIT 3;
```


Create a temporary teble and pipe to another select to make sure the logic is working fine
```postgresql

WITH test AS (SELECT unesco.name AS unesco_name, year, category.name AS category, state.name AS state_name, region.name AS region_name, iso.name AS iso_name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  WHERE region.name LIKE '%Africa%' AND
  	(unesco.name NOT LIKE '%Khomani Cultural Landscape%'
  	AND unesco.name NOT LIKE '%Aapravasi Ghat%'
  	AND unesco.name NOT LIKE '%Natural Reserves%')
  ORDER BY region.name, unesco.name)
SELECT unesco_name FROM test WHERE unesco_name LIKE '%Natural Reserves%';


DELETE FROM unesco
  USING region
  WHERE unesco.region_id = region.id AND region.name LIKE '%Africa%' AND
  	(unesco.name NOT LIKE '%Khomani Cultural Landscape%'
  	AND unesco.name NOT LIKE '%Aapravasi Ghat%'
  	AND unesco.name NOT LIKE '%Natural Reserves%')
  RETURNING *;


SELECT unesco.name AS unesco_name, year, category.name AS category, state.name AS state_name, region.name AS region_name, iso.name AS iso_name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY region.name, unesco.name;
  
  
 UPDATE unesco SET name = 'Khomani Cultural Landscape' WHERE name = 'ǂKhomani Cultural Landscape' RETURNING *;
```
```postgresql

UPDATE iso SET name=LOWER(name) RETURNING *;

UPDATE unesco SET name='Air and T n r Natural Reserves' WHERE name='Air and T n r Natural Reserves' RETURNING *;
```