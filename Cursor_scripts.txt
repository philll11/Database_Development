--####### This Cursor gets columns from the customer table that have a balance equal to 0.
SET SERVEROUTPUT ON;
DECLARE CURSOR MY_CURSOR IS
SELECT CUST_NUM, CUST_LNAME, CUST_FNAME, CUST_BALANCE
FROM CUSTOMER
WHERE CUST_BALANCE = 0;
VR_CUST MY_CURSOR%ROWTYPE;
    
BEGIN
    OPEN MY_CURSOR;
    LOOP
        FETCH MY_CURSOR INTO VR_CUST;
        EXIT WHEN MY_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VR_CUST.CUST_NUM || '  ' 
        || VR_CUST.CUST_FNAME || ' ' || VR_CUST.CUST_LNAME || ' '
        || VR_CUST.CUST_BALANCE);
    END LOOP;
    IF MY_CURSOR%ISOPEN THEN 
        CLOSE MY_CURSOR;
    END IF;
END;
/


--######## This Cursor looks into two tables and finds what customers are in each. Uses exceptions
set serveroutput on;
declare cursor my_cursor is
    select distinct c.cust_fname || ' ' || c.cust_lname as name
    from customer c, invoice i
    where c.cust_num = i.cust_num;
    
    vr_cust my_cursor%rowtype;
    
begin
    open my_cursor;
    loop
        fetch my_cursor into vr_cust;
        if my_cursor%found then
            dbms_output.put_line(to_char(my_cursor%rowcount) || '  ' || vr_cust.name);
        else 
            exit;
        end if;
    end loop;
exception
    when others
    then
        if my_cursor%isopen then
            close my_cursor;
        end if;
end;
/


--####### Updates Customer table when Invoice is updated
Create or replace TRIGGER TRG_UPDATE_CUST_BAL_INS
BEFORE INSERT OR UPDATE ON INVOICE
FOR EACH ROW
BEGIN
    UPDATE CUSTOMER
    SET CUST_BALANCE = CUST_BALANCE + :NEW.INV_AMOUNT
    WHERE CUSTOMER.CUST_NUM = :NEW.CUST_NUM;
END;

--Test Code
INSERT INTO INVOICE VALUES(8008, 1001, TO_DATE('17-4-18','DD-MM-YY'), 225.40); 

--####### Updated Customer table when an invocie is deleted
create or replace TRIGGER TRG_UPDATE_CUST_BAL_DEL
BEFORE DELETE ON INVOICE
FOR EACH ROW
BEGIN
    UPDATE CUSTOMER
    SET CUST_BALANCE = CUST_BALANCE - :OLD.INV_AMOUNT
    WHERE CUSTOMER.CUST_NUM = :OLD.CUST_NUM;
END;



--######### Creates a new record in the CUST_AUDIT when customer is changed
--CREATE TABLE
CREATE TABLE CUST_AUDIT(
    AUDIT_USER VARCHAR2(60 BYTE) NOT NULL,
    AUDIT_DATE DATE
);
create or replace TRIGGER RECORD_USER
BEFORE INSERT OR UPDATE OR DELETE ON CUSTOMER
FOR EACH ROW
BEGIN
    INSERT INTO CUST_AUDIT VALUES(USER, SYSDATE);
END;




