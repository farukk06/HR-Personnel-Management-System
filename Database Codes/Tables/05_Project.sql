CREATE SEQUENCE ProjectIDseq;	
CREATE TABLE "public"."Project" ( 
	"ProjectID" INTEGER DEFAULT NEXTVAL('ProjectIDseq') NOT NULL,
	"ProjectName" VARCHAR( 100 ) NOT NULL,
	CONSTRAINT "ProjectPK" PRIMARY KEY ( "ProjectID" ) );