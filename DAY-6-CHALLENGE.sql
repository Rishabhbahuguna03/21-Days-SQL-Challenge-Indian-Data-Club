/* Practice Questions */

/* 1. Count the number of patients by each service.*/
Select COUNT(patients),service
FROM patients 
GROUP BY service;
/* 2. Calculate the average age of patients grouped by service.*/
SELECT ROUND(AVG(age)),service 
FROM patients 
GROUP BY service;
/* 3. Find the total number of staff members per role.*/
SELECT COUNT(staff),role 
FROM staff
GROUP BY role;

/* Daily Challenge:*/
/* Question: For each hospital service, calculate the total number of patients admitted, total patients refused, 
and the admission rate (percentage of requests that were admitted). Order by admission rate descending.*/
SELECT 
    service,
    SUM(patients_admitted) AS total_admitted,
    SUM(patients_refused) AS total_refused,
    ROUND(
        (SUM(patients_admitted) * 100.0) / 
        (SUM(patients_admitted) + SUM(patients_refused)), 
    2) AS admission_rate
FROM 
    services_weekly
GROUP BY 
    service
ORDER BY 
    admission_rate DESC;
