/*
Так как текущие запросы используют дату при пересечении и фильтрации отбора, то добавил индексы на даты.
В 4 задание в итоге отбор только по индексу Index Only

также добавил индекс для внешних ключей area_id и vacancy_id таблиц vacancy и vacancies_response соответвенно,
так как по ним идет тоже пересечение в наших запросах
 */


CREATE INDEX resume_publication_date_idx ON resume(publication_date);
CREATE INDEX vacancy_publication_date_idx ON vacancy(publication_date);
CREATE INDEX vacancies_response_response_date_idx ON vacancies_response(response_date);
CREATE INDEX vacancy_area_id_idx ON vacancy(area_id);
CREATE INDEX vacancies_response_response_vacancy_id_idx ON vacancies_response(vacancy_id);
