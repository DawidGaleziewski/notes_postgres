Basic posgre setup 
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl status postgresql
```


Postgresql sql shell. Connecting and basic commands

```bash
# enter postgres shell
sudo -u postgres psql

\q # quit
\l # list databases
```

creating user and database
```postgresql
-- Semicolons are important
CREATE USER pg4e WITH PASSWORD 'secret'; 
CREATE DATABASE people WITH OWNER admin;

ALTER DATABASE people RENAME TO new_owner_name;
```

Connecting to a database on localhost with forced creds
```bash
 psql -h localhost -U admin -d peopl
```

List tables
```postgresql
\dt
```

Create tables
```postgresql
CREATE TABLE users(name VARCHAR(128), email VARCHAR(128));
```

Show shema for table
```bash
\d+ users
```

Running a standard sql commands
```postgresql
SELECT * FROM pg4e_meta;
```

Autograder is on on:
https://www.pg4e.com/

