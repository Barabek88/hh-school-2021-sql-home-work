DO
$$
    DECLARE
        iterator                           INT;
        INTERVAL_FROM             CONSTANT INT       = 1;
        INTERVAL_TO               CONSTANT INT       = 20;
        ADDITIONAL_NUMBER_FOR_AGE CONSTANT INT       = 20;
        COMPENSATION_MIN          CONSTANT INT       = 10000;
        COMPENSATION_MAX          CONSTANT INT       = 100000;
        COMPENSATION_DELTA        CONSTANT INT       = 50000;
        VACANCIES_COUNT           CONSTANT INT       = 1000000;
        RESUMES_COUNT             CONSTANT INT       = 2000000;
        DATE_FROM                 CONSTANT TIMESTAMP = '2021-01-01 00:00:00';
        DATE_TO                   CONSTANT TIMESTAMP = '2022-01-01 00:00:00';
    BEGIN

        -- Заполнение справочников
        FOR iterator IN SELECT * FROM generate_series(INTERVAL_FROM, INTERVAL_TO)
            LOOP
                INSERT INTO AREA(name)
                SELECT 'Area' || iterator;

                INSERT INTO Specialization(name)
                SELECT 'Specialization' || iterator;

                INSERT INTO Currency(name)
                SELECT 'Currency' || iterator;

                INSERT INTO Employer(name, area_id)
                SELECT 'Employer' || iterator, iterator;

                INSERT INTO Employee(first_name, second_name, last_name, age, area_id)
                SELECT 'First_name' || iterator             AS first_name,
                       'Second_name' || iterator            AS second_name,
                       'Last_name' || iterator              AS last_name,
                       iterator + ADDITIONAL_NUMBER_FOR_AGE AS age,
                       iterator                             AS area_id;
            END LOOP;

        -- Заполнние базовых таблиц
        WITH test_data(id, title, employer_id, area_id, compensation_from, currency_id) AS (
            SELECT generate_series(1, VACANCIES_COUNT)                                            AS id,
                   md5(random() :: TEXT)                                                          AS title,
                   floor(random() * (INTERVAL_TO - INTERVAL_FROM + 1) + INTERVAL_FROM)::INT       AS employer_id,
                   floor(random() * (INTERVAL_TO - INTERVAL_FROM + 1) + INTERVAL_FROM)::INT       AS area_id,
                   (random() * (COMPENSATION_MAX - COMPENSATION_MIN + 1) + COMPENSATION_MIN)::INT AS compensation_from,
                   floor(random() * (INTERVAL_TO - INTERVAL_FROM + 1) + INTERVAL_FROM)::INT       AS currency_id,
                   DATE_FROM + random() * (DATE_TO - DATE_FROM)                                   AS date
        )
        INSERT
        INTO Vacancy (employer_id, title, area_id, compensation_from, compensation_to, currency_id, description,
                      publication_date)
        SELECT employer_id,
               title,
               area_id,
               compensation_from,
               compensation_from + COMPENSATION_DELTA,
               currency_id,
               title,
               date
        FROM test_data;

        WITH test_data(id, title, employer_id, area_id, compensation, currency_id, date) AS (
            SELECT generate_series(1, RESUMES_COUNT)                                              AS id,
                   md5(random() :: TEXT)                                                          AS title,
                   floor(random() * (INTERVAL_TO - INTERVAL_FROM + 1) + INTERVAL_FROM)::INT       AS employer_id,
                   floor(random() * (INTERVAL_TO - INTERVAL_FROM + 1) + INTERVAL_FROM)::INT       AS area_id,
                   (random() * (COMPENSATION_MAX - COMPENSATION_MIN + 1) + COMPENSATION_MIN)::INT AS compensation,
                   floor(random() * (INTERVAL_TO - INTERVAL_FROM + 1) + INTERVAL_FROM)::INT       AS currency_id,
                   DATE_FROM + random() * (DATE_TO - DATE_FROM)                                   AS date
        )
        INSERT
        INTO Resume (employee_id, title, compensation, currency_id, description,
                     publication_date)
        SELECT employer_id, title, compensation, currency_id, title, date
        FROM test_data;

        WITH test_data(id, description, resume_id, vacancy_id, date) AS (
            SELECT generate_series(1, 1000000)                   AS id,
                   md5(random() :: TEXT)                        AS description,
                   floor(random() * (RESUMES_COUNT) + 1)::INT   AS resume_id,
                   floor(random() * (VACANCIES_COUNT) + 1)::INT AS vacancy_id,
                   DATE_FROM + random() * (DATE_TO - DATE_FROM) AS date
        )
        INSERT
        INTO Vacancies_Response (vacancy_id, resume_id, description, status, response_date)
        SELECT t.vacancy_id, t.resume_id, t.description, 0, t.date
        FROM test_data t
        ON CONFLICT (vacancy_id, resume_id) DO NOTHING;
    END
$$;
