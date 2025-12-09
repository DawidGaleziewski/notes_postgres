
DATE 'YYYY-MM-DD' - more fore things like historical dates. When timezone is not important
TIME - 'HH:MM:SS' - same as date but for hours
TIMESTAMP - 'YYYY-MM-DD HH:MM:SS' - DATE + TIME but without timezone (kinda usless)
TIMESTAMPTZ - 'YYYY-MM-DD HH:MM:SS+TZ' - DATE + TIME + TIMEZONE
NOW() - buiilt in postgresa function. It generates date, time, mintures and second and has time zone associateds with it. 

```postgresql
CREATE TABLE post(
    id SERIAL PRIMARY KEY,
    content TEXT,
--     timestpamp with time zone. Required and if not filled it will default to NOW()
--     THis is a very popular field to use. SO that you have date of creation and you don't have to put this in sinsert statement
--     Best to use UTC
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     ALTER will NOT auto update that
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

We can transform timezones with AT TIME ZONE
```postgresql
SELECT NOW(), NOW() AT TIME ZONE 'UTC', NOW() AT TIME ZONE 'Europe/Warsaw';
```

6:00