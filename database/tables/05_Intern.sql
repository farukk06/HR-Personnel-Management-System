-- Table: public.Intern

-- DROP TABLE IF EXISTS public."Intern";

CREATE TABLE IF NOT EXISTS public."Intern"
(
    "EmployeeID" integer NOT NULL,
    "UniversityName" character varying(100) COLLATE pg_catalog."default",
    "InternshipEndDate" date NOT NULL,
    CONSTRAINT "InternPK" PRIMARY KEY ("EmployeeID"),
    CONSTRAINT "InternEmployeeFK" FOREIGN KEY ("EmployeeID")
        REFERENCES public."Employee" ("EmployeeID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT "InternDateCheck" CHECK ("InternshipEndDate" > '2020-01-01'::date)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Intern"
    OWNER to postgres;