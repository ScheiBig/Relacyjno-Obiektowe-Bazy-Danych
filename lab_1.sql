-- Tworzenie tabel

create table emp
as select *
from scott.emp
;

create table dept
as select *
from scott.dept
;

------------------
-- Na zajęciach --
------------------

-- 1. Wyświetlić nazwiska pracowników oraz ich zawód:

select 
    ename
    , job
from emp
;


-- 2. Wyświetlić pierwsze 3 rekordy z tabeli emp;

select *
from emp
fetch first 3 rows only
;


-- 3.  Wyświetlić pierwsze uporządkowane po nazwisku 3 rekordy z tabeli emp;

select *
from (
    select *
    from emp
    order by ename
)
fetch first 3 rows only
;
-- lub
select *
from emp
order by ename
fetch first 3 rows only
;


-- 4.  Wybierz z tabeli emp wszystkie wzajemnie różne kombinacje numeru departamentu i stanowiska pracy:

select distinct
    deptno
    , job
from emp
;


-- 5.  Wybierz nazwiska i pensje wszystkich pracowników których nazwiska zaczynają się na literę S i s oraz trzecią literę i

select
    ename
    , sal
from emp
where lower( ename ) like 's_i%'
;
-- lub
select
    ename
    , sal
from emp
where ename like '[sS]_i%'
;


-- 6.  Wybierz nazwiska i wartości zarobków wszystkich pracowników łącznie z obliczeniem prowizji od początku roku (POLE COMM)

select
    ename
    , ( sal + coalesce( comm, 0 ) )
from emp
;


-- 7. Podaj datę zegara systemowego

select 
    to_char( sysdate, 'yyyy-MM-dd hh24:mi:ss' )
    , to_char( sysdate, 'yyyy-Month-Day hh24:mi:ss' )
from dual
;


-- 8. Do daty zegara systemowego dodaj 3 dni

select 
    to_char( dt, 'yyyy-MM-dd hh24:mi:ss' )
from (
    select sysdate + 3 as dt
    from dual
)
;

-- 9. Do daty zegara systemowego dodaj 3 godziny

select 
    to_char( dt, 'yyyy-MM-dd hh24:mi:ss' )
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

