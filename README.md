Learning & Development Analytics

This project analyzes employee Learning & Development data using PostgreSQL, SQL, and Power BI.
The goal was to understand training effectiveness, completion and dropout rates, learner feedback, L&D spending, and employee skill gaps.

The dataset is synthetic and was created for learning and portfolio purposes.

PROJECT OBJECTIVE

The project answers questions such as:

Are employees improving after training?
Which training programs are most effective?
Which programs have high completion or dropout rates?
Which departments and skills have the biggest gaps?
Which training programs are expensive but less effective?

TOOLS USED

PostgreSQL
SQL
Power BI
Power Query
DAX
GitHub

DATASET

The project contains 65,096 records across 9 related tables, including:

2,000 employees
12,000 training enrollments
19,536 assessment records
7,001 feedback records
23,955 employee skill records

SQL ANALYSIS

The SQL analysis covered:

Training participation
Training effectiveness
Feedback analysis
Skills gap analysis
Completion and dropout rates
Training cost analysis
Cost vs effectiveness
Data quality validation

SQL concepts used include JOIN, GROUP BY, HAVING, CASE WHEN, CTEs, subqueries, window functions, and RANK().

SQL BUSINESS QUESTIONS:
The SQL analysis was built around practical business questions, including:

Which departments have the highest training participation?
Which training programs have the most enrollments?
Did employees improve after completing training?
Which training programs produced the highest average improvement in assessment scores?
Which training programs received the highest learner satisfaction?
Which employees have skills below the level required for their current role?
Which skills have the largest number of employee skill gaps?
Which departments have the greatest skill gaps?
What are the overall training completion and dropout rates?
Which training programs have the highest completion and dropout rates?
Which training programs have the highest total training cost?
Which expensive training programs produce below-average learning improvement?
How do training programs compare across completion rate, learning improvement, satisfaction, and cost?
Which training programs rank highest based on learning improvement?
Are there any missing values, duplicate records, invalid scores, or inconsistent dates in the dataset?

KEY FINDINGS

Training completion rate: 72.29%
Dropout rate: 7.94%
Power BI Fundamentals had the highest average assessment improvement at 17.66 points
SQL for Analysts had the highest total training investment at about ₹2.58 million
Information Technology had the highest number of skill gaps with 903
Customer Support had the highest average skill-gap severity at about 1.30
No critical missing values or exact duplicate enrollment records were found

POWER BI DASHBOARD

The dashboard contains 3 pages:
Executive Overview
Shows workforce size, training enrollments, completion rate, dropout rate, training cost, department participation, and top training programs.
screenshots/01_executive_overview.png

Training Effectiveness
Shows pre and post scores, average improvement, satisfaction, completion rate by program, and training cost vs learning improvement.
screenshots/02_training_effectiveness.png

Skills Gap Analysis
Shows total skill gaps, employees with gaps, top skills requiring development, department-level gaps, and employee skill-gap details.
screenshots/03_skills_gap_analysis.png

SKILLS DEMONSTRATED

SQL and Database
Relational database design
Multi-table joins
Aggregations
CTEs and subqueries
Window functions
Data validation

Power BI
Data modelling
Table relationships
Power Query
DAX measures
Interactive slicers
Dashboard development

WHY I BUILT THIS PROJECT
I built this project to explore how data can be used to understand employee learning, development needs, and training outcomes. With my background in psychology,
I was especially interested in looking at learning improvement, feedback, skill gaps, and employee development from both a behavioural and analytical perspective. 
the project brings together training participation, assessment results, learner feedback, cost, and skill data in one system. Using SQL and Power BI, I analyzed which programs were more effective, 
where skill gaps were concentrated, how employees progressed after training, and where L&D investment may need closer review.

AUTHOR

Komal Mehare

Interested in opportunities related to HR Analytics, People Analytics, Learning & Development Analytics, and Research Analytics.
