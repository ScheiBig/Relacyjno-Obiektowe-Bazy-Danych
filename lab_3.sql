-- Każdy z wyzwalaczy sprawdzamy czy działa po czym wyłączamy go przed realizacją
-- następnego zadnia. Wyzwalacze mają być typu FOR EACH ROW.

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
create or replace procedure drop_view_if_exists (
	table_name in varchar2
) is
  view_does_not_exist exception;
  pragma exception_init(view_does_not_exist, -942);
 begin
	execute immediate 'drop view ' || table_name;
	dbms_output.put_line(
		'View ['
		|| table_name
		||   '] dropped'
	);
exception
	when view_does_not_exist
	then
		dbms_output.put_line(
			'View ['
			|| table_name
			||   '] does not exist: no need to drop'
		);
end;
/

execute drop_table_if_exists( 'employees' );
create table employees as select * from HR.employees;

execute drop_table_if_exists( 'departments' );
create table departments as select * from HR.departments;


--  1. Zdefiniować wyzwalacz na tabeli EMPLOYEES, który przy wstawieniu
--     lub modyfikowaniu danych pole LAST_NAME i FIRST_NAME będzie zamieniane
--     na duże litery.

create or replace trigger trig_zad_1
	before insert or update
	on Employees
	for each row
begin
	:new.first_name := upper( :new.first_name );
	:new.last_name := upper( :new.last_name );
end;
/

commit; set transaction name 'test__trig_zad_1';
	insert into Employees (
		first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		'jACEK'
		, 'pLaCeK'
		, 'jacek.placek@firma.com'
		, ( select sysdate from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
rollback;
alter trigger trig_zad_1 disable;


--  2. Zdefiniować wyzwalacz na tabeli EMPLOYEES, który z wykorzystaniem
--     sekwencji wcześniej utworzonej będzie numerował EMPLOYEE_ID tabeli
--     od wartości 210 i do wartości maksymalnie 999999.

create sequence seq_zad_2
	increment by 1
	start with 210
	maxvalue 999999
;
create or replace trigger trig_zad_2
	before insert
	on Employees
	for each row
begin
	:new.employee_id := seq_zad_2.nextval;
end;
/

commit; set transaction name 'test__trig_zad_2';
	insert into Employees (
		first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		'Jacek'
		, 'Pankracek'
		, 'jacek.pankracek@firma.com'
		, ( select sysdate from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
rollback;
alter trigger trig_zad_2 disable;


--  3. Zdefiniować wyzwalacz na tabeli EMPLOYEES, który sprawdzi czy pole
--     HIRE_DATE jest mniejsze lub równe dacie systemowej +-10 dni przy
--     wstawianiu nowego pracownika lub jego modyfikacji. Jeśli nie, zwrócony
--     zostanie komunikat o błędzie a transakcja zostanie wycofana.

create or replace trigger trig_zad_3
	before insert or update
	on Employees
	for each row
begin
	if :new.hire_date not between ( sysdate - 10 ) and (sysdate + 10)
	then
		raise_application_error( -20001,
			'Data zatrudnienia '
			|| :new.hire_date
			|| ' poza zakresem '
			|| ( sysdate - 10 )
			|| ' do '
			|| ( sysdate + 10 )
		);
		rollback;
	end if;
end;
/

commit; set transaction name 'test__trig_zad_3';
	insert into Employees (
		first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		'Jacek'
		, 'Gacek'
		, 'jacek.gacek@firma.com'
		, ( select sysdate - 20 from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
rollback;
alter trigger trig_zad_3 disable;


--  4. Zdefiniować wyzwalacz na tabeli EMPLOYEES, który wyświetli komunikat
--     na ekranie jaki użytkownik został skasowany, wstawiony lub zmodyfikowany.

create or replace trigger trig_zad_4
	after insert or update or delete
	on Employees
	for each row
begin
	if inserting
	then
		dbms_output.put_line(
			'Wstawiono rekord z ID <<' || :new.employee_id || '>>'
		);
	elsif updating
	then
		dbms_output.put_line(
			'Zamieniono rekord z ID <<' || :old.employee_id || '>>'
		);
	else
		dbms_output.put_line(
			'Usunięto rekord z ID <<' || :old.employee_id || '>>'
		);
	end if;
end;
/

commit; set transaction name 'test__trig_zad_4';
	insert into Employees (
		employee_id
		, first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		1337
		, 'Jacek'
		, 'Płaczek'
		, 'jacek.placzek@firma.com'
		, ( select sysdate - 20 from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
rollback;
alter trigger trig_zad_4 disable;


--  5. Zdefiniować wyzwalcz na tabeli EMPLOYEES, który przy kasowaniu
--     lub modyfikowaniu pracownika zapisze wszystkie dane do tabeli EMP_HIST
--     z dodatkowymi polami tj. data_czas_operacji oraz typ_operacji
--     (DELETE, UPDATE) - wcześniej trzeba przygotować daną tabelę.

execute drop_table_if_exists( 'Emp_Hist' );
create table Emp_Hist
as select
	'INSERT' as op_type
	, to_char( sysdate, 'yyyy-mm-dd hh24:mi:ss' ) as op_date
	, t.*
from Employees t
fetch first 1 rows only
;
truncate table Emp_Hist;
	
create or replace trigger trig_zad_5
	after insert or update or delete
	on Employees
	for each row
declare
	op varchar2(6);
begin
	if inserting
	then
		op := 'INSERT';
	elsif updating
	then
		op := 'UPDATE';
	else
		op := 'DELETE';
	end if;

	insert into Emp_Hist
	values (
		op
		, to_char( sysdate, 'yyyy-mm-dd hh24:mi:ss' )
		, :new.employee_id
		, :new.first_name
		, :new.last_name
		, :new.email
		, :new.phone_number
		, :new.hire_date
		, :new.job_id
		, :new.salary
		, :new.commission_pct
		, :new.manager_id
		, :new.department_id
	);

end;
/

commit; set transaction name 'test__trig_zad_5';
	insert into Employees (
		employee_id
		, first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		1337
		, 'Jacek'
		, 'Raczek'
		, 'jacek.raczek@firma.com'
		, ( select sysdate - 20 from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
	select * from Emp_Hist;
rollback;
alter trigger trig_zad_5 disable;


--  6. Zdefiniować widok na tabeli EMPLOYEES i DEPARTMENTS. Na widoku
--     zdefiniować wyzwalacz typu INSTEAD OF, który przy poleceniu INSERT
--     na widoku doda użytkownika, który nie będzie miał przypisanego żadnego
--     departamentu.

execute drop_view_if_exists( 'v_Emp_Dept' );
create view v_Emp_Dept
as select
	employee_id
	, first_name
	, last_name
	, email
	, phone_number
	, hire_date
	, job_id
	, salary
	, commission_pct
	, e.manager_id
	, department_id
	, department_name
	, d.manager_id as director_id
	, location_id
from Employees e
left join Departments d
	using ( department_id )
;

create or replace trigger trig_zad_6
	instead of insert
	on v_Emp_Dept
	for each row
begin
	insert into Employees
	values (
		:new.employee_id
		, :new.first_name
		, :new.last_name
		, :new.email
		, :new.phone_number
		, :new.hire_date
		, :new.job_id
		, :new.salary
		, :new.commission_pct
		, :new.manager_id
		, null
	);
end;
/

commit; set transaction name 'test__trig_zad_6';
	insert into v_Emp_Dept (
		employee_id
		, first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		1337
		, 'Jacek'
		, 'Nieboraczek'
		, 'jacek.nieboraczek@firma.com'
		, ( select sysdate - 20 from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
	select * from v_Emp_Dept;
rollback;
alter trigger trig_zad_6 disable;


--  7. Zdefiniować wyzwalacz, który reaguje na pensję mniejszą od zera
--     i wtedy zmienia jej wartość na 0.

create or replace trigger trig_zad_7
	before insert or update
	on Employees
	for each row
begin
	if :new.salary < 0 or :new.salary is null
	then
		:new.salary := 0;
	end if;
end;
/

commit; set transaction name 'test__trig_zad_7';
	insert into Employees (
		employee_id
		, first_name
		, last_name
		, email
		, hire_date
		, job_id
	) values (
		1337
		, 'Jacek'
		, 'Płaczek'
		, 'jacek.Płaczek@firma.com'
		, ( select sysdate - 20 from dual )
		, 'ST_CLERK'
	);
	select *
	from Employees
	order by employee_id desc
	fetch first 1 rows only
	;
rollback;
alter trigger trig_zad_7 disable;


--  8. Zdefiniować wyzwalacz na tabeli DEPARTMENTS, która zadziała
--     przy modyfikacji pola DEPTARTMENT_ID i jednocześnie zaktualizuje numer
--     departamnetu wszystkim pracownikom pracującym w tym departamencie
--     w tabeli EMPLOYEES (tzw. kaskadowa aktualizacja - ON CASCADE UPDATE
--     dla systemu MS SQL SERVER).

create or replace trigger trig_zad_8
	before update
	on Departments
	for each row
begin
	if :new.department_id != :old.department_id
	then
		update Employees
		set department_id = :new.department_id
		where department_id = :old.department_id
		;
	end if;
end;
/

commit; set transaction name 'test__trig_zad_8';
	select *
	from Employees
	where last_name = 'Gietz'
	;
	declare
		id number(6,0);
	begin
		select department_id
		into id
		from Employees
		where last_name = 'Gietz'
		;
		update Departments
		set department_id = 420
		where department_id = id
		;
	end;
	/
	select *
	from Employees
	where last_name = 'Gietz'
	;
rollback;
alter trigger trig_zad_8 disable;


--  9. Zdefiniować wyzwalacz, który zapewni, że żaden pracownik nie otrzyma
--     podwyżki większej niż 10%. Dodatkowo zmiana taka ma być zarejestrowana
--     w bazie danych w tabeli REJESTR_ZMIAN z polami (Nazwisko_pracownika,
--     data, pensja_stara, pensja_nowa, akcja). Akcja podaje informację słowną
--     ('wstawiono_rekord' lub 'Zmodyfikowano rekord') w zależności czy
--     pracownik nowy czy już jest w bazie i jest modyfikowana jego pensja
--     (jeden wyzwalacz działa na polecenie INSERT i UPDATE na polu SALARY).
--     W przypadku głównego szefa 'PRESIDENT' ta zasada nie działa czy wyzwalacz
--     nie uruchamian się (klauzla WHEN)

execute drop_table_if_exists( 'Change_Registry' );
create table Change_Registry (
	last_name varchar2(25) not null
	, op_date varchar(20) not null
	, old_salary number(8,2)
	, new_salary number(8,2)
	, op_name varchar2(6)

	, constraint pk_Rejestr_Zmian primary key ( last_name, op_date )
);

create or replace trigger trig_zad_9
	after insert or update
	on Employees
	for each row
declare
	op varchar2(6);
begin
	if :new.salary > 1.10 * :old.salary
	then
		raise_application_error(-20001, 'Podwyżka nie może wynosić więcej niż 10%');
	end if;

	if inserting
	then
		op := 'INSERT';
	else
		op := 'UPDATE';
	end if;

	insert into Change_Registry
	values (
		:new.last_name
		, to_char( sysdate, 'yyyy-mm-dd hh24:mi:ss' )
		, :old.salary
		, :new.salary
		, op
	);

end;
/


commit; set transaction name 'test__trig_zad_9';
	select *
	from Employees
	where last_name = 'Gietz'
	;
	update Employees
	set salary = 10000
	where last_name = 'Gietz'
	;
	update Employees
	set salary = 9000
	where last_name = 'Gietz'
	;
	select *
	from Employees
	where last_name = 'Gietz'
	;
	select * from Change_Registry;
rollback;
alter trigger trig_zad_9 disable;


-- 10. Mamy widok, który zawiera dane pracownika i nazwę departamentu,
--     do którego należy (z tabeli departments). Zdefiniować wyzwalacz
--     na tabeli, który sprawdzi numer departamentu i wstawi do tabeli
--     pracownicy. Jeżeli nie ma takiego numeru departamentu to wstawiamy NULL.

execute drop_view_if_exists( 'v_Emp_Dept' );
create view v_Emp_Dept
as select
	employee_id
	, first_name
	, last_name
	, email
	, phone_number
	, hire_date
	, job_id
	, salary
	, commission_pct
	, e.manager_id
	, department_name
from Employees e
left join Departments d
	using ( department_id )
;

create or replace trigger trig_zad_10
	instead of insert
	on v_Emp_Dept
	for each row
declare
	depid number(6,0) := null;
begin
	select department_id
	into depid
	from Departments
	where department_name = :new.department_name
	;

	insert into Employees
	select
		:new.employee_id
		, :new.first_name
		, :new.last_name
		, :new.email
		, :new.phone_number
		, :new.hire_date
		, :new.job_id
		, :new.salary
		, :new.commission_pct
		, :new.manager_id
		, depid
	from dual
	;
end;
/


commit; set transaction name 'test__trig_zad_10';
	insert into v_Emp_Dept ( 
		first_name
		, last_name
		, email
		, hire_date
		, job_id
		, department_name
	) values (
		'Jan'
		, 'Znaczek'
		, 'jan.znaczek@firma.com'
		, sysdate
		, 'IT_PROG'
		, 'IT Support'
	);
	select * 
	from v_Emp_Dept
	order by hire_date desc
	fetch first 1 rows only
	;
rollback;
alter trigger trig_zad_10 disable;


-- 11. Zdefiniuj wyzwalacz na tabeli Departments, który wstawi rejestr
--     wszystkich nazw departamnetu, które są dokładane do tabeli DEPARTMENTS
--     nawet te, które nie dodano ze względu na wycofanie transakcji poleceniem
--     ROLLBACK. Tabela REJESTR_DEPT z polami Nazwa_departamentu oraz
--     Data_wstawienia) (wykorzystaj transakcje autonomiczne
--     PRAGMA AUTONOMOUS_TRANSACTION)

execute drop_table_if_exists( 'Dept_Registry' );
create table Dept_Registry (
	department_name varchar2(30) not null
	, entry_date date not null

	, constraint pk_Dept_Registry primary key ( department_name, entry_date )
);

create or replace trigger trig_zad_11
	before insert
	on Departments
	for each row
declare
	pragma autonomous_transaction;
begin
	insert into Dept_Registry
	values (
		:new.department_name
		, sysdate
	);
	commit;
end;
/


commit; set transaction name 'test__trig_zad_11';
	insert into Departments ( 
		department_name
	) values (
		'Figma Corps.'
	);
	select * from Departments;
	select * from Dept_Registry;
rollback;
alter trigger trig_zad_11 disable;


-- 12. Zdefiniuj wyzwalacz, który sprawdzi czy dana nazwa departamentu
--     nie powtarza się w bazie danych (nie używamy ograniczenia UNIQUE).
--     Jeśli tak to definiujemy wyjątek, który przekazujemy do bloku instrukcji
--     nadrzędnego, w którym wstawiany jest dany departament i tutaj obsługujemy
--     dany błąd łącznie z wycofaniem transakcji.

create or replace trigger trig_zad_12
	before insert or update
	on Departments
	for each row
declare
	Dept_Name_Duplicate exception;
	pragma exception_init( Dept_Name_Duplicate, -20042 );
	has_dups number;
begin
	select count( * )
	into has_dups
	from Departments
	where department_name = :new.department_name
	;

	if has_dups > 0
	then
		raise Dept_Name_Duplicate;
	end if; 
end;
/


commit; set transaction name 'test__trig_zad_12';
	
	declare
		Dept_Name_Duplicate exception;
		pragma exception_init( Dept_Name_Duplicate, -20042 );
	begin
		insert into Departments ( 
			department_name
		) values (
			'IT Support'
		);
	exception
		when Dept_Name_Duplicate
		then
			dbms_output.put_line( 'Nazwa departamentu już jest w użyciu' );
			rollback;
	end;
	/
rollback;
alter trigger trig_zad_12 disable;
