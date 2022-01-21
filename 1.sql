DROP TABLE IF EXISTS Vacancies_Response;
DROP TABLE IF EXISTS Resume_Specialization;
DROP TABLE IF EXISTS Vacancy_Specialization;
DROP TABLE IF EXISTS Resume;
DROP TABLE IF EXISTS Vacancy;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Employer;
DROP TABLE IF EXISTS Currency;
DROP TABLE IF EXISTS Specialization;
DROP TABLE IF EXISTS Area;

CREATE TABLE Area
(
    area_id SERIAL PRIMARY KEY,
    name    VARCHAR NOT NULL
);

CREATE TABLE Specialization
(
    specialization_id SERIAL PRIMARY KEY,
    name              VARCHAR NOT NULL
);

CREATE TABLE Currency
(
    currency_id SERIAL PRIMARY KEY,
    name        VARCHAR NOT NULL
);

CREATE TABLE Employer
(
    employer_id SERIAL PRIMARY KEY,
    name        VARCHAR NOT NULL,
    area_id     INT REFERENCES Area (area_id)
);

CREATE TABLE Employee
(
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR NOT NULL,
    second_name VARCHAR NULL,
    last_name   VARCHAR NOT NULL,
    age         INT,
    area_id     INT REFERENCES Area (area_id)
);

CREATE TABLE Vacancy
(
    vacancy_id        SERIAL PRIMARY KEY,
    employer_id       INT NOT NULL REFERENCES Employer (employer_id),
    title             VARCHAR NOT NULL,
    publication_date  TIMESTAMPTZ NOT NULL DEFAULT now(),
    area_id           INT REFERENCES Area (area_id),
    compensation_from INT,
    compensation_to   INT,
    currency_id       INT REFERENCES Currency (currency_id),
    before_tax        BOOLEAN DEFAULT TRUE,
    description       VARCHAR,
    is_active         BOOLEAN DEFAULT TRUE
);

CREATE TABLE Resume
(
    resume_id        SERIAL PRIMARY KEY,
    employee_id      INT NOT NULL REFERENCES Employee (employee_id),
    title            VARCHAR NOT NULL,
    publication_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    compensation     INT,
    currency_id      INT REFERENCES Currency (currency_id),
    before_tax       BOOLEAN DEFAULT TRUE,
    description      VARCHAR,
    is_active        BOOLEAN DEFAULT TRUE
);

CREATE TABLE Vacancy_Specialization
(
    vacancy_id        INT REFERENCES Vacancy (vacancy_id),
    specialization_id INT REFERENCES Specialization (specialization_id),
    PRIMARY KEY (vacancy_id, specialization_id)
);

CREATE TABLE Resume_Specialization
(
    resume_id         INT REFERENCES Resume (resume_id),
    specialization_id INT REFERENCES Specialization (specialization_id),
    PRIMARY KEY (resume_id, specialization_id)
);

CREATE TABLE Vacancies_Response
(
    vacancy_id    INT REFERENCES Vacancy (vacancy_id),
    resume_id     INT REFERENCES Resume (resume_id),
    response_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    description   VARCHAR,
    status        INT,
    PRIMARY KEY (vacancy_id, resume_id)
);


