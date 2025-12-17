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
