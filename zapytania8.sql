--1. Wyswietl imiona i nazwiska klientow bez nadmiarowych spacji(kolumny z imieniem i nazwiskiem są argumentami funkcji trim - ktory usuwa znaki zewnetrzne tylko po skrajnej lewej lub prawej stronie)

SELECT
	trim(k.imie_klienta)'imie',
	trim(k.nazwisko_klienta) 'nazwisko'
FROM klienci AS k 

--usunięcie znakow(spacji) z srodka slowa - uzycie 

SELECT
	replace(k.imie_klienta, ' ', '')'imie',
	trim(k.nazwisko_klienta) 'nazwisko'
FROM klienci AS k 

--2. Wyswietl imiona i nazwiska klientow bez nadmiarowych spacji oraz miasta z jakich pochodza. Wyniki posortuj malejaco wedlug liczby znakow w kolumnie miasto

SELECT
	replace(k.imie_klienta, ' ', '')'imie',
	trim(k.nazwisko_klienta) 'nazwisko',
	k.miasto_klienta 'miasto' 
FROM klienci AS k 
ORDER BY char_length(k.miasto_klienta) DESC

--3.Zaktualizujm rekordy w tabeli klienci pozbywajac sie nadmiarowych spacji w kolumnach imię i nazwisko
UPDATE klienci AS k SET k.imie_klienta=replace(k.imie_klienta,' ', ''),
						k.nazwisko_klienta=trim(k.nazwisko_klienta)
						
--4. Wyswietl nazwy domen w jakich klienci mają adresy e-mail
SELECT
	substring(k.email_klienta,instr(k.email_klienta,'@')) 'domena'
FROM klienci AS k

--nazwa domeny ale bez znaku @
SELECT
	substring(k.email_klienta,instr(k.email_klienta,'@')+1) 'domena'
FROM klienci AS k

--usuwanie powtarzajacych sie rekordow
SELECT DISTINCT
	substring(k.email_klienta,instr(k.email_klienta,'@')+1) 'domena'
FROM klienci AS k

--ZADANIE : zamien domeny pl na eu w mailu klienta

SELECT 
	k.email_klienta,
	replace (k.email_klienta, 'pl', 'eu') 
FROM klienci AS k 
WHERE k.email_klienta LIKE "%wp%";

--5.Wyswietl w jednej kolumnie imiona i nazwiska klientow z dolaczona forma grzecznosciowa
SELECT
	CONCAT(
		IF (k.plec='M','Pan ','Pani '),
		k.imie_klienta,
		' ',
		k.nazwisko_klienta) 'klienci'
FROM klienci AS k 
ORDER BY klienci

--6. (-polaczenie kolumn marka i model pojazdu, -obliczenie ilosci wypozyczen kazdego auta, -zmiana pierwszych liter marek i modeli aut na wielkie, -dodanie frazy raz albo razy do ilosci wypozyczonych aut, -konstrukcja warunku sprawdzajacego ilosc znakow lancucha i dla rekordow spelniajacych warunek zmiana liter na wielkie)concat aby połączyc dwie kolumny

SELECT
		CONCAT(
			IF(
				char_length(s.marka)<=3,
				ucase(s.marka),
				concat(ucase(left(s.marka,1)),substring(s.marka,2))
				),
			' ',
			IF(
				char_length(s.model)<=3,
				ucase(s.model),
				concat(ucase(left(s.model,1)),substring(samochody.model,2))
				)
			) 'Auto',
			ucase(LEFT(s.marka,1)), --pierwszy argument funkcji concat, zwraca pierwsza litere z marki pojazdu i ustawia ja na wielka
			substring(s.marka,2), -- drugi argument concat, który zwraca pozostale czesci nazwy marki pojazdu
			' ', --spacja pomiedzy marka i modelem
			ucase(LEFT(s.model,1)),
			substring(s.model,2)
			)'Auto',
		concat(
			COUNT(d.id_samochodu),
			' ',
			CASE WHEN COUNT(d.id_samochodu)=1 THEN 'raz' ELSE 'razy' END --jesli wart w kolumnie ilosc wyp bedzie sie rownac 1 wowczas dopisz do wartosci: raz, w przeciwnym wypadku dopisz: razy
			)'Ilosc wypozyczen'
FROM samochody AS s
	LEFT JOIN dane_wypozyczen AS d ON s.id_samochodu=d.id_samochodu
	GROUP BY d.id_samochodu
	ORDER BY COUNT(d.id_samochodu) DESC;
	
	--v2
	SELECT
		CONCAT(
			IF(
				char_length(s.marka)<=3,
				ucase(s.marka),
				concat(ucase(left(s.marka,1)),substring(s.marka,2))
				),
			' ',
			IF(
				char_length(s.model)<=3,
				ucase(s.model),
				concat(ucase(left(s.model,1)),substring(s.model,2))
				)
			) 'Auto',
		concat(
			COUNT(d.id_samochodu),
			' ',
			CASE WHEN COUNT(d.id_samochodu)=1 THEN 'raz' ELSE 'razy' END --jesli wart w kolumnie ilosc wyp bedzie sie rownac 1 wowczas dopisz do wartosci: raz, w przeciwnym wypadku dopisz: razy
			)'Ilosc wypozyczen'
FROM samochody AS s
	LEFT JOIN dane_wypozyczen AS d ON s.id_samochodu=d.id_samochodu
	GROUP BY d.id_samochodu
	ORDER BY COUNT(d.id_samochodu) DESC;
	
	
	
	
--ZADANIA DOMOWE
--1. Korzystajac z funkcji left, right lub substring wyswietl kazdy element daty wypozyczenia(dzien, miesiac, rok) w osobnych kolumnach.

SELECT
	LEFT(w.data_wyp,4) 'rok',
    substring(w.data_wyp,6,2) 'miesiac',
    RIGHT(w.data_wyp,2) 'dzien'
FROM wypozyczenia AS w;


--2. Korzystajac z funkcji concat wyswietl w jednej kolumnie imie i nazwisko klienta, a w drugiej jego adres. Dodaj do wynikow fraze "ul" przed nazwami ulic

SELECT
	concat
    	(k.imie_klienta,' ',k.nazwisko_klienta) 'Dane_klienta',
    concat
    	('ul.',k.ulica_klienta,' ',k.numer_domu_klienta,', ',k.kod_klienta,' ',k.miasto_klienta,' ')'Adres_klienta'
FROM  klienci AS k;

--3. Korzystajac z funkcji replace oraz instrukcji warunkowej wyswietl adresy e-mail klientow ze zmieniona nazwa domeny pl na com i odwrotnie. Zadanie wykonaj dla domeny wp.pl oraz gmail.com, bez modyfikacji domeny onet.pl

SELECT
	replace
    	(k.email_klienta, 'pl', 'com') 'zmieniona_domena_pl_com',
		IF(k.email_klienta LIKE"%com",'pl','com') 'zmieniona_domena_com_pl'
FROM klienci AS k;

--v2
SELECT
	replace
    	(k.email_klienta, 'pl', 'com') 'zmiana_domeny',
		IF(k.email_klienta LIKE"%com",'pl','com') 'zmieniona'
FROM klienci AS k;

--4.Korzystajac z funkcji lcase, ucase oraz left, right lub substring wyswietl nazwiska klientow zaczynajac od malej litery a konczac na wielkiej (mroczeK, stelmacH)

SELECT
	concat(
    	LCASE(substring(k.nazwisko_klienta,1, LENGTH(k.nazwisko_klienta)-1)),
        UCASE(RIGHT(k.nazwisko_klienta,1))
        )'nazwisko'
FROM klienci AS k;
