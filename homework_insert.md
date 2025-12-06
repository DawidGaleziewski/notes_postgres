```postgresql

-- Create schema
CREATE TABLE student (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE course CASCADE;
CREATE TABLE course (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE roster CASCADE;
CREATE TABLE roster (
    id SERIAL,
    student_id INTEGER REFERENCES student(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES course(id) ON DELETE CASCADE,
    role INTEGER,
    UNIQUE(student_id, course_id),
    PRIMARY KEY (id)
);

-- Insert values
INSERT INTO student (name) VALUES ('Neiv');
INSERT INTO student (name) VALUES ('Ashtyn');
INSERT INTO student (name) VALUES ('Doone');
INSERT INTO student (name) VALUES ('Niah');
INSERT INTO student (name) VALUES ('Ruari');

INSERT INTO student (name) VALUES ('Rosheen');
INSERT INTO student (name) VALUES ('Jael');
INSERT INTO student (name) VALUES ('Martyna');
INSERT INTO student (name) VALUES ('Rhian');
INSERT INTO student (name) VALUES ('Sidra');

INSERT INTO student (name) VALUES ('Reiah');
INSERT INTO student (name) VALUES ('Brandan');
INSERT INTO student (name) VALUES ('Malachi');
INSERT INTO student (name) VALUES ('Maree');

INSERT INTO student (name) VALUES ('Zinedine');

INSERT INTO course (title) VALUES ('si106');
INSERT INTO course (title) VALUES ('si110');
INSERT INTO course (title) VALUES ('si206');

-- insert values  into junction table
INSERT INTO roster (student_id, course_id, role) VALUES (1, 1, 1);
INSERT INTO roster (student_id, course_id, role) VALUES (2, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (3, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (4, 1, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (5, 1, 0);

INSERT INTO roster (student_id, course_id, role) VALUES (6, 2, 1);
INSERT INTO roster (student_id, course_id, role) VALUES (7, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (8, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (9, 2, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (10, 2, 0);

INSERT INTO roster (student_id, course_id, role) VALUES (11, 3, 1);
INSERT INTO roster (student_id, course_id, role) VALUES (12, 3, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (13, 3, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (14, 3, 0);
INSERT INTO roster (student_id, course_id, role) VALUES (16, 3, 0);

--  check data
SELECT student.name, course.title, roster.role
    FROM student 
    JOIN roster ON student.id = roster.student_id
    JOIN course ON roster.course_id = course.id
    ORDER BY course.title, roster.role DESC, student.name;
```