-- Table: public.FullTimeEmployee

-- DROP TABLE IF EXISTS public."FullTimeEmployee";

CREATE TABLE IF NOT EXISTS public."FullTimeEmployee"
(
    "EmployeeID" integer NOT NULL,
    "Salary" numeric(10,2) NOT NULL,
    "AnnualLeaveQuota" integer DEFAULT 14,
    CONSTRAINT "FullTimePK" PRIMARY KEY ("EmployeeID"),
    CONSTRAINT "FullTimeEmployeeFK" FOREIGN KEY ("EmployeeID")
        REFERENCES public."Employee" ("EmployeeID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT "SalaryPositiveCheck" CHECK ("Salary" > 0::numeric)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."FullTimeEmployee"
    OWNER to postgres;