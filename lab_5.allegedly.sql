------------
-- W domu --
------------
-- Każdy z wyzwalaczy sprawdzamy czy działa po czym wyłączamy go przed realizacją
-- następnego zadnia. Wyzwalacze mają być typu FOR EACH ROW.

-- 1. Zdefiniować wyzwalacz na tabeli EMP, który przy wstawieniu lub modyfikowaniu danych
--    pole ENAME będzie zamieniał wprowadzany ciąg na duże litery.

;


-- 2. Zdefiniować wyzwalacz na tabeli EMP, który z wykorzystaniem sekwencji wcześniej utworzonej
--    będzie numerował EMPNO tabeli EMP od wartości 100 z krokiem 11 do wartości maksymalnie 9999.

;


-- 3. Zdefiniować wyzwalacz na tabeli EMP, który sprawdzi czy pole HIREDATE jest mniejsze
--    lub równe dacie systemowej +-10 dni przy wstawianiu nowego pracownika lub jego modyfikacji.
--    Jeśli nie, zwrócony zostanie komunikat o błędzie a transakcja zostanie wycofana.

;


-- 4. Zdefiniować wyzwalcz na tabeli EMP, który wyświetli komunikat na ekranie jaki użytkownik
--    został skasowany, wstawiony lub zmodyfikowany.

;


-- 5. Zdefiniować wyzwalcz na tabeli EMP, który przy kasowaniu lub modyfikowaniu pracownika
--    zapisze wszystkie dane do tabeli EMP_HIST z dodatkowymi polami tj. Data_Czas_operacji
--    oraz typ_operacji (DELETE, UPDATE) - wcześniej trzeba przygotować daną tabelę.

;


-- 6. Zdefiniować widok na tabeli EMP i DEP. Na widoku zdefiniować wyzwalacz typu INSTEAD OF,
--    który przy poleceniu INSERT na widoku doda użytkownika, który nie będzie miał
--    przypisanego żadnego departamentu.

;


-- 7. Zdefiniować wyzwalacz na tabeli EMP, który reaguje na pensję mniejszą od zera
--    i wtedy zmienia jej wartość na 0.

;


-- 8. Zdefiniować wyzwalacz na tabeli DEPT, która zadziała przy modyfikacji pola DEPTNO
--    i jednocześnie zaktualizuje numer departamnetu wszystkim pracownikom pracującym
--    w tym departamencie w tabeli EMP (tzw. kaskadowa aktualizacja - ON CASCADE UPDATE
--    dla systemu MS SQL SERVER).

;


-- 9. Zdefiniować wyzwalacz, który zapewni, że żaden pracownik nie otrzyma podwyżki większej
--    niż 10%. Dodatkowo zmiana taka ma być zarejestrowana w bazie danych w tabeli REJESTR_ZMIAN
--    z polami (Nazwisko_pracownika, data, pensja_stara, pensja_nowa, akcja).
--
--    Akcja podaje informację słowną ('wstawiono_rekord' lub 'Zmodyfikowano rekord') w zależności
--    czy pracownik nowy czy już jest w bazie i jest modyfikowana jego pensja (jeden wyzwalacz
--    działa na polecenie INSERT i UPDATE na polu SAL). W przypadku głównego szefa 'PRESIDENT'
--    ta zasada nie działa czy wyzwalacz nie uruchamian się (klauzla WHEN)

;


-- 10. Mamy widok, który zawiera dane pracownika i nazwę departamentu, do którego należy
--     (z tabeli DEPT). Zdefiniować wyzwalacz na tabeli, który sprawdzi numer departamentu
--     i wstawi do tabeli pracownicy. Jeżeli nie ma takiego numeru departamentu to wstawiamy NULL.

;


-- 11. Zdefiniuj wyzwalacz na tabeli DEPT, który wstawi do tabeli REJESTR_DEPT (jeżeli nie ma,
--     założyć - zaproponowac strukturę tabeli np.: z polami Nazwa_departamentu oraz
--     Data_wstawienia) rejestr wszystkich nazw departamnetu, które są dokładane do tabeli DEPT,
--     nawet te, które nie dodano ze względu na wycofanie transakcji poleceniem ROLLBACK.
--
--     UWAGA wykorzystać transakcje autonomiczne PRAGMA AUTONOMOUS_TRANSACTION.

;


-- 12. Zdefiniuj wyzwalacz, który sprawdzi czy dana nazwa departamentu nie powtarza się w bazie
--     danych (nie używamy ograniczenia UNIQUE). Jeśli tak to definiujemy wyjątek,
--     który przekazujemy do bloku instrukcji nadrzędnego, w którym wstawiany jest dany departament
--     i tutaj obsługujemy dany błąd łącznie z wycofaniem transakcji.

;
