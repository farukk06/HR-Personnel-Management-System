CREATE TABLE "public"."Intern" ( 
	"EmployeeID" INTEGER NOT NULL,
	"UniversityName" VARCHAR( 100 ) NOT NULL,
	"InternshipEndDate" DATE,
	CONSTRAINT "InternPK" PRIMARY KEY ( "EmployeeID" ),
	CONSTRAINT "Intern_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE );
