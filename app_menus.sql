
  CREATE TABLE "APP_MENUS" 
   (	"MENU_ID" NUMBER, 
	"MENU_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"MENU_LABEL" VARCHAR2(100), 
	"PAGE_ID" NUMBER, 
	"ICON" VARCHAR2(50), 
	"PARENT_MENU_ID" NUMBER, 
	"IS_ACTIVE" VARCHAR2(1) DEFAULT 'Y', 
	"PAGE_LIST" VARCHAR2(100), 
	 CONSTRAINT "PK_APP_MENU_MENU_ID" PRIMARY KEY ("MENU_ID")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "APP_MENUS" ADD CONSTRAINT "FK_APP_MENU_PARENT_MENU_ID" FOREIGN KEY ("PARENT_MENU_ID")
	  REFERENCES "APP_MENUS" ("MENU_ID") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_APP_MENUS" 
   before insert or update on app_menus
   for each row
   begin
      if inserting then
         if :NEW.menu_id is null then
           select NVL(MAX(menu_id),0)+1  into :new.menu_id
           from app_menus;
         end if;
         --:NEW.CREATED_DATE := current_timestamp;
         --:NEW.CREATED_BY := nvl(v('APP_USER'),USER);
      end if;
      /*if updating then
         :NEW.MODIFIED_DATE := current_timestamp;
         :NEW.MODIFIED_BY := nvl(v('APP_USER'),USER);
      end if;*/
END;
/
ALTER TRIGGER "TRG_APP_MENUS" ENABLE;