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


-- Przykład 2:
set serveroutput on;
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


-- Przykład 3:
-- Zadanie (samodzielna realizacja):
-- Za pomocą kursora zrealizować, by w zależności od nazwiska pracownika
-- wyświetlany był pracownik i dział w którym on pracuje (jeżeli jego nazwisko
-- jest na literę od A do G) lub samo nazwisko pracownika.



-- Przykład 4:
-- Zadanie:(samodzielna realizacja):
-- Za pomocą kursora policzyć sumaryczną wartość pensji pracowników
-- (bez prowizji i z prowizją).
