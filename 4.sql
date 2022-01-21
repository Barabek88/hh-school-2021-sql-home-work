SELECT (
           SELECT extract(MONTH FROM v.publication_date)
           FROM vacancy v
           GROUP BY extract(MONTH FROM v.publication_date)
           ORDER BY count(*) DESC
           LIMIT 1
       ) AS month_with_the_most_vacancies,
       (
           SELECT extract(MONTH FROM r.publication_date) AS month
           FROM resume r
           GROUP BY extract(MONTH FROM r.publication_date)
           ORDER BY count(*) DESC
           LIMIT 1
       ) AS month_with_the_most_resumes;

