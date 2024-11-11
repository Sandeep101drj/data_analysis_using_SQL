# Data Analysis Project Using SQL: Job Market Insights for Data Analyst Roles

This project utilizes SQL to analyze the job market for Data Analyst roles based on four datasets. The primary focus is to identify high-paying job opportunities, understand required skills, and reveal skills that are both in demand and financially rewarding.

## Datasets

The analysis utilizes four flat files as datasets, loaded into SQL tables for querying and analysis. Below are the details of each dataset:

### Fact Table

1. **`job_postings_fact`**
   - **Columns**: 
     - `job_id`, `company_id`, `job_title_short`, `job_title`, `job_location`, `job_via`, `job_schedule_type`, `job_work_from_home`, `search_location`, `job_posted_date`, `job_no_degree_mention`, `job_health_insurance`, `job_country`, `salary_rate`, `salary_year_avg`, `salary_hour_avg`
   - **Total Rows**: 787,687

### Dimension Tables

1. **`company_dim`**
   - **Columns**: 
     - `company_id`, `name`
   - **Total Rows**: 140,027

2. **`skills_dim`**
   - **Columns**: 
     - `skill_id`, `skills`, `type`
   - **Total Rows**: 259

3. **`skills_job_dim`**
   - **Columns**: 
     - `job_id`, `skill_id`
   - **Total Rows**: 3,669,604

## Tools Used
This project was developed using Microsoft SQL Server and Visual Studio Code. 

- **Microsoft SQL Server**: A robust relational database management system that facilitated the creation, management, and analysis of the sales data. SQL Server's powerful querying capabilities enabled efficient data extraction and manipulation, allowing for comprehensive insights into sales performance.

- **Visual Studio Code**: A lightweight and versatile code editor that provided a user-friendly environment for writing and executing SQL queries. Its integrated terminal and extensions enhanced productivity by enabling seamless database interaction and code management.

## Analysis Questions and SQL Queries

This section details each analysis question along with the SQL queries used to answer them.

---

### Question 1: What are the top-paying Data Analyst jobs?

#### Goal
Identify the top 10 highest-paying Data Analyst roles that are available remotely, providing insights into employment options and location flexibility.

#### Deliverables
- List the top 10 highest-paying Data Analyst jobs that offer remote work.
- Focus only on job postings with specified salaries (exclude rows where `salary_year_avg` is `NULL`).
- Include company names of the top 10 roles.

#### SQL Query

```sql
USE project_job_data_analysis;

SELECT TOP 10
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    job_via,
    name AS company_name
FROM 
    job_postings_fact
    LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;
```

---

### Question 2: What skills are required for the top-paying Data Analyst jobs?

#### Goal
Provide a detailed overview of the specific skills required for the highest-paying Data Analyst jobs. This information can help job seekers focus on high-value skills.

#### Deliverables
- Use the top 10 highest-paying Data Analyst jobs from the first query.
- List the specific skills required for these roles.

#### SQL Query

```sql
SELECT 
    job_postings_fact.job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    job_via,
    name AS company_name,
    skills
FROM 
    job_postings_fact
    LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;
```

### Question 3: What are the most in-demand skills for Data Analysts?

#### Goal
Retrieve the top 5 skills with the highest demand in the job market. This will provide insights into the most valuable skills for job seekers.

#### Deliverables
- Identify the top 5 in-demand skills for Data Analyst roles.
- Analyze all job postings, regardless of location or salary.

#### SQL Query

```sql
SELECT TOP 5 
    skills,
    COUNT(skills) AS Demand
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY 
    Demand DESC;
```

### Question 4: What are the top skills based on salary?

#### Goal
Analyze how different skills impact salary levels for Data Analyst positions. This information will help identify the most financially rewarding skills.

#### Deliverables
- Calculate the average salary associated with each skill for Data Analyst positions.
- Focus only on roles with specified salaries, regardless of location.

#### SQL Query

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS Average_Salary_per_year
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
GROUP BY 
    skills
ORDER BY 
    Average_Salary_per_year DESC;
```

### Question 5: What are the most optimal skills to learn (in high demand and a high-paying skill)?

#### Goal
Identify skills that offer both high demand and high salaries for Data Analyst roles, especially for remote positions. This can guide job seekers in targeting skills that enhance job security and financial benefits.

#### Deliverables
- Identify skills that are both in high demand and associated with high average salaries for remote Data Analyst positions with specified salaries.

#### SQL Query

```sql
SELECT TOP 25 
    skills,
    COUNT(skills) AS Demand,
    ROUND(AVG(salary_year_avg), 0) AS Average_Salary_per_year
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 1
GROUP BY 
    skills
ORDER BY 
    Demand DESC;
```

---

## Conclusion

This SQL-based data analysis project offers insights into the Data Analyst job market, focusing on high-paying job opportunities, in-demand skills, and optimal skills to acquire for career advancement. Here is a summary of the findings:

1. **Top-Paying Data Analyst Jobs**: The top 10 highest-paying Data Analyst jobs that offer remote work flexibility are identified, giving job seekers insight into lucrative, location-flexible roles.
2. **Skills Required for High-Paying Jobs**: By analyzing the top-paying jobs, a list of essential skills that employers look for are identified, helping job seekers understand which skills are most valuable for high-salary positions.
3. **Most In-Demand Skills**: The top 5 most in-demand skills for Data Analyst positionsa are identified, giving job seekers an idea of what skills are essential for securing a job in this field.
4. **Top Skills Based on Salary**: By evaluating average salaries associated with each skill, the skills that significantly increase earning potential, guiding professionals toward high-value skill acquisition are pinpointed.
5. **Optimal Skills to Learn**: Lastly,the skills that are both in high demand and associated with high salaries for remote Data Analyst positions are identified, helping job seekers make informed career development choices that balance job security and financial benefits.

This project provides a valuable resource for job seekers aiming to enter or advance in the field of Data Analysis. By understanding the combination of high-paying, in-demand skills, job seekers can strategically develop skills that align with lucrative and flexible career opportunities.

--- 
