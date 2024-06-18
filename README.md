# Introduction
📊 Dive into the data job market! Focusing on data scientist roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔎 SQL Queries? Check them out here: [project_sql folder](/project_sql/) 

edit

# Background

edit

## Dataset

The dataset used in this project consists of information on the top 10 highest paying data scientist jobs based on average yearly salary. You can access the dataset [here](https://drive.google.com/drive/folders/your_folder_id).

Please note that the dataset is hosted externally on Google Drive and is not stored within this GitHub repository.*


Driven by a desire to better understand the data scientist job market and identify the most lucrative and sought-after skills, this project aimed to streamline the job search process for others seeking optimal positions in the data science field. Additionally, this project provided a valuable opportunity for me to become proficient in SQL and demonstrate my capability to perform advanced queries.

The dataset used for this analysis originated from a [SQL Course](https://lukebarousse.com/sql), containing valuable insights on job titles, salaries, locations, and essential skills. The data included job listings collected throughout the year 2023 using an [app](https://datanerd.tech) developed by the course leader.

### The questions I aimed to answer through my SQL queries were:

1. What are the top-paying data scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data scientists?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

By addressing these questions, the project provided a comprehensive overview of the current data science job market, highlighting key areas for professional development and career advancement. At the same time, it showcased my proficiency in SQL and my ability to handle complex data queries.

# Tools I Used
For my exploration of the data scientist job market, I utilized:

- **SQL:** Essential for querying and analyzing the dataset, providing insights into data scientist job trends.
- **PostgreSQL:** Chosen for its robust database management capabilities, ideal for handling and analyzing job postings data.
- **Visual Studio Code:** Used for writing and executing SQL queries, providing a user-friendly environment for project management.
- **Git and GitHub:** Employed for version control and potential collaboration, enabling future sharing of SQL scripts and analysis with others.

This project marked my first experience with these tools, allowing me to gain valuable skills in database management, SQL querying, version control, and preparing for potential collaboration on GitHub.

edit

# The Analysis
Each query for this project aimed at investigating specific aspects of the data scientist job market. Here's how I approached each question:

## 1. Top-Paying Data Scientist Jobs
To identify the highest-paying roles, I filtered data scientist positions by average yearly salary and location, with a focus on remote opportunities. This query highlights lucrative career options within the field of data science.

```sql
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
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data scientist jobs in 2023:
- **Wide Salary Range:** Top 10 paying data scientist roles span from $300,000 to $550,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like Walmart, Reddit, and Selby Jennings are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Scientist to Director of Data Science & Analytics, reflecting varied roles and specializations within data science.

### Visualizing Top Salaries

Here is an example of R code that can be used to visualize the top 10 highest paying data scientist jobs based on average yearly salary, as identified from the 1st analysis SQL query. 
```r
# Load necessary libraries
library(ggplot2)
library(readr) # For reading CSV file
library(scales) # For formatting

# Read the CSV file
data <- read_csv("top_salaries_data_scientist.csv")  # Replace with your location of the file

# Ensure salary_year_avg is numeric
data$salary_year_avg <- as.numeric(data$salary_year_avg)

# Take top 10 salaries
top_10 <- head(data, 10)

# Truncate job titles to make them shorter
top_10$job_title <- substr(top_10$job_title, 1, 23)

# Create a horizontal bar plot with formatted salary labels
ggplot(top_10, aes(x = salary_year_avg, y = reorder(job_title, -salary_year_avg))) +
  geom_bar(stat = "identity", fill = "skyblue", alpha = 0.7) +
  labs(title = "Top 10 Highest Paying Data Scientist Jobs",
       x = "Average Yearly Salary",
       y = "Job Title") +
  scale_x_continuous(labels = dollar_format(prefix = "$", suffix = "k", scale = 1e-3)) +  # Format salary labels
  theme_minimal() +
  theme(axis.text.y = element_text(face = "bold", size = 10),
        axis.text.x = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"))
```
Here is the bar graph that results from the above R code: (said here too many times!!!!!) (should i say above???)*
![Top Paying Jobs](assets/top10jobs.png)

**The file path in the R code should be replaced with your actual path to the CSV file containing the top salaries data. The top salaries CSV file containing the results from the 1st analysis SQL query can be found here: [assets folder](/assets/)*
*edit to the appropriate folder later after adding the csv file to it (a data folder within SQLProject), the current one just houses the image!!

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying data scientist jobs, I joined the job postings data with the skills data. The final result of this query included multiple rows for each job, with each row representing a job-skill combination. This provided valuable insights into the specific skills that employers prioritize for high-compensation roles.

```sql
WITH top_paying_jobs AS (

    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Scientist' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills --from skills_dim table
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest-paying data scientist jobs in 2023:

- **Python** leads with a prominent count of 5.
- **SQL** follows closely with a count of 4.
- **AWS** is also highly sought after, with a count of 3.
- Other skills such as **Java**, **GCP**, **TensorFlow**, and **Tableau** show varying degrees of demand.

### Visualizing Skills for Top Paying Jobs

Here is an example of R code that visualizes the count of skills for the top 10 highest paying data scientist jobs, based on the analysis conducted with the 2nd SQL query:

```r
# Load necessary library
library(ggplot2)

# Read the CSV file
skills_data <- read.csv("top_paying_job_skills_data_scientist.csv")

# Count the frequency of each skill
skill_counts <- table(skills_data$skill)
skill_counts <- as.data.frame(skill_counts)
colnames(skill_counts) <- c("skill", "count")

# Create a bar plot for skill counts with reversed order and gradient color
ggplot(skill_counts, aes(x = reorder(skill, count), y = count, fill = count)) +
  geom_bar(stat = "identity") +
  coord_flip() +  # Flip coordinates to make it horizontal
  labs(title = "Skill Count for Top 10 Highest Paying Data Scientist Jobs",
       x = "Skill",
       y = "Frequency") +
  scale_fill_gradient(low = "lightblue", high = "blue") +  # Gradient color
  theme_minimal() +
  theme(legend.position = "none")  # Hide the legend
```
Here is the bar graph that results from the above R code:
![Top Paying Jobs](assets/top10payingskills.png)
*say something about file path each time?

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
This query identified and ranked the top 5 skills most in demand for data scientist roles that offer work-from-home opportunities. *should i say remote every time or clarify at beginning

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data scientists in 2023:
-**Python** and **SQL** remain fundamental, emphasizing the need for strong foundational skills in data manipulation, analysis, and machine learning model development.
-**R**, **AWS**, and **Tableau** are also crucial, indicating high demand for statistical analysis, cloud computing skills, and advanced data visualization capabilities in complex data science projects.

### Top 5 In-Demand Skills for Data Scientists

| Skills      | Demand Count |
|-------------|--------------|
| Python      | 10390        |
| SQL         | 7488         |
| R           | 4674         |
| AWS         | 2593         |
| Tableau     | 2458         |

*Table of the top 5 most in-demand skills in data scientist job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
This SQL query identifies and ranks the top 25 skills that are most in demand for data scientist roles offering work-from-home opportunities, based on their average yearly salaries. By exploring these average salaries, it reveals which skills are the highest paying and provides insights into their relative value in the data scientist job market.


```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg)) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for the top paying skills for Data Analysts:
-**High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilites.
-**Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.**

### Breakdown of Top Skills for Data Scientists

- **Advanced Programming Languages:** Skills in Golang and PHP showcase expertise in modern programming languages, essential for developing efficient and scalable data solutions.

- **Data Analytics, Visualization, and Statistical Modeling:** Proficiency in tools like OpenCV, Neo4j, and Tidyverse highlights capabilities in advanced analytics, graph databases, statistical modeling, and data visualization, crucial for interpreting complex data, deriving insights, and optimizing data-driven processes.

- **Business Intelligence and Compliance Tools:** Mastery of platforms such as MicroStrategy and GDPR tools reflects skills in translating complex data into actionable insights and ensuring compliance with data regulations.

### Skills and Average Salaries

| Skill        | Average Salary ($) |
|--------------|--------------------|
| gdpr         | 217,738            |
| golang       | 208,750            |
| atlassian    | 189,700            |
| selenium     | 180,000            |
| opencv       | 172,500            |
| neo4j        | 171,655            |
| microstrategy| 171,147            |
| dynamodb     | 169,670            |
| php          | 168,125            |
| tidyverse    | 165,513            |

*Table of the average salary for the top 10 paying skills for data scientists*

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
*make table of skill id, skills, demand count, avg salary
*Table of the most optimal skills for data analyst sorted by salary.

Here's a breakdown of the most optimal skills for Data Analysts in 2023:
-**High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
-**Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
-**Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
-**Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **puzzle emoji Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **bar graph emoji Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **lightbulb emoji Analytical Wizardy:** Leveled up my real-world puzzle-solving, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:
1. **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest of $650,000!
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skills for earning top salary.
3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demad and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This Project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspriring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continous learning and adaptation to emerging trends in the field of data analytics.

pin repository*
