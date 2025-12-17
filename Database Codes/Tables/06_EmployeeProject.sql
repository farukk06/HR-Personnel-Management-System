CREATE TABLE "public"."EmployeeProject" ( 
	"EmployeeID" INTEGER NOT NULL,
	"ProjectID" INTEGER NOT NULL,
	"AssignedDate" DATE DEFAULT CURRENT_DATE,
	"RoleInProject" VARCHAR( 100 ),
	CONSTRAINT "EmployeeProjectPK" PRIMARY KEY ( "EmployeeID", "ProjectID" ),
	CONSTRAINT "EmployeeProject_EmployeeFK" FOREIGN KEY ("EmployeeID") REFERENCES "Employee"("EmployeeID") ON DELETE CASCADE ON UPDATE NO ACTION,
	CONSTRAINT "EmployeeProject_ProjectFK" FOREIGN KEY ("ProjectID") REFERENCES "Project" ("ProjectID") ON DELETE CASCADE ON UPDATE NO ACTION );
