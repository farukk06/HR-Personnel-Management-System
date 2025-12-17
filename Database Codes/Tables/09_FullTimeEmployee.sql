CREATE TABLE "public"."FullTimeEmployee" ( 
	"EmployeeID" INTEGER NOT NULL,
	"BaseSalary" NUMERIC( 10, 2 ) NOT NULL,
	"AnnualLeaveQuota" INTEGER NOT NULL,
	CONSTRAINT "FullTimeEmployeePK" PRIMARY KEY ( "EmployeeID" ),
	CONSTRAINT "FullTimeEmployee_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE );
