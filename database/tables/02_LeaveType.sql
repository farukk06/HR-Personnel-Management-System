-- Table: public.LeaveType

-- DROP TABLE IF EXISTS public."LeaveType";

CREATE TABLE IF NOT EXISTS public."LeaveType"
(
    "LeaveTypeID" integer NOT NULL DEFAULT nextval('"LeaveType_LeaveTypeID_seq"'::regclass),
    "LeaveTypeName" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "DefaultAnnualDays" integer DEFAULT 0,
    CONSTRAINT "LeaveTypePK" PRIMARY KEY ("LeaveTypeID"),
    CONSTRAINT "LeaveTypeUnique" UNIQUE ("LeaveTypeName")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."LeaveType"
    OWNER to postgres;