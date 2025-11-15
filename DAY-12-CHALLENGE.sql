/* Practice Questions:*/

/* Find all weeks in services_weekly where no special event occurred.*/
SELECT week, event
FROM services_weekly
WHERE event IS NULL 
OR event = 'none';
/* Count how many records have null or empty event values.*/ 
SELECT COUNT(*) 
FROM services_weekly 
WHERE event IS NULL OR event ='none'; 
/* List all services that had at least one week with a special event.*/ 
SELECT DISTINCT service
FROM services_weekly
WHERE event IS NOT NULL 
AND event <> 'none';

/* Question: Analyze the event impact by comparing weeks with events vs weeks without events.
Show: event status ('With Event' or 'No Event'), count of weeks, average patient satisfaction, and average staff morale. 
Order by average patient satisfaction descending.*/
SELECT 
    CASE 
        WHEN event IS NOT NULL AND event <> 'none' THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    COUNT(week) AS week_count,
    AVG(patient_satisfaction) AS avg_patient_satisfaction,
    AVG(staff_morale) AS avg_staff_morale
FROM services_weekly
GROUP BY 
    CASE 
        WHEN event IS NOT NULL AND event <> 'none' THEN 'With Event'
        ELSE 'No Event'
    END
ORDER BY avg_patient_satisfaction DESC;
