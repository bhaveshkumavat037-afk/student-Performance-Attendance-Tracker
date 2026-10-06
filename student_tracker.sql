-- =========================================================
-- STUDENT PERFORMANCE & ATTENDANCE TRACKER
-- Complete Project SQL Script
-- =========================================================

-- 1. DATABASE CREATION
CREATE DATABASE IF NOT EXISTS student_performance_db;
USE student_performance_db;

-- =========================================================
-- 2. SCHEMA DESIGN (TABLES CREATION)
-- =========================================================

-- Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);

-- Faculty Table
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address TEXT,
    admission_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

-- Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_id)
);

-- Attendance Table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    attendance_date DATE,
    status ENUM('Present', 'Absent', 'Late') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Grades Table
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    marks_obtained INT,
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- =========================================================
-- 3. SAMPLE DATA INSERTION
-- =========================================================

INSERT INTO Departments (department_name) VALUES 
('Computer Science'), 
('Information Technology'), 
('Mechanical');

INSERT INTO Faculty (name, email, phone_number, department_id) VALUES 
('Dr. Sharma', 'sharma@school.com', '9876543210', 1),
('Prof. Verma', 'verma@school.com', '9876543211', 2),
('Dr. Patel', NULL, '9876543212', 1);

INSERT INTO Students (name, dob, gender, email, phone_number, address, admission_date, department_id) VALUES 
('Rahul Kumar', '2002-05-15', 'Male', 'rahul@gmail.com', '9998887771', 'Mumbai', '2022-08-01', 1),
('Priya Singh', '2001-11-20', 'Female', NULL, '9998887772', 'Delhi', '2021-08-01', 1),
('Aman Verma', '2003-01-10', 'Male', 'aman@gmail.com', '9998887773', 'Surat', '2023-08-01', 2);

INSERT INTO Courses (course_name, faculty_id) VALUES 
('DBMS', 1),
('Python', 2),
('Web Development', NULL);

INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES 
(1, 1, '2022-08-05'),
(2, 1, '2021-08-05'),
(3, 2, '2023-08-05');

INSERT INTO Attendance (student_id, course_id, attendance_date, status) VALUES 
(1, 1, '2023-09-01', 'Present'),
(1, 1, '2023-09-02', 'Present'),
(2, 1, '2023-09-01', 'Absent'),
(3, 2, '2023-09-01', 'Late');

INSERT INTO Grades (student_id, course_id, marks_obtained, grade) VALUES 
(1, 1, 92, 'A+'),
(2, 1, 78, 'B'),
(3, 2, 45, 'F');

-- =========================================================
-- 4. TASKS & FUNCTIONALITIES QUERIES
-- =========================================================

-- CRUD Operations
UPDATE Students 
SET email = 'rahul.new@gmail.com', phone_number = '9876500000' 
WHERE student_id = 1;

-- SQL Clauses & Operators
SELECT * FROM Students WHERE department_id = 1;

SELECT * FROM Grades ORDER BY marks_obtained DESC LIMIT 10;

SELECT * FROM Grades WHERE marks_obtained > 90;

SELECT * FROM Faculty WHERE department_id IS NULL;

-- Grouping & Aggregations
SELECT * FROM Students ORDER BY name ASC;

SELECT department_id, COUNT(student_id) AS total_students 
FROM Students 
GROUP BY department_id;

SELECT course_id, MAX(marks_obtained) AS highest_marks, MIN(marks_obtained) AS lowest_marks 
FROM Grades 
GROUP BY course_id;

-- Advanced Joins
SELECT s.student_id, s.name, d.department_name 
FROM Students s
INNER JOIN Departments d ON s.department_id = d.department_id;

SELECT s.student_id, s.name 
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

SELECT c.course_name, f.name AS faculty_name 
FROM Faculty f
RIGHT JOIN Courses c ON f.faculty_id = c.faculty_id
WHERE f.faculty_id IS NULL;

-- Subqueries, String Functions & CASE Statements
SELECT * FROM Grades 
WHERE marks_obtained > (SELECT AVG(marks_obtained) FROM Grades);

SELECT UPPER(name) AS uppercase_name, COALESCE(email, 'Email Not Provided') AS contact_email 
FROM Faculty;

SELECT student_id, marks_obtained,
    CASE 
        WHEN marks_obtained > 90 THEN 'Excellent'
        WHEN marks_obtained BETWEEN 75 AND 90 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_status
FROM Grades;