/* Practice Questions */

/* 1. Join patients, staff, and staff_schedule to show patient service and staff availability.*/
SELECT 
    p.patient_id,p.service,s.staff_name,ss.week,ss.present
FROM patients p
LEFT JOIN staff s ON p.service = s.service
LEFT JOIN staff_schedule ss ON s.staff_id = ss.staff_id
ORDER BY p.patient_id, ss.week;
/* 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.*/
SELECT 
    sw.week,sw.service,sw.event,sw.patient_satisfaction,sw.staff_morale,st.staff_id,st.staff_name,st.role,ss.present
FROM services_weekly sw
LEFT JOIN staff st ON sw.service = st.service
LEFT JOIN staff_schedule ss ON st.staff_id = ss.staff_idAND sw.week = ss.week
ORDER BY sw.week, st.staff_name;
/* 3. Create a multi-table report showing patient admissions with staff information.*/
SELECT 
    p.patient_id,p.name AS patient_name,p.service,sw.week,sw.event,sw.patient_satisfaction,sw.staff_morale,
    st.staff_id,st.staff_name,st.role,ss.present AS staff_present
FROM patients p
LEFT JOIN services_weekly sw ON p.service = sw.service
LEFT JOIN staff st ON p.service = st.service
LEFT JOIN staff_schedule ss ON st.staff_id = ss.staff_id AND sw.week = ss.week
ORDER BY p.patient_id, sw.week, st.staff_name;

/*Question: Create a comprehensive service analysis report for week 20 showing: service name, total patients 
admitted that week, total patients refused, average patient satisfaction, count of staff assigned to service, 
and count of staff present that week. Order by patients admitted descending.*/
/* Comprehensive service analysis for Week 20 */

SELECT 
    sw.service, sw.week,
    COUNT(p.patient_id) FILTER (WHERE sw.week = 20) AS total_admitted,
    COUNT(p.patient_id) FILTER (WHERE sw.week = 20 AND sw.patients_refused = 1) AS total_refused,
	COUNT(ss.present) FILTER (WHERE sw.week = 20 AND ss.present = 1) AS staff_present,
    AVG(sw.patient_satisfaction) AS avg_satisfaction,
    COUNT(DISTINCT st.staff_id) AS staff_assigned
FROM services_weekly sw
LEFT JOIN patients p 
    ON sw.service = p.service 
    AND sw.week = 20
LEFT JOIN staff st
    ON sw.service = st.service
LEFT JOIN staff_schedule ss
    ON st.staff_id = ss.staff_id 
    AND ss.week = 20
WHERE sw.week = 20
GROUP BY sw.service,sw.week
ORDER BY total_admitted DESC;
