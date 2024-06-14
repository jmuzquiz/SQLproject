/*
Question: what are the top skills based on salary?
-look at the average salary associated with each skill for Data Analyst positions
-focuses on roles with specified salaries, regardless of location
-why? it reveals how different skills impact salary levels for data analysts
    and helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    -- AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

--can do csv file again or talk to chatgpt about results