# L2-Assignment02

1.  What is PostgreSQL?

Ans:
PostgreSQL is an open-source database management system (DBMS). We use it to save, search, update, or delete different types of data. we learn PostgreSQL cause

Example:
You can store student names, roll numbers, and classes of a school in PostgreSQL.

2. What is a Schema and why is it used?
   A schema is like a folder inside a database. It helps organize different tables, views, and functions separately.

Example:
You can create different schemas like accounts, sales, users to keep your database clean and organized.

3.  What is Primary Key and Foreign Key?
    Primary Key:
    A unique column that cannot be null. It helps to identify each row separately.

Foreign Key:
A column that refers to another table's primary key. It connects two tables.

Example:

```
CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE marks (
  mark_id SERIAL PRIMARY KEY,
  student_id INT REFERENCES students(student_id),
  subject VARCHAR(50),
  score INT
);
```

4. What is the difference between VARCHAR and CHAR?
   Type Description
   VARCHAR Uses only the required space, ignores the rest
   CHAR Always takes fixed space, fills with empty spaces if short

Example:

```

name VARCHAR(20) -- Takes space for only 5 letters if name has 5
code CHAR(5)     -- Takes full 5 spaces even if code has only 3 letters
```

5. What is the WHERE clause?
   WHERE is used to add conditions and filter data.

Example:

```


SELECT * FROM students WHERE name = 'Sami';
```

6.  What are LIMIT and OFFSET?

LIMIT: Tells how many records to show
OFFSET: Skips some records before showing the rest

Example:

```

SELECT * FROM students LIMIT 5 OFFSET 10;
```

7. How to update data using UPDATE?
   UPDATE is used to change existing data in a table.

Example:

```

UPDATE students SET name = 'Nayeem' WHERE student_id = 1;
```
