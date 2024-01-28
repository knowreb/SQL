--1.Wyswietl w jednej tabeli dane osobowe klientow i pracownikow
SELECT
	k.imie_klienta 'imie',
	k.nazwisko_klienta 'nazwisko',
    k.miasto_klienta 'miasto',
    k.email_klienta 'email',
    k.plec 'plec',
    'klient' rola
FROM klienci AS k
UNION
SELECT
	p.imie_pracownika,
    p.nazwisko_pracownika,
    p.miasto_pracownika,
    p.email_pracownika,
    NULL,
    'pracownik'
FROM pracownicy AS p;


--2.Wyswietl imion i nazwiska klientow, ktorzy wypozyczali oraz pracownikow ktorzy obslugiwali wypozyczenia samochodu marki audi a4
SELECT
	k.imie_klienta 'imie',
    k.nazwisko_klienta 'nazwisko',
    s.marka 'marka',
    s.model 'model',
    'klient' rola
FROM klienci AS k
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.marka='Audi' AND s.model='a4'
UNION
SELECT
	p.imie_pracownika,
    p.nazwisko_pracownika,
    s.marka,
    s.model,
    'pracownik'
FROM pracownicy AS p
	JOIN wypozyczenia AS w ON w.id_pracownika=p.id_pracownika
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.marka='Audi' AND s.model='a4';

--LUB // LUB // LUB
SELECT
	k.imie_klienta 'imie',
    k.nazwisko_klienta 'nazwisko',
    concat(s.marka,' ',s.model) auto,
	p.imie_pracownika,
	p.nazwisko_pracownika
    'klient' rola
FROM klienci AS k
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
	JOIN pracownicy AS p ON p.id_pracownika=w.id_pracownika
WHERE s.marka='Audi' AND s.model='a4'


--3.Wyswietl imiona i nazwiska klientow, ktorzy wypozyczali samochody Renault Clio oraz Opel Astra
SELECT
	k.imie_klienta,
    k.nazwisko_klienta
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='clio'
INTERSECT
SELECT
	k.imie_klienta,
    k.nazwisko_klienta
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='astra';


--4. Wyswietl klientow, ktorzy wypozyczali dwa konkretne samochody w tym samym dniu. Do zapytania dolacz id, date wypozyczenia oraz model auta
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    w.id_wypozyczenia,
    w.data_wyp,
    s.marka
FROM klienci AS k
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='corsa'
INTERSECT
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    w.id_wypozyczenia,
    w.data_wyp,
    s.marka
FROM klienci AS k
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='astra';


--5.  Wyswietl imiona i nazwiska klientow, ktorzy wypozyczali Forda mondeo ale nie wypozyczali nigdy Opla astry
SELECT
	k.imie_klienta,
    k.nazwisko_klienta
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='mondeo'
EXCEPT
SELECT
    k.imie_klienta,
    k.nazwisko_klienta
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='astra';


--ZADANIE DOMOWE
--1.Wyswietl imiona i nazwiska klientow, ktorzy wypozyczalo praz pracownikow ktorzy obslugiwali wypozyczenia aut marki bmw
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    'klient' rola
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.marka="bmw"
UNION
SELECT
	p.imie_pracownika,
    p.nazwisko_pracownika,
    'pracownik'
FROM pracownicy AS p
	JOIN wypozyczenia AS w ON w.id_klienta=p.id_pracownika
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.marka="bmw";

--2. Wyswietl imiona i nazwiska klientow, ktorzy w okresie od maja do wrzesnia 2022 roku wypozyczali auta marki bmw model 3 oraz mercedesa model clk
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    w.data_wyp
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='3' AND w.data_wyp BETWEEN "2022-05-31" AND "2022-09-30"
INTERSECT
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    w.data_wyp
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='CLK' AND w.data_wyp BETWEEN "2022-05-31" AND "2022-09-30";

--3.Wyswietl imiona i nazwiska klientow, ktorzt wypozyczali Renault clio ale nie wypozyczali bmw3
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    s.marka
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='clio'
EXCEPT
SELECT
	k.imie_klienta,
    k.nazwisko_klienta,
    S.marka
FROM klienci AS k 
	JOIN wypozyczenia AS w ON w.id_klienta=k.id_klienta
    JOIN dane_wypozyczen AS d ON d.id_wypozyczenia=w.id_wypozyczenia
    JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
WHERE s.model='bmw'