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
