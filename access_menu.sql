create or replace PROCEDURE ACCESS_MENU(P_NODES IN VARCHAR2,P_ROLE_ID IN NUMBER,P_PAGE_ACTION IN VARCHAR2) IS 
cursor c1 is
SELECT COLUMN_VALUE AS item
FROM TABLE(apex_string.split(P_NODES,':'));
begin
for rec_c1 in c1 loop

    DECLARE
    CURSOR C2 IS
    select * from(
    select case when connect_by_isleaf = 1 then 0 when level = 1 then 1 else -1 end as status,
        level,
        MENU_NAME as title,
        icon as icon,
        MENU_ID as value,
        MENU_NAME as tooltip
        , substr(SYS_CONNECT_BY_PATH(menu_id, ':'),2) AS FULL_PATH
        ,PARENT_MENU_ID
   from APP_MENUS
  start with PARENT_MENU_ID is null
connect by prior MENU_ID = PARENT_MENU_ID
  order siblings by MENU_ID
)
where 1=1
and (InStr( ':' || FULL_PATH || ':', ':' || REC_C1.item || ':' ) > 0);
BEGIN
FOR REC_C2 IN C2 LOOP
--DBMS_OUTPUT.PUT_LINE(REC_C2.VALUE||'>>'||REC_C2.TITLE);

    DECLARE
    CURSOR C3 IS
    SELECT * FROM(
    SELECT COLUMN_VALUE AS MENU_ID
    FROM TABLE(apex_string.split(REC_C2.FULL_PATH,':')) 
    ORDER BY TO_NUMBER(COLUMN_VALUE))X
    WHERE NOT EXISTS(SELECT 1 FROM ROLE_MENUS R WHERE R.ROLE_ID=P_ROLE_ID AND R.MENU_ID=X.MENU_ID);
    BEGIN
        FOR REC_C3 IN C3 LOOP
        --DBMS_OUTPUT.PUT_LINE(REC_C3.item);
        INSERT INTO ROLE_MENUS(ROLE_ID,MENU_ID,PAGE_ACTION,PARENT_MENU_ID)
        VALUES(P_ROLE_ID,REC_C3.MENU_ID,P_PAGE_ACTION,rec_c2.PARENT_MENU_ID);
        END LOOP;

    END;


END LOOP;
END;


end loop;
end;
/