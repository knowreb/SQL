--do wyp. sam.v4 0. informacje o najtanszych samochodach

SELECT*
FROM samochody
WHERE samochody.cena_katalogowa=(SELECT MIN(samochody.cena_katalogowa)
								FROM samochody)
								
-- 1.Wyświetl informacje o samochodach, które są droższe niż wszystkie samochody z klasy aut luksusowych*/

SELECT *
FROM samochody
WHERE samochody.cena_katalogowa > ALL (SELECT samochody.cena_katalogowa
										FROM samochody
										WHERE samochody.id_klasy = 5)

-- 2. Wyświetl informacje o samochodach marki OPEL wraz ze średnią ceną samochodów tej marki*/

SELECT
	samochody.marka,
	samochody.model,
	samochody.nr_rejestracyjny,
	samochody.cena_katalogowa,
	(SELECT ROUND(AVG(samochody.cena_katalogowa),2)
		FROM samochody
		WHERE samochody.marka = 'opel') AS 'średnia cena za opla'
FROM samochody
WHERE samochody.marka = 'opel'

-- 3. Wyświetl informacje o ilości (liczbie) wypożyczeń, w ramach których klient wypożyczał więcej niż jeden samochód.

SELECT 
	dane_wypozyczen.id_wypozyczenia,
	COUNT(dane_wypozyczen.id_wypozyczenia) AS 'ile'
FROM dane_wypozyczen
GROUP BY dane_wypozyczen.id_wypozyczenia 
HAVING ile >=2

--3. wersja 2
SELECT
	COUNT(*) AS 'ile tego było?'
FROM
	(SELECT
		dane_wypozyczen.id_wypozyczenia
	FROM dane_wypozyczen
	GROUP BY dane_wypozyczen.id_wypozyczenia
	HAVING COUNT(dane_wypozyczen.id_wypozyczenia) >=2) podzpt
	
	
--4. Wyświetl informacje o klientach którzy dokonali największej ilości wypożyczeń 

SELECT 
	klienci.imie_klienta,
	klienci.nazwisko_klienta,
	COUNT(wypozyczenia.id_klienta) AS 'ile'
FROM klienci
	INNER JOIN wypozyczenia ON wypozyczenia.id_klienta=klienci.id_klienta
GROUP BY wypozyczenia.id_klienta
HAVING ile = (SELECT
				COUNT(wypozyczenia.id_klienta) AS 'maks'
				FROM klienci
					INNER JOIN wypozyczenia
					ON wypozyczenia.id_klienta=klienci.id_klienta
				GROUP BY wypozyczenia.id_klienta
				ORDER BY maks DESC
				LIMIT 1)
				
--5. Wyświetl informacje o samochodach, które nigdy nie były wypożyczone

SELECT*
FROM samochody
WHERE id_samochodu NOT IN (SELECT 
								id_samochodu
							FROM dane_wypozyczen
							WHERE id_samochodu IS NOT NULL)


--ZADANIA DOMOWE
-- 1. Wyswietl ID klientow, ktorzy nie dokonalii jeszcze wypozyczenia

SELECT *
FROM klienci AS k 
WHERE id_klienta NOT IN (SELECT
							id_klienta
						FROM wypozyczenia
						WHERE id_klienta IS NOT NULL)
						
-- 2. Wyswietl imiona i nazwiska klientoow, ktorzy nie wypozyczali jeszcze aut z klasy sedan
SELECT 
	k.id_klienta,
	k.imie_klienta,
	k.nazwisko_klienta
FROM klienci AS k 
WHERE id_klienta NOT IN (SELECT w.id_klienta
						FROM wypozyczenia AS w
							JOIN dane_wypozyczen AS d ON d.wypozyczenia=w.id_wypozyczenia
							JOIN samochody AS s ON s.id_samochodu=d.id_samochodu
							JOIN klasy_samochodow AS ks ON ks.id_klasy=s.id_klasy
						WHERE ks.id_klasy=3)
						
-- 3. Policz ilosc wypozyczen tylko na jedno auto
SELECT 
	COUNT* 'ilosc_wypozyczen'
FROM (SELECT 
        dane_wypozyczen.id_wypozyczenia
      FROM dane_wypozyczen 
      GROUP BY dane_wypozyczen.id_wypozyczenia
      HAVING COUNT(dane_wypozyczen.id_wypozyczenia) = 1)
	  

-- 4.Marki i modele aut, które były wypożyczane najmniej razy.
SELECT 
    samochody.marka,
    samochody.model,
    samochody.nr_rejestracyjny,
    COUNT(dane_wypozyczen.id_samochodu) AS 'ile_razy'
FROM samochody 
    INNER JOIN dane_wypozyczen ON dane_wypozyczen.id_samochodu=samochody.id_samochodu
GROUP BY dane_wypozyczen.id_samochodu
HAVING ile_razy = (SELECT COUNT(dane_wypozyczen.id_samochodu) ilosc
	               FROM samochody
                        INNER JOIN dane_wypozyczen ON dane_wypozyczen.id_samochodu=samochody.id_samochodu
                   GROUP BY dane_wypozyczen.id_samochodu
                   ORDER BY ilosc
                   LIMIT 1)