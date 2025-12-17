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
