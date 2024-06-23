set ServerOutput on;
declare
	v1 number(10);
	v2 v1%type;
	v3 scott.emp%rowtype;
begin
	v1 := 10;
	dbms_output.put_line('Zmienna v1: ' || v1);

	select
		sal
	into v2
	from scott.emp
	where empno = 7369
	;
	dbms_output.put_line('Zmienna v2: ' || v2);

	select *
	into v3
	from scott.emp
	where empno = 7369
	;
	dbms_output.put_line(
		'Zmienna v3: { ename: ' || v3.ename
		|| ', job: ' || v3."JOB"
		|| ' }'
	);
end;
/
show errors;


-- 1. Opracować przykładowy blok PL/SQL z wykorzystaniem etykiety i instrukcji skoku
--    sprawdzający, czy podana liczba jest liczbą pierwszą:

declare
	num_parameter number(10) := 65537;
	i number(10) := 1;
	max_i number(10);
begin
	max_i := sqrt(num_parameter);
	<< loop_beg >>
	i := i + 1;
	if i < max_i
	then
		if mod( num_parameter, i ) = 0
		then
			goto loop_fail;
		else
			goto loop_beg;
		end if;
	else
		goto loop_success;
	end if;
	<< loop_fail >>
	dbms_output.put_line( 'Liczba ' || num_parameter || ' nie jest pierwsza' );
	return;
	<< loop_success >>
	dbms_output.put_line('Liczba ' || num_parameter || ' jest pierwsza' );
	return;
end;
/
show errors;


-- 2. Opracować przykładowy blok PL/SQL z wykorzystaniem etykiety i instrukcji skoku
--    sprawdzający, czy dla zadeklarowanej zmiennej typu varchar - sprawdzi czy w podanym ciągu
--    znajduje się cyfra:

declare
	zmienna varchar(255) := 'xx1122';
	--//--
	i number(10) := 0;
begin
	<< loop_beg >>
	i := i + 1;
	if i < length( zmienna )
	then
		if substr( zmienna, i, 1 ) between '0' and '9'
		then
			goto loop_success;
		else
			goto loop_beg;
		end if;
	else
		goto loop_fail;
	end if;


	<< loop_fail >>
	dbms_output.put_line( 'Zmienna ' || zmienna || ' nie zawiera liczb ' );
	return;
	<< loop_success >>
	dbms_output.put_line(
		'Zmienna ' || zmienna || ' zawiera liczbę ' || substr( zmienna, i, 1 )
		|| ' na pozycji ' || i
	);
	return;
end;
/
show errors;


-- 3. Zdefiniować blok PL/SQL sprawdzającą poprawność hasła :
--    - minimalna długość hasła(tzn. długość - min 4 znaki w tym I litera I cyfra 1 znak specjalny),
--    - hasło nie takie samo jak użytkownik, etc.
--    - hasło nie może zawierać popularnych wyrazów: ,ORACLE', ,HASŁO', ,12345' itp.
--
--    W części deklaracyjnej bloku należy zadeklarować trzy zmienne 'UZYTKOWNIK'
--    'STAREHASLO'. 'NOWEHASLO'

declare
	uzytkownik varchar(64) := 'Janosz';
	stare_haslo varchar(64) := '!agu4r';
	--//--
	nowe_haslo varchar(64) := 'oracle1*';
begin

	if length( nowe_haslo ) < 4
	then
		dbms_output.put_line( 'Hasło za krótkie' );
	end if;

	if not regexp_like( nowe_haslo, '.*[a-zA-Z].*' )
	then
		dbms_output.put_line( 'Haslo musi zawierać przynajmniej jedną literę' );
	end if;

	if not regexp_like( nowe_haslo, '.*[0-9].*' )
	then
		dbms_output.put_line( 'Haslo musi zawierać przynajmniej jedną cyfrę' );
	end if;

	if not regexp_like( nowe_haslo, '.*[\D\W].*' )
	then
		dbms_output.put_line( 'Haslo musi zawierać przynajmniej jeden znak specjalny' );
	end if;
end;
/
show errors;



-- 4. Opracować przykładowy blok PL/SQL, który dla zmiennej datdaUrodzin policzy z dziennymi
--    odsetkami jaka jest skapitalizowana wartość pieniędzy od daty urodzin do  dnia dzisiejszego
--    przy założeniu, że dzień utrzymania dziecka kosztuje 12.5 zł dziennie,
--    a odsetki dzienne 5/365 procenta.
declare
	birth_date date := date'1996-06-18';
	daily_add number := 12.5;
	daily_percent number := 0.0001369863013698; /*5/356*/
	--//--
	days number;
	capitalized_sum number := 0.0;
begin
	days := round( sysdate - birth_date );
	dbms_output.put_line( 'Czas zbierania to ' || days || ' dni' );


	for i in 1..days
	loop
		capitalized_sum := capitalized_sum + daily_add;
		capitalized_sum := capitalized_sum + ( capitalized_sum * daily_percent );
	end loop;

	dbms_output.put_line( 'Suma to ' || capitalized_sum );
end;
/
show errors;
