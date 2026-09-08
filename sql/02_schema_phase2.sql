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

SELECT * FROM assessments;
SELECT COUNT(*) FROM feedback;

select * from assessments 

select assessment_type,
ROUND(avg(assessment_score),2) as assessment_score
FROM assessments 
group by assessment_type;

SELECT * FROM training_programs

SELECT 
tp.training_name,
ROUND (avg(case when assessment_type = 'Pre' then assessment_score END),2 ) as avg_pre_score,
ROUND (avg(case when assessment_type = 'Post' then assessment_score END),2 ) as avg_Post_score,
ROUND (avg(case when assessment_type = 'Post' then assessment_score END),2 ) - 
ROUND (avg(case when assessment_type = 'Pre' then assessment_score END),2 ) 
as avg_improvement
From assessments a
join training_enrollments te
on a.enrollment_id = te.enrollment_id
join training_programs tp
on te.training_id = tp.training_id
WHERE completion_status = 'Completed' 
group by tp.training_name
order by avg_improvement desc;

select * from feedback

SELECT tp.training_name,
ROUND(avg(f.satisfaction_score),2) as avg_satisfaction,
ROUND(avg(f.trainer_rating),2) as avg_trainer_rating,
ROUND(avg (f.content_rating),2) as avg_content_rating,
round(avg(f.relevance_score),2) as avg_relavence_score
from feedback f
join training_enrollments te
on f.enrollment_id = te.enrollment_id
join training_programs tp
on te.training_id = tp.training_id
group by training_name
order by avg_satisfaction desc;


