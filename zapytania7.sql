--Jak wyglada zawartosc tablicy dane_wypozyczen
SELECT *
FROM dane_wypozyczen

--Jakie auta zostały wypożyczone? (stworzyc zapytanie, które złączy dwie tabele: dane_wypozyczen i samochody za pomoca where lub join) nr wypo marka i model

SELECT 
	dane_wypozyczen.id_wypozyczenia,
    samochody.marka,
    samochody.model
FROM dane_wypozyczen 
INNER JOIN samochody ON samochody.id_samochodu=dane_wypozyczen.id_samochodu
ORDER BY dane_wypozyczen.id_wypozyczenia

--dodanie do powyzszego kodu dat wypozyczen (obecne w tablicy wypozyczenia)

SELECT 
	dane_wypozyczen.id_wypozyczenia,
    samochody.marka,
    samochody.model,
    wypozyczenia.data_wyp
FROM dane_wypozyczen 
	INNER JOIN samochody ON samochody.id_samochodu=dane_wypozyczen.id_samochodu
    INNER JOIN wypozyczenia ON wypozyczenia.id_wypozyczenia=dane_wypozyczen.id_wypozyczenia
ORDER BY dane_wypozyczen.id_wypozyczenia

--dodajmy do wyników informacje o klientach które dane wypozyczenie realizowali
SELECT 
	dane_wypozyczen.id_wypozyczenia,
    samochody.marka,
    samochody.model,
    wypozyczenia.data_wyp,
    klienci.imie_klienta,
    klienci.nazwisko_klienta
FROM dane_wypozyczen 
	INNER JOIN samochody ON samochody.id_samochodu=dane_wypozyczen.id_samochodu
    INNER JOIN wypozyczenia ON wypozyczenia.id_wypozyczenia=dane_wypozyczen.id_wypozyczenia
    INNER JOIN klienci ON klienci.id_klienta=wypozyczenia.id_klienta
ORDER BY dane_wypozyczen.id_wypozyczenia

-- dodanie do listy imienia i nazwiska pracownikow realizujacych dane wypozyczenie
SELECT 
	dane_wypozyczen.id_wypozyczenia,
    samochody.marka,
    samochody.model,
    wypozyczenia.data_wyp,
    klienci.imie_klienta,
    klienci.nazwisko_klienta,
    pracownicy.imie_pracownika,
    pracownicy.nazwisko_pracownika
FROM dane_wypozyczen 
	INNER JOIN samochody ON samochody.id_samochodu=dane_wypozyczen.id_samochodu
    INNER JOIN wypozyczenia ON wypozyczenia.id_wypozyczenia=dane_wypozyczen.id_wypozyczenia
    INNER JOIN klienci ON klienci.id_klienta=wypozyczenia.id_klienta
    INNER JOIN pracownicy ON pracownicy.id_pracownika=wypozyczenia.id_wypozyczenia
ORDER BY dane_wypozyczen.id_wypozyczenia

--wydobyc date wypozyczenia i jakie auto zostalo wypozyczone model i marka (trzeba wykorzystac tablice znajdujaca sie pomiedzy tab wypozyczenia i samochody tj. tablica dane wypozyczen aby uzyskac dane o marce, modelu i dacie )
SELECT
	wypozyczenia.data_wyp,
    samochody.marka,
    samochody.model
FROM wypozyczenia
	INNER JOIN dane_wypozyczen ON wypozyczenia.id_wypozyczenia=dane_wypozyczen.id_wypozyczenia
    INNER JOIN samochody ON samochody.id_samochodu=dane_wypozyczen.id_samochodu
    ORDER BY wypozyczenia.data_wyp
	
-- zapytanie które zwróci nam nazwiska pracowników oraz id wypozyczen
SELECT
	pracownicy.nazwisko_pracownika,
    wypozyczenia.id_wypozyczenia
FROM pracownicy
INNER JOIN wypozyczenia ON wypozyczenia.id_pracownika=pracownicy.id_pracownika

-- zapytanie ktore zwroci rowniez nazwiska(tylko) pracownikow ktorzy nie zrealizowali wypozyczen / klientow ktorzy nie wypozyczyli
SELECT
	pracownicy.nazwisko_pracownika
FROM pracownicy
	LEFT JOIN wypozyczenia ON wypozyczenia.id_pracownika=pracownicy.id_pracownika
WHERE wypozyczenia.id_wypozyczenia IS NULL
ORDER BY wypozyczenia.id_wypozyczenia ASC

-- przy uzyciu RIGHT join wyswietlane sa wszystkie rekordy z tabeli znajdujacej sie po prawej stronie klauzuli

SELECT
	pracownicy.nazwisko_pracownika,
    wypozyczenia.id_wypozyczenia
FROM pracownicy
	RIGHT JOIN wypozyczenia ON wypozyczenia.id_pracownika=pracownicy.id_pracownika;
	
	
--modyfikuj pytanie z right joinem tak aby wyswietlilo tylko te id wyp ktorych nie obslugiwal zaden konkretny pracownik

SELECT
	pracownicy.nazwisko_pracownika,
    wypozyczenia.id_wypozyczenia
FROM pracownicy
	RIGHT JOIN wypozyczenia ON wypozyczenia.id_pracownika=pracownicy.id_pracownika
WHERE pracownicy.id_pracownika is NULL
    
	lub 
SELECT
    wypozyczenia.id_wypozyczenia
FROM pracownicy
	RIGHT JOIN wypozyczenia ON wypozyczenia.id_pracownika=pracownicy.id_pracownika
WHERE pracownicy.id_pracownika is NULL
    
-- czy mamy w bazie klientow ktorzy nie wypozyczali jeszcze auta (z right join wychodza takie same)
SELECT
	klienci.imie_klienta,
    klienci.nazwisko_klienta,
    wypozyczenia.id_wypozyczenia
FROM klienci
    	LEFT JOIN wypozyczenia ON klienci.id_klienta=wypozyczenia.id_klienta

SELECT
	klienci.imie_klienta,
    klienci.nazwisko_klienta,
    wypozyczenia.id_wypozyczenia
FROM wypozyczenia
    	RIGHT JOIN klienci ON klienci.id_klienta=wypozyczenia.id_klienta
		
-- zapytanie ktore wskaze auta (model i marka) ktore nigdy nie zostaly wypozyczone
SELECT
	samochody.marka,
    samochody.model
FROM samochody
    	LEFT JOIN dane_wypozyczen ON dane_wypozyczen.id_samochodu=samochody.id_samochodu

--wyswietlic pracownikow (imie i nazwisko) ktorzy nie wypozyczyli samochodu oraz wypozyczenia do ktorych nie ma przypisanych pracownikow

SELECT
	pracownicy.imie_pracownika,
    pracownicy.nazwisko_pracownika,
    wypozyczenia.id_wypozyczenia
FROM pracownicy
	LEFT JOIN wypozyczenia ON pracownicy.id_pracownika=wypozyczenia.id_pracownika
WHERE wypozyczenia.id_pracownika IS null

UNION

SELECT
	pracownicy.imie_pracownika,
    pracownicy.nazwisko_pracownika,
    wypozyczenia.id_wypozyczenia
FROM pracownicy
	RIGHT JOIN wypozyczenia ON pracownicy.id_pracownika=wypozyczenia.id_pracownika
WHERE wypozyczenia.id_pracownika IS null

---dodatkowe '37
SELECT
	d.id_wypozyczenia,
    s.marka,
    s.model,
   	w.data_wyp,
    k.imie_klienta,
    k.nazwisko_klienta
FROM dane_wypozyczen AS d
    INNER JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
    INNER JOIN wypozyczenia AS w ON w.id_wypozyczenia=d.id_wypozyczenia
    LEFT JOIN klienci AS k ON k.id_klienta=w.id_klienta
UNION
SELECT
	d.id_wypozyczenia,
    s.marka,
    s.model,
   	w.data_wyp,
    k.imie_klienta,
    k.nazwisko_klienta
FROM dane_wypozyczen AS d
    INNER JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
    INNER JOIN wypozyczenia AS w ON w.id_wypozyczenia=d.id_wypozyczenia
    RIGHT JOIN klienci AS k ON k.id_klienta=w.id_klienta
ORDER BY 6

--raport ktory przedstawi wartosc wsystkich wypozyczen dla poszczegolnych klientow (potrzebujemy dane klienta imie i nazwisko oraz wartosc wypozyczenia)
SELECT
	SUM(dane_wypozyczen.cena_doba*dane_wypozyczen.ilosc_dob) wartosc,
    klienci.imie_klienta,
    klienci.nazwisko_klienta
    FROM dane_wypozyczen 
    INNER JOIN wypozyczenia on wypozyczenia.id_wypozyczenia=dane_wypozyczen.id_wypozyczenia
    inner JOIN klienci on klienci.id_klienta=wypozyczenia.id_klienta
GROUP BY wypozyczenia.id_klienta

--sprawdzenie czy w bazie sa pracownicy i klienci z tych samych miast 
SELECT
	klienci.imie_klienta,
    klienci.nazwisko_klienta,
    pracownicy.imie_pracownika,
    pracownicy.nazwisko_pracownika,
    pracownicy.miasto_pracownika miasto
FROM klienci
INNER JOIN pracownicy ON klienci.miasto_klienta=pracownicy.miasto_pracownika

--SELF JOIN
SELECT
	p.nazwisko_pracownika,
	s.nazwisko_pracownika szef
FROM pracownicy p 
	JOIN pracownicy s ON p.szef_id=s.id_pracownika
	
	
---ZADANIE DOMOWE
--1 Wyświetl daty wypożyczeń, a także imiona i nazwiska klientów, którzy w danym dniu dokonywali wypożyczenia.
SELECT
	wypozyczenia.data_wyp,
    klienci.imie_klienta,
    klienci.nazwisko_klienta
FROM wypozyczenia
	INNER JOIN klienci ON klienci.id_klienta=wypozyczenia.id_klienta
	
	
--2  Wyświetl marki i modele aut wraz z cenami za dobę wypożyczenia.
SELECT DISTINCT
	samochody.marka,
    samochody.model,
    dane_wypozyczen.cena_doba
FROM samochody
	INNER JOIN dane_wypozyczen ON dane_wypozyczen.id_samochodu=samochody.id_samochodu

--3 Wyświetl imiona i nazwiska pracowników wypożyczani, którzy obsługiwali wypożyczenia w lipcu 2022 roku.
SELECT DISTINCT
	p.imie_pracownika,
    p.nazwisko_pracownika
FROM pracownicy AS p 
	INNER JOIN wypozyczenia AS w ON w.id_pracownika=p.id_pracownika
WHERE w.data_wyp LIKE "2022-07%";

--4 Wyświetl marki i modele aut, które w okresie od kwietnia do września wypożyczał klient o nazwisku Karwowski.
SELECT 
	s.marka,
    s.model,
    w.data_wyp,
    k.nazwisko_klienta
FROM samochody AS s 
	JOIN dane_wypozyczen AS d ON s.id_samochodu=d.id_samochodu
	JOIN wypozyczenia AS w ON w.id_wypozyczenia=d.id_wypozyczenia
    JOIN klienci AS k ON k.id_klienta=w.id_klienta
WHERE k.nazwisko_klienta LIKE 'Karwowski'
AND w.data_wyp LIKE '2022-04%'
OR w.data_wyp LIKE '2022-05%'
OR w.data_wyp LIKE '2022-06%'
OR w.data_wyp LIKE '2022-07%'
OR w.data_wyp LIKE '2022-08%'
OR w.data_wyp LIKE '2022-09%'
ORDER BY w.data_wyp

--5 Wyświetl wartość wypożyczeń, które obsługiwał pracownik o nazwisku Nowacki. 
SELECT
	SUM(d.cena_doba*d.ilosc_dob) wartosc,
    p.nazwisko_pracownika
FROM dane_wypozyczen AS d
	JOIN wypozyczenia AS w ON w.id_wypozyczenia=d.id_wypozyczenia
    JOIN pracownicy AS p ON p.id_pracownika=w.id_pracownika
WHERE p.nazwisko_pracownika LIKE 'Nowacki'