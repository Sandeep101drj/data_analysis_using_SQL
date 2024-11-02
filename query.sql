USE project_job_data_analysis;

/* 
Question 1: 
            - What are the top-paying data analyst jobs?
Deliverables :
            - Identify the top 10 highest-paying Data Analyst roles that are available remotely
            - Focus on job postings with specified salaries (remove nulls)
            - Include company names of top 10 roles
Goal :
            - Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility
*/
SELECT TOP 10
    job_id,job_title,job_location,job_schedule_type,salary_year_avg,job_posted_date,job_via,name as company_name
FROM 
    job_postings_fact
    LEFT JOIN
    company_dim ON job_postings_fact.company_id=company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
    ;

/* Question 2:
            - What skills are required for the top-paying data analyst jobs?
Deliverables:
            - Use the top 10 highest-paying Data Analyst jobs from first query
            - Add the specific skills required for these roles
Goal
            - provide a detailed look at which high-paying jobs demand certain skills,
              helping job seekers understand which skills to develop that align with top salaries
*/
SELECT 
    job_postings_fact.job_id,job_title,job_location,job_schedule_type,salary_year_avg,job_posted_date,job_via,name as company_name,skills
FROM 
    job_postings_fact
    LEFT JOIN
    company_dim ON job_postings_fact.company_id=company_dim.company_id
    INNER JOIN
    skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN
    skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
;

/* Question 3:
            - What are the most in-demand skills for data analysts?
Deliverables:
            - Join job postings to inner join table similar to query 2
            - Identify the top 5 in-demand skills for a data analyst.
            - Focus on all job postings.
Goal
            - Retrieves the top 5 skills with the highest demand in the job market, 
              providing insights into the most valuable skills for job seekers.
*/
SELECT TOP 5 skills,COUNT(skills) as Demand
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst'
GROUP BY
    skills
ORDER BY Demand DESC
;

/* Question 4:
            - What are the top skills based on salary?
Deliverables:
            - Look at the average salary associated with each skill for Data Analyst positions
            - Focuses on roles with specified salaries, regardless of location
Goal
            - reveal how different skills impact salary levels for Data Analysts and 
              help identify the most financially rewarding skills to acquire or improve
*/

SELECT skills,ROUND(AVG(salary_year_avg),0) as Average_Salary_per_year
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY Average_Salary_per_year DESC
;

/* Question 5:
            - What are the most optimal skills to learn (in high demand and a high-paying skill)?
Deliverables:
            - Identify skills in high demand and associated with high average salaries for Data Analyst roles
            - Concentrate on remote positions with specified salaries
Goal
            - Target skills that offer job security (high demand) and financial benefits (high salaries), 
              offering strategic insights for career development in data analysis
*/

SELECT TOP 25 skills,COUNT(skills) as Demand,ROUND(AVG(salary_year_avg),0) as Average_Salary_per_year
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home=1
GROUP BY
    skills
ORDER BY Demand DESC
;
