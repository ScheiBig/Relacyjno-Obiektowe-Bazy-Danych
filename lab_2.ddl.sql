-- Zdanie do realizacji:
-- Zdefiniować przykładową bazę danych (modelu fizycznego bazy danych),
-- która będzie znormalizowana.Model fizyczny przedstawiamy w formie tabel
-- (dla bazy relacyjnej).Ograniczenia PK, FK, DEFAULT, UNIQUE, CHECK,
-- (typ danych oraz NOT NULL) zdefiniujemy w czasie definiowania danej
-- struktury.
-- Po zaprojektowaniu wstępnej struktury poddajemy bazę normalizacji
-- (pierwsze trzy postacie normalne) i wstawiamy przykładowe dane.Założenia
-- (scenariusz):
-- * Model bazy danych jest związany z prostą bazą klientów.
-- * Model ma przechowywać informację o Klientach, w jakim Mieście
--   i Województwie mieszkają (schemat poniżej).
-- * Dla Czytelnika przechowujemy następujące informacje: Nazwisko , Imię,
--   Numer PESEL, Data urodzenia, Data zatrudnienia, Pensja,
--   Typ nazwy ('ul.','Al.','Plac','skwer') (nie podany na schemacie),
--   Nazwa ulica zamieszkania, Numer ulicy oraz Numer mieszkania.
-- * Dodatkowo chcemy aby pojawiła się informacja o nazwie Miasta
--   (jako identyfikator) i Województwa (jako identyfikator w tabeli miasta).
-- Po utworzeniu, każdej z tabel wstawiamy 3-5 przykładowych rekordów
-- i sprawdzamy czy wszystkie ograniczenia poprawnie funkcjonują. W osobnej
-- sekcji dokładamy polecenia, które naruszają zdefiniowane ograniczenia.
-- Schemat jest tylko przykładowy i nie muszą istnieć typy danych podanych
-- na schemacie.

-- Tabela Wojewodztwa
-------------------------------------------------------
-- WojewodztwoID int not null identity (PK),
--Nazwa varchar2(30) not null
-- Aktywne bit (0,1) default 1 (jeśli istnieje taki typ danych)


-- Tabela Miasta
-------------------------------------------------------
-- MiastoID int not null identity (PK)
-- Nazwa varchar2(30) not null
-- WojewodztwoID int (FK - Wojewodztwa[WojewodztwoID])


-- Tabela Klienci
-------------------------------------------------------
-- klientID int identity not null PK
-- Nazwisko varchar2(30) not null
-- Imie varchar2(20) not null
-- PESEL (11 cyfr) UNIQUE
-- Data_ur date null
-- Data_zatr date DEFAULT bieżąca data
-- Pensja decimal default 0 + CHECK (pensja >=0) not null
-- Pensja_roczna - pole obliczane na podstawie pola Pensja *12 (automatycznie wypełniane)
-- Ulica varchar2( ? ) null
-- Numer varchar2( ? ) null
-- Mieszkania integer NULL
-- MiastoID int FK (Miasta[MiastoID])
-- Wiek - pole obliczane na podstawie pól daty urodzenia (automatycznie wypełniane)
--
-- Dodatkowe ograniczenie na poziomie tabeli, aby data_ur < data_zatr (CHECK)
-- oraz ograniczenie aby nie zatrudnić pracownika poniżej 18 lat.





--  1. Dołożyć do tabeli Wojewodztwa pole Państwo varchar2(20) null


--  2. Zmienić NULL na NOT NULL (defaultowa wartość pola to `Polska')


--  3. Zmienić typ danych kraj na VARCHAR2(5) -- nie spełnia warunków (zostawić
--     tylko 5 znaków)


--  4. Zmienić typ danych kraj na VARCHAR2(35)


--  5. Zmienić nazwę kolumny Aktywne na Active


--  6. Zarządzanie ograniczeniami np. CHECK - włączanie/wyłączanie


--  7. Dołożyć do tabeli Miasta i jej kolumn osobne opisy


--  8. Zmiana dwóch kluczy obcych na wartość kaskadowe usuwanie ON DELETE
--     CASCADE i sprawdzić czy skasowanie danego Wojewodztwa skasuje zarówno
--     wszystkie miasta w tych województwach jak i klientów w danych miastach.


--  9. Zdefiniować widok, który poda kolumny Nazwisko klienta, jego wiek, pensję
--     roczną, nazwa miasta i województwa w którym mieszka.


-- 10. Napisać zapytania, które podadzą nam jakie tabele mamy w bazie, Jakie
--     widoki mamy w bazie oraz nazwy i typ kolumn w danej tabeli
--     oraz ograniczenia.


-- 11. Zmienić nazwę tabeli Klienci na Klienci1


-- 12. Zmienić kolejność kolumn


-- 13. Do zastanowienia się jak i gdzie przechowywać kod miejsca zamieszkania
--     oraz jak wyglądałaby struktura bazy ( np. 34-400 ), aby po podaniu kodu
--     można byłoby wybrać przypisane do danego kodu województwo, miasto i ulicę
--     (dane już istnieją w bazie danych)
