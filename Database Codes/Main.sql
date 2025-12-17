CREATE SEQUENCE DepartmentIDseq;  --Instead of manually assigning an ID each time a new record is added, we automate this process with Sequence.

-- Each department has an auto-generated DepartmentID. DepartmentName is unique to avoid duplicates.

CREATE TABLE "public"."Department" ( 
	"DepartmentID" INTEGER DEFAULT NEXTVAL('DepartmentIDseq') NOT NULL,
	"DepartmentName" VARCHAR( 100 ) NOT NULL,
	"Location" VARCHAR( 100 ),
	CONSTRAINT "DepartmentPK" PRIMARY KEY ( "DepartmentID" ),
	CONSTRAINT "DepartmentNameUnique" UNIQUE( "DepartmentName" ) );
	
-- Stores all employees with type distinction (FULL_TIME / INTERN). DepartmentID is a foreign key referencing Department.

CREATE SEQUENCE EmployeeIDseq;
CREATE TABLE "public"."Employee" ( 
	"EmployeeID" INTEGER DEFAULT NEXTVAL('EmployeeIDseq') NOT NULL,
	"FirstName" VARCHAR( 50 ) NOT NULL,
	"LastName" VARCHAR( 50 ) NOT NULL,
	"Email" VARCHAR( 100 ) NOT NULL,
	"Phone" VARCHAR( 20 ),
	"HireDate" DATE DEFAULT CURRENT_DATE NOT NULL,
	"Status" BOOLEAN DEFAULT TRUE,
	"DepartmentID" INTEGER,
	"EmployeeType" VARCHAR(20) NOT NULL,
	CONSTRAINT "EmployeePK" PRIMARY KEY ( "EmployeeID" ),
	CONSTRAINT "EmployeeEmailUnique" UNIQUE( "Email" ),
	CONSTRAINT "EmployeeTypeCheck" CHECK ("EmployeeType" IN ('FULL_TIME','INTERN')),
	CONSTRAINT "EmployeeDepartmentFK" FOREIGN KEY ("DepartmentID") REFERENCES "Department"("DepartmentID") ON DELETE NO ACTION ON UPDATE NO ACTION );

-- Each review belongs to exactly one employee. Score is restricted between 1 and 5.

CREATE SEQUENCE PerformanceReviewIDseq;	
CREATE TABLE "public"."PerformanceReview" ( 
	"PerformanceReviewID" INTEGER DEFAULT NEXTVAL('PerformanceReviewIDseq') NOT NULL,
	"EmployeeID" INTEGER NOT NULL,
	"ReviewDate" DATE DEFAULT CURRENT_DATE NOT NULL,
	"Score" INTEGER,
	"Comments" TEXT,
	CONSTRAINT "PerformanceReviewPK" PRIMARY KEY ( "PerformanceReviewID" ),
	CONSTRAINT "PerformanceReview_Score_check" CHECK("Score" >= 1 AND "Score" <= 5),
	CONSTRAINT "EmployeePerformanceReviewFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE ON UPDATE NO ACTION );

-- Stores monthly salary records for employees. Bonus and NetSalary are automatically calculated by triggers.

CREATE SEQUENCE SalaryIDseq;	
CREATE TABLE "public"."Salary" ( 
	"SalaryID" INTEGER DEFAULT NEXTVAL('SalaryIDseq') NOT NULL,
	"EmployeeID" INTEGER NOT NULL,
	"Month" INTEGER NOT NULL,
	"Year" INTEGER NOT NULL,
	"BaseSalary" NUMERIC( 10, 2 ) NOT NULL,
	"BonusAmount" NUMERIC( 10, 2 ) DEFAULT 0,
	"NetSalary" NUMERIC( 10, 2 ) DEFAULT 0,
	CONSTRAINT "SalaryPK" PRIMARY KEY ( "SalaryID" ),
	CONSTRAINT "Salary_Month_check" CHECK("Month" >= 1 AND "Month" <= 12),
	CONSTRAINT "EmployeeSalaryFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE ON UPDATE NO ACTION );

CREATE SEQUENCE ProjectIDseq;	
CREATE TABLE "public"."Project" ( 
	"ProjectID" INTEGER DEFAULT NEXTVAL('ProjectIDseq') NOT NULL,
	"ProjectName" VARCHAR( 100 ) NOT NULL,
	CONSTRAINT "ProjectPK" PRIMARY KEY ( "ProjectID" ) );

-- EmployeeProject acts as a junction table(bridge table).
	
CREATE TABLE "public"."EmployeeProject" ( 
	"EmployeeID" INTEGER NOT NULL,
	"ProjectID" INTEGER NOT NULL,
	"AssignedDate" DATE DEFAULT CURRENT_DATE,
	"RoleInProject" VARCHAR( 100 ),
	CONSTRAINT "EmployeeProjectPK" PRIMARY KEY ( "EmployeeID", "ProjectID" ),
	CONSTRAINT "EmployeeProject_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "EmployeeProject_ProjectFK" FOREIGN KEY ("ProjectID") REFERENCES "Project" ("ProjectID") ON DELETE CASCADE ON UPDATE NO ACTION );

-- LeaveType defines leave categories.

CREATE SEQUENCE LeaveTypeIDseq;	
CREATE TABLE "public"."LeaveType" ( 
	"LeaveTypeID" INTEGER DEFAULT nextval('LeaveTypeIDseq') NOT NULL,
	"LeaveTypeName" VARCHAR( 100 ) NOT NULL,
	"DefaultAnnualDays" INTEGER DEFAULT 10,
	CONSTRAINT "LeaveTypePK" PRIMARY KEY ( "LeaveTypeID" ) );

-- LeaveRequest stores employee leave requests.

CREATE SEQUENCE LeaveRequestIDseq;	
CREATE TABLE "public"."LeaveRequest" ( 
	"LeaveRequestID" INTEGER DEFAULT NEXTVAL('LeaveRequestIDseq') NOT NULL,
	"EmployeeID" INTEGER NOT NULL,
	"LeaveTypeID" INTEGER NOT NULL,
	"StartDate" DATE NOT NULL,
	"EndDate" DATE NOT NULL,
	"RequestedDays" INTEGER NOT NULL,
	"Status" VARCHAR( 20 ) DEFAULT 'Pending',
	"Reason" TEXT,
	CONSTRAINT "LeaveRequestPK" PRIMARY KEY ( "LeaveRequestID" ),
	CONSTRAINT "LeaveRequest_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE,
	CONSTRAINT "LeaveRequest_LeaveTypeFK" FOREIGN KEY ("LeaveTypeID") REFERENCES "LeaveType"("LeaveTypeID") ON DELETE RESTRICT );
	
-- INHERITANCE STRUCTURE (Employee specialization)
-- FullTimeEmployee and Intern depend on Employee.

CREATE TABLE "public"."FullTimeEmployee" ( 
	"EmployeeID" INTEGER NOT NULL,
	"BaseSalary" NUMERIC( 10, 2 ) NOT NULL,
	"AnnualLeaveQuota" INTEGER NOT NULL,
	CONSTRAINT "FullTimeEmployeePK" PRIMARY KEY ( "EmployeeID" ),
	CONSTRAINT "FullTimeEmployee_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE );
	
CREATE TABLE "public"."Intern" ( 
	"EmployeeID" INTEGER NOT NULL,
	"UniversityName" VARCHAR( 100 ) NOT NULL,
	"InternshipEndDate" DATE,
	CONSTRAINT "InternPK" PRIMARY KEY ( "EmployeeID" ),
	CONSTRAINT "Intern_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE );

-- Each table has been filled with 5 data entries so that they can be used on the application screen.

INSERT INTO "Department" ("DepartmentName", "Location") VALUES
('Human Resources', 'Istanbul'),
('Software', 'Ankara'),
('Finance', 'Izmir'),
('Marketing', 'Bursa'),
('Operations', 'Antalya');

INSERT INTO "Employee"
("FirstName","LastName","Email","Phone","DepartmentID","EmployeeType")
VALUES
('Ali','Yilmaz','ali.yilmaz@mail.com','0555000001',1,'FULL_TIME'),
('Ayse','Demir','ayse.demir@mail.com','0555000002',2,'FULL_TIME'),
('Mehmet','Kaya','mehmet.kaya@mail.com','0555000003',3,'INTERN'),
('Zeynep','Acar','zeynep.acar@mail.com','0555000004',2,'FULL_TIME'),
('Can','Arslan','can.arslan@mail.com','0555000005',4,'INTERN');

INSERT INTO "PerformanceReview"
("EmployeeID","ReviewDate","Score","Comments")
VALUES
(1, CURRENT_DATE, 5, 'Excellent performance'),
(2, CURRENT_DATE, 4, 'Very good'),
(3, CURRENT_DATE, 3, 'Satisfactory'),
(4, CURRENT_DATE, 5, 'Outstanding'),
(5, CURRENT_DATE, 2, 'Needs improvement');

INSERT INTO "Salary"
("EmployeeID","Month","Year","BaseSalary","BonusAmount","NetSalary")
VALUES
(1, 1, 2025, 30000, 3000, 33000),
(2, 1, 2025, 28000, 2500, 30500),
(4, 1, 2025, 32000, 4000, 36000),
(1, 2, 2025, 30000, 2000, 32000),
(2, 2, 2025, 28000, 1500, 29500);

INSERT INTO "Project" ("ProjectName") VALUES
('HR Automation'),
('ERP System'),
('Mobile App'),
('Website Redesign'),
('Data Analytics');

INSERT INTO "EmployeeProject"
("EmployeeID","ProjectID","AssignedDate","RoleInProject")
VALUES
(1,1,CURRENT_DATE,'Manager'),
(2,2,CURRENT_DATE,'Backend Developer'),
(3,3,CURRENT_DATE,'Intern Developer'),
(4,4,CURRENT_DATE,'Frontend Developer'),
(5,5,CURRENT_DATE,'Marketing Intern');

INSERT INTO "LeaveType"
("LeaveTypeName","DefaultAnnualDays")
VALUES
('Annual Leave', 14),
('Sick Leave', 10),
('Maternity Leave', 90),
('Paternity Leave', 10),
('Unpaid Leave', 30);

INSERT INTO "LeaveRequest"
("EmployeeID","LeaveTypeID","StartDate","EndDate","RequestedDays","Status","Reason")
VALUES
(1,1,'2025-02-01','2025-02-05',5,'Approved','Vacation'),
(2,2,'2025-03-10','2025-03-12',3,'Pending','Flu'),
(3,1,'2025-04-01','2025-04-03',3,'Approved','Personal'),
(4,4,'2025-05-01','2025-05-05',5,'Pending','Family'),
(5,5,'2025-06-01','2025-06-10',10,'Rejected','Unpaid request');

INSERT INTO "FullTimeEmployee"
("EmployeeID","BaseSalary","AnnualLeaveQuota")
VALUES
(1,30000,14),
(2,28000,14),
(4,32000,14);

INSERT INTO "Intern"
("EmployeeID","UniversityName","InternshipEndDate")
VALUES
(3,'SAU','2025-08-01'),
(5,'ITU','2025-07-15');

-- Calculates the bonus based on the entered salary value.

CREATE OR REPLACE FUNCTION public.fn_calculate_bonus(base_salary REAL)
 RETURNS REAL
 LANGUAGE plpgsql
AS $$
BEGIN
    RETURN base_salary * 0.10;
END;
$$;

SELECT fn_calculate_bonus( 30000 );

-- It calculates the base salary entered and the calculated bonus salary and automatically adds these two pieces of information together.

CREATE OR REPLACE FUNCTION public.fn_calculate_net_salary(base_salary REAL, bonus REAL)
 RETURNS REAL
 LANGUAGE plpgsql
AS $$
BEGIN
    RETURN base_salary + bonus;
END;
$$;

SELECT fn_calculate_net_salary( 30000, 3000 );

-- It calculates how many employees each department has based on the data.

CREATE OR REPLACE FUNCTION public.fn_get_department_employee_count(dept_id INTEGER)
 RETURNS INTEGER
 LANGUAGE plpgsql
AS $$
DECLARE 
    dept_exists INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO dept_exists
    FROM "Department"
    WHERE "DepartmentID" = dept_id;
    
    IF dept_exists = 0 THEN
        RAISE EXCEPTION 'Invalid Department ID: %',dept_id;
    END IF;
    
    RETURN (
        SELECT COUNT(*)
        FROM "Employee"
        WHERE "DepartmentID" = dept_id
    );
END;
$$;

SELECT fn_get_department_employee_count( 2 );

-- Using the entered employee ID, it calculates how many days of leave have been used from that employee's quota and gives the remaining number of days.

CREATE OR REPLACE FUNCTION public.fn_get_remaining_leave(emp_id INTEGER)
 RETURNS INTEGER
 LANGUAGE plpgsql
AS $$
DECLARE
    quota INT;
    used_days INT;
BEGIN
    SELECT "AnnualLeaveQuota"
    INTO quota
    FROM "FullTimeEmployee"
    WHERE "EmployeeID" = emp_id;

    SELECT COALESCE(SUM("RequestedDays"), 0)
    INTO used_days
    FROM "LeaveRequest"
    WHERE "EmployeeID" = emp_id
      AND "Status" = 'APPROVED';

    RETURN quota - used_days;
END;
$$;

SELECT fn_get_remaining_leave( 4 );

-- This is a trigger function that calculates the bonus amount of the salary entered when creating a new employee, adds it to the base salary
-- and converts it to net salary.

CREATE OR REPLACE FUNCTION public.trg_salary_before_insert()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    NEW."BonusAmount" :=
        fn_calculate_bonus(NEW."BaseSalary");

    NEW."NetSalary" :=
        fn_calculate_net_salary(
            NEW."BaseSalary",
            NEW."BonusAmount"
        );

    RETURN NEW;
END;
$$;

-- It works BEFORE INSERT on Salary table.

-- Ensures bonus and net salary are always calculated automatically when a new salary record is added.

CREATE TRIGGER trg_salary_calc BEFORE INSERT ON "public"."Salary" FOR EACH ROW EXECUTE FUNCTION trg_salary_before_insert();

SELECT * FROM "Employee";

INSERT INTO "Salary"("EmployeeID", "Month", "Year", "BaseSalary") VALUES (1, 5, 2025, 10000);

SELECT "BaseSalary","BonusAmount","NetSalary" FROM "Salary" WHERE "EmployeeID" = 1 ORDER BY "SalaryID" DESC LIMIT 1;

-- It works BEFORE UPDATE on Salary table.

-- Recalculates bonus and net salary if base salary changes.

CREATE TRIGGER trg_salary_before_update BEFORE UPDATE ON "public"."Salary" FOR EACH ROW EXECUTE FUNCTION trg_salary_before_insert();

SELECT "SalaryID", "BaseSalary", "BonusAmount", "NetSalary" FROM "Salary" WHERE "EmployeeID" = 1 ORDER BY "SalaryID" LIMIT 1;

UPDATE "Salary" SET "BaseSalary" = 40000 WHERE "SalaryID" = 1;

SELECT "SalaryID", "BaseSalary", "BonusAmount", "NetSalary" FROM "Salary" WHERE "EmployeeID" = 1 ORDER BY "SalaryID" LIMIT 1;

-- This prevents the salary information entered when creating a new employee from being negative.

CREATE OR REPLACE FUNCTION public.trg_salary_validation()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."BaseSalary" < 0 THEN
        RAISE EXCEPTION 'Base salary cannot be negative';
    END IF;

    RETURN NEW;
END;
$$;

-- It works BEFORE INSERT on Salary table.

-- Enforces business rule: salary must be non-negative.

CREATE TRIGGER trg_salary_validation BEFORE INSERT ON "public"."Salary" FOR EACH ROW EXECUTE FUNCTION trg_salary_validation();

INSERT INTO "Salary"("EmployeeID","Month","Year","BaseSalary") VALUES (1, 3, 2025, 25000);

SELECT "BaseSalary" FROM "Salary" WHERE "EmployeeID" = 1 ORDER BY "SalaryID" DESC LIMIT 1;

INSERT INTO "Salary"("EmployeeID","Month","Year","BaseSalary") VALUES (1, 4, 2025, -5000);

-- Ensures employees cannot request leave days exceeding their remaining annual leave quota.

-- Business logic is enforced at database level.

CREATE OR REPLACE FUNCTION public.trg_leave_quota_check()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."RequestedDays" >
       fn_get_remaining_leave(NEW."EmployeeID") THEN
        RAISE EXCEPTION 'Leave quota exceeded';
    END IF;

    RETURN NEW;
END;
$$;

-- It works BEFORE INSERT on LeaveRequest table.

-- Prevents inserting leave requests that exceed quota.

CREATE TRIGGER trg_leave_before_insert BEFORE INSERT ON "public"."LeaveRequest" FOR EACH ROW EXECUTE FUNCTION trg_leave_quota_check();

SELECT fn_get_remaining_leave(1);

INSERT INTO "LeaveRequest"("EmployeeID","LeaveTypeID","StartDate","EndDate","RequestedDays","Status","Reason") VALUES (1, 1, '2025-07-01', '2025-07-05', 5, 'Pending', 'Summer vacation');

INSERT INTO "LeaveRequest"("EmployeeID","LeaveTypeID","StartDate","EndDate","RequestedDays","Status","Reason") VALUES (1, 1, '2025-08-01', '2025-08-20', 15, 'Pending', 'Long vacation');

-- Detects when a leave request status changes to APPROVED.

-- Can be extended later for logging or notifications.

CREATE OR REPLACE FUNCTION public.trg_leave_after_approve()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."Status" = 'APPROVED'
       AND OLD."Status" <> 'APPROVED' THEN NULL;
    END IF;

    RETURN NEW;
END;
$$;

-- It works AFTER UPDATE on LeaveRequest table.

-- Monitors approval status changes.

CREATE TRIGGER trg_leave_after_update AFTER UPDATE ON "public"."LeaveRequest" FOR EACH ROW EXECUTE FUNCTION trg_leave_after_approve();

SELECT "LeaveRequestID", "Status" FROM "LeaveRequest" WHERE "LeaveRequestID" = 2;

UPDATE "LeaveRequest" SET "Status" = 'APPROVED' WHERE "LeaveRequestID" = 2;

SELECT "LeaveRequestID", "Status" FROM "LeaveRequest" WHERE "LeaveRequestID" = 2;
