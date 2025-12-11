-- Table: public.Department

-- DROP TABLE IF EXISTS public."Department";

CREATE TABLE IF NOT EXISTS public."Department"
(
    "DepartmentID" integer NOT NULL DEFAULT nextval('"Department_DepartmentID_seq"'::regclass),
    "DepartmentName" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "Location" character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "DepartmentPK" PRIMARY KEY ("DepartmentID"),
    CONSTRAINT "DepartmentUnique" UNIQUE ("DepartmentName")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Department"
    OWNER to postgres;