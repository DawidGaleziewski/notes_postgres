
Good rules to fallow:

If there is one thing in real word it should be reflected once in db.
We should not have duplicate strings. We should be using relationships.

When we have a table. WE DON'T WANT VERTICAL REPLICATION OF STRING ENTRY


## pt 2

Best to see a sample data or UI. After that we should go piece by piece of the info and decide, if this column is an object or an atribute of a existing object.

Once objects are defined we need to define relationships between objects

Very often is to start with one object. Very often good deicsion is the User

Often we dont care about vertical replication of numbers. As those are cheap. I.E rating

![img.png](img.png)

# keys
In general simplest and best case for more pirmary, foreign keys is to use a simple int. Som e DBS will use a GUID and fake the efficiency.

Using a logical key as a primary key is illadvised as it still may change

## Primary key 
- autoincremented unique key. Often something like ID. We often dont know what it is.


## Logical key 
- something that we would use to find something. I.E a album by its name, or a person by his name.


## foreign key 
- integer pointing to specific row in another table.
Naming convention: <table_name>_id i.e album_id

