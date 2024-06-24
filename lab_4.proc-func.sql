set ServerOutput on;
create or replace procedure drop_table_if_exists (
	table_name in varchar2
) is
  table_does_not_exist exception;
  pragma exception_init(table_does_not_exist, -942);
 begin
	execute immediate 'drop table ' || table_name;
	dbms_output.put_line(
		'Table ['
		|| table_name
		||   '] dropped'
	);
exception
	when table_does_not_exist
	then
		dbms_output.put_line(
			'Table ['
			|| table_name
			||   '] does not exist: no need to drop'
		);
end;
/

execute drop_table_if_exists( 'Employees' );
create table Employees as select * from HR.employees;

execute drop_table_if_exists( 'Departments' );
create table Departments as select * from HR.departments;


---------------
-- PROCEDURE --
---------------

-- 1. Zdefiniuj procedurę, która wyświetli na ekranie imię, nazwisko oraz pensję
--    pracownika o identyfikatorze podanym jako pierwszy parametr. Jeżeli nie ma
--    takiego id to zwrócony zostanie informacja a braku takiego pracownika.

create or replace procedure proc_zad_1 (
	p__emp_id number
) is
	emp Employees%rowtype;
begin
	select *
	into emp
	from Employees
	where employee_id = p__emp_id
	;

	dbms_output.put_line(
		emp.first_name
		|| ' '
		|| emp.last_name
		|| ' zarabia '
		|| emp.salary
	);
exception
	when No_Data_Found
	then
		dbms_output.put_line( 'Nie ma takiego pracownika' );
end;
/

execute proc_zad_1( 111 );
execute proc_zad_1( 55 );


-- 2. Zdefiniować procedurę, która zwróci liczbę zatrudnionych wszystkich
--    pracowników.

create or replace procedure proc_zad_2 (
	p__emp_cnt out number
) is
begin
	select count( * )
	into p__emp_cnt
	from Employees
	;
end;
/

declare
	how_many_emps number;
begin
	proc_zad_2( how_many_emps );

	dbms_output.put_line(
		'W firmie pracuje '
		|| how_many_emps
		|| ' pracowników'
	);
end;
/


-- 3. Zdefiniować procedurę, która zwróci liczbę departamentów bez pracowników.

create or replace procedure proc_zad_3 (
	p__dept_cnt out number
) is
begin
	with Emp_Dep_cnt
	as (
		select
			department_id
			, count( * ) as emp_cnt
		from Employees
		group by department_id
	),
	Dep_Emp_cnt as (
		select
			department_id
			, coalesce( e.emp_cnt, 0 ) as emp_cnt
		from Departments d
		left join Emp_Dep_cnt e
			using( department_id )
	)
	select count( * )
	into p__dept_cnt
	from Dep_Emp_cnt
	where emp_cnt = 0
	;
end;
/

declare
	how_many_deps number;
begin
	proc_zad_3( how_many_deps );

	dbms_output.put_line(
		how_many_deps
		|| ' departamentów nie ma pracowników'
	);
end;
/


-- 4. Zdefiniować procedurę, która zwróci liczbę zatrudnionych w danym
--    departamencie podanym jako pierwszy parametr typu IN. Parametr drugi
--    typu OUT zwróci liczbę zatrudnionych.

create or replace procedure proc_zad_4 (
	p__dept_id number,
	p__emp_cnt out number
) is
begin
	select count( * )
	into p__emp_cnt
	from Employees
	where department_id = p__dept_id
	;
end;
/

declare
	dept_id number := 30;
	how_many_emps number;
begin
	proc_zad_4( dept_id, how_many_emps );

	dbms_output.put_line(
		'Departament z ID '
		|| dept_id
		|| ' ma '
		||  how_many_emps
		|| ' pracowników'
	);
end;
/


-- 5. Zdefiniować procedurę, która zwróci liczbę zatrudnionych w danym
--    departamencie na danym stanowisku pracy podanym odpowiednio jako pierwszy
--    i drugi parametr typu IN. Parametr trzeci typu OUT zwróci liczbę
--    zatrudnionych.

create or replace procedure proc_zad_5 (
	p__dept_id number,
	p__job_id varchar2,
	p__emp_cnt out number
) is
begin
	select count( * )
	into p__emp_cnt
	from Employees
	where department_id = p__dept_id
		and job_id = p__job_id
	;
end;
/

declare
	dept_id number := 30;
	job_id varchar2(10) := 'PU_CLERK';
	how_many_emps number;
begin
	proc_zad_5( dept_id, job_id, how_many_emps );

	dbms_output.put_line(
		'Departament z ID '
		|| dept_id
		|| ' ma '
		||  how_many_emps
		|| ' pracowników na stanowisku '
		|| job_id
	);
end;
/


-- 6. Zdefiniuj procedurę, która dla danego departamentu wyświetli wszystkie
--    nazwiska i imiona pracowników.

create or replace procedure proc_zad_6 (
	p__dept_id number
) is
	cursor emps
	is select
		first_name
		, last_name
	from Employees
	where department_id = p__dept_id
	;
begin
	for e in emps
	loop
		dbms_output.put_line(
			e.first_name
			|| ' '
			|| e.last_name
		);
	end loop;
end;
/

execute proc_zad_6( 30 );


-- 7. Zdefiniuj procedurę która jako parametr wejściowy przyjmie id managera,
--    a parametrem wyjściowym zwróci średnią zarobków osób podległych pod
--    tego managera.

create or replace procedure proc_zad_7 (
	p__mgr_id number,
	p__avg_sal out number
) is
begin
	select coalesce( avg( salary ), 0 )
	into p__avg_sal
	from Employees
	where manager_id = p__mgr_id
	;
end;
/

declare
	mgr_id number := 114;
	avg_sal number;
begin
	proc_zad_7( mgr_id, avg_sal );

	dbms_output.put_line(
		'Średnie zarobki podwładnych managera z id '
		|| mgr_id
		|| ' wynoszą '
		|| avg_sal

	);
end;
/



--------------
-- FUNCTION --
--------------

--  1. Zdefiniować funkcję, która wycina spacje na początku i końcu zmiennej
--     typu VARCHAR2 i zwraca to co zostanie.

create or replace function func_zad_1 (
	p__str varchar2
) return varchar2
is begin
	return trim( both ' ' from p__str );
end;
/

select func_zad_1( '             Hello   world!               ' )
from dual
;

--  2. Zdefiniować funkcję, która sprawdza czy dana liczba całkowita jest
--     parzysta czy nieparzysta i zwraca wartość 'Parzysta' lub 'Nieparzysta'.

create or replace function func_zad_2 (
	p__num number
) return varchar2
is begin
	if mod( p__num, 2 ) = 0
	then
		return 'Parzysta';
	else
		return 'Nieparzysta';
	end if;
end;
/

select
	func_zad_2( 123 )
	, func_zad_2( 222 )
from dual
;


--  3. Zdefiniować funkcję, która zwraca z daty podanej jako parametr wejściowy
--     dzień tygodnia w języku polskim.

create or replace function func_zad_3 (
	p__date date
) return varchar2
is begin
	return case to_char( p__date, 'D' )
		when '1'
			then 'Poniedziałek'
		when '2'
			then 'Wtorek'
		when '3'
			then 'Środa'
		when '4'
			then 'Czwartek'
		when '5'
			then 'Piątek'
		when '6'
			then 'Sobota'
		when '7'
			then 'Niedziela'
	end;
end;
/

select func_zad_3( sysdate )
from dual
;


--  4. Zdefiniować funkcję, która będzie zwracać średnią zarobków w dziale,
--     którego numer funkcja będzie przyjmować jako parametr.

create or replace function func_zad_4 (
	p__dept_id number
) return number
is
	avg_sal number;
begin
	select coalesce( avg( salary ), 0 )
	into avg_sal
	from Employees
	where department_id = p__dept_id
	;
	return avg_sal;
end;
/

select round( func_zad_4( 80 ), 2 )
from dual
;


--  5. Zdefiniować funkcję z trzema parametrami, która sprawdzi czy dane boki
--     tworzą trójąt, a jeśli tak to obliczyć jego pole.

create or replace function func_zad_5 (
	a number,
	b number,
	c number
) return number
is
	s number;
	sq number;
begin
	s := ( a + b + c ) / 2;
	sq := s * ( s - a ) * ( s - b ) * ( s - c );

	if sq > 0
	then
		return sqrt( sq );
	else
		return null;
	end if;
end;
/

select
	func_zad_5( 1, 1, 3 )
	, func_zad_5( 4, 5, 6 )
from dual;


--  6. Zdefiniować funkcję zamieniajacą wszystkie spacje podkreśleniem.

create or replace function func_zad_6 (
	p__str varchar2
) return varchar2
is begin
	return replace( p__str, ' ', '_' );
end;
/

select func_zad_6( '             Hello   world!               ' )
from dual
;


--  7. Zdefiniować funkcję do odwracania stringu.

create or replace function func_zad_7 (
	p__str varchar2
) return varchar2
is
	str varchar2(1024);
begin
	for i in reverse 1..length(p__str)
	loop
		str := str || substr( p__str, i, 1 );
	end loop;
	return str;
end;
/

select func_zad_7( 'Hello world!' )
from dual
;


--  8. Zdefiniować funckcję PESEL, która sprawdza czy liczba jest poprawnym
--     typem CHAR o określonej długości zawierający tylko cyfry od 0-9
--     (nie sprawdzamy poprawności funkcji PESEL)

create or replace function func_zad_8 (
	p__str varchar2
) return number
is begin
	if regexp_like( p__str, '^\d{11}$' )
	then
		return 1;
	else
		return 0;
	end if;
end;
/

select
	func_zad_8( 'Hello world!' )
	, func_zad_8( '12345678901' )
from dual
;

--  9. Zdefiniować funkcję, która sprawdza czy dana liczba jest liczbą pierwszą.

create or replace function func_zad_9 (
	p__num number
) return number
is begin
	for i in 2..trunc( sqrt( p__num ))
	loop
		if mod ( p__num, i ) = 0
		then
			return 0;
		end if;
	end loop;
	return 1;
end;
/

select
	func_zad_9( 42 )
	, func_zad_9( 61 )
from dual
;


-- 10. Zdefiniować funkcję do obliczenia wartości silnia z liczby całkowitej
--     (zdefiniować obsługę błędów w przypadku liczb mniejszych od 1 i takich,
--     które przekroczą zakres wykorzystywanego typu.

create or replace function func_zad_10 (
	p__num number
) return number
is
	res number := 1;
begin
	if p__num < 0 or p__num != trunc( p__num )
	then
		return null;
	end if;

	for i in 1..p__num
	loop
		res := res * i;
	end loop;
	return res;
end;
/

select
	func_zad_10( 12 )
	, func_zad_10( 61.2 )
	, func_zad_10( -11 )
from dual
;
