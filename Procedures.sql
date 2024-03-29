########### Uses SYSDATE to calculate what day it is
########### Also includes IF statements
SET SERVEROUTPUT ON

DECLARE
    MY_DATE VARCHAR(10) := to_char(SYSDATE, 'Day');
    SUBDATE VARCHAR(3);
BEGIN
    SUBDATE := SUBSTR(MY_DATE, 0, 3);
    IF SUBDATE = 'Sat' OR SUBDATE = 'Sun' THEN
        DBMS_OUTPUT.PUT_LINE('Yay! It is weekend, being ' || MY_DATE || 'today.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Oh no! It is not the weekend yet, being ' || MY_DATE || 'today.');
    END IF;
END;
/


########### The above annonymus pl/sql block in a procedure
CREATE OR REPLACE PROCEDURE PROCEDURE1 AS
    MY_DATE VARCHAR(10) := (SYSDATE, 'Day');
    SUBDATE VARCHAR(3);
BEGIN
    SUBDATE := SUBSTR(MY_DATE, 0, 3);
    IF SUBDATE = 'Tue' OR SUBSTR = 'Sun' THEN
        DBMS_OUTPUT.PUT_LINE('Yay! It is weekend, being ' || MY_DATE || 'today.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Oh no! It is not the weekend yet, being ' || MY_DATE || 'today.');
    END IF;
END;


########### Function that takes two inputs and returns the sum
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION PRC_NUM_ADDITION_FUNC
    (X IN NUMBER, Y IN NUMBER)
    RETURN NUMBER
AS
    OUTPUT NUMBER;
BEGIN
    OUTPUT := X+Y;
    RETURN OUTPUT;
END ;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(PRC_NUM_ADDITION_FUNC(10,20));
END;
/


########### Passing variable by reference Procedure
VARIABLE G_RESULT NUMBER;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE PRC_NUM_ADDITION
    (X IN NUMBER, Y IN NUMBER, OUTPUT OUT NUMBER)
AS
BEGIN
    OUTPUT := X+Y;
END ;
/

EXECUTE PRC_NUM_ADDITION(10,20,:G_RESULT);
PRINT G_RESULT



########### Inserts data into table within a procedure
CREATE OR REPLACE PROCEDURE PRC_INVOICE_ADD
AS
BEGIN
    INSERT INTO INVOICE VALUES(8089,1000,'02-APR-2018',301.00);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data added');
END;
/
EXECUTE PRC_INVOICE_ADD()

SELECT * FROM INVOICE
WHERE INV_NUM = 8088;

########### Inserts data into table within a procedure using input variables
CREATE OR REPLACE PROCEDURE PRC_INVOICE_ADD
(INV_NUM IN NUMBER, CUST_NUM IN NUMBER, INV_DATE_CHAR IN DATE, INV_AMOUNT IN FLOAT)
AS
BEGIN
    INSERT INTO INVOICE VALUES(INV_NUM, CUST_NUM, INV_DATE_CHAR, INV_AMOUNT);
    COMMIT;
END;

EXECUTE PRC_INVOICE_ADD(8090,1001,'03-Apr-2018',301);

SELECT * FROM INVOICE
WHERE INV_NUM = 8090;


########### A procedure to delete an invoice given the invoice number as an input parameter
CREATE OR REPLACE PROCEDURE PRC_INVOICE_DELETE
(C_NUM IN NUMBER)
AS
BEGIN
    DELETE FROM INVOICE
    WHERE CUST_NUM = C_NUM;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data deleted');
END;
/
EXECUTE PRC_INVOICE_ADD(8090)


########### Selects customer nums that match input and calculates the difference they owe
CREATE OR REPLACE PROCEDURE PRC_CHECK_CUST_BAL
(C_NUM IN NUMBER)
AS
    MY_CUST_NUM NUMBER;
    MY_CUST_BALANCE NUMBER;
    AMOUNT_OWED NUMBER;
BEGIN
    SELECT CUST_NUM, CUST_BALANCE
    INTO MY_CUST_NUM, MY_CUST_BALANCE
    FROM CUSTOMER
    WHERE CUST_NUM = C_NUM;
    
    IF MY_CUST_BALANCE > 500 THEN
        AMOUNT_OWED := MY_CUST_BALANCE - 500;
        DBMS_OUTPUT.PUT_LINE('PLEASE PAY $' || AMOUNT_OWED);
    ELSE
        DBMS_OUTPUT.PUT_LINE('YOU DO NOT OWE ANYTHING');
    END IF;
END;
/
EXECUTE PRC_CHECK_CUST_BAL(1001);
