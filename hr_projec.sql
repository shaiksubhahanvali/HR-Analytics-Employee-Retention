 create database hr_analytics;
 use hr_analytics;
 CREATE TABLE hr_1 (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(30),
    DailyRate INT,
    Department VARCHAR(100),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(100),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(20),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(100),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(30)
);
desc table hr_1;
select * from hr_1;
select count(*) from hr_1;
CREATE TABLE hr_2 (
    Employee_ID INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
select * from hr_2;
select count(*) from hr_2;

-- Total Employees
SELECT COUNT(EmployeeNumber) AS Total_Employees FROM hr_1;

-- Active Employees
SELECT COUNT(EmployeeNumber) AS Active_Employees FROM hr_1
WHERE Attrition = 'No';

-- Attrition count
SELECT COUNT(EmployeeNumber) AS Attrition_Count
FROM hr_1
WHERE Attrition = 'Yes';
-- Attrition Rate
 SELECT 
    CONCAT(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*),2),"%")AS Attrition_Rate
    FROM hr_1;
 
-- Average monthly income
SELECT ROUND(AVG(MonthlyIncome), 2) AS Average_Monthly_Income
FROM hr_2;

-- Average total working years
SELECT ROUND(AVG(TotalWorkingYears), 2) AS Average_Total_Working_Years
FROM hr_2;

-- what is average attrition rate accross all the departments
SELECT
    Department,
    concat(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1
GROUP BY Department
ORDER BY Attrition_Rate DESC;

 -- what is average hourly rate of male research scientists?
 SELECT ROUND(AVG(HourlyRate), 2) AS Average_Hourly_Rate FROM hr_1
 WHERE Gender = 'Male'
 AND JobRole = 'Research Scientist';
  
-- how does attrition rate vary across monthly income groups?
  SELECT
    CASE
        WHEN h2.MonthlyIncome BETWEEN 0 AND 10000 THEN '0-10K'
        WHEN h2.MonthlyIncome BETWEEN 10001 AND 20000 THEN '10K-20K'
        WHEN h2.MonthlyIncome BETWEEN 20001 AND 30000 THEN '20K-30K'
        WHEN h2.MonthlyIncome BETWEEN 30001 AND 40000 THEN '30K-40K'
        ELSE '40K+'
         
    END AS Income_Group,
    concat(ROUND(SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY Income_Group
ORDER BY  CASE income_group WHEN '0-10K' THEN 1
        WHEN '10K-20K' THEN 2
        WHEN '20K-30K' THEN 3
        WHEN '30K-40K' THEN 4
        WHEN '40K+' THEN 5
    END;

-- What is average working years for employees in each department  
  SELECT
    h1.Department,
    ROUND(AVG(h2.TotalWorkingYears), 2) AS Average_Working_Years
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY h1.Department
ORDER BY Average_Working_Years DESC;

-- how does work life balance vary across different job roles?
SELECT 
h1.JobRole,
    SUM(h2.WorkLifeBalance = 1) AS `1`,
    SUM(h2.WorkLifeBalance = 2) AS `2`,
    SUM(h2.WorkLifeBalance = 3) AS `3`,
    SUM(h2.WorkLifeBalance = 4) AS `4`,
    COUNT(h1.EmployeeNumber) AS Grand_Total
FROM hr_1 AS h1 JOIN Hr_2 AS h2 ON h1.EmployeeNumber = h2.Employee_id
GROUP BY h1.JobRole ORDER BY h1.JobRole;

-- how does attrition rate vary with years since last promotion?
SELECT
    h2.YearsSinceLastPromotion,
    concat(ROUND(SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY h2.YearsSinceLastPromotion
ORDER BY h2.YearsSinceLastPromotion;

-- 17 Does overtime significantly increase employee attrition?
SELECT
    h2.OverTime,
    concat(ROUND(
        SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY h2.OverTime ;
 

-- 18. Which Work-Life Balance Level Has Highest Attrition?
SELECT
    h2.WorkLifeBalance,
    concat(ROUND(SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY h2.WorkLifeBalance
ORDER BY Attrition_Rate DESC limit 1;


-- Does Job Satisfaction Impact Attrition?
SELECT
    JobSatisfaction,
     concat(ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Does employee tenure influence attrition?
SELECT
    CASE
        WHEN h2.YearsAtCompany between 0 and 2 THEN '0-2 Years'
        WHEN h2.YearsAtCompany between 3 and 5  THEN '3-5 Years'
        WHEN h2.YearsAtCompany between 6 and 10 THEN '6-10 Years'
        WHEN h2.YearsAtCompany  between 11 and 15 THEN '11-15 Years'
        ELSE '16+ Years'
    END AS Tenure_Group,
concat(ROUND(SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1 JOIN hr_2 h2 ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY Tenure_Group
ORDER BY  case Tenure_Group 
          WHEN '0-2 years' THEN 1
        WHEN '3-5 years' THEN 2
        WHEN '6-10 years' THEN 3
        WHEN '11-15 years' THEN 4
        WHEN '16+ years' THEN 5
    END;

-- which age group has the highest attrition rate?
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '<25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
concat(ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1 
GROUP BY Age_Group
ORDER BY CASE Age_Group
    WHEN '<25' THEN 1
    WHEN '26-35' THEN 2
    WHEN '36-45' THEN 3
    WHEN '46-55' THEN 4
    WHEN '56+' THEN 5
END;

-- which job roles have the hihest attrition rates?
SELECT
    JobRole,
	concat(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%") AS Attrition_Rate
FROM hr_1 h1
GROUP BY JobRole
ORDER BY Attrition_Rate DESC;

-- Does total working experience affect attrition?
SELECT CASE
        WHEN h2.TotalWorkingYears BETWEEN 0 AND 5 THEN '0-5 years'
        WHEN h2.TotalWorkingYears BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN h2.TotalWorkingYears BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN h2.TotalWorkingYears BETWEEN 16 AND 20 THEN '16-20 years'
        WHEN h2.TotalWorkingYears BETWEEN 21 AND 30 THEN '21-30 years'
        ELSE '31+ years'
END AS working_experience,
CONCAT(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100/ COUNT(*),2),"%")  AS Attrition_Rate
FROM Hr_1 AS h1 JOIN Hr_2 AS h2  ON h1.EmployeeNumber = h2.Employee_ID
GROUP BY working_experience 
ORDER BY CASE working_experience
        WHEN '0-5 years' THEN 1
        WHEN '6-10 years' THEN 2
        WHEN '11-15 years' THEN 3
        WHEN '16-20 years' THEN 4
        WHEN '21-30 years' THEN 5
        WHEN '31+ years' THEN 6
    END;