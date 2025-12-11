-- Table: public.Employee

-- DROP TABLE IF EXISTS public."Employee";

CREATE TABLE IF NOT EXISTS public."Employee"
(
    "EmployeeID" integer NOT NULL DEFAULT nextval('"Employee_EmployeeID_seq"'::regclass),
    "FirstName" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "LastName" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Email" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "Phone" character varying(20) COLLATE pg_catalog."default",
    "HireDate" date NOT NULL DEFAULT CURRENT_DATE,
    "Status" boolean DEFAULT true,
    "DepartmentID" integer NOT NULL,
    CONSTRAINT "EmployeePK" PRIMARY KEY ("EmployeeID"),
    CONSTRAINT "EmployeeEmailUnique" UNIQUE ("Email"),
    CONSTRAINT "EmployeeDepartmentFK" FOREIGN KEY ("DepartmentID")
        REFERENCES public."Department" ("DepartmentID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Employee"
    OWNER to postgres;