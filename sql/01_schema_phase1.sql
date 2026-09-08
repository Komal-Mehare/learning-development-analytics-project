CREATE SCHEMA IF NOT EXISTS lnd_project;
SET search_path TO lnd_project;

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INTEGER NOT NULL REFERENCES departments(department_id),
    job_title VARCHAR(120) NOT NULL,
    hire_date DATE NOT NULL,
    employment_level VARCHAR(20) NOT NULL,
    location VARCHAR(50),
    employment_type VARCHAR(30)
);

CREATE TABLE training_programs (
    training_id INTEGER PRIMARY KEY,
    training_name VARCHAR(150) NOT NULL,
    training_category VARCHAR(50) NOT NULL,
    duration_hours INTEGER NOT NULL,
    delivery_mode VARCHAR(30) NOT NULL,
    cost_per_employee NUMERIC(10,2) NOT NULL,
    difficulty_level VARCHAR(20) NOT NULL
);

CREATE TABLE training_enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(employee_id),
    training_id INTEGER NOT NULL REFERENCES training_programs(training_id),
    enrollment_date DATE NOT NULL,
    completion_date DATE,
    completion_status VARCHAR(30) NOT NULL
);

SET search_path TO lnd_project;

select * from departments
select * from employees
select * from training_programs
select * from training_enrollments

SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM training_programs;
SELECT COUNT(*) FROM training_enrollments;
SET search_path TO lnd_project;

CREATE TABLE assessments (
    assessment_id INTEGER PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES training_enrollments(enrollment_id),
    assessment_type VARCHAR(10) NOT NULL CHECK (assessment_type IN ('Pre', 'Post')),
    assessment_score INTEGER NOT NULL CHECK (assessment_score BETWEEN 0 AND 100),
    assessment_date DATE NOT NULL
);

CREATE TABLE feedback (
    feedback_id INTEGER PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES training_enrollments(enrollment_id),
    satisfaction_score INTEGER NOT NULL CHECK (satisfaction_score BETWEEN 1 AND 5),
    trainer_rating INTEGER NOT NULL CHECK (trainer_rating BETWEEN 1 AND 5),
    content_rating INTEGER NOT NULL CHECK (content_rating BETWEEN 1 AND 5),
    relevance_score INTEGER NOT NULL CHECK (relevance_score BETWEEN 1 AND 5),
    would_recommend VARCHAR(3) NOT NULL CHECK (would_recommend IN ('Yes', 'No')),
    feedback_date DATE NOT NULL
);

SELECT CURRENT_DATABASE();

SHOW search_path;

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'lnd_project'
ORDER BY table_name;


