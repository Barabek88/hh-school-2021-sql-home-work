SELECT v.vacancy_id,
       v.title
FROM vacancy v
  INNER JOIN Vacancies_Response vr ON v.vacancy_id = vr.vacancy_id
WHERE vr.response_date <= (v.publication_date + interval '7' day)
GROUP BY v.vacancy_id, v.title
HAVING COUNT(*) > 5
;
