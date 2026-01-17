We first create a raw table for working with data

```postgresql
DROP TABLE IF EXISTS raw_housing;

-- Create raw table for holding data
CREATE TABLE raw_housing (
    id SERIAL PRIMARY KEY,
    "Oznaczenie_lokalu" TEXT,
    "Cena_[PLN]" TEXT,
    "Cena_za_m²_[PLN]" TEXT,
    "Data_aktualizacji" TEXT,
    "Cena_przed_zmianą_[PLN]" TEXT,
    "Cena_za_m²_przed_zmianą_[PLN]" TEXT,
    "Nazwa_dewelopera" TEXT,
    "Forma_prawna_dewelopera" TEXT,
    "Nr_NIP" TEXT,
    "Nr_REGON" TEXT,
    "Nr_telefonu" TEXT,
    "Adres_poczty_elektronicznej" TEXT,
    "Adres_strony_internetowej_dewelopera" TEXT,
    "Województwo_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Powiat_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Gmina_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Miejscowość_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Ulica_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Nr_nieruchomości_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Nr_lokalu_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Kod_pocztowy_adresu_siedziby/głównego_miejsca_wykonywania_działalności_gospodarczej_dewelopera" TEXT,
    "Województwo_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Powiat_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Gmina_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Miejscowość_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Ulica_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Nr_nieruchomości_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Nr_lokalu_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Kod_pocztowy_adresu_lokalu,_w_którym_prowadzona_jest_sprzedaż" TEXT,
    "Sposób_kontaktu_nabywcy_z_deweloperem" TEXT
);


```

Copy data into table
```bash
 \copy raw_housing FROM './mock_data/ceny_2026-01-04.csv' WITH DELIMITER ',' CSV HEADER;
```

resequence the id
```postgresql
ALTER SEQUENCE raw_housing_id_seq RESTART WITH 1;


ALTER TABLE raw_housing RENAME COLUMN "Nazwa_dewelopera" TO developer_name;

CREATE TABLE developers (
    id SERIAL PRIMARY KEY,
    developer_name VARCHAR(1250),
    developer_law_status VARCHAR(1250),
    nip CHAR(10),
    regon CHAR(9),
    phone_number VARCHAR(256),
    email VARCHAR(256),
    website VARCHAR(256),
    main_headquoters_voivodeship VARCHAR(256)
);

-- SELECTINg distinc combinations to put them in new table:

INSERT  INTO developers
(
    developer_name,
    developer_law_status,
    nip,
    regon,
    phone_number,
    email,
    website,
    main_headquoters_voivodeship
)
SELECT DISTINCT 
    developer_name,
    "Forma_prawna_dewelopera",
    "Nr_NIP",
    "Nr_REGON",
    "Nr_telefonu",
    "Adres_poczty_elektronicznej",
    "Adres_strony_internetowej_dewelopera", "Województwo_adresu_siedziby/głównego_miejsca_wykonywania_dzi" 
FROM raw_housing;

ALTER TABLE developer ADD CONSTRAINT
    unique_developer_name UNIQUE (developer_name);

-- update the original table with new ids
ALTER TABLE raw_housing 
ADD COLUMN developer_id INT REFERENCES developers(id);
UPDATE raw_housing SET developer_id=(SELECT id FROM developers WHERE developer_name=raw_housing.developer_name)

-- remove not used columns
ALTER TABLE raw_houding
DROP COLUMN developer_name,
DROP COLUMN "Forma_prawna_dewelopera",
DROP COLUMN "Nr_NIP",
DROP COLUMN "Nr_REGON",
DROP COLUMN "Nr_telefonu",
DROP COLUMN "Adres_poczty_elektronicznej",
DROP COLUMN "Adres_strony_internetowej_dewelopera",
DROP COLUMN "Województwo_adresu_siedziby/głównego_miejsca_wykonywania_dzi"
```

Homework 
```postgresql

```
