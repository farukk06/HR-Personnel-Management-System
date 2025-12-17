CREATE SEQUENCE LeaveTypeIDseq;	
CREATE TABLE "public"."LeaveType" ( 
	"LeaveTypeID" INTEGER DEFAULT nextval('LeaveTypeIDseq') NOT NULL,
	"LeaveTypeName" VARCHAR( 100 ) NOT NULL,
	"DefaultAnnualDays" INTEGER DEFAULT 10,
	CONSTRAINT "LeaveTypePK" PRIMARY KEY ( "LeaveTypeID" ) );