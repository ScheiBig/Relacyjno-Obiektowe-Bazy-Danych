-- Tworzenie tabel

-- create table emp
-- as select *
-- from scott.emp
-- ;

-- create table dept
-- as select *
-- from scott.dept
-- ;

-- begin
--     execute immediate 'drop table emp';
-- exception
--     when others then
--         if sqlcode != -942 then raise;
--         end if;
-- end;

-- begin
--     execute immediate 'drop table dept';
-- exception
--     when others then
--         if sqlcode != -942 then raise;
--         end if;
-- end;

------------------
-- Na zajęciach --
------------------

-- 1. Wyświetlić nazwiska pracowników oraz ich zawód:

select 
	ename
	, "JOB"
from scott.emp
;


-- 2. Wyświetlić pierwsze 3 rekordy z tabeli emp;

select *
from scott.emp
fetch first 3 rows only
;


-- 3.  Wyświetlić pierwsze uporządkowane po nazwisku 3 rekordy z tabeli emp;

select *
from (
	select *
	from scott.emp
	order by ename
)
fetch first 3 rows only
;
-- lub
select *
from scott.emp
order by ename
fetch first 3 rows only
;


-- 4.  Wybierz z tabeli emp wszystkie wzajemnie różne kombinacje numeru departamentu i stanowiska pracy:

select distinct
	deptno
	, "JOB"
from scott.emp
;


-- 5.  Wybierz nazwiska i pensje wszystkich pracowników których nazwiska zaczynają się na literę S i s oraz trzecią literę i

select
	ename
	, sal
from scott.emp
where lower( ename ) like 's_i%'
;
-- lub
select
	ename
	, sal
from scott.emp
where regexp_like( ename, '[sS].[iI].*' )
;


-- 6.  Wybierz nazwiska i wartości zarobków wszystkich pracowników łącznie z obliczeniem prowizji od początku roku (POLE COMM)

select
	ename
	, ( sal + coalesce( comm, 0 ) )
from scott.emp
;


-- 7. Podaj datę zegara systemowego

select 
	to_char( sysdate, 'yyyy-mm-dd hh24:mi:ss' )
	, to_char( sysdate, 'day, dd month yyyy hh24:mi:ss' )
from dual
;


-- 8. Do daty zegara systemowego dodaj 3 dni

select 
	to_char( dt, 'yyyy-mm-dd hh24:mi:ss' )
from (
	select sysdate + 3 as dt
	from dual
)
;


-- 9. Do daty zegara systemowego dodaj 3 godziny

select 
	to_char( dt, 'yyyy-mm-dd hh24:mi:ss' )
from (
	select sysdate + 3 / 24 as dt
	from dual
)
;


-- 10. Ile dni upłynęło od Twoich narodzin?

select 
	floor( sysdate - date'1996-06-18' )
	, round( sysdate - date'1996-06-18', 0 )
from dual
;


-- 11. Ile dni pozostało do Twoich urodzin?

select 
	floor( date'2024-06-18' - sysdate )
	, round( date'2024-06-18' - sysdate, 0 )
from dual
;


------------
-- W domu --
------------

-- 1. Wykorzystaj składnię CASE to określenia jak wysoką mamy pensję
--    - sal < 1000 to mamy wyświetlany napis 'Niska pensja'
--    - sal between 1000 and 2000 to mamy wyświetlany napis 'Średnia pensja'
--    - sal >2000 to mamy wyświetlany napis 'Wysoka pensja'
--    - w innym przypadku mamy wyświetlany napis 'brak wartości'

select
	ename
	, case
		when sal < 1000 
			then 'Niska pensja'
		when sal between 1000 and 2000 
			then 'Srednia pensja'
		when sal > 2000 
			then 'Wysoka pensja'
		else 'Brak wartosci'
	end as "wysokosc pensji"
from scott.emp
;


-- 2. Wykorzystaj funkcję NVL, NVL2, COALESCE, DECODE do zamiany wartości NULL na 
--    wartość 0 w przypadku wyświetlenia kolumny COMM w tabeli EMP.
--    Przykład z wykorzystaniem składni CASE ma postać:
--        select ename ,sal, 
--        case when comm is null then 0 
--        else comm end as Dodatek 
--        from emp;

select
	ename
	, sal
	, nvl( comm, 0 )
	, nvl2( comm, comm, 0)
	, coalesce( comm, 0 )
	, decode( comm, null, 0, comm )
from scott.emp
;


-- 3. Wyświetl wynik zapytania, gdzie wartości NULL będą na końcu lub początku zestawu wyników.
--        select * from emp order by comm nulls first; --nulls last (standardowo)

-- na początku
select *
from scott.emp
order by comm nulls first
;
-- na końcu
select *
from scott.emp
order by comm nulls last
;


-- 4. Podaj nazwę zalogowanego użytkownika oraz jego id (funkcja USER, UID)
--    Wyświetl aktualna datę w formacie np.: 01-04-2018 13:35:29 

select
	user
	, uid
	, to_char( current_date, 'yyyy-mm-dd hh24:mi:ss' )
from dual
;


-- 5. Zamień ciąg znaków na format daty np. '01-30-2017' (do wykorzystania podczas wstawia danych 
--    do pola typu Date)

select
	to_date( '2017-01-30', 'yyyy-mm-dd' )
from dual
;
-- lub gdy wpisujemy stałą datę
select
	date'2017-01-30'
from dual
;


-- 6. Ile pełnych miesięcy upłynęło w okresie od pierwszej zatrudnionej osoby do ostatniej 
--    zatrudnionej osoby (MONTHS_BETWEEN) – podaj w pełnych miesiącach?

select
	floor( months_between( max( hiredate ), min( hiredate ) ))
from scott.emp
;


-- 7. Jaki jest data ostatniego dnia danego miesiąca 

select
	last_day( current_date )
from dual
;


-- 8. Ile dni ma luty w 2020 roku?

select
	to_char( last_day( date'2020-02-01' ), 'dd' )
from dual
;
-- lub
select
	extract( day from last_day( date'2020-02-01' ) )
from dual
;



-- 9. Zaokrąglij datę, która przypada za 50 miesięcy do pierwszego stycznia danego roku

select
	round( add_months( timestamp'2024-01-01 01:23:45', 50 ) )
from dual
;


-- 10. W jakim dniu tygodnia jest Sylwester tego roku (dzień tygodnia ma być w języku polskim)
--     wykorzystaj polecenie - alter session set nls_language

alter session set nls_language= Polish;
select
	to_char( date'2024-12-31', 'day' )
from dual
;
alter session set nls_language= English;


-- 11. Dodaj 3 miesiące do bieżącej daty

select
	add_months( current_date, 3 )
from dual
;


-- 12. Do aktualnej daty dodaj 3 dni i odejmij 1 godzinę.

select
	to_char( current_timestamp + 3 - 1/24, 'yyyy-mm-dd hh24:mi:ss')
from dual
;


-- 13. Obliczyć średni zarobek w firmie (zaokrąglij ROUND oraz utnij TRUNC do dwóch miejsc po 
--     przecinku). Wykorzystaj funkcję to_char do przedstawienia w postaci wartości znakowej, gdzie 
--     mamy dwa miejsca po przecinku (czy działa zaokrąglanie)

select
	to_char( round( avg( sal ), 2 ))
	, to_char( trunc( avg( sal ), 2 ))
from scott.emp
;


-- 14. Znaleźć minimalny zarobek na stanowisku 'MANAGER'.

select
	min( sal )
from scott.emp
where "JOB" = 'MANAGER'
;


-- 15. Znaleźć, ilu pracowników pracuje w departamencie ACCOUNTING.

select
	count( * )
from scott.emp
where deptno = (
	select deptno
	from scott.dept
	where dname = 'ACCOUNTING'
)
;


-- 16. Znaleźć, ile pracowników zostało zatrudnionych, w każdym roku i miesiącu, w którym 
--     funkcjonowała firma (wykorzystać operator ROLLUP i CUBE i za pomocą operatorów zbiorów 
--     UNION ALL, UNION, INTERSECT, MINUS zobaczyć czym różnią się dane wyniki zapytań).

select
	extract( year from hiredate )
	, extract( month from hiredate )
	, count( * )
from scott.emp
group by rollup (
	extract( year from hiredate )
	, extract( month from hiredate )
)
;
select
	extract( year from hiredate )
	, extract( month from hiredate )
	, count( * )
from scott.emp
group by cube (
	extract( year from hiredate )
	, extract( month from hiredate )
)
;


-- 17. Znaleźć, ile pracowników zostało zatrudnionych, w każdym roku i miesiącu, w którym 
--     funkcjonowała firma. Z tym że poziomo podajemy kolejne miesiące, a pionowo w pierwszej 
--     kolumnie lata (DECODE).

with hires as ( 
	select
		extract( year from hiredate ) "year"
		, extract( month from hiredate ) "month"
		, count( * ) "count"
	from scott.emp
	group by
		extract( year from hiredate )
		, extract( month from hiredate )
	order by
		"year"
		, "month"
)
select 
	"year" "<year>"
	, sum( decode( "month", 1, "count" )) jan
	, sum( decode( "month", 2, "count" )) feb
	, sum( decode( "month", 3, "count" )) mar
	, sum( decode( "month", 4, "count" )) apr
	, sum( decode( "month", 5, "count" )) may
	, sum( decode( "month", 6, "count" )) jun
	, sum( decode( "month", 7, "count" )) jul
	, sum( decode( "month", 8, "count" )) aug
	, sum( decode( "month", 9, "count" )) sep
	, sum( decode( "month", 10, "count" )) oct
	, sum( decode( "month", 11, "count" )) nov
	, sum( decode( "month", 12, "count" )) dec
from hires
group by "year"
;


-- 18. Obliczyć średnie zarobki w każdym departamencie (podajemy pełną nazwę departamentu) 
--     wykorzystaj NATURAL JOIN.

select
	dname
	, round( avg( sal ), 2 )
from scott.emp
natural join scott.dept
group by dname
;


-- 19. Wybierz stanowiska pracy i maksymalne zarobki na tych stanowiskach (bez stanowiska CLERK).

select
	"JOB"
	, max( sal )
from scott.emp
where "JOB" != 'CLERK'
group by "JOB"
;


-- 20. Obliczyć minimalne pensje w każdym departamencie w podziałem na stanowiska.

select
	dname
	, "JOB"
	, min( sal )
from scott.emp
inner join scott.dept
	using( deptno )
group by
	dname
	, "JOB"
order by
	dname
	, "JOB"
;


-- 21. Obliczyć średnie zarobki w każdym departamencie.

select
	dname
	, round( avg( sal ), 2 )
from scott.emp
inner join scott.dept
	using( deptno )
group by dname
order by dname
;


-- 22. Wybrać średnie zarobki dla grup zawodowych, gdzie maksymalne zarobki są wyższe niż 2000.

select
	"JOB"
	, round( avg( sal ), 2 )
from scott.emp
inner join scott.dept
	using( deptno )
group by "JOB"
having max( sal ) > 2000
order by "JOB"
;


-- 23. Znajdź różnice między najwyższą i najniższą pensją, w każdym z departamentów.

select
	dname
	, max( sal ) - min( sal )
from scott.emp
inner join scott.dept
	using( deptno )
group by dname
order by dname
;


-- 24. Wybrać pracowników, którzy zarabiają mniej od swoich kierowników.

select
	e_w.ename
	, e_w.sal
from scott.emp e_w
inner join scott.emp e_m
	on e_w.mgr = e_m.empno
	and e_w.sal < e_m.sal
;


-- 25. Podzapytania w klauzuli FROM
--         select * from (select * from emp order by sal desc) where rownum <=3

select 
	*
from (
	select
		*
	from scott.emp
	order by sal desc
) 
where rownum <= 3
;


-- 26. Podzapytania w klauzuli SELECT
--         select ename, sal, (select max(sal) from emp) as Salary_max from emp;

select
	ename
	, sal
	, (
		select
			max( sal )
		from scott.emp
	) "salary max"
from scott.emp
;

-- 27. Znaleźć pracowników, których pensja jest wyższa niż obliczona pensja średnia.

select
	ename
	, sal
from scott.emp
where sal > (
	select 
		avg( sal )
	from scott.emp
)
;


-- 28. Znaleźć wszystkich zatrudnionych na tym samym stanowisku co SMITH.

select
	ename
	, "JOB"
from scott.emp
where "JOB" = (
	select 
		"JOB"
	from scott.emp
	where ename = 'SMITH'
)
;


-- 29. Jak sortować względem języka polskiego. - - ALTER SESSION SET NLS_SORT = Polish;

create private temporary table ora$ptt__pl_chars
as select 'Ć' letter from dual
union all select 'C' letter from dual
union all select 'B' letter from dual
union all select 'Ą' letter from dual
union all select 'A' letter from dual
;

-- domyślne sortowanie - polskie znaki po pozostałych
show parameter nls_sort; -- BINARY
select *
from ora$ptt__pl_chars
order by letter
;

-- sortowanie alfabetyczne polskie
alter session set nls_sort= Polish;
select *
from ora$ptt__pl_chars
order by letter
;

alter session set nls_sort= Binary;
commit;


-- 30. Znaleźć pracowników, których pensja jest na liście najwyższych zarobków w departamentach 
--     (wykonaj jako zapytanie z podzapytaniem nieskorelowane i skorelowane). Wykonaj przed
--     napisaniem zapytania polecenie:
--         INSERT INTO EMP (empno, ename, deptno, sal, hiredate) 
--         VALUES (101,'Łukasiński',10, 2850, to_date('01-30-2014','mm-dd-yy')); 
--         COMMIT;

insert into scott.emp (
	empno
	, ename
	, deptno
	, sal
	, hiredate
) values (
	101
	, 'Lukasinski'
	, 10
	, 2850
	, date'2014-01-30'
)
;
commit;

-- nieskorelowane
select
	dname
	, ename
	, sal
from scott.emp
natural join scott.dept
natural join (
	select
		deptno
		, max( sal ) sal
	from scott.emp
	group by deptno
)
;

-- skorelowane
with top_earners as (
	select
		deptno
		, ename
		, sal
	from scott.emp e
	where sal in (
		select
			max( sal )
		from scott.emp e_i
		where e_i.deptno = e.deptno
	)
)
select
	dname
	, ename
	, sal
from top_earners
natural join scott.dept
;

delete from scott.emp
where empno = 101
;
commit;

-- 31. Wyświetl tych pracowników, których pensja jest większa od pensji przynajmniej jednej osoby 
--     z departamentu o numerze 10 (operator ANY/SOME)

select
	ename
	, sal
	, deptno
from scott.emp
where sal > any (
	select sal
	from scott.emp
	where deptno = 10
)
;


-- 32. Wybierzmy wszystkich pracowników, którzy zarabiają więcej niż ktokolwiek w departamencie 

select
	dname
	, ename
	, sal
from scott.emp
natural join scott.dept
natural join (
	select
		deptno
		, max( sal ) sal
	from scott.emp
	group by deptno
)
;


-- (operator ALL)

select
	d.dname
	, ename
	, sal
from scott.emp e
inner join scott.dept d
	on e.deptno = d.deptno
where sal >= all (
	select sal
	from scott.emp e_i
	where e.deptno = e_i.deptno
)
;


-- 33. Wybrać zawody, w których średnia płaca jest wyższa niż średnia płaca w zawodzie 'MANAGER'

select
	"JOB"
	, avg( sal )
from scott.emp
group by "JOB"
having avg( sal ) > (
	select
		avg( sal )
	from scott.emp
	where "JOB" = 'MANAGER'
)
;


-- 34. Wybrać stanowisko, na którym są najniższe średnie zarobki.

select
	"JOB"
	, round( avg( sal ), 2 ) "AVG SAL"
from scott.emp
group by "JOB"
order by "AVG SAL"
fetch first 1 rows only
;


-- 35. Znaleźć osoby, które zarabiają mniej niż wynosi średnia w ich zawodach:


select
	"JOB"
	, ename
	, sal
from scott.emp e
where sal < any (
	select
		avg( sal )
	from scott.emp e_i
	where e."JOB" = e_i."JOB"
)
;


-- 36. Za pomocą operatora EXIST znaleźć pracowników, którzy mają podwładnych:

select
	empno
from scott.emp e
where exists (
	select null
	from scott.emp e_i
	where e.empno = e_i.mgr
)
;



-- 37. Znaleźć departament, w którym nikt nie pracuje (wykorzystaj EXISTS, JOIN i klauzulę IN).

-- exists
select
	dname
from scott.dept d
where not exists (
	select null
	from scott.emp e
	where d.deptno = e.deptno
)
;

-- join
select
	dname
from scott.dept
natural left join scott.emp
where ename is null
;

-- exists
select
	dname
from scott.dept
where deptno not in (
	select deptno
	from scott.emp
)
;
