
  CREATE TABLE "IMAGE_GALLERIES" 
   (	"ID" NUMBER, 
	"BLOB_CONTENT" BLOB, 
	"FILE_NAME" VARCHAR2(250), 
	"MIME_TYPE" VARCHAR2(250), 
	"GALLERY_TYPE" VARCHAR2(25), 
	"ACTIVE_STATUS" VARCHAR2(1) DEFAULT 'Y', 
	"TITLE" VARCHAR2(150), 
	"DESCRIPTION" VARCHAR2(150)
   ) ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "IMAGE_GALLERIES_TRG" 
   before insert or update ON IMAGE_GALLERIES
   for each row
begin
      if inserting then
         if :NEW.ID is null then
           select NVL(MAX(ID),0)+1  into :new.ID
           from IMAGE_GALLERIES;
         end if;
        
      end if;
      
END;
/
ALTER TRIGGER "IMAGE_GALLERIES_TRG" ENABLE;