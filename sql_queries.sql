CREATE TABLE hr_data (
    Age                      INT,
    Attrition                VARCHAR(5),
    BusinessTravel           VARCHAR(30),
    DailyRate                INT,
    Department               VARCHAR(30),
    DistanceFromHome         INT,
    Education                INT,
    EducationField           VARCHAR(30),
    EmployeeNumber           INT PRIMARY KEY,
    EnvironmentSatisfaction  INT,
    Gender                   VARCHAR(10),
    HourlyRate               INT,
    JobInvolvement           INT,
    JobLevel                 INT,
    JobRole                  VARCHAR(40),
    JobSatisfaction          INT,
    MaritalStatus            VARCHAR(15),
    MonthlyIncome            INT,
    MonthlyRate              INT,
    NumCompaniesWorked       INT,
    OverTime                 VARCHAR(5),
    PercentSalaryHike        INT,
    PerformanceRating        INT,
    RelationshipSatisfaction INT,
    StockOptionLevel         INT,
    TotalWorkingYears        INT,
    TrainingTimesLastYear    INT,
    WorkLifeBalance          INT,
    YearsAtCompany           INT,
    YearsInCurrentRole       INT,
    YearsSinceLastPromotion  INT,
    YearsWithCurrManager     INT,
    Attrition_Binary         INT
);

SELECT COUNT(*) FROM hr_data;

--Query 1 — Overall Attrition Rate
SELECT
    COUNT(*) AS total_employees,
    SUM(attrition_binary) AS left_count,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data;

--Query 2 — Attrition by Department
SELECT
    department,
    COUNT(*) AS total,
    SUM(attrition_binary) AS left_count,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
GROUP BY department
ORDER BY attrition_rate DESC;

--Query 3 — Overtime Impact
SELECT
    overtime,
    COUNT(*) AS total,
    SUM(attrition_binary) AS left_count,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
GROUP BY overtime
ORDER BY attrition_rate DESC;

--Query 4 — Job Satisfaction by Role
SELECT
    jobrole,
    ROUND(AVG(jobsatisfaction)::NUMERIC, 2) AS avg_satisfaction,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
GROUP BY jobrole
ORDER BY avg_satisfaction ASC;

--Query 5 — Income Brackets
SELECT
    CASE
        WHEN monthlyincome < 3000 THEN 'Low'
        WHEN monthlyincome < 6000 THEN 'Mid'
        WHEN monthlyincome < 10000 THEN 'Upper-Mid'
        ELSE 'High'
    END AS income_band,
    COUNT(*) AS total,
    SUM(attrition_binary) AS left_count,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
GROUP BY income_band
ORDER BY attrition_rate DESC;

--Query 6 — Age Groups
SELECT
    CASE
        WHEN age < 25 THEN 'Under 25'
        WHEN age < 35 THEN '25-34'
        WHEN age < 45 THEN '35-44'
        ELSE '45+'
    END AS age_group,
    COUNT(*) AS total,
    SUM(attrition_binary) AS left_count,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
GROUP BY age_group
ORDER BY attrition_rate DESC;

--Query 7 — High Risk Roles (Overtime + Attrition)
SELECT
    jobrole,
    department,
    COUNT(*) AS headcount,
    ROUND(AVG(monthlyincome)) AS avg_income,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
WHERE overtime = 'Yes'
GROUP BY jobrole, department
HAVING COUNT(*) >= 10
ORDER BY attrition_rate DESC
LIMIT 10;

--Query 8 — Work Life Balance
SELECT
    worklifebalance,
    COUNT(*) AS total,
    SUM(attrition_binary) AS left_count,
    ROUND(AVG(attrition_binary) * 100, 2) AS attrition_rate
FROM hr_data
GROUP BY worklifebalance
ORDER BY worklifebalance;
