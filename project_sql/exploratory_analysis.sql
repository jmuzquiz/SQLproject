--making sure all dates are from 2023
SELECT
    MIN(job_posted_date) AS earliest_date,
    MAX(job_posted_date) AS latest_date
FROM
    job_postings_fact;
--this is in UTC time as per course leader

