
  CREATE TABLE "NOTICES" 
   (	"ID" NUMBER, 
	"NOTICE_TITLE" VARCHAR2(50), 
	"NOTICE" VARCHAR2(4000), 
	"ACTIVE_STATUS" VARCHAR2(1) DEFAULT 'Y'
   ) ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "NOTICES_TRG" 
   before insert or update ON NOTICES
   for each row
begin
      if inserting then
         if :NEW.ID is null then
           select NVL(MAX(ID),0)+1  into :new.ID
           from NOTICES;
         end if;
        
      end if;
      
END;
/
ALTER TRIGGER "NOTICES_TRG" ENABLE;