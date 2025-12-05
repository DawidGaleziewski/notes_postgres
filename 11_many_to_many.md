When  using many to many relationship on a physical level we will need to crearte a junction table. This table will have two foreign keys.
Usually this will not have a separate primary key

Many times in those case we want to make two forewign keys a unique combination

```postgresql
CREATE TABLE student (
    id SERIAL,
    name VARCHAR(128),
--     email is our logical key
    email VARCHAR(128) UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE course
(
 id SERIAL,
 title VARCHAR(128) UNIQUE,
 PRIMARY KEY(id)
);

CREATE TABLE member (
    student_id INTEGER REFERENCES student(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES course(id) ON DELETE CASCADE,
--     data modeled at the connection. I.E a teacher
    role INTEGER,
--     making primary key out of two tables, makes it unique. We can't have two same connections
    PRIMARY KEY (student_id, course_id)    
);

INSERT INTO student (name, email) VALUES ('Jake Kowalski', 'jack@ripper.com');
INSERT INTO student (name, email) VALUES ('Martin Valece', 'martin@ripper.com');


INSERT INTO course (title) VALUES ('SQL');
INSERT INTO course (title) VALUES ('Python');

-- Insert into middle tab;le
INSERT INTO member (student_id, course_id, role) VALUES (2,1, 1);

-- reconstructing the daya
SELECT student.name, student.email, course.title
    FROM student
        JOIN member ON member.student_id = student.id
        JOIN course ON course.id = member.course_id
```