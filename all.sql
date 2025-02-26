---table
create table table_1 (first_name varchar2(50), middle_name  varchar2(50), last_name  varchar2(50), age number)
alter table table_1 add FULL_NAME varchar2(50);
alter table table_1 add ERROR_NAME varchar2(50);
select * from table_1

--procedure
CREATE OR REPLACE PROCEDURE PRC_1 (P_first_name  IN VARCHAR2,
                                  P_MIDDLE_name IN VARCHAR2,
                                  P_last_name IN VARCHAR2,
                                  P_AGE IN NUMBER,
                                  P_FULL_NAME OUT VARCHAR2)
IS
 v_AGE       NUMBER;
BEGIN
   P_FULL_NAME:= P_first_name||' '||P_MIDDLE_name||' '||P_last_name;
   v_AGE:=P_AGE;
insert into  table_1 (FULL_NAME,age)
values (P_FULL_NAME,v_AGE);
EXCEPTION
 WHEN OTHERS THEN
   NULL;
END;

DECLARE
P_FULL_NAME VARCHAR2(50);
BEGIN
  PRC_1('RAHUL',
      'SINGH',
      'RAWAT',
      25,
      P_FULL_NAME);
DBMS_OUTPUT.PUT_LINE(P_FULL_NAME);
END;
------------------------
---type--
DECLARE
TYPE TYP_NT_NUM IS TABLE OF number;
Nt_tab TYP_NT_NUM:=TYP_NT_NUM (5,10,15,20);
BEGIN
FOR i IN 1 .. nt_tab.COUNT
LOOP
DBMS_OUTPUT.put_line ('The Value Nested Table ' || nt_tab (i));
END LOOP;
END;
              
create table  table_3 (value_1 number)

select * from table_2 for update

select * 
from table_2 a inner join table_3 b
on  a.value_1=b.value_1;

weo_accr_receipt




---1)Associative array OR INDEX BY TABLE

DECLARE
  -- Associative array indexed by string:
  
  TYPE population IS TABLE OF NUMBER  -- Associative array type
    INDEX BY VARCHAR2(64);            --  indexed by string
  
  city_population  population;        -- Associative array variable
  i  VARCHAR2(64);                    -- Scalar variable
  
BEGIN
  -- Add elements (key-value pairs) to associative array:
 
  city_population('Smallville')  := 2000;
  city_population('Midland')     := 750000;
  city_population('Megalopolis') := 1000000;
 
  -- Change value associated with key 'Smallville':
 
  city_population('Smallville') := 2001;
 
  -- Print associative array:
 
  i := city_population.FIRST;  -- Get first element of array
 
  WHILE i IS NOT NULL LOOP
    DBMS_Output.PUT_LINE
      ('Population of ' || i || ' is ' || city_population(i));
    i := city_population.NEXT(i);  -- Get next element of array
  END LOOP;
END;
/

Population of Megalopolis is 1000000
Population of Midland is 750000
Population of Smallville is 2001

-------------------------------------------------------

DECLARE
  TYPE sum_multiples IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  n  PLS_INTEGER := 5;   -- number of multiples to sum for display
  sn PLS_INTEGER := 10;  -- number of multiples to sum
  m  PLS_INTEGER := 3;   -- multiple

  FUNCTION get_sum_multiples (
    multiple IN PLS_INTEGER,
    num      IN PLS_INTEGER
  ) RETURN sum_multiples
  IS
    s sum_multiples;
  BEGIN
    FOR i IN 1..num LOOP
      s(i) := multiple * ((i * (i + 1)) / 2);  -- sum of multiples
    END LOOP;
    RETURN s;
  END get_sum_multiples;

BEGIN
  DBMS_OUTPUT.PUT_LINE (
    'Sum of the first ' || TO_CHAR(n) || ' multiples of ' ||
    TO_CHAR(m) || ' is ' || TO_CHAR(get_sum_multiples (m, sn)(n))
  );
END;
/
----------------------------------------------------------
DECLARE
  TYPE My_AA IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
  v CONSTANT My_AA := My_AA(-10=>'-ten', 0=>'zero', 1=>'one', 2=>'two', 3 => 'three', 4 => 'four', 9 => 'nine');
BEGIN
  DECLARE
    Idx PLS_INTEGER := v.FIRST();
  BEGIN
    WHILE Idx IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(Idx, '999')||LPAD(v(Idx), 7));
      Idx := v.NEXT(Idx);
    END LOOP;
  END;
END;
/
----------------------------------------------------------


CREATE OR REPLACE PACKAGE My_Types AUTHID CURRENT_USER IS
  TYPE My_AA IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
  FUNCTION Init_My_AA RETURN My_AA;
END My_Types;
/
CREATE OR REPLACE PACKAGE BODY My_Types IS
  FUNCTION Init_My_AA RETURN My_AA IS
    Ret My_AA;
  BEGIN
    Ret(-10) := '-ten';
    Ret(0) := 'zero';
    Ret(1) := 'one';
    Ret(2) := 'two';
    Ret(3) := 'three';
    Ret(4) := 'four';
    Ret(9) := 'nine';
    RETURN Ret;
  END Init_My_AA;
END My_Types;
/
DECLARE
  v CONSTANT My_Types.My_AA := My_Types.Init_My_AA();
BEGIN
  DECLARE
    Idx PLS_INTEGER := v.FIRST();
  BEGIN
    WHILE Idx IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(Idx, '999')||LPAD(v(Idx), 7));
      Idx := v.NEXT(Idx);
    END LOOP;
  END;
END;
/
----------------------------------------------------------------

----2)Varrays (Variable-Size Arrays)

A varray (variable-size array) is an array whose number of elements can vary from zero (empty) to the declared maximum size.

To access an element of a varray variable, use the syntax variable_name(index). The lower bound of index is 1; the upper bound is the current number of elements. The upper bound changes as you add or delete elements, but it cannot exceed the maximum size. When you store and retrieve a varray from the database, its indexes and element order remain stable.

Figure 6-1 shows a varray variable named Grades, which has maximum size 10 and contains seven elements. Grades(n) references the nth element of Grades. The upper bound of Grades is 7, and it cannot exceed 10.

Figure 6-1 Varray of Maximum Size 10 with 7 Elements

Description of Figure 6-1 follows
Description of "Figure 6-1 Varray of Maximum Size 10 with 7 Elements"
The database stores a varray variable as a single object. If a varray variable is less than 4 KB, it resides inside the table of which it is a column; otherwise, it resides outside the table but in the same tablespace.

An uninitialized varray variable is a null collection. You must initialize it, either by making it empty or by assigning a non-NULL value to it. For details, see "Collection Constructors" and "Assigning Values to Collection Variables".

Topics

Appropriate Uses for Varrays

See Also:

Table 6-1 for a summary of varray characteristics

"varray_type_def ::=" for the syntax of a VARRAY type definition

"CREATE TYPE Statement" for information about creating standalone VARRAY types

Oracle Database SQL Language Reference for more information about varrays

Example 6-4 Varray (Variable-Size Array)

This example defines a local VARRAY type, declares a variable of that type (initializing it with a constructor), and defines a procedure that prints the varray. The example invokes the procedure three times: After initializing the variable, after changing the values of two elements individually, and after using a constructor to the change the values of all elements. (For an example of a procedure that prints a varray that might be null or empty, see Example 6-30.)

Live SQL:You can view and run this example on Oracle Live SQL at Varray (Variable-Size Array)

-----------------------------------------------------------

DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);  -- VARRAY type
 
  -- varray variable initialized with constructor:
 
  team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    FOR i IN 1..4 LOOP
      DBMS_OUTPUT.PUT_LINE(i || '.' || team(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('---'); 
  END;
  
BEGIN 
  print_team('2001 Team:');
 
  team(3) := 'Pierre';  -- Change values of two elements
  team(4) := 'Yvonne';
  print_team('2005 Team:');
 
  -- Invoke constructor to assign new values to varray variable:
 
  team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
  print_team('2009 Team:');
END;
/

-----------------------------------------------------------------------------
--3)nested table

DECLARE
  TYPE Roster IS TABLE OF VARCHAR2(15);  -- nested table type
 
  -- nested table variable initialized with constructor:
 
  names Roster := Roster('D Caruso', 'J Hamil', 'D Piro', 'R Singh');
 
  PROCEDURE print_names (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    FOR i IN names.FIRST .. names.LAST LOOP  -- For first to last element
      DBMS_OUTPUT.PUT_LINE(names(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('---');
  END;
  
BEGIN 
  print_names('Initial Values:');
 
  names(3) := 'P Perez';  -- Change value of one element
  print_names('Current Values:');
 
  names := Roster('A Jansen', 'B Gupta');  -- Change entire table
  print_names('Current Values:');
END;
/


CREATE OR REPLACE TYPE nt_type IS TABLE OF NUMBER;
/
CREATE OR REPLACE PROCEDURE print_nt (nt nt_type) AUTHID DEFINER IS
  i  NUMBER;
BEGIN
  i := nt.FIRST;
 
  IF i IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('nt is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      DBMS_OUTPUT.PUT('nt.(' || i || ') = ');
      DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(nt(i)), 'NULL'));
      i := nt.NEXT(i);
    END LOOP;
  END IF;
 
  DBMS_OUTPUT.PUT_LINE('---');
END print_nt;
/
DECLARE
  nt nt_type := nt_type();  -- nested table variable initialized to empty
BEGIN
  print_nt(nt);
  nt := nt_type(90, 9, 29, 58);
  print_nt(nt);
END;
/
-----------------------------------------------------------
----Nested Tables of Nested Tables and Varrays of Integers
DECLARE
  TYPE tb1 IS TABLE OF VARCHAR2(20);  -- nested table of strings
  vtb1 tb1 := tb1('one', 'three');

  TYPE ntb1 IS TABLE OF tb1; -- nested table of nested tables of strings
  vntb1 ntb1 := ntb1(vtb1);

  TYPE tv1 IS VARRAY(10) OF INTEGER;  -- varray of integers
  TYPE ntb2 IS TABLE OF tv1;          -- nested table of varrays of integers
  vntb2 ntb2 := ntb2(tv1(3,5), tv1(5,7,3));

BEGIN
  vntb1.EXTEND;
  vntb1(2) := vntb1(1);
  vntb1.DELETE(1);     -- delete first element of vntb1
  vntb1(2).DELETE(1);  -- delete first string from second table in nested table
END;
-----------------------------------------------------------------
-----------------RECORDS
A RECORD type defined in a PL/SQL block is a local type. It is available only in the block, and is stored in the database only if the block is in a standalone or package subprogram.

A RECORD type defined in a package specification is a public item. You can reference it from outside the package by qualifying it with the package name (package_name.type_name). It is stored in the database until you drop the package with the DROP PACKAGE statement.

You cannot create a RECORD type at schema


DECLARE
  TYPE DeptRecTyp IS RECORD (
    dept_id    NUMBER(4) NOT NULL := 10,
    dept_name  VARCHAR2(30) NOT NULL := 'Administration',
    mgr_id     NUMBER(6) := 200,
    loc_id     NUMBER(4) := 1700
  );
 
  dept_rec DeptRecTyp;
BEGIN
  DBMS_OUTPUT.PUT_LINE('dept_id:   ' || dept_rec.dept_id);
  DBMS_OUTPUT.PUT_LINE('dept_name: ' || dept_rec.dept_name);
  DBMS_OUTPUT.PUT_LINE('mgr_id:    ' || dept_rec.mgr_id);
  DBMS_OUTPUT.PUT_LINE('loc_id:    ' || dept_rec.loc_id);
END;
/

todays birthday sql query
select * from bjaz_emp_mast where to_char(BIRTH_DT,'dd-mon')= to_char(sysdate,'dd-mon');
--1)---------------------------join-------------------
create table table_2(c_id varchar2(10))
insert into table_1 values('4');
select * from table_1;
select * from table_2;
1     1
2     2
3     2
3     5
4     null
null  null
null  null
---------------------------
-------inner 
select *
from table_1 a inner join table_2 b
on a.c_id=b.c_id;

select *
from table_1 a,table_2 b
where a.c_id=b.c_id
1
2
2

----left join
select *
from table_1 a left join table_2 b
on a.c_id=b.c_id;

select *
from table_1 a, table_2 b
where a.c_id=b.c_id(+)
1
2
2
3
3
4
null
null

----right join
select * 
from  table_1 a right join table_2 b
on a.c_id=b.c_id;

select * 
from table_1 a ,table_2 b
where a.c_id(+)=b.c_id;

1
2
2
5
null
null
null

--full outer join
select *
from table_1 a full outer join table_2 b
on a.c_id=b.c_id;

1
2
2
3
3
4
null
null
5
null
null
null

---------------------------Rank dense Rank----------------------------------------------------------------
-- Create the table
CREATE TABLE employeesbhai (
    employee_id NUMBER,
    employee_name VARCHAR2(50),
    department VARCHAR2(50),
    salary NUMBER
);

-- Insert data into the table
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (1, 'John Doe', 'HR', 50000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (2, 'Jane Smith', 'HR', 55000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (3, 'Emily Davis', 'IT', 60000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (4, 'Michael Brown', 'IT', 60000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (7, 'Virat maroon', 'IT', 65000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (5, 'Chris Wilson', 'Finance', 70000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (6, 'Anna Johnson', 'Finance', 75000);
insert into employeesbhai (EMPLOYEE_ID, EMPLOYEE_NAME, DEPARTMENT, SALARY) values (8, 'Emily Daviss', 'IT', 70000);
insert into employeesbhai (EMPLOYEE_ID, EMPLOYEE_NAME, DEPARTMENT, SALARY) values (9, 'Virat maroon', 'IT', 40000);

-- Commit the data
COMMIT;

select employee_id,employee_name,department,salary,
rank() over (PARTITION BY department order by salary desc) as rank,
dense_rank() over (partition by department order by salary desc) as dense_rank
from employeesbhai

--------------------set operator--------------
CREATE TABLE UKEmployee
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO UKEmployee VALUES(1, 'Pranaya');
INSERT INTO UKEmployee VALUES(2, 'Priyanka');
INSERT INTO UKEmployee VALUES(3, 'Preety');
INSERT INTO UKEmployee VALUES(4, 'Subrat');
INSERT INTO UKEmployee VALUES(5, 'Anurag');
INSERT INTO UKEmployee VALUES(6, 'Rajesh');
INSERT INTO UKEmployee VALUES(7, 'Hina');

CREATE TABLE USAEmployee
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO USAEmployee VALUES(1, 'James');
INSERT INTO USAEmployee VALUES(2, 'Priyanka');
INSERT INTO USAEmployee VALUES(3, 'Sara');
INSERT INTO USAEmployee VALUES(4, 'Subrat');
INSERT INTO USAEmployee VALUES(5, 'Sushanta');
INSERT INTO USAEmployee VALUES(6, 'Mahesh');
INSERT INTO USAEmployee VALUES(7, 'Hina');
--------------------------------------------------------------------------------------

select * from UKEmployee;
select * from USAEmployee;

EMPLOYEEID
1     1
1     1
1     2 
2     2
2     3
3     4
4     5
5     6
null null
null null
null

1)
SELECT EMPLOYEEID FROM UKEmployee
union
SELECT EMPLOYEEID FROM USAEmployee;---first find distinct then common from both table(null is equal to null means if there are
                                       -- more then 1 null then considered only one null value )
                                       --here only in set operator null is equal to anoter null)
2)
SELECT EMPLOYEEID FROM UKEmployee
union all
SELECT EMPLOYEEID FROM USAEmployee;--two table combined

3)
SELECT EMPLOYEEID FROM UKEmployee
intersect
SELECT EMPLOYEEID FROM USAEmployee;---first find distinct then common from both table(null is equal to null means if there are
                                       -- more then 1 null then considered only one null value )
4.1) 
SELECT EMPLOYEEID FROM UKEmployee
minus
SELECT EMPLOYEEID FROM USAEmployee;--a-b ---first find distinct then common from both table(null is equal to null means if there are
                                       -- more then 1 null then considered only one null value )
4.2)
SELECT EMPLOYEEID FROM USAEmployee
minus
SELECT EMPLOYEEID FROM UKEmployee;--b-a  first find distinct then common from both table(null is equal to null means if there are
                                       -- more then 1 null then considered only one null value )
----------------------------------------------------
-----highest salary---
-------3 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                              from table_3 
                               order by sal desc)
                      where rownum <=3);

-------2 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                             from table_3 
                             order by sal desc)
                      where rownum <=2);
--------------------                   
select max(sal) from 
table_3
where sal  not in (select max(sal)
                   from table_3)
               
------------------------    
-----------day 2---------
create table table_5(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
insert into UKEmployee (EMPLOYEEID,c_name) 
values (4,null);
 
create table USAEmployee(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
 

select * from UKEmployee for update;
select * from USAEmployee for update;
select * from table_3 for update;
select * from table_4 for update;
select * from table_5 for update;
alter table table_5 add  dept varchar2(20);


select * 
from UKEmployee a inner join USAEmployee b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from UKEmployee a right join USAEmployee b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from USAEmployee a left join USAEmployee b
on a.EMPLOYEEID=b.EMPLOYEEID

select *
from UKEmployee a full outer join USAEmployee b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from UKEmployee a natural join USAEmployee b

select * 
from UKEmployee a cross join USAEmployee b 


select min(sal) from  (select sal from (select sal
                                        from table_3
                                        order by sal desc)
                       where rownum<=3);
----delete
select * from table_4 a where rowid not in (select max(rowid) from table_4 a
group by a.EMPLOYEEID,a.c_name,a.sal)


select * from table_4 a where rowid > (select min(rowid) from table_4 b
where a.EMPLOYEEID=b.EMPLOYEEID and a.c_name=b.c_name and a.sal=b.sal)

select * from table_5
select instr(C_NAME,'a',1,3) from table_5

select substr(C_NAME,1,3) from table_5


select instr('sudhanshussss','s',2,5) from dual



---max sal in each dept
select * from  table_5 a inner join(select dept,max(sal) sal
                                    from table_5 n
                                    group by dept) b
                                    
        on a.sal= b.sal
        and a.dept=b.dept;
-----------------
                                  
--2nd mthod                       
select * from table_5 where sal in (select max(sal)
from table_5
group by dept)

delete from UKEmployee where rowid not in (sel max(rowid)
                                        from UKEmployee
                                        group by sal,dept)

---co-related subquery
select * from table_5 a
where 1 <=(select count(sal)
           from table_5 b
           where a.EMPLOYEEID=b.EMPLOYEEID)
           
 create or replace function function_11 (age number)
 return number
 is 
 no_of_days number;
 v_sal     number;
 begin
   select sal
   into v_sal
   from table_5;
   
   no_of_days:=v_sal*age*365;
   return no_of_days;
 exception
   when others then
    null;
 end;
   
 select (to_date('14-aug-2023')-to_date('26-nov-2021'))/30 from dual
 select add_
 
 select (0.715068*365)/30 from dual
 
 select function_11(10) from dual
 
 --nested table
declare
type emp_name_list_type  is table of varchar2(20);
lv_emp_name_list  emp_name_list_type:=emp_name_list_type();
begin
  
lv_emp_name_list.extend(2);

lv_emp_name_list(1):='rahul';
dbms_output.put_line (lv_emp_name_list(1));
end;


select to_date('31-jul-2024','DD-MON-YYYY') -TRUNC(SYSDATE-1)FROM DUAL











create table table_5(c_id number(20),
                    c_name varchar2(20)
                    );
insert into table_1 (c_id,c_name) 
values (4,null);
 
create table table_2(c_id number(20),
                    c_name varchar2(20)
                    );
 

select * from table_1 for update;
select * from table_2 for update;
select * from table_3 for update;
-------inner join---------------------------
select * 
from table_1 a inner join table_2 b
on a.c_id=b.c_id;
  
select *
from table_1 a , table_2 b
where a.c_id=b.c_id
 
-------left join---------------------------
select * 
from table_1 a left join table_2 b
on a.c_id=b.c_id;

select * 
from table_1, table_2
where table_1.c_id=table_2.c_id(+)
------right join------------------

select * 
from table_1 a right join table_2 b
on a.c_id= b.c_id;

select *
from table_1 a, table_2 b
where a.c_id(+)=b.c_id;

------full outer join----------
select * 
from table_1 a full outer join table_2 b
on a.c_id=b.c_i

----natural join----------

select *
from table_1 a natural join table_2 b;

----cross join-------
select * 
from table_1 a cross join table_2 b;



-----highest salary---
-------3 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                              from table_3 
                               order by sal desc)
                      where rownum <=3);

-------2 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                             from table_3 
                             order by sal desc)
                      where rownum <=2);
--------------------                   
select max(sal) from 
table_3
where sal  not in (select max(sal)
                   from table_3)
               
------------------------    
-----------day 2---------
create table table_5(c_id number(20),
                    c_name varchar2(20)
                    );
insert into table_1 (c_id,c_name) 
values (4,null);
 
create table table_2(c_id number(20),
                    c_name varchar2(20)
                    );
 

select * from table_1 for update;
select * from table_2 for update;
select * from table_3 for update;
select * from table_4 for update;
select * from table_5 for update;
alter table table_5 add  dept varchar2(20);


select * 
from table_1 a inner join table_2 b
on a.c_id=b.c_id

select * 
from table_1 a right join table_2 b
on a.c_id=b.c_id

select * 
from table_2 a left join table_2 b
on a.c_id=b.c_id

select *
from table_1 a full outer join table_2 b
on a.c_id=b.c_id

select * 
from table_1 a natural join table_2 b

select * 
from table_1 a cross join table_2 b 


select min(sal) from  (select sal from (select sal
                                        from table_3
                                        order by sal desc)
                       where rownum<=3);
----delete
select * from table_4 a where rowid not in (select max(rowid) from table_4 a
group by a.c_id,a.c_name,a.sal)


select * from table_4 a where rowid > (select min(rowid) from table_4 b
where a.c_id=b.c_id and a.c_name=b.c_name and a.sal=b.sal)

select * from table_5
select instr(C_NAME,'a',1,3) from table_5

select substr(C_NAME,1,3) from table_5


select instr('sudhanshussss','s',2,5) from dual



---max sal in each dept
select * from  table_5 a inner join(select dept,max(sal) sal
                                    from table_5 n
                                    group by dept) b
                                    
        on a.sal= b.sal
        and a.dept=b.dept;
-----------------
                                  
--2nd mthod                       
select * from table_5 where sal in (select max(sal)
from table_5
group by dept)

delete from table_1 where rowid not in (sel max(rowid)
                                        from table_1
                                        group by sal,dept)

---co-related subquery
select * from table_5 a
where 1 <=(select count(sal)
           from table_5 b
           where a.c_id=b.c_id)
           
 create or replace function function_11 (age number)
 return number
 is 
 no_of_days number;
 v_sal     number;
 begin
   select sal
   into v_sal
   from table_5;
   
   no_of_days:=v_sal*age*365;
   return no_of_days;
 exception
   when others then
    null;
 end;
   
 select (to_date('14-aug-2023')-to_date('26-nov-2021'))/30 from dual
 select add_
 
 select (0.715068*365)/30 from dual
 
 select function_11(10) from dual
 
 --nested table
declare
type emp_name_list_type  is table of varchar2(20);
lv_emp_name_list  emp_name_list_type:=emp_name_list_type();
begin
  
lv_emp_name_list.extend(2);

lv_emp_name_list(1):='rahul';
dbms_output.put_line (lv_emp_name_list(1));
end;

-- Create the table
CREATE TABLE employeesbhai (
    employee_id NUMBER,
    employee_name VARCHAR2(50),
    department VARCHAR2(50),
    salary NUMBER
);

-- Insert data into the table
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (1, 'John Doe', 'HR', 50000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (2, 'Jane Smith', 'HR', 55000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (3, 'Emily Davis', 'IT', 60000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (4, 'Michael Brown', 'IT', 60000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (7, 'Virat maroon', 'IT', 65000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (5, 'Chris Wilson', 'Finance', 70000);
INSERT INTO employeesbhai (employee_id, employee_name, department, salary) VALUES (6, 'Anna Johnson', 'Finance', 75000);

-- Commit the data
COMMIT;


select * from employeesbhai for update


-- Using RANK
SELECT 
    employee_id,
    employee_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM 
    employeesbhai;

-- Using DENSE_RANK
SELECT 
    employee_id,
    employee_name,
    department,
    salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM 
    employeesbhai;


CREATE TABLE EmployeeUK
(
  EmployeeId INT,
  FirstName VARCHAR(20),
  LastName VARCHAR(20),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUK VALUES(1, 'Pranaya', 'Rout', 'Male','IT');
INSERT INTO EmployeeUK VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUK VALUES(3, 'Preety', 'Tiwary', 'Female','HR');
INSERT INTO EmployeeUK VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUK VALUES(5, 'Anurag', 'Mohanty', 'Male','IT');
INSERT INTO EmployeeUK VALUES(6, 'Rajesh', 'Pradhan', 'Male','HR');
INSERT INTO EmployeeUK VALUES(7, 'Hina', 'Sharma', 'Female','IT');

CREATE TABLE EmployeeUSA
(
  EmployeeId INT,
  FirstName VARCHAR(20),
  LastName VARCHAR(20),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUSA VALUES(1, 'James', 'Pattrick', 'Male','IT');
INSERT INTO EmployeeUSA VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUSA VALUES(3, 'Sara', 'Taylor', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(5, 'Sushanta', 'Jena', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(6, 'Mahesh', 'Sindhey', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(7, 'Hina', 'Sharma', 'Female','IT');

-----------------------------------------------------------------------------------
CREATE TABLE EmployeeUKA
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO EmployeeUKA VALUES(1, 'Pranaya');
INSERT INTO EmployeeUKA VALUES(2, 'Priyanka');
INSERT INTO EmployeeUKA VALUES(3, 'Preety');
INSERT INTO EmployeeUKA VALUES(4, 'Subrat');
INSERT INTO EmployeeUKA VALUES(5, 'Anurag');
INSERT INTO EmployeeUKA VALUES(6, 'Rajesh');
INSERT INTO EmployeeUKA VALUES(7, 'Hina');

CREATE TABLE EmployeeUSAA
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO EmployeeUSAA VALUES(1, 'James');
INSERT INTO EmployeeUSAA VALUES(2, 'Priyanka');
INSERT INTO EmployeeUSAA VALUES(3, 'Sara');
INSERT INTO EmployeeUSAA VALUES(4, 'Subrat');
INSERT INTO EmployeeUSAA VALUES(5, 'Sushanta');
INSERT INTO EmployeeUSAA VALUES(6, 'Mahesh');
INSERT INTO EmployeeUSAA VALUES(7, 'Hina');
--------------------------------------------------------------------------------------

select * from EmployeeUKA for update;
delete from  EmployeeUKA where  EMPLOYEEID is null
select * from EmployeeUSAA;


EMPLOYEEID
1   1
1   1
1   2 
2   2
2   3
3   4
4   5
5   6
null null
null null
null

1)
SELECT EMPLOYEEID FROM EmployeeUKA
union
SELECT EMPLOYEEID FROM EmployeeUSAA;---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
                                       --here only in set operator null is equal to anoter null)
2)
SELECT EMPLOYEEID FROM EmployeeUKA
union all
SELECT EMPLOYEEID FROM EmployeeUSAA;--two table combined

3)
SELECT EMPLOYEEID FROM EmployeeUKA
intersect
SELECT EMPLOYEEID FROM EmployeeUSAA;---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
4.1) 
SELECT EMPLOYEEID FROM EmployeeUKA
minus
SELECT EMPLOYEEID FROM EmployeeUSAA;--a-b ---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
4.2)
SELECT EMPLOYEEID FROM EmployeeUSAA
minus
SELECT EMPLOYEEID FROM EmployeeUKA;--b-a  first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )




----------------------------------------------------


select * from EmployeeUKA;
select * from EmployeeUSAA;


EMPLOYEEID
1      1
1      1
1      2
2      2
2      3
3      4
4      5
5      6
NULL   NULL
NULL   NULL
       NULL

-------inner join---------------------------
select * 
from EmployeeUKA a inner join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID;
  
select *
from EmployeeUKA a , EmployeeUSAA b
where a.EMPLOYEEID=b.EMPLOYEEID
 
-------left join---------------------------
select * 
from EmployeeUKA a left join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID;

select * 
from EmployeeUKA, EmployeeUSAA
where EmployeeUKA.EMPLOYEEID=EmployeeUSAA.EMPLOYEEID(+)
------right join------------------

select * 
from EmployeeUKA a right join EmployeeUSAA b
on a.EMPLOYEEID= b.EMPLOYEEID;

select *
from EmployeeUKA a, EmployeeUSAA b
where a.EMPLOYEEID(+)=b.EMPLOYEEID;

------full outer join----------
select * 
from EmployeeUKA a full outer join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

----natural join----------

select *
from EmployeeUKA a natural join EmployeeUSAA b;


----cross join-------
select * 
from EmployeeUKA a cross join EmployeeUSAA b;



-----highest salary---
-------3 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                              from table_3 
                               order by sal desc)
                      where rownum <=3);

-------2 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                             from table_3 
                             order by sal desc)
                      where rownum <=2);
--------------------                   
select max(sal) from 
table_3
where sal  not in (select max(sal)
                   from table_3)
               
------------------------    
-----------day 2---------
create table table_5(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
insert into EmployeeUKA (EMPLOYEEID,c_name) 
values (4,null);
 
create table EmployeeUSAA(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
 

select * from EmployeeUKA for update;
select * from EmployeeUSAA for update;
select * from table_3 for update;
select * from table_4 for update;
select * from table_5 for update;
alter table table_5 add  dept varchar2(20);


select * 
from EmployeeUKA a inner join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUKA a right join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUSAA a left join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select *
from EmployeeUKA a full outer join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUKA a natural join EmployeeUSAA b

select * 
from EmployeeUKA a cross join EmployeeUSAA b 


select min(sal) from  (select sal from (select sal
                                        from table_3
                                        order by sal desc)
                       where rownum<=3);
----delete
select * from table_4 a where rowid not in (select max(rowid) from table_4 a
group by a.EMPLOYEEID,a.c_name,a.sal)


select * from table_4 a where rowid > (select min(rowid) from table_4 b
where a.EMPLOYEEID=b.EMPLOYEEID and a.c_name=b.c_name and a.sal=b.sal)

select * from table_5
select instr(C_NAME,'a',1,3) from table_5

select substr(C_NAME,1,3) from table_5


select instr('sudhanshussss','s',2,5) from dual



---max sal in each dept
select * from  table_5 a inner join(select dept,max(sal) sal
                                    from table_5 n
                                    group by dept) b
                                    
        on a.sal= b.sal
        and a.dept=b.dept;
-----------------
                                  
--2nd mthod                       
select * from table_5 where sal in (select max(sal)
from table_5
group by dept)

delete from EmployeeUKA where rowid not in (sel max(rowid)
                                        from EmployeeUKA
                                        group by sal,dept)

---co-related subquery
select * from table_5 a
where 1 <=(select count(sal)
           from table_5 b
           where a.EMPLOYEEID=b.EMPLOYEEID)
           
 create or replace function function_11 (age number)
 return number
 is 
 no_of_days number;
 v_sal     number;
 begin
   select sal
   into v_sal
   from table_5;
   
   no_of_days:=v_sal*age*365;
   return no_of_days;
 exception
   when others then
    null;
 end;
   
 select (to_date('14-aug-2023')-to_date('26-nov-2021'))/30 from dual
 select add_
 
 select (0.715068*365)/30 from dual
 
 select function_11(10) from dual
 
 --nested table
declare
type emp_name_list_type  is table of varchar2(20);
lv_emp_name_list  emp_name_list_type:=emp_name_list_type();
begin
  
lv_emp_name_list.extend(2);

lv_emp_name_list(1):='rahul';
dbms_output.put_line (lv_emp_name_list(1));
end;


select to_date('31-jul-2024','DD-MON-YYYY') -TRUNC(SYSDATE-1)FROM DUAL


CREATE TABLE EmployeeUK
(
  EmployeeId INT,
  FirstName VARCHAR(20),
  LastName VARCHAR(20),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUK VALUES(1, 'Pranaya', 'Rout', 'Male','IT');
INSERT INTO EmployeeUK VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUK VALUES(3, 'Preety', 'Tiwary', 'Female','HR');
INSERT INTO EmployeeUK VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUK VALUES(5, 'Anurag', 'Mohanty', 'Male','IT');
INSERT INTO EmployeeUK VALUES(6, 'Rajesh', 'Pradhan', 'Male','HR');
INSERT INTO EmployeeUK VALUES(7, 'Hina', 'Sharma', 'Female','IT');

CREATE TABLE EmployeeUSA
(
  EmployeeId INT,
  FirstName VARCHAR(20),
  LastName VARCHAR(20),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUSA VALUES(1, 'James', 'Pattrick', 'Male','IT');
INSERT INTO EmployeeUSA VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUSA VALUES(3, 'Sara', 'Taylor', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(5, 'Sushanta', 'Jena', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(6, 'Mahesh', 'Sindhey', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(7, 'Hina', 'Sharma', 'Female','IT');

-----------------------------------------------------------------------------------
CREATE TABLE EmployeeUKA
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO EmployeeUKA VALUES(1, 'Pranaya');
INSERT INTO EmployeeUKA VALUES(2, 'Priyanka');
INSERT INTO EmployeeUKA VALUES(3, 'Preety');
INSERT INTO EmployeeUKA VALUES(4, 'Subrat');
INSERT INTO EmployeeUKA VALUES(5, 'Anurag');
INSERT INTO EmployeeUKA VALUES(6, 'Rajesh');
INSERT INTO EmployeeUKA VALUES(7, 'Hina');

CREATE TABLE EmployeeUSAA
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO EmployeeUSAA VALUES(1, 'James');
INSERT INTO EmployeeUSAA VALUES(2, 'Priyanka');
INSERT INTO EmployeeUSAA VALUES(3, 'Sara');
INSERT INTO EmployeeUSAA VALUES(4, 'Subrat');
INSERT INTO EmployeeUSAA VALUES(5, 'Sushanta');
INSERT INTO EmployeeUSAA VALUES(6, 'Mahesh');
INSERT INTO EmployeeUSAA VALUES(7, 'Hina');
--------------------------------------------------------------------------------------

select * from EmployeeUKA for update;
delete from  EmployeeUKA where  EMPLOYEEID is null
select * from EmployeeUSAA;


EMPLOYEEID
1   1
1   1
1   2 
2   2
2   3
3   4
4   5
5   6
null null
null null
null

1)
SELECT EMPLOYEEID FROM EmployeeUKA
union
SELECT EMPLOYEEID FROM EmployeeUSAA;---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
                                       --here only in set operator null is equal to anoter null)
2)
SELECT EMPLOYEEID FROM EmployeeUKA
union all
SELECT EMPLOYEEID FROM EmployeeUSAA;--two table combined

3)
SELECT EMPLOYEEID FROM EmployeeUKA
intersect
SELECT EMPLOYEEID FROM EmployeeUSAA;---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
4.1) 
SELECT EMPLOYEEID FROM EmployeeUKA
minus
SELECT EMPLOYEEID FROM EmployeeUSAA;--a-b ---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
4.2)
SELECT EMPLOYEEID FROM EmployeeUSAA
minus
SELECT EMPLOYEEID FROM EmployeeUKA;--b-a  first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )


 If to_char(trunc(sysdate),'DD') in ('11','21') then
  v_start_date := trunc(p_start_date)-10;
  v_end_date :=  trunc(p_end_date) -1;

  elsif to_char(trunc(sysdate),'DD') in ('01') then
       if
        to_char(trunc(sysdate-1),'DD') in ('31') then
         v_start_date := trunc(p_start_date)-11;
         v_end_date :=  trunc(p_end_date) -1;
       elsif
         to_char(trunc(sysdate-1),'DD') in ('30') then
        v_start_date := trunc(p_start_date)-10;
        v_end_date :=  trunc(p_end_date) -1;
       elsif
        to_char(trunc(sysdate-1),'DD') in ('28') then
        v_start_date := trunc(p_start_date)-8;
        v_end_date :=  trunc(p_end_date) -1;
       elsif
        to_char(trunc(sysdate-1),'DD') in ('29') then
        v_start_date := trunc(p_start_date)-9;
        v_end_date :=  trunc(p_end_date) -1;
      end if;
  ELSE
    RETURN;
  end if;


  BEGIN
      SELECT validate_yn,OFFICIAL_EMAIL
      INTO  v_validate_yn,V_OFFICIAL_EMAIL
      FROM   bjaz_packpol_agent_validations
      WHERE  validation_no = 'conveyance_flag';
   EXCEPTION
      WHEN OTHERS THEN
         v_validate_yn := 'N';
         V_OFFICIAL_EMAIL:=null;
   END;
IF  v_validate_yn='Y' THEN

   pagentsobj       :=  weo_agents_obj
                            (NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                             NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                             NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                            );
  pagentsobj.loginname:=V_OFFICIAL_EMAIL;
  p_emp_dtls        := weo_rec_strings40 (v_start_date, v_end_date, 'UPDATE_PAYMENT_STATUS', NULL, NULL, NULL, NULL, NULL,
                            NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                            NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  p_emp_search_dtls := weo_rec_strings20 (SYSDATE,SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                                                 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  p_app_dtls_list   := weo_rec_strings20_list(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                            NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  p_ref_dtls_list   := weo_rec_strings20_list(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                            NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
  p_error           := weo_tyge_error_message_list();
  p_mode_list       := bjaz_gen_strings5_list();
  p_export_list_new := weo_rec_strings40_list();

    bjaz_conveyance_diary.view_acc_conveyance_bills (pagentsobj,
                                                     p_emp_dtls,
                                                     p_app_dtls_list,
                                                     p_ref_dtls_list,
                                                     p_error,
                                                     p_mode_list,
                                                     p_error_code
                                                     );
 
   FOR i IN 1 .. p_app_dtls_list.COUNT LOOP
     
      IF p_app_dtls_list (i).stringval18='E'
      THEN 
      p_app_dtls_list (i).stringval14 := 'Y';
      END IF;
  
      p_app_dtls_list (i).stringval15 := '3';
      p_app_dtls_list (i).stringval19 := 'PAID';

  END LOOP;
  

     bjaz_conveyance_diary.save_conveyance_bills (pagentsobj,
                                                     p_emp_dtls,
                                                     p_app_dtls_list,
                                                     p_ref_dtls_list,
                                                     p_error,
                                                     p_error_code
                                                     );

      bjaz_conveyance_diary.sts_approval_payment_new (p_emp_search_dtls,
                                                      p_export_list_new,
                                                      p_error,
                                                      p_error_code
                                                      );
     -----------utl file start---------------------------------
     begin
     select IMD_CODE
     into v_IMD_CODE
     from CUSTOMER.BJAZ_PACKPOL_AGENT_VALIDATIONS where validation_no='conveyance_payment' AND VALIDATE_YN= 'Y';
     exception when others then
     null;
     end;


   file_name :=
      REPLACE (v_IMD_CODE||sysdate|| '.csv',' ', '');
      
       BEGIN
      ft := UTL_FILE.fopen ('UTL_PATH_C', file_name, 'w');
      UTL_FILE.put_line
         (ft,
            '"Payment Indicator","Pay Ref","Date","Invoice Number","INDICATOR","Base Amt","TDS Rate","TDS ADV","Bene Add 1","Bene Add 2","Bene Add 3","AMT","Pay details","Print Location","Pay Location","Pay details 2","Payment Type","Processing Mode","Chq No","IFCS CODE","Account Number"');

      IF p_export_list_new.COUNT > 0 THEN

         FOR v IN p_export_list_new.FIRST .. p_export_list_new.LAST LOOP
            UTL_FILE.put_line (ft,
                               REPLACE (p_export_list_new (v).stringval1, ',', ' ')----Payment Indicator
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval2, ',', ' ')---Pay Ref
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval6, ',', ' ')---------date
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval40, ',', ' ')--INVOICE NO
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval12, ',', ' ')---------INDICATOR
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval27, ',', ' ')---Base Amt (Exclu Ser Tax)
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval28, ',', ' ')--TDS Rate
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval29, ',', ' ')--TDS /ADV
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval33, ',', ' ')----Bene Add 1
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval19, ',', ' ')--Bene Add 2
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval20, ',', ' ')----Bene Add 3
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval8, ',', ' ')---AMT
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval21, ',', ' ')---Pay details
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval22, ',', ' ')---Print Location
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval23, ',', ' ')--Pay Location
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval24, ',', ' ')---Pay details 2
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval25, ',', ' ')---Payment Type
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval26, ',', ' ')---Processing Mode
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval31, ',', ' ')--- Chq No.
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval13, ',', ' ')---IFCS CODE
                               || ','
                               || ''
                               || REPLACE (p_export_list_new (v).stringval11, ',', ' ')--- Account Number
                               );


         END LOOP;

         UTL_FILE.fclose (ft);
END IF;
END;
     blob_insert (file_name);

 BEGIN
      BEGIN

      SELECT ip_no, port_no, p_dir, username, user_password,
             ftp_path
        INTO v_ip_no, v_port_no, v_p_dir, v_username, v_user_password,
             v_ftp_path
        FROM bjaz_ftp_ri_reports
       WHERE source_name = 'HDFC_FPT';
   EXCEPTION
      WHEN OTHERS
      THEN
         v_ip_no := '';
         v_port_no := '';
         v_p_dir := '';
         v_username := '';
         v_user_password := '';
         v_ftp_path := '';

   END;

   l_conn :=
       bjaz_ftp_utils.login (v_ip_no, v_port_no, v_username, v_user_password);
   bjaz_ftp_utils.ASCII (p_conn => l_conn);
   bjaz_ftp_utils.put (p_conn           => l_conn,
                        p_from_dir       => v_ftp_path,
                        p_from_file      => file_name,
                        p_to_file        => v_p_dir || file_name
                       );
   bjaz_ftp_utils.LOGOUT (l_conn);

----------------------------------------------------


select * from EmployeeUKA;
select * from EmployeeUSAA;


EMPLOYEEID
1      1
1      1
1      2
2      2
2      3
3      4
4      5
5      6
NULL   NULL
NULL   NULL
       NULL

-------inner join---------------------------
select * 
from EmployeeUKA a inner join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID;
  
select *
from EmployeeUKA a , EmployeeUSAA b
where a.EMPLOYEEID=b.EMPLOYEEID
 
-------left join---------------------------
select * 
from EmployeeUKA a left join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID;

select * 
from EmployeeUKA, EmployeeUSAA
where EmployeeUKA.EMPLOYEEID=EmployeeUSAA.EMPLOYEEID(+)
------right join------------------

select * 
from EmployeeUKA a right join EmployeeUSAA b
on a.EMPLOYEEID= b.EMPLOYEEID;

select *
from EmployeeUKA a, EmployeeUSAA b
where a.EMPLOYEEID(+)=b.EMPLOYEEID;

------full outer join----------
select * 
from EmployeeUKA a full outer join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

----natural join----------

select *
from EmployeeUKA a natural join EmployeeUSAA b;


----cross join-------
select * 
from EmployeeUKA a cross join EmployeeUSAA b;



-----highest salary---
-------3 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                              from table_3 
                               order by sal desc)
                      where rownum <=3);

-------2 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                             from table_3 
                             order by sal desc)
                      where rownum <=2);
--------------------                   
select max(sal) from 
table_3
where sal  not in (select max(sal)
                   from table_3)
               
------------------------    
-----------day 2---------
create table table_5(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
insert into EmployeeUKA (EMPLOYEEID,c_name) 
values (4,null);
 
create table EmployeeUSAA(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
 

select * from EmployeeUKA for update;
select * from EmployeeUSAA for update;
select * from table_3 for update;
select * from table_4 for update;
select * from table_5 for update;
alter table table_5 add  dept varchar2(20);


select * 
from EmployeeUKA a inner join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUKA a right join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUSAA a left join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select *
from EmployeeUKA a full outer join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUKA a natural join EmployeeUSAA b

select * 
from EmployeeUKA a cross join EmployeeUSAA b 


select min(sal) from  (select sal from (select sal
                                        from table_3
                                        order by sal desc)
                       where rownum<=3);
----delete
select * from table_4 a where rowid not in (select max(rowid) from table_4 a
group by a.EMPLOYEEID,a.c_name,a.sal)


select * from table_4 a where rowid > (select min(rowid) from table_4 b
where a.EMPLOYEEID=b.EMPLOYEEID and a.c_name=b.c_name and a.sal=b.sal)

select * from table_5
select instr(C_NAME,'a',1,3) from table_5

select substr(C_NAME,1,3) from table_5


select instr('sudhanshussss','s',2,5) from dual



---max sal in each dept
select * from  table_5 a inner join(select dept,max(sal) sal
                                    from table_5 n
                                    group by dept) b
                                    
        on a.sal= b.sal
        and a.dept=b.dept;
-----------------
                                  
--2nd mthod                       
select * from table_5 where sal in (select max(sal)
from table_5
group by dept)

delete from EmployeeUKA where rowid not in (sel max(rowid)
                                        from EmployeeUKA
                                        group by sal,dept)

---co-related subquery
select * from table_5 a
where 1 <=(select count(sal)
           from table_5 b
           where a.EMPLOYEEID=b.EMPLOYEEID)
           
 create or replace function function_11 (age number)
 return number
 is 
 no_of_days number;
 v_sal     number;
 begin
   select sal
   into v_sal
   from table_5;
   
   no_of_days:=v_sal*age*365;
   return no_of_days;
 exception
   when others then
    null;
 end;
   
 select (to_date('14-aug-2023')-to_date('26-nov-2021'))/30 from dual
 select add_
 
 select (0.715068*365)/30 from dual
 
 select function_11(10) from dual
 
 --nested table
declare
type emp_name_list_type  is table of varchar2(20);
lv_emp_name_list  emp_name_list_type:=emp_name_list_type();
begin
  
lv_emp_name_list.extend(2);

lv_emp_name_list(1):='rahul';
dbms_output.put_line (lv_emp_name_list(1));
end;


select to_date('31-jul-2024','DD-MON-YYYY') -TRUNC(SYSDATE-1)FROM DUAL





CREATE TABLE EmployeeUK
(
  EmployeeId INT,
  FirstName VARCHAR(20),
  LastName VARCHAR(20),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUK VALUES(1, 'Pranaya', 'Rout', 'Male','IT');
INSERT INTO EmployeeUK VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUK VALUES(3, 'Preety', 'Tiwary', 'Female','HR');
INSERT INTO EmployeeUK VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUK VALUES(5, 'Anurag', 'Mohanty', 'Male','IT');
INSERT INTO EmployeeUK VALUES(6, 'Rajesh', 'Pradhan', 'Male','HR');
INSERT INTO EmployeeUK VALUES(7, 'Hina', 'Sharma', 'Female','IT');

CREATE TABLE EmployeeUSA
(
  EmployeeId INT,
  FirstName VARCHAR(20),
  LastName VARCHAR(20),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUSA VALUES(1, 'James', 'Pattrick', 'Male','IT');
INSERT INTO EmployeeUSA VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUSA VALUES(3, 'Sara', 'Taylor', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(5, 'Sushanta', 'Jena', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(6, 'Mahesh', 'Sindhey', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(7, 'Hina', 'Sharma', 'Female','IT');

-----------------------------------------------------------------------------------
CREATE TABLE EmployeeUKA
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO EmployeeUKA VALUES(1, 'Pranaya');
INSERT INTO EmployeeUKA VALUES(2, 'Priyanka');
INSERT INTO EmployeeUKA VALUES(3, 'Preety');
INSERT INTO EmployeeUKA VALUES(4, 'Subrat');
INSERT INTO EmployeeUKA VALUES(5, 'Anurag');
INSERT INTO EmployeeUKA VALUES(6, 'Rajesh');
INSERT INTO EmployeeUKA VALUES(7, 'Hina');

CREATE TABLE EmployeeUSAA
(
  EmployeeId NUMBER,
  FirstName VARCHAR(20)
);

INSERT INTO EmployeeUSAA VALUES(1, 'James');
INSERT INTO EmployeeUSAA VALUES(2, 'Priyanka');
INSERT INTO EmployeeUSAA VALUES(3, 'Sara');
INSERT INTO EmployeeUSAA VALUES(4, 'Subrat');
INSERT INTO EmployeeUSAA VALUES(5, 'Sushanta');
INSERT INTO EmployeeUSAA VALUES(6, 'Mahesh');
INSERT INTO EmployeeUSAA VALUES(7, 'Hina');
--------------------------------------------------------------------------------------

select * from EmployeeUKA for update;
delete from  EmployeeUKA where  EMPLOYEEID is null
select * from EmployeeUSAA;


EMPLOYEEID
1   1
1   1
1   2 
2   2
2   3
3   4
4   5
5   6
null null
null null
null

1)
SELECT EMPLOYEEID FROM EmployeeUKA
union
SELECT EMPLOYEEID FROM EmployeeUSAA;---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
                                       --here only in set operator null is equal to anoter null)
2)
SELECT EMPLOYEEID FROM EmployeeUKA
union all
SELECT EMPLOYEEID FROM EmployeeUSAA;--two table combined

3)
SELECT EMPLOYEEID FROM EmployeeUKA
intersect
SELECT EMPLOYEEID FROM EmployeeUSAA;---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
4.1) 
SELECT EMPLOYEEID FROM EmployeeUKA
minus
SELECT EMPLOYEEID FROM EmployeeUSAA;--a-b ---first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )
4.2)
SELECT EMPLOYEEID FROM EmployeeUSAA
minus
SELECT EMPLOYEEID FROM EmployeeUKA;--b-a  first find distinct then common from both table(null value is also distinct means inf there are
                                       -- more then 1 null then considered only one null value )




----------------------------------------------------


select * from EmployeeUKA;
select * from EmployeeUSAA;


EMPLOYEEID
1      1
1      1
1      2
2      2
2      3
3      4
4      5
5      6
NULL   NULL
NULL   NULL
       NULL

-------inner join---------------------------
select * 
from EmployeeUKA a inner join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID;
  
select *
from EmployeeUKA a , EmployeeUSAA b
where a.EMPLOYEEID=b.EMPLOYEEID
 
-------left join---------------------------
select * 
from EmployeeUKA a left join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID;

select * 
from EmployeeUKA, EmployeeUSAA
where EmployeeUKA.EMPLOYEEID=EmployeeUSAA.EMPLOYEEID(+)
------right join------------------

select * 
from EmployeeUKA a right join EmployeeUSAA b
on a.EMPLOYEEID= b.EMPLOYEEID;

select *
from EmployeeUKA a, EmployeeUSAA b
where a.EMPLOYEEID(+)=b.EMPLOYEEID;

------full outer join----------
select * 
from EmployeeUKA a full outer join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

----natural join----------

select *
from EmployeeUKA a natural join EmployeeUSAA b;


----cross join-------
select * 
from EmployeeUKA a cross join EmployeeUSAA b;



-----highest salary---
-------3 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                              from table_3 
                               order by sal desc)
                      where rownum <=3);

-------2 rd highest---

select min(sal) from (select sal 
                      from  (select sal 
                             from table_3 
                             order by sal desc)
                      where rownum <=2);
--------------------                   
select max(sal) from 
table_3
where sal  not in (select max(sal)
                   from table_3)
               
------------------------    
-----------day 2---------
create table table_5(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
insert into EmployeeUKA (EMPLOYEEID,c_name) 
values (4,null);
 
create table EmployeeUSAA(EMPLOYEEID number(20),
                    c_name varchar2(20)
                    );
 

select * from EmployeeUKA for update;
select * from EmployeeUSAA for update;
select * from table_3 for update;
select * from table_4 for update;
select * from table_5 for update;
alter table table_5 add  dept varchar2(20);


select * 
from EmployeeUKA a inner join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUKA a right join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUSAA a left join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select *
from EmployeeUKA a full outer join EmployeeUSAA b
on a.EMPLOYEEID=b.EMPLOYEEID

select * 
from EmployeeUKA a natural join EmployeeUSAA b

select * 
from EmployeeUKA a cross join EmployeeUSAA b 


select min(sal) from  (select sal from (select sal
                                        from table_3
                                        order by sal desc)
                       where rownum<=3);
----delete
select * from table_4 a where rowid not in (select max(rowid) from table_4 a
group by a.EMPLOYEEID,a.c_name,a.sal)


select * from table_4 a where rowid > (select min(rowid) from table_4 b
where a.EMPLOYEEID=b.EMPLOYEEID and a.c_name=b.c_name and a.sal=b.sal)

select * from table_5
select instr(C_NAME,'a',1,3) from table_5

select substr(C_NAME,1,3) from table_5


select instr('sudhanshussss','s',2,5) from dual



---max sal in each dept
select * from  table_5 a inner join(select dept,max(sal) sal
                                    from table_5 n
                                    group by dept) b
                                    
        on a.sal= b.sal
        and a.dept=b.dept;
-----------------
                                  
--2nd mthod                       
select * from table_5 where sal in (select max(sal)
from table_5
group by dept)

delete from EmployeeUKA where rowid not in (sel max(rowid)
                                        from EmployeeUKA
                                        group by sal,dept)

---co-related subquery
select * from table_5 a
where 1 <=(select count(sal)
           from table_5 b
           where a.EMPLOYEEID=b.EMPLOYEEID)
           
 create or replace function function_11 (age number)
 return number
 is 
 no_of_days number;
 v_sal     number;
 begin
   select sal
   into v_sal
   from table_5;
   
   no_of_days:=v_sal*age*365;
   return no_of_days;
 exception
   when others then
    null;
 end;
   
 select (to_date('14-aug-2023')-to_date('26-nov-2021'))/30 from dual
 select add_
 
 select (0.715068*365)/30 from dual
 
 select function_11(10) from dual
 
 --nested table
declare
type emp_name_list_type  is table of varchar2(20);
lv_emp_name_list  emp_name_list_type:=emp_name_list_type();
begin
  
lv_emp_name_list.extend(2);

lv_emp_name_list(1):='rahul';
dbms_output.put_line (lv_emp_name_list(1));
end;


select to_date('31-jul-2024','DD-MON-YYYY') -TRUNC(SYSDATE-1)FROM DUAL

