/*
Question: What are the top-paying data analyst jobs?
(do this later for data scientist jobs)
-identify top 10 highest-paying data analyst jobs that are remote
-focuses on job postings with specified salaries (remove nulls)
-why? highlight top-paying opportunities for data analysts, offering insights into employment opportunities
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

--want to know company as well, so added left join