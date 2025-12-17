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
