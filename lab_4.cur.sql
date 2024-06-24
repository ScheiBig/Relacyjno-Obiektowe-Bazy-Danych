-- Przykład 1:
---------------------
set serveroutput on;
declare
cursor kur1 is select sal
from emp order by 1;
zm emp.sal%type;
begin
	open kur1;
		loop
			fetch kur1 into zm;
			exit when kur1%notfound;
			dbms_output.put_line(zm);
		end loop;
	close kur1;
end;
/

-- Przykład 2:
set serveroutput on
declare
  cursor kur1(n number) is select sal from emp
where sal > n order by 1;
  zm kur1%ROWTYPE;
begin
	open kur1(2000);
		loop
		fetch kur1 into zm;
		exit when kur1%notfound;
		dbms_output.put_line(zm.sal);
		end loop;
	close kur1;
end;
/

-- Przykład 3:
-- Zadanie (samodzielna realizacja):
-- Za pomocą kursora zrealizować, by w zależności od nazwiska pracownika
-- wyświetlany był pracownik i dział w którym on pracuje (jeżeli jego nazwisko
-- jest na literę od A do G) lub samo nazwisko pracownika.

declare
	cursor emps
	is select
		last_name
		, department_name
	from Employees
	left join Departments
		using( department_id )
	;
begin
	for e in emps
	loop
		if regexp_like( e.last_name, '^[a-gA-G]' )
		then
			dbms_output.put_line(
				e.last_name
				|| ' pracujący w '
				|| coalesce( e.department_name, '~nie podano~' )
			);
		else
			dbms_output.put_line(
				e.last_name
			);
		end if;
	end loop;
end;
/

-- Przykład 4:
-- Zadanie:(samodzielna realizacja):
-- Za pomocą kursora policzyć sumaryczną wartość pensji pracowników
-- (bez prowizji i z prowizją).

declare
	cursor emps
	is select
		salary
		, commission_pct
	from Employees
	;
	sal_sum number := 0;
	sal_comm_sum number := 0;
begin
	for e in emps
	loop
		sal_sum := sal_sum + coalesce( e.salary, 0 );
		sal_comm_sum := sal_comm_sum
			+ coalesce( e.salary, 0 ) * ( 1 + coalesce( e.commission_pct, 0 ));
	end loop;
	dbms_output.put_line(
		'Pensje pracowników wynoszą '
		|| sal_sum
		|| ', '
		|| sal_comm_sum
		|| ' włączając prowizje.'
	);
end;
/
