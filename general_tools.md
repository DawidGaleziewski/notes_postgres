Check what DB I am connected to:

connect to superuser
```bash
sudo -u postgres psql
```
connect by specific user to specific database
```bash
psql -U dawid -h localhost -d bank
```

```postgresql
SELECT current_database();
```

Create a database dump
```bash
sudo -u postgres pg_dump -t 'account' postgres > account_backup.sql
```

Import a databse dump
```bash
sudo -u postgres psql -d bank < account_backup.sql
```