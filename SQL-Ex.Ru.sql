/* 1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
Result set: model, speed, hd */

SELECT model, speed, hd 
FROM PC 
WHERE price < $500;

/* 2. List all printer makers. Result set: maker*/

SELECT maker
FROM Product 
WHERE type = 'printer' 
GROUP BY maker;

/* 3. Find the model number, RAM and screen size of the laptops with prices over $1000 */

SELECT model, ram, screen 
FROM Laptop 
WHERE price > $1000;

/* 4. Find all records from the Printer table containing data about color printers */

SELECT * FROM Printer 
WHERE color = 'y';

/* 5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive*/

SELECT model, speed, hd 
FROM PC 
WHERE price < 600 AND cd IN ('12x', '24x');

/* 6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed*/

SELECT DISTINCT product.maker, laptop.speed
FROM product
JOIN laptop
ON product.model = laptop.model
WHERE laptop.hd >= 10
ORDER BY product.maker;

/* 7. Get the models and prices for all commercially available products (of any type) produced by maker B */

SELECT product.model, pc.price AS Price 
FROM Product 
JOIN PC ON product.model = pc.model 
WHERE product.maker = 'B'
UNION
SELECT product.model, laptop.price AS Price 
FROM Product 
JOIN Laptop ON product.model = laptop.model 
WHERE product.maker = 'B'
UNION 
SELECT product.model, Printer.price AS Price 
FROM Product 
JOIN Printer ON product.model = printer.model 
WHERE product.maker = 'B';

/* 8. Find the makers producing PCs but not laptops */

SELECT maker FROM product 
WHERE type = 'pc' 
GROUP BY maker 
EXCEPT 
SELECT maker FROM product 
WHERE type = 'laptop' 
GROUP BY maker;

/* 9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker */

SELECT product.maker FROM Product 
JOIN PC ON product.model = pc.model 
WHERE pc.speed >= 450 
GROUP BY maker;

/* 10. Find the printer models having the highest price. Result set: model, price */

SELECT model, price 
FROM Printer 
WHERE price = (SELECT MAX(price) FROM Printer);

/* 11. Find out the average speed of PCs */

SELECT AVG(speed) 
FROM PC;

/* 12. Find out the average speed of the laptops priced over $1000 */

SELECT AVG(speed) 
FROM Laptop 
WHERE price > $1000;

/* 13. Find out the average speed of the PCs produced by maker A */

SELECT AVG(pc.speed) 
FROM PC 
JOIN Product ON pc.model = product.model 
WHERE product.maker = 'A';

/* 14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country */

SELECT ships.class, ships.name, classes.country 
FROM Ships 
JOIN Classes ON ships.class = classes.class 
WHERE classes.numGuns >= 10;

/* 15. Get hard drive capacities that are identical for two or more PCs.
Result set: hd */

SELECT hd FROM PC 
GROUP BY hd 
HAVING COUNT(hd) >=2;

/*16. Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
Result set: model with the bigger number, model with the smaller number, speed, and RAM. */

SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram 
FROM pc p1, pc p2 
WHERE p1.speed = p2.speed 
	AND p1.ram = p2.ram 
    AND p1.model > p2.model;
    
/* 17. Get the laptop models that have a speed smaller than the speed of any PC.
Result set: type, model, speed. */

SELECT DISTINCT product.type, laptop.model, laptop.speed 
FROM Product 
JOIN Laptop ON product.model = laptop.model 
WHERE speed < All (SELECT speed FROM PC);

/* 18. Find the makers of the cheapest color printers.
Result set: maker, price. */

SELECT DISTINCT maker, price 
FROM Product 
JOIN Printer ON product.model = printer.model 
WHERE color = 'y' 
	AND price = (SELECT MIN(price) 
				 FROM Printer 
                 WHERE color = 'y');
				
/* 19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
Result set: maker, average screen size. */

SELECT maker, AVG(screen) AS average_screen_size 
FROM Product 
JOIN Laptop ON product.model = laptop.model 
GROUP BY maker;

/* 20. Find the makers producing at least three distinct models of PCs.
Result set: maker, number of PC models. */

SELECT maker, COUNT(DISTINCT model) AS number_of_PC_models 
FROM Product 
WHERE type = 'PC' 
GROUP BY maker 
HAVING COUNT(DISTINCT model) >= 3;

/* 21. Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price. */

SELECT maker, MAX(price) 
FROM Product 
JOIN PC ON product.model = pc.model 
GROUP BY maker;

/* 22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
Result set: speed, average price. */

SELECT speed, AVG(price) 
FROM PC 
WHERE speed > 600 
GROUP BY speed;

/* 23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
Result set: maker */

SELECT maker FROM Product 
JOIN PC ON product.model = pc.model 
WHERE speed >= 750 
INTERSECT
SELECT maker FROM Product 
JOIN laptop ON product.model = laptop.model 
WHERE speed >= 750;

/* 24. List the models of any type having the highest price of all products present in the database. */

WITH A1 AS 
(SELECT model, price 
FROM PC 
UNION
SELECT model, price 
FROM Laptop 
UNION 
SELECT model, price 
FROM Printer)

SELECT model FROM A1 
WHERE price = (SELECT MAX(price) 
			   FROM A1);
               
/* 25. Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
Result set: maker. */

WITH t AS
(SELECT maker, speed, pc.model 
FROM PC JOIN Product ON pc.model = product.model 
WHERE ram = (SELECT MIN(ram) FROM pc))

SELECT maker 
FROM t 
WHERE speed IN (SELECT MAX(speed) FROM t)
INTERSECT 
SELECT maker FROM Product 
WHERE type = 'Printer';

/* 26. Find out the average price of PCs and laptops produced by maker A.
Result set: one overall average price for all items. */

SELECT AVG(price) 
FROM (SELECT price FROM PC 
      JOIN Product ON pc.model = product.model  
      WHERE maker = 'A'  
      UNION ALL 
      SELECT price FROM Laptop 
      JOIN Product ON laptop.model = product.model 
      WHERE maker = 'A')
t;

/* 27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
Result set: maker, average HDD capacity. */

SELECT maker, AVG(hd) 
FROM Product 
JOIN PC ON product.model = pc.model 
WHERE maker IN (SELECT maker 
				FROM Product 
                WHERE type = 'Printer')
GROUP BY maker;

/* 28. Using Product table, find out the number of makers who produce only one model. */

SELECT COUNT(maker) 
FROM (SELECT COUNT(model) AS ct, maker 
	  FROM Product 
      GROUP BY maker) 
a 
WHERE ct = 1;

/* 29. Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense).
Use Income_o and Outcome_o tables. */

SELECT
CASE WHEN i.point IS NULL THEN o.point
ELSE i.point 
END AS Point,
CASE WHEN i.date IS NULL THEN o.date 
ELSE i.date 
END AS Date,
inc AS Income,
out AS Expense
FROM Income_o i 
FULL JOIN Outcome_o o ON i.point = o.point AND i.date = o.date;

/* 30. Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
Result set: point, date, total payout per day (out), total money intake per day (inc).
Missing values are considered to be NULL. */

SELECT 
CASE 
WHEN a.point IS NULL THEN b.point 
ELSE a.point 
END AS Point,
CASE
WHEN a.date IS NULL THEN b.date
ELSE a.date 
END AS Date,
Total_Payout,
Total_Intake
FROM (SELECT point, date, SUM(out) AS Total_Payout 
      FROM Outcome 
      GROUP BY point, date) a
FULL JOIN (SELECT point, date, SUM(inc) AS Total_Intake 
           FROM Income 
           GROUP BY point, date) b 
ON a.date = b.date AND a.point = b.point;

/* 31. For ship classes with a gun caliber of 16 in. or more, display the class and the country. */

SELECT class, country 
FROM Classes 
WHERE bore >= 16;

/* 32. One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw).
Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database. */

WITH t1 AS (SELECT country, bore, name 
            FROM classes JOIN ships 
            ON classes.class=ships.class
            UNION
            SELECT country, bore, ship AS Name 
            FROM classes JOIN outcomes
            ON classes.class = outcomes.ship)
SELECT country, CAST(AVG(POWER(bore , 3))/2 AS DECIMAL(8,2)) AS mw 
FROM t1 
GROUP BY country;

/* 33. Get the ships sunk in the North Atlantic battle.
Result set: ship. */

SELECT ship 
FROM Outcomes 
WHERE battle = 'North Atlantic' AND result = 'sunk';

/* 34. In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
Get the ships violating this treaty (only consider ships for which the year of launch is known).
List the names of the ships. */

SELECT DISTINCT name 
FROM ships 
JOIN classes ON ships.class = classes.class 
WHERE launched IS NOT NULL 
AND launched >= 1922 
AND displacement > 35000 
AND type = 'bb';

/* 35. Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
Result set: model, type. */

SELECT model, type 
FROM Product 
WHERE model NOT LIKE '%[^0-9]%' 
   OR model NOT LIKE  '%[^A-Z]%' 
   OR model not like '%[^a-z]%';
   
/* 36. List the names of lead ships in the database (including the Outcomes table). */

SELECT name 
FROM Ships 
WHERE name = class
UNION
SELECT ship 
FROM Outcomes 
JOIN classes ON outcomes.ship = classes.class;

/* 37. Find classes for which only one ship exists in the database (including the Outcomes table). */

SELECT * FROM (SELECT class 
               FROM (SELECT DISTINCT name, 
                            class
                     FROM ships) b
               UNION ALL
               SELECT DISTINCT class
               FROM classes
               JOIN outcomes
                ON classes.class=outcomes.ship
               WHERE outcomes.ship NOT IN (SELECT name
                                           FROM ships)
               ) a
GROUP BY class
HAVING COUNT(class)=1;

/* 38. Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’). */

SELECT country 
FROM classes 
WHERE type = 'bb'
INTERSECT
SELECT country 
FROM classes 
WHERE type = 'bC';

/* 39. Find the ships that `survived for future battles`; that is, after being damaged in a battle, they participated in another one, which occurred later. */

SELECT DISTINCT a.ship 
FROM (SELECT * FROM outcomes 
	  JOIN battles ON outcomes.battle = battles.name 
      WHERE result = 'damaged') a
JOIN
	  (SELECT * FROM outcomes 
      JOIN battles ON outcomes.battle = battles.name) b
ON a.ship = b.ship 
WHERE a.date < b.date;

/* 40. Get the makers who produce only one product type and more than one model. Output: maker, type. */

WITH t AS (SELECT maker FROM product 
		   GROUP BY maker
           HAVING COUNT(DISTINCT type) = 1 
           AND COUNT(model) > 1)
SELECT DISTINCT product.maker, product.type 
FROM product 
JOIN t ON product.maker = t.maker;

/* 41. For each maker who has models at least in one of the tables PC, Laptop, or Printer, determine the maximum price for his products.
Output: maker; if there are NULL values among the prices for the products of a given maker, display NULL for this maker, otherwise, the maximum price. */

SELECT DISTINCT maker, CASE WHEN SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE MAX(price) END AS price
FROM Product 
JOIN (SELECT model, price FROM PC
	UNION ALL
	 SELECT model, price FROM Laptop
	UNION ALL
	 SELECT model, price FROM Printer) t
ON product.model = t.model
GROUP BY maker;


/* 42. Find the names of ships sunk at battles, along with the names of the corresponding battles. */

SELECT ship, battle 
FROM outcomes 
WHERE result = 'sunk';

/* 43. Get the battles that occurred in years when no ships were launched into water. */

SELECT name
FROM battles
WHERE DATEPART(YY,DATE) NOT IN (SELECT launched 
								FROM ships 
                                WHERE launched IS NOT NULL);
                                
/* 44. Find all ship names beginning with the letter R. */

SELECT name AS ship_name 
FROM Ships 
WHERE name LIKE 'R%'
UNION 
SELECT ship AS ship_name
FROM Outcomes 
WHERE ship LIKE 'R%';

/* 45. Find all ship names consisting of three or more words (e.g., King George V).
Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces. */

SELECT name AS ship_name 
FROM Ships 
WHERE name LIKE '% % %'
UNION 
SELECT ship AS ship_name 
FROM Outcomes 
WHERE ship LIKE '% % %';

/* 46. For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns. */

SELECT DISTINCT ship, displacement, numguns 
FROM Classes 
LEFT JOIN Ships ON classes.class = ships.class 
RIGHT JOIN Outcomes ON classes.class = outcomes.ship OR ships.name = outcomes.ship 
WHERE battle = 'Guadalcanal';

/* 47. Find the countries that have lost all their ships in battles */

WITH sunkShips AS (SELECT ship
				   FROM outcomes
                   WHERE result = 'sunk'),
countryClass AS (SELECT country,class 
				 FROM classes),
shipsData AS (SELECT DISTINCT a.name AS ship, b.country 
			  FROM ships a
              INNER JOIN countryClass b
			  ON a.class = b.class
              UNION
              SELECT DISTINCT a.ship, b.country
              FROM outcomes a
              INNER JOIN countryClass b
              ON a.ship = b.class)
SELECT country
FROM (SELECT b.country, isnull(a.ship, 'AA') AS Name
	  FROM sunkShips a
      RIGHT JOIN shipsData b ON a.ship = b.ship) A
GROUP BY country
HAVING MIN(name) <> 'AA';

/* 48. Find the ship classes having at least one ship sunk in battles. */

WITH t AS (SELECT ships.name, ships.class 
		   FROM ships 
           JOIN classes ON ships.class = classes.class
           UNION 
           SELECT outcomes.ship, classes.class 
           FROM outcomes 
           JOIN classes ON outcomes.ship = classes.class)
SELECT class FROM classes 
WHERE class IN (SELECT t.class FROM t 
				JOIN outcomes ON t.name = outcomes.ship 
                WHERE outcomes.result = 'sunk');
                
/* 49. Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table). */

WITH t AS (SELECT ships.name, ships.class FROM ships 
		   JOIN classes ON ships.class = classes.class 
           UNION 
           SELECT outcomes.ship, classes.class FROM outcomes 
           JOIN classes ON outcomes.ship = classes.class)
SELECT t.name FROM t 
JOIN classes ON t.class = classes.class 
WHERE bore = 16;

/* 50. Find the battles in which Kongo-class ships from the Ships table were engaged. */

SELECT DISTINCT battle 
FROM outcomes 
WHERE ship IN (SELECT name FROM ships 
			   WHERE class = 'Kongo');
               
/* 51. Find the names of the ships with the largest number of guns among all ships having the same displacement (including ships in the Outcomes table). */

WITH t AS (SELECT name AS ship_name, numGuns, displacement 
		   FROM ships 
           JOIN classes ON ships.class = classes.class
           UNION
           SELECT ship AS ship_name, numGuns, displacement 
           FROM outcomes 
           JOIN classes ON outcomes.ship = classes.class)
SELECT ship_name FROM t 
JOIN (SELECT MAX(numGuns) AS maxnum, displacement 
	  FROM t 
      GROUP BY displacement) a ON t.displacement = a.displacement AND t.numGuns = a.maxnum;
      
/* 52. Determine the names of all ships in the Ships table that can be a Japanese battleship having at least nine main guns with a caliber of less than 19 inches and a displacement of not more than 65 000 tons. */

SELECT name FROM ships 
JOIN classes ON ships.class = classes.class
WHERE (country = 'Japan' OR country IS NULL) 
AND (type = 'bb' OR type IS NULL) 
AND (numGuns >= 9 OR numGuns IS NULL)
AND ( bore < 19 OR bore IS NULL)
AND (displacement <= 65000 OR displacement IS NULL);

/* 53. With a precision of two decimal places, determine the average number of guns for the battleship classes. */

SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(6,2)) 
FROM classes 
WHERE type = 'bb';

/* 54. With a precision of two decimal places, determine the average number of guns for all battleships (including the ones in the Outcomes table). */

WITH t AS (SELECT name AS ship_name, numGuns 
		   FROM ships 
           JOIN classes ON ships.class = classes.class 
           WHERE type = 'bb'
           UNION
           SELECT ship AS ship_name, numGuns 
           FROM outcomes 
           JOIN classes ON outcomes.ship = classes.class 
           WHERE type = 'bb')
SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(6,2)) FROM t;

/* 55. For each class, determine the year the first ship of this class was launched.
If the lead ship’s year of launch is not known, get the minimum year of launch for the ships of this class.
Result set: class, year. */

SELECT Classes.class, 
       CASE WHEN ships.launched IS NULL THEN 
       (SELECT MIN(launched) 
        FROM   Ships 
       WHERE   Ships.class = Classes.class) ELSE Ships.launched END
FROM   Classes LEFT JOIN Ships
ON     Classes.class = Ships.name;

/* 56. For each class, find out the number of ships of this class that were sunk in battles.
Result set: class, number of ships sunk. */

WITH t AS (SELECT class, ship, result 
		   FROM Classes c 
           LEFT JOIN Outcomes o 
           ON o.ship=c.class
	UNION
		   SELECT class, ship, result
           FROM Ships s 
           LEFT JOIN  Outcomes o 
           ON o.ship=s.class OR o.ship=s.name)
SELECT class,
SUM(CASE WHEN result='sunk' THEN 1 ELSE 0 END) 
FROM t
GROUP BY class;

/* 57. For classes having irreparable combat losses and at least three ships in the database, display the name of the class and the number of ships sunk. */

SELECT class, COUNT(*) 
FROM (SELECT class, name FROM ships 
	 UNION 
     SELECT ship AS class, ship AS name 
     FROM outcomes 
     WHERE ship IN (SELECT class FROM classes)) AS a 
JOIN outcomes b ON name = ship 
WHERE result = 'sunk' AND class IN(SELECT class 
								   FROM(SELECT class, name FROM ships 
                                        UNION 
                                        SELECT ship AS class, ship AS name 
                                        FROM outcomes 
                                        WHERE ship IN (SELECT class FROM classes)
									) c 
                                    GROUP BY class HAVING COUNT(*)>=3) 
GROUP BY class;

/* 58. For each product type and maker in the Product table, find out, with a precision of two decimal places, the percentage ratio of the number of models of the actual type produced by the actual maker to the total number of models by this maker.
Result set: maker, product type, the percentage ratio mentioned above. */

SELECT p1.maker, p2.type, CAST(100.0 * (SELECT COUNT(1) 
										FROM product p 
                                        WHERE p.maker = p1.maker AND p.type = p2.type) / 
                                        (SELECT COUNT(1) FROM product p WHERE p.maker = p1.maker) AS NUMERIC(12, 2)) AS ratio 
FROM product p1, product p2 
GROUP BY p1.maker, p2.type;

/* 59. Calculate the cash balance of each buy-back center for the database with money transactions being recorded not more than once a day.
Result set: point, balance. */

SELECT a.point, 
CASE WHEN inc IS NULL THEN 0 ELSE inc END -
CASE WHEN out IS NULL THEN 0 ELSE out END 
FROM ( SELECT point, SUM(inc) AS inc 
	   FROM income_o 
       GROUP BY point) AS a 
FULL JOIN (SELECT point, SUM(out) AS out 
		   FROM outcome_o 
           GROUP BY point) 
AS b ON a.point = b.point;
           
/* 60. For the database with money transactions being recorded not more than once a day, calculate the cash balance of each buy-back center at the beginning of 4/15/2001.
Note: exclude centers not having any records before the specified date.
Result set: point, balance */

SELECT a.point, 
CASE WHEN inc IS NULL THEN 0 ELSE inc END -
CASE WHEN out IS NULL THEN 0 ELSE out END 
FROM (SELECT point, SUM(inc) AS inc 
	  FROM income_o 
      WHERE '20010415' > date 
      GROUP BY point) AS a 
FULL JOIN (SELECT point, SUM(out) AS out 
		   FROM outcome_o 
           WHERE '20010415' > date 
           GROUP BY point) 
AS b on a.point = b.point;

/* 61. For the database with money transactions being recorded not more than once a day, calculate the total cash balance of all buy-back centers.*/

SELECT SUM(CASE WHEN inc IS NULL THEN 0 ELSE inc END -
		   CASE WHEN out IS NULL THEN 0 ELSE out END) AS balance 
FROM (SELECT point, SUM(inc) AS inc 
	  FROM income_o 
      GROUP BY point ) AS a 
FULL JOIN (SELECT point, SUM(out) AS out 
		   FROM outcome_o 
           GROUP BY point) AS b 
ON a.point = b.point;

/* 62. For the database with money transactions being recorded not more than once a day, calculate the total cash balance of all buy-back centers at the beginning of 04/15/2001.*/

SELECT SUM(CASE WHEN inc IS NULL THEN 0 ELSE inc END -
		   CASE WHEN out IS NULL THEN 0 ELSE out END) AS balance 
FROM (SELECT point, SUM(inc) AS inc 
	  FROM income_o 
      WHERE '20010415' > date 
      GROUP BY point ) AS a 
FULL JOIN (SELECT point, SUM(out) AS out 
		   FROM outcome_o 
           WHERE '20010415' > date 
           GROUP BY point) AS b 
ON a.point = b.point;

/* 63. Find the names of different passengers that ever travelled more than once occupying seats with the same number. */

SELECT name FROM passenger 
JOIN pass_in_trip ON passenger.ID_psg = pass_in_trip.ID_psg
GROUP BY passenger.name, passenger.ID_psg
HAVING COUNT(DISTINCT place) < COUNT(*);

/* 64. Using the Income and Outcome tables, determine for each buy-back center the days when it received funds but made no payments, and vice versa.
Result set: point, date, type of operation (inc/out), sum of money per day. */

WITH t AS (SELECT income.point, income.date, SUM(inc) AS total_inc, SUM(out) AS total_out 
		   FROM income 
           LEFT JOIN outcome ON income.point = outcome.point AND income.date = outcome.date
           GROUP BY income.point, income.date
	UNION ALL
		   SELECT outcome.point, outcome.date, SUM(inc), SUM(out) FROM outcome 
           LEFT JOIN income ON income.point = outcome.point AND outcome.date = income.date
           GROUP BY outcome.point, outcome.date
	EXCEPT
		   SELECT income.point, income.date, SUM(inc), SUM(out) FROM income 
           JOIN outcome ON income.point = outcome.point AND income.date = outcome.date
           GROUP BY income.point, income.date)
SELECT point, date, 
	   CASE WHEN total_inc IS NULL THEN 'out' ELSE 'inc' END AS operation, 
       COALESCE(total_inc, total_out) 
FROM t;

/* 65. Number the unique pairs {maker, type} in the Product table, ordering them as follows:
- maker name in ascending order;
- type of product (type) in the order PC, Laptop, Printer.
If a manufacturer produces more than one type of product, its name should be displayed in the first row only;
other rows for THIS manufacturer should contain an empty string (').*/

SELECT ROW_NUMBER() OVER(ORDER BY maker,
	                     CASE WHEN type LIKE 'pc' THEN 1 
                         WHEN type LIKE 'laptop' THEN 2 
                         ELSE 3 END) AS num, 
CASE WHEN ROW_NUMBER() OVER(PARTITION BY maker ORDER BY maker) <> 1 THEN '' 
ELSE maker END AS maker , type 
FROM (SELECT DISTINCT maker, type FROM product) AS a;

/* 66. For all days between 2003-04-01 and 2003-04-07 find the number of trips from Rostov with passengers aboard.
Result set: date, number of trips. */

WITH a AS (
SELECT CAST('2003-04-01 00:00:00.000' AS DATETIME) AS date
UNION
SELECT CAST('2003-04-02 00:00:00.000' AS DATETIME) AS date
UNION
SELECT CAST('2003-04-03 00:00:00.000' AS DATETIME) AS date
UNION
SELECT CAST('2003-04-04 00:00:00.000' AS DATETIME) AS date
UNION
SELECT CAST('2003-04-05 00:00:00.000' AS DATETIME) AS date
UNION
SELECT CAST('2003-04-06 00:00:00.000' AS DATETIME) AS date
UNION
SELECT CAST('2003-04-07 00:00:00.000' AS DATETIME) AS date)

SELECT a.date,
	  (SELECT COUNT(DISTINCT tp.trip_no) 
      FROM pass_in_trip tp, trip t 
      WHERE TP.TRIP_NO = T.TRIP_NO 
      AND TP.DATE = a.date 
      AND T.town_from = 'Rostov') AS number_of_trip
FROM a;

/* 67. Find out the number of routes with the greatest number of flights (trips).
Notes.
1) A - B and B - A are to be considered DIFFERENT routes.
2) Use the Trip table only. */

WITH c AS (SELECT COUNT(*) AS number_of_routs 
		   FROM Trip
           GROUP BY town_from, town_to)
SELECT COUNT(*)
FROM c
WHERE number_of_routs = (SELECT MAX(number_of_routs) FROM c);

/* 68. Find out the number of routes with the greatest number of flights (trips).
Notes.
1) A - B and B - A are to be considered the SAME route.
2) Use the Trip table only. */

SELECT COUNT(*) 
FROM (SELECT TOP 1 WITH TIES SUM(c) cc, c1, c2 
	  FROM (SELECT COUNT(*) c, town_from c1, town_to c2 
			FROM trip 
			WHERE town_from >= town_to 
			GROUP BY town_from, town_to 
		UNION ALL 
			SELECT COUNT(*) c, town_to, town_from 
			FROM trip 
            WHERE town_to > town_from 
			GROUP BY town_from, town_to) AS t 
			GROUP BY c1,c2 
	  ORDER BY cc DESC) AS tt;
      
/* 69. Using the Income and Outcome tables, find out the balance for each buy-back center by the end of each day when funds were received or payments were made.
Note that the cash isn’t withdrawn, and the unspent balance/debt is carried forward to the next day.
Result set: buy-back center ID (point), date in dd/mm/yyyy format, unspent balance/debt by the end of this day. */

WITH base AS (SELECT point, date, inc 
			  FROM income 
		UNION ALL 
			  SELECT point, date, -out 
              FROM outcome) 
SELECT DISTINCT bs.point, 
	   CONVERT(varchar(10), bs.date, 103) day,
       (SELECT SUM(inc) FROM base WHERE date <= bs.date AND point = bs.point) rem 
FROM base bs;

/* 70. Get the battles in which at least three ships from the same country took part */

SELECT DISTINCT outcomes.battle 
FROM outcomes 
LEFT JOIN ships ON ships.name = outcomes.ship
LEFT JOIN classes ON classes.class = outcomes.ship OR ships.class = classes.class
WHERE classes.country IS NOT NULL
GROUP BY classes.country, outcomes.battle
HAVING COUNT(outcomes.ship) >= 3;

/* 71. Find the PC makers with all personal computer models produced by them being present in the PC table. */

SELECT maker FROM product 
LEFT JOIN pc ON pc.model = product.model 
WHERE product.type = 'pc'
GROUP BY  product.maker
HAVING COUNT(product.model) = COUNT(pc.model);

/* 72. Among the customers using a single airline, find distinct passengers who have flown most frequently. Result set: passenger name, number of trips.*/

WITH t AS (SELECT id_psg, COUNT(pit.trip_no) AS trip_qty, 
		   MAX(COUNT(pit.trip_no)) OVER () AS max_trip 
           FROM trip 
           JOIN pass_in_trip pit ON trip.trip_no = pit.trip_no 
           GROUP BY id_psg 
           HAVING COUNT(DISTINCT trip.id_comp) = 1)
SELECT (SELECT name FROM passenger 
		WHERE id_psg = t.id_psg) AS name, trip_qty 
FROM t WHERE trip_qty = max_trip;

/* 73. For each country, determine the battles in which the ships of this country did not participate.
Result set: country, battle. */

WITH t1 AS (SELECT c.country, o.battle 
			FROM classes c, outcomes o 
            WHERE c.class = o.ship 
		UNION
			SELECT c.country, o.battle 
            FROM classes c, ships s, outcomes o
			WHERE c.class = s.class 
            AND s.name = o.ship) 
SELECT DISTINCT country, b.name FROM classes c, battles b 
WHERE(SELECT COUNT(1) FROM t1 
	  WHERE t1.country = c.country AND t1.battle = b.name) = 0;
      
/* 74. Get all ship classes of Russia. If there are no Russian ship classes in the database, display classes of all countries present in the DB.
Result set: country, class. */

SELECT  country, class
FROM classes
WHERE country = ALL (SELECT   country
					FROM classes
					WHERE country = 'Russia');
                    
/* 75. For makers who have products with a known price in at least one of the Laptop, PC, or Printer tables, find the maximum price for each product type.
Output: maker, maximum price of laptops, maximum price of PCs, maximum price of printers. For missing products/prices, use NULL. */

SELECT maker, MAX(laptop.price) AS laptop, MAX(pc.price) AS pc, MAX(printer.price) AS Printer 
FROM product 
LEFT JOIN pc ON product.model = pc.model 
LEFT JOIN laptop ON product.model = laptop.model 
LEFT JOIN printer ON product.model = printer.model 
GROUP BY maker
HAVING MAX(laptop.price) IS NOT NULL
OR MAX(pc.price) IS NOT NULL
OR MAX(printer.price) IS NOT NULL;

/* 76. Find the overall flight duration for passengers who never occupied the same seat.
Result set: passenger name, flight duration in minutes. */

WITH pf AS (SELECT id_psg, COUNT(*) AS place_count
			FROM pass_in_trip
            GROUP BY id_psg, place),
pt AS (SELECT pt.id_psg, pt.trip_no, ps.name, time_out, time_in, 
	   CASE WHEN time_out >= time_in
			THEN time_in-time_out + 1440
			ELSE time_in-time_out
			END AS time
	   FROM pass_in_trip pt
	   JOIN passenger ps ON ps.id_psg=pt.id_psg
			JOIN (SELECT datepart(hh, time_out)*60 + datepart(mi, time_out) time_out, 
						 datepart(hh, time_in)*60 + datepart(mi, time_in) time_in,
                         trip_no
				  FROM trip t) AS t ON t.trip_no=pt.trip_no
                  WHERE 1 = ALL (SELECT place_count FROM pf 
								 WHERE pf.id_psg=pt.id_psg))
SELECT name, SUM(time) fly_time
FROM pt
GROUP BY id_psg, name;

/* 77. Find the days with the maximum number of flights departed from Rostov. Result set: number of trips, date. */

WITH a AS (SELECT COUNT(DISTINCT t.trip_no) AS trip_count, pt.date
		   FROM trip t, pass_in_trip pt
           WHERE t.trip_no=pt.trip_no
           AND town_from='Rostov'
           GROUP BY date)
SELECT trip_count, date FROM a
WHERE trip_count = (SELECT MAX(trip_count) FROM a);

/* 78. For each battle, get the first and the last day of the month when the battle occurred.
Result set: battle name, first day of the month, last day of the month.
Note: output dates in yyyy-mm-dd format.*/

SELECT name, DATEADD(day, 1, EOMONTH(DATEADD(month, -1, date))) first_day, EOMONTH(date) last_day 
FROM battles;

/* 79. Get the passengers who, compared to others, spent most time flying.
Result set: passenger name, total flight duration in minutes.*/

WITH pass_time AS (SELECT pt.id_psg, 
						  SUM(CASE WHEN time_out >= time_in THEN DATEDIFF(mi, time_out, time_in) + 1440
                              ELSE DATEDIFF(mi,time_out, time_in) 
                              END) AS trip_time
				   FROM pass_in_trip pt 
                   JOIN trip t ON t.trip_no=pt.trip_no
                   GROUP BY id_psg)
SELECT p.name, trip_time
FROM pass_time pt 
JOIN passenger p ON pt.id_psg=p.id_psg
WHERE trip_time = (SELECT MAX(trip_time) FROM pass_time);

/* 80. Find the computer equipment makers not producing any PC models absent in the PC table. */

SELECT maker FROM product
EXCEPT
SELECT maker FROM product
WHERE type='pc' AND model NOT IN (SELECT model FROM pc);

/* 81. For each month-year combination with the maximum sum of payments (out), retrieve all records from the Outcome table. */

WITH a AS (SELECT *, SUM(out) OVER (PARTITION BY YEAR(date), MONTH(date)) AS month_out 
		   from outcome)
SELECT code, point, date, out 
FROM a WHERE month_out = (SELECT MAX(month_out) FROM a);

/* 82. Assuming the PC table is sorted by code in ascending order, find the average price for each group of six consecutive personal computers.
Result set: the first code value in a set of six records, average price for the respective set. */

SELECT TOP((SELECT COUNT(code) FROM pc) - 5) code, 
				   AVG(price) OVER (ORDER BY code ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING) AS 'avgprc'
FROM pc;

/* 83. Find out the names of the ships in the Ships table that meet at least four criteria from the following list:
numGuns = 8, bore = 15, displacement = 32000, type = bb, launched = 1915, class = Kongo, country = USA. */

WITH t AS (SELECT name,
				  CASE numGuns WHEN 8 THEN 1 ELSE 0 END AS a,
                  CASE bore WHEN 15 THEN 1 ELSE 0 END AS b,
                  CASE displacement WHEN 32000 THEN 1 ELSE 0 END AS c,
                  CASE type WHEN 'bb' THEN 1 ELSE 0 END AS d,
                  CASE launched WHEN 1915 THEN 1 ELSE 0 END AS e,
                  CASE classes.class WHEN 'Kongo' THEN 1 ELSE 0 END AS f,
                  CASE country WHEN 'USA' THEN 1 ELSE 0 END AS g 
           FROM ships 
           JOIN classes ON ships.class = classes.class)
SELECT name FROM t 
WHERE (a+b+c+d+e+f+g) >= 4;

/* 84. For each airline, calculate the number of passengers carried in April 2003 (if there were any) by ten-day periods. Consider only flights that departed that month.
Result set: company name, number of passengers carried for each ten-day period. */

SELECT company.name, 
	   SUM(IIF(DAY(date) < 11, 1, 0)) AS d1, 
       SUM(IIF(DAY(date) < 21 AND DAY(date) > 10, 1, 0)) AS d2, 
       SUM(IIF(DAY(date) > 20, 1, 0)) AS d3
FROM pass_in_trip 
JOIN trip ON pass_in_trip.trip_no = trip.trip_no 
JOIN company ON company.id_comp = trip.id_comp 
WHERE YEAR(pass_in_trip.date) = 2003 AND MONTH(pass_in_trip.date) = 4 
GROUP BY company.name;

/* 85. Get makers producing either printers only or personal computers only; in case of PC manufacturers they should produce at least 3 models.*/

SELECT maker FROM Product 
WHERE type = 'printer'
EXCEPT
SELECT maker FROM product 
WHERE type != 'printer'
UNION (SELECT maker FROM product 
	   WHERE type = 'pc'
       GROUP BY maker
       HAVING COUNT(model) >= 3
	EXCEPT 
       SELECT maker FROM product 
       WHERE type != 'pc');
       
/* 86. For each maker, list the types of products he produces in alphabetic order, using a slash ("/") as a delimiter.
Result set: maker, list of product types. */

SELECT maker, STRING_AGG(type, '/')
FROM (SELECT maker, type 
	  FROM Product 
      GROUP BY maker, type) AS A
GROUP BY maker;

/* 87. Supposing a passenger lives in the town his first flight departs from, find non-Muscovites who have visited Moscow more than once.
Result set: passenger's name, number of visits to Moscow.*/

WITH t AS (SELECT trip.trip_no, id_psg, town_from, town_to, time_out, 
				  RANK() OVER (PARTITION BY id_psg ORDER BY date+time_out) AS trip_num
		   FROM trip 
           INNER JOIN pass_in_trip ON trip.trip_no = pass_in_trip.trip_no),
pass_list AS (SELECT id_psg FROM t 
			  WHERE trip_num = 1 AND town_from != 'Moscow'),
final_list AS (SELECT id_psg, COUNT(trip_no) AS qty FROM t 
			   WHERE town_to = 'Moscow'
               GROUP BY id_psg
               HAVING id_psg IN (SELECT * FROM pass_list) AND COUNT(trip_no) > 1)
SELECT name, qty 
FROM final_list  
INNER JOIN passenger ON passenger.id_psg = final_list.id_psg;

/* 88. Among those flying with a single airline find the names of different passengers who have flown most often.
Result set: passenger name, number of trips, and airline name.*/

WITH cte AS (SELECT ID_psg, COUNT(pit.trip_no) AS qty, MIN(ID_comp) AS ID_comp, MAX(COUNT(pit.trip_no)) OVER() AS maxqty
			 FROM Trip AS t
             JOIN Pass_in_trip AS pit ON t.trip_no = pit.trip_no
             GROUP BY pit.ID_psg
             HAVING MAX(ID_comp) = MIN(ID_comp))
SELECT (SELECT name FROM Passenger WHERE ID_psg = cte.ID_psg), 
	  qty, 
	  (SELECT name FROM company WHERE ID_comp = cte.ID_comp)
FROM cte
WHERE qty = maxqty;

/* 89. Get makers having most models in the Product table, as well as those having least.
Output: maker, number of models. */

WITH s AS (SELECT maker, COUNT(model) qty 
		   FROM product 
           GROUP BY maker)
SELECT maker, qty FROM  s
WHERE qty = (SELECT MAX(qty) FROM s) OR qty = (SELECT MIN(qty) FROM s);

/* 90. Display all records from the Product table except for three rows with the smallest model numbers and three ones with the greatest model numbers.*/

SELECT maker, model, type 
FROM (SELECT maker, model, type,
	 ROW_NUMBER() OVER(ORDER BY model) first,
	 ROW_NUMBER() OVER(ORDER BY model DESC) second
	 FROM Product) R
WHERE first > 3 AND second > 3;

/* 91. Determine the average quantity of paint per square with an accuracy of two decimal places. */

SELECT
    ISNULL(CAST((SUM(B_VOL * 1.0) / (SELECT COUNT(*) FROM utQ)) AS decimal(6,2)), 0) avg_paint
FROM
    utB

/* 92. Get all white squares that have been painted only with spray cans empty at present.
Output the square names. */

SELECT q_name FROM utq 
WHERE q_id IN (SELECT DISTINCT b.b_q_id 
			  FROM (SELECT b_q_id FROM utb 
					GROUP BY b_q_id 
                    HAVING SUM(b_vol) = 765) AS b 
                    WHERE b.b_q_id NOT IN (SELECT b_q_id FROM utb 
										   WHERE b_v_id IN (SELECT b_v_id FROM utb 
															GROUP BY b_v_id 
                                                            HAVING SUM(b_vol) < 255)));
                                                            
/* 93. For each airline that transported passengers calculate the total flight duration of its planes.
Result set: company name, duration in minutes. */

WITH t AS (SELECT DISTINCT trip.id_comp, name, trip.trip_no, date, time_out, time_in 
		   FROM trip 
           JOIN pass_in_trip ON trip.trip_no = pass_in_trip.trip_no 
           JOIN company ON company.id_comp = trip.id_comp)
SELECT name, SUM(CASE WHEN DATEDIFF(MINUTE, time_out, time_in) < 0 THEN DATEDIFF(MINUTE, time_out, time_in) + 1440 
				 ELSE DATEDIFF(MINUTE, time_out, time_in) END) AS minutes 
FROM t 
GROUP BY name;

/* 94. For seven successive days starting with the earliest date when the number of departures from Rostov was maximal, get the number of flights departed from Rostov.
Result set: date, number of flights. */

WITH qty_dt AS (SELECT pit.date, COUNT(DISTINCT pit.trip_no) AS qty 
			    FROM pass_in_trip pit 
                JOIN trip ON pit.trip_no = trip.trip_no 
                WHERE town_from = 'Rostov' 
                GROUP BY pit.date),
start_date AS (SELECT MIN(date) AS ref_date 
			   FROM qty_dt 
               WHERE qty IN (SELECT MAX(qty) FROM qty_dt)),
date_all AS (SELECT DATEADD(dd, days.id, x.ref_date) dt 
			FROM (SELECT 0 id UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) days,  
				 (SELECT MIN(date) AS ref_date FROM qty_dt WHERE qty IN (SELECT MAX(qty) FROM qty_dt)) x)
SELECT dt, 
	   CASE WHEN qty IS NULL THEN 0 ELSE qty END AS qty_2 
FROM date_all 
LEFT JOIN qty_dt ON date_all.dt = qty_dt.date;

/* 95. Using the Pass_in_Trip table, calculate for each airline:
1) the number of performed flights;
2) the number of plane types used;
3) the number of different passengers that have been transported;
4) the total number of passengers that have been transported by the company.
Output: airline name, 1), 2), 3), 4). */

WITH t1 AS (SELECT pit.trip_no, date, id_psg, trip.id_comp, plane, time_out, name 
			FROM pass_in_trip pit 
            LEFT JOIN trip ON pit.trip_no = trip.trip_no 
            LEFT JOIN company ON trip.id_comp = company.id_comp),
f2 AS (SELECT name, SUM(f_1) AS flights 
	   FROM (SELECT name, COUNT(DISTINCT trip_no) AS f_1 FROM t1 
		     GROUP BY name, date) t2 
	   GROUP BY name)
SELECT t1.name, flights, COUNT(DISTINCT t1.plane) AS planes, COUNT(DISTINCT t1.id_psg) AS diff_psg, COUNT(t1.id_psg) AS total_psg 
FROM t1 
JOIN f2 ON t1.name = f2.name 
GROUP BY t1.name, flights;

/* 96. Considering only red spray cans used more than once, get those that painted squares currently having a non-zero blue component.
Result set: spray can name. */

WITH A AS (
    SELECT * FROM utB
	JOIN utV ON V_ID = B_V_ID)
SELECT V_NAME
FROM A
WHERE V_ID IN (SELECT B_V_ID FROM A
			   GROUP BY B_V_ID, V_COLOR
               HAVING V_COLOR = 'R'
               AND COUNT(B_VOL) >  1) 
AND B_Q_ID IN (SELECT B_Q_ID FROM A
			   WHERE V_COLOR = 'B')
GROUP BY v_name;

/* 97.From the Laptop table, select rows fulfilling the following condition:
the values of the speed, ram, price, and screen columns can be arranged in such a way that each successive value exceeds two or more times the previous one.
Note: all known laptop characteristics are greater than zero.
Output: code, speed, ram, price, screen. */

WITH base AS (SELECT code, name, value, ROW_NUMBER() OVER(PARTITION BY code ORDER BY value) n FROM Laptop
             CROSS APPLY
             (VALUES('speed', speed),
             ('ram', ram),
             ('price', price),
             ('screen', screen)) spec(name, value)),
pivoted AS (SELECT [code],[1]a,[2]b,[3]c,[4]d
			FROM (SELECT code, n, value FROM base) x
		PIVOT
			(MIN(value) FOR n IN([1],[2],[3],[4])) pvt),
validation AS (SELECT code FROM pivoted
			   WHERE a*2 <= b AND b*2 <= c AND c*2 <= d)

SELECT code, speed, ram, price, screen 
FROM Laptop
WHERE code IN (SELECT code FROM validation);

/* 98. Display the list of PCs, for each of which the result of the bitwise OR operation performed on the binary representations of its respective processor speed and RAM capacity contains a sequence of at least four consecutive bits set to 1.
Result set: PC code, processor speed, RAM capacity. */

WITH binaries AS (SELECT code, ram, speed, CAST(ram | speed AS INT) bin_, CAST('' AS VARCHAR(max)) bin
				  FROM pc
			union all
				  SELECT code, ram, speed, bin_ / 2, CAST(bin_ % 2 AS VARCHAR(max)) + bin
                  FROM binaries
                  WHERE bin_ >  0)
SELECT DISTINCT code, speed, ram
FROM binaries 
WHERE bin LIKE '%1111%';

/* 100. Write a query that displays all operations from the Income and Outcome tables as follows:
date, sequential record number for this date, buy-back center receiving funds, funds received, buy-back center making a payment, payment amount.
All revenue transactions for all centers made during a single day are ordered by the code field, and so are all expense transactions.
If the numbers of revenue and expense transactions are different for a day, display NULL in the corresponding columns for missing operations. */

WITH a1 AS (SELECT date, ROW_NUMBER() OVER(PARTITION BY date ORDER BY date, code) num, point, inc FROM income i),

a2 AS (SELECT date, ROW_NUMBER() OVER(PARTITION BY date ORDER BY date, code) num, point, out FROM outcome o)

SELECT COALESCE(a1.date, a2.date) date, COALESCE(a1.num, a2.num), a1.point, inc, a2.point, out 
FROM a1 
FULL JOIN a2 ON a1.date = a2.date AND a1.num = a2.num;

/* 101. The Printer table is sorted by the code field in ascending order.
The ordered rows form groups: the first group starts with the first row, each row having color=’n’ begins a new group, the groups of rows don’t overlap.
For each group, determine the maximum value of the model field (max_model), the number of unique printer types (distinct_types_cou), and the average price (avg_price).
For all table rows, display code, model, color, type, price, max_model, distinct_types_cou, avg_price. */

WITH result AS (SELECT code, model, color, SUM(CASE WHEN color = 'n' THEN 1 ELSE 0 END) OVER (ORDER BY code) no, type, price 
				FROM Printer) 
SELECT code, model, color, type, price, MAX(model) OVER(PARTITION BY r.no) max_model, cnt, AVG(price) OVER(PARTITION BY r.no) avg_price
FROM result r
JOIN (SELECT no, COUNT(DISTINCT type) cnt FROM result 
	  GROUP BY no) AS a ON r.no = a.no
ORDER BY code;

/* 102. Find the names of different passengers who travelled between two towns only (one way or back and forth). */

SELECT p.name 
FROM Passenger p
WHERE p.ID_psg IN (SELECT pit.ID_psg 
				   FROM (SELECT trip_no, town_from AS town 
						FROM Trip 
					 UNION ALL 
						SELECT trip_no, town_to AS town 
                        from Trip) t
				   JOIN Pass_in_trip pit ON pit.trip_no = t.trip_no
                   GROUP BY pit.ID_psg 
                   HAVING COUNT(DISTINCT t.town) = 2);
                   
/* 103. Find out the three smallest and three greatest trip numbers. Output them in a single row with six columns, ordered from the least trip number to the greatest one.
Note: it is assumed the Trip table contains 6 or more rows. */

SELECT MIN(trip_no) AS min1, 
	   (SELECT MIN(trip_no) FROM Trip WHERE trip_no > (SELECT MIN(trip_no) FROM Trip)) AS min2,
       (SELECT MIN(trip_no) FROM Trip WHERE trip_no > (SELECT MIN(trip_no) FROM Trip WHERE trip_no > (SELECT MIN(trip_no) FROM Trip))) AS min3, 
       (SELECT MAX(trip_no) FROM Trip WHERE trip_no < (SELECT MAX(trip_no) FROM Trip WHERE trip_no < (SELECT MAX(trip_no) FROM Trip))) AS max3 ,
       (SELECT MAX(trip_no) FROM Trip WHERE trip_no < (SELECT MAX(trip_no) FROM Trip)) AS max2, 
       MAX(trip_no) as max1
FROM Trip

/* 104. For each cruiser class whose quantity of guns is known, number its guns sequentially beginning with 1.
Output: class name, gun ordinal number in 'bc-N' style.*/

WITH x AS (SELECT class, numGuns, 1 i FROM classes 
		   WHERE type = 'bc' AND numGuns IS NOT NULL
		UNION ALL
		  SELECT class, numGuns, i + 1 FROM x 
          WHERE   i != numGuns)
SELECT class, CONCAT('bc-', i) num FROM x
ORDER BY class, i;

/* 105. Statisticians Alice, Betty, Carol and Diana are numbering rows in the Product table.
Initially, all of them have sorted the table rows in ascending order by the names of the makers.
Alice assigns a new number to each row, sorting the rows belonging to the same maker by model in ascending order.
The other three statisticians assign identical numbers to all rows having the same maker.
Betty assigns the numbers starting with one, increasing the number by 1 for each next maker.
Carol gives a maker the same number the row with this maker's first model receives from Alice.
Diana assigns a maker the same number the row with this maker's last model receives from Alice.
Output: maker, model, row numbers assigned by Alice, Betty, Carol, and Diana respectively. */

SELECT maker, 
	   model,
       ROW_NUMBER() OVER(ORDER BY maker, model) AS A,
       DENSE_RANK() OVER(ORDER BY maker) AS B, 
       RANK() OVER(ORDER BY maker) AS C, 
       SUM(1) OVER(ORDER BY maker) AS D
FROM product;

/* 106. Let v1, v2, v3, v4, ... be a sequence of real numbers corresponding to paint amounts b_vol, sorted by b_datetime, b_q_id, and b_v_id in ascending order.
Find the transformed sequence P1=v1, P2=v1/v2, P3=v1/v2*v3, P4=v1/v2*v3/v4, ..., where each subsequent member is obtained from the preceding one by either multiplication by vi (for an odd i) or division by vi (for an even i).
Output the result as b_datetime, b_q_id, b_v_id, b_vol, Pi, with Pi being the member of the sequence corresponding to the record number i. Display Pi with eight decimal places.*/

WITH CTE AS (
    SELECT B_DATETIME, B_Q_ID, B_V_ID, B_VOL, 
           CAST(B_VOL AS FLOAT) AS sv, 
           ROW_NUMBER() OVER(ORDER BY B_DATETIME, B_Q_ID, B_V_ID) AS rn
    FROM utB),
RecursiveCTE AS (
    SELECT B_DATETIME, B_Q_ID, B_V_ID, B_VOL, sv, rn
    FROM CTE
    WHERE rn = 1
    UNION ALL
    SELECT C.B_DATETIME, C.B_Q_ID, C.B_V_ID, C.B_VOL,
           CASE 
               WHEN C.rn%2 = 0 THEN R.sv / C.B_VOL
               ELSE R.sv * C.B_VOL
           END AS sv, 
           C.rn
    FROM CTE C
    INNER JOIN RecursiveCTE R ON C.rn = R.rn + 1)
SELECT B_DATETIME, B_Q_ID, B_V_ID, B_VOL, 
       CAST(sv AS DECIMAL(18,8)) AS sv
FROM RecursiveCTE
ORDER BY B_DATETIME, B_Q_ID, B_V_ID
OPTION (MAXRECURSION 0);

/* 107. Find the company, trip number, and trip date for the fifth passenger from among those who have departed from Rostov in April 2003.
Note. For this exercise it is assumed two flights can’t depart from Rostov simultaneously. */

SELECT Company.name, pit.trip_no, date
FROM PASS_in_trip pit
JOIN Trip ON Trip.trip_no = pit.trip_no
JOIN Company ON Company.ID_Comp = Trip.ID_Comp
WHERE CAST(CAST(pit.date AS date) AS VARCHAR(10)) LIKE '2003-04%'
AND trip.town_from = 'Rostov'
ORDER BY pit.date, trip.time_out ASC OFFSET 4 ROW FETCH FIRST  1 ROW ONLY;

/* 110. Find out the names of different passengers who ever travelled on a flight that took off on Saturday and landed on Sunday.*/

SELECT name 
FROM passenger 
WHERE id_psg IN (SELECT id_psg FROM pass_in_trip pit 
				JOIN trip t ON pit.trip_no = t.trip_no 
                WHERE time_in < time_out AND datepart(dw, date) = 7);
                
/* 113. How much paint of each color is needed to dye all squares white?
Result set: amount of each paint in order (R,G,B). */

SELECT
	COUNT(DISTINCT utQ.Q_ID) * 255 -  SUM(CASE WHEN utV.V_COLOR = 'R' THEN utB.B_VOL ELSE 0 END),
	COUNT(DISTINCT utQ.Q_ID) * 255 -  SUM(CASE WHEN utV.V_COLOR = 'G' THEN utB.B_VOL ELSE 0 END),
	COUNT(DISTINCT utQ.Q_ID) * 255 -  SUM(CASE WHEN utV.V_COLOR = 'B' THEN utB.B_VOL ELSE 0 END)
FROM utQ 
LEFT JOIN utB ON utB.B_Q_ID = utQ.Q_ID
LEFT JOIN utV ON utV.V_ID = utB.B_V_ID;
