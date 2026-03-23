USE hr_analytics;

-- Query 1: Attrition rate by Department
SELECT 
    Department,
    COUNT(*) as total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as attrition_rate
FROM employees
GROUP BY Department
ORDER BY attrition_rate DESC;

-- Query 2: Department + Overtime CTE
WITH attrition_summary AS (
    SELECT 
        Department,
        OverTime,
        COUNT(*) as total,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as left_count,
        ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as attrition_rate
    FROM employees
    GROUP BY Department, OverTime
)
SELECT * FROM attrition_summary
ORDER BY attrition_rate DESC;

-- Query 3: Salary comparison using Window Functions
SELECT 
    Department,
    JobRole,
    ROUND(AVG(MonthlyIncome), 0) as avg_salary,
    ROUND(AVG(AVG(MonthlyIncome)) OVER (PARTITION BY Department), 0) as dept_avg_salary,
    CASE 
        WHEN AVG(MonthlyIncome) > AVG(AVG(MonthlyIncome)) OVER (PARTITION BY Department) 
        THEN 'Above Average'
        ELSE 'Below Average'
    END as salary_position
FROM employees
GROUP BY Department, JobRole
ORDER BY Department, avg_salary DESC;