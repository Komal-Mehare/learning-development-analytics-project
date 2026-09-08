SET search_path TO lnd_project;

CREATE TABLE skills (
    skill_id INTEGER PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    skill_category VARCHAR(50) NOT NULL
);

CREATE TABLE employee_skills (
    employee_skill_id INTEGER PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(employee_id),
    skill_id INTEGER NOT NULL REFERENCES skills(skill_id),
    proficiency_level INTEGER NOT NULL CHECK (proficiency_level BETWEEN 1 AND 5)
);

CREATE TABLE role_skill_requirements (
    requirement_id INTEGER PRIMARY KEY,
    job_title VARCHAR(120) NOT NULL,
    skill_id INTEGER NOT NULL REFERENCES skills(skill_id),
    required_level INTEGER NOT NULL CHECK (required_level BETWEEN 1 AND 5)
);

SET search_path TO lnd_project;

SELECT COUNT(*) FROM skills;
SELECT COUNT(*) FROM employee_skills;
SELECT COUNT(*) FROM role_skill_requirements;

SELECT 
e.employee_name,
e.job_title,
s.skill_name,
es.proficiency_level as current_level,
rsr.required_level,
rsr.required_level-es.proficiency_level as skill_gap
from employees e
join employee_skills es
on e.employee_id = es.employee_id
join skills s
on es.skill_id = s.skill_id
join role_skill_requirements rsr
on e.job_title = rsr.job_title
and es.skill_id = rsr.skill_id
WHERE rsr.required_level > es.proficiency_level
ORDER BY skill_gap DESC;

SELECT s.skill_name,
COUNT(*) AS employees_with_gap,
ROUND(AVG(rsr.required_level - es.proficiency_level),2) AS avg_skill_gap
FROM employees e
JOIN employee_skills es
ON e.employee_id = es.employee_id
JOIN skills s
ON es.skill_id = s.skill_id
JOIN role_skill_requirements rsr
ON e.job_title = rsr.job_title
AND es.skill_id = rsr.skill_id
WHERE rsr.required_level > es.proficiency_level
GROUP BY s.skill_name
ORDER BY employees_with_gap DESC;

SELECT 
d.department_name,
COUNT(*) AS total_skill_gaps,
COUNT (distinct(e.employee_id)) as employee_with_gaps, 
ROUND(avg(rsr.required_level - es.proficiency_level),2) as avg_skill_gap
from employees e 
join departments d
on e.department_id = d.department_id 
join employee_skills es
on e.employee_id = es.employee_id
join role_skill_requirements rsr
on e.job_title = rsr.job_title 
and es.skill_id = rsr.skill_id
WHERE rsr.required_level>es.proficiency_level
group by d.department_name
order by total_skill_gaps DesC;


SELECT
completion_status,
COUNT(*) AS total_enrollments
FROM training_enrollments
GROUP BY completion_status
ORDER BY total_enrollments DESC;

select 
count (*) as total_enrollment,
sum(case when completion_status='Completed' then 1 else 0 end) as completed,
sum(case when completion_status='Dropped' then 1 else 0 end) as dropped,
ROUND(100.0*sum(case when completion_status='Completed' then 1 else 0 end)/ count(*),2)
as completion_rate,
ROUND(100.0*sum(case when completion_status='Dropped' then 1 else 0 end)/ count(*),2)
as dropout_rate
from training_enrollments;

SELECT
tp.training_name,
count (*) as total_enrollment,
sum(case when te.completion_status='Completed' then 1 else 0 end) as completed,
sum(case when te.completion_status='Dropped' then 1 else 0 end) as dropped,
ROUND(100.0*sum(case when te.completion_status='Completed' then 1 else 0 end)/ count(*),2)
as completion_rate,
ROUND(100.0*sum(case when te.completion_status='Dropped' then 1 else 0 end)/ count(*),2)
as dropout_rate
from training_enrollments te
join training_programs tp
on tp.training_id=te.training_id
group by tp.training_name
order by completion_rate desc;

select * from training_programs;
select tp.training_name, tp.cost_per_employee,
count(*) as total_enrollments,
count (*) * cost_per_employee as total_training_cost
from training_enrollments te
join training_programs tp
on te.training_id = tp.training_id
group by tp.training_name,
tp.cost_per_employee
ORDER BY total_training_cost DESC; 

WITH training_effectiveness AS (
SELECT tp.training_id,
tp.training_name,
ROUND(AVG(CASE WHEN a.assessment_type = 'Post' THEN a.assessment_score END)-         
AVG(CASE WHEN a.assessment_type = 'Pre' THEN a.assessment_score END),2) AS avg_improvement
FROM assessments a
JOIN training_enrollments te
ON a.enrollment_id = te.enrollment_id
JOIN training_programs tp
ON te.training_id = tp.training_id
WHERE te.completion_status = 'Completed'
GROUP BY tp.training_id, tp.training_name
)
SELECT
tef.training_name,
tef.avg_improvement,
COUNT(*) AS total_enrollments,
tp.cost_per_employee,
COUNT(*) * tp.cost_per_employee
AS total_training_cost
FROM training_effectiveness tef
JOIN training_programs tp
ON tef.training_id = tp.training_id
JOIN training_enrollments te
ON tp.training_id = te.training_id
GROUP BY
tef.training_name,
tef.avg_improvement,
tp.cost_per_employee
ORDER BY total_training_cost DESC;

-- Business Question:
-- Which training programs are expensive but produce below-average improvement?

WITH training_effectiveness AS (
SELECT
tp.training_id,
tp.training_name,
ROUND(AVG(CASE WHEN a.assessment_type = 'Post' THEN a.assessment_score END)-
AVG(CASE WHEN a.assessment_type = 'Pre' THEN a.assessment_score END ),2) AS avg_improvement
FROM assessments a
JOIN training_enrollments te
	ON a.enrollment_id = te.enrollment_id
JOIN training_programs tp
    ON te.training_id = tp.training_id
    WHERE te.completion_status = 'Completed'
GROUP BY
tp.training_id,
tp.training_name
),
training_cost AS (
SELECT
tp.training_id,
tp.cost_per_employee,
COUNT(*) AS total_enrollments,
COUNT(*) * tp.cost_per_employee AS total_training_cost
FROM training_enrollments te
JOIN training_programs tp
ON te.training_id = tp.training_id
GROUP BY
tp.training_id,
tp.cost_per_employee
),
training_summary AS 
(
SELECT
tef.training_id,
tef.training_name,
tef.avg_improvement,
tc.total_enrollments,
tc.cost_per_employee,
tc.total_training_cost
FROM training_effectiveness tef
JOIN training_cost tc
ON tef.training_id = tc.training_id
)
SELECT
training_name,
avg_improvement,
total_enrollments,
cost_per_employee,
total_training_cost,
CASE WHEN total_training_cost > (SELECT AVG(total_training_cost)
FROM training_summary)
AND avg_improvement <(SELECT AVG(avg_improvement) FROM training_summary)
THEN 'Needs Review'
ELSE 'Acceptable'
END AS program_status
FROM training_summary
ORDER BY total_training_cost DESC;

with completion_metrics as (
	select tp.training_id,
		tp.training_name,
		count (*) as total_enrollments,
		round(100.0*sum(case when te.completion_status ='Completed' then 1 else 0 end)/count(*),2)
		as completion_rate 
		from training_enrollments te
		join training_programs tp 
		on te.training_id = tp.training_id
		group by tp.training_id,
				tp.training_name),
effectiveness_metrices as (
	select te.training_id,
	round(avg(case when a.assessment_type='Post' then a.assessment_score end)-	
	avg(case when a.assessment_type='Pre' then a.assessment_score end),2)
	as avg_improvement
	from assessments a
	join training_enrollments te
	on a.enrollment_id = te.enrollment_id 
	where te.completion_status='Completed' 
	group by te.training_id ),
feedback_metrics as (
	select te.training_id,
	round(avg(f.satisfaction_score),2)
	as avg_satisfaction
	from feedback f
	join training_enrollments te 
	on f.enrollment_id = te.enrollment_id
	group by te.training_id),
cost_metrics as (
	select te.training_id,
	count(*) * tp.cost_per_employee as total_training_cost
	from training_enrollments te
	join training_programs tp
	on te.training_id=tp.training_id
	group by te.training_id, 
			tp.cost_per_employee)
select 
	cm.training_name,
    cm.total_enrollments,
    cm.completion_rate,
    em.avg_improvement,
    fm.avg_satisfaction,
    cost.total_training_cost
from completion_metrics cm
JOIN effectiveness_metrices em
    ON cm.training_id = em.training_id
JOIN feedback_metrics fm
    ON cm.training_id = fm.training_id
JOIN cost_metrics cost
    ON cm.training_id = cost.training_id
ORDER BY em.avg_improvement DESC;

WITH training_effectiveness AS (
    SELECT
        tp.training_name,
    ROUND(AVG(CASE WHEN a.assessment_type = 'Post' THEN a.assessment_score END)-
    AVG(CASE WHEN a.assessment_type = 'Pre' THEN a.assessment_score END), 2) 
	AS avg_improvement
    FROM assessments a
    JOIN training_enrollments te
        ON a.enrollment_id = te.enrollment_id
    JOIN training_programs tp
        ON te.training_id = tp.training_id
    WHERE te.completion_status = 'Completed'
    GROUP BY tp.training_name)

SELECT
    training_name,
    avg_improvement,
	rank() over (order by avg_improvement desc) as improvement_rank 
	FROM training_effectiveness
	ORDER BY improvement_rank;

	-- Data Quality Check:
-- Check for missing important values in training enrollments.

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE employee_id IS NULL ) AS missing_employee_id,
    COUNT(*) FILTER (
        WHERE training_id IS NULL ) AS missing_training_id,
    COUNT(*) FILTER (
        WHERE enrollment_date IS NULL) AS missing_enrollment_date,
    COUNT(*) FILTER (
        WHERE completion_status IS NULL ) AS missing_completion_status
FROM training_enrollments;

-- Data Quality Check:
-- Find possible duplicate training enrollments.

SELECT
    employee_id,
    training_id,
    enrollment_date,
    COUNT(*) AS duplicate_count
FROM training_enrollments
GROUP BY
    employee_id,
    training_id,
    enrollment_date
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Data Quality Check:
-- Find invalid assessment scores.

SELECT *
FROM assessments
WHERE assessment_score < 0
   OR assessment_score > 100;

-- Data Quality Check:
-- Find unexpected completion-status values.

SELECT DISTINCT completion_status
FROM training_enrollments;

-- Data Quality Check:
-- Find completion dates earlier than enrollment dates.

SELECT *
FROM training_enrollments
WHERE completion_date < enrollment_date;

-- Data Quality Check:
-- Find completed training records with missing completion dates.

SELECT *
FROM training_enrollments
WHERE completion_status = 'Completed'
  AND completion_date IS NULL;

