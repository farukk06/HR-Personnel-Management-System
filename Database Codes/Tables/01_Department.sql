CREATE SEQUENCE DepartmentIDseq;
CREATE TABLE "public"."Department" ( 
	"DepartmentID" INTEGER DEFAULT NEXTVAL('DepartmentIDseq') NOT NULL,
	"DepartmentName" VARCHAR( 100 ) NOT NULL,
	"Location" VARCHAR( 100 ),
	CONSTRAINT "DepartmentPK" PRIMARY KEY ( "DepartmentID" ),
	CONSTRAINT "DepartmentNameUnique" UNIQUE( "DepartmentName" ) );
