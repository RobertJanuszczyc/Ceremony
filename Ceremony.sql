DROP DATABASE Ceremony;
CREATE DATABASE IF NOT EXISTS Ceremony; 
USE Ceremony;
DROP TABLE IF EXISTS Ceremony;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Planner;
DROP TABLE IF EXISTS Hall;

CREATE TABLE Customer (
customer_id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(25) NOT NULL,
last_name VARCHAR(25) NOT NULL,
phone_number INT(9) NOT NULL,
email_address VARCHAR(25),
gender ENUM('M', 'F') NOT NULL
);

CREATE TABLE Ceremony(
ceremony_number VARCHAR(4) PRIMARY KEY NOT NULL,
type_of_ceremony VARCHAR(25) NOT NULL,
number_of_people INT(11) NOT NULL,
cost DECIMAL(7,2) NOT NULL,
ceremony_date DATE NOT NULL,
customer_id INT(11) NOT NULL,
planner_id INT(11) NOT NULL,
FOREIGN KEY (customer_id) references Customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE Hall(
hall_id VARCHAR(4) PRIMARY KEY,
hall_name VARCHAR(25) NOT NULL,
reception_phone_number INT(9),
address VARCHAR(25)
);

CREATE TABLE Planner(
planner_id INT(11) PRIMARY KEY AUTO_INCREMENT,
p_first_name VARCHAR(25) NOT NULL,
p_last_name VARCHAR(25) NOT NULL,
p_phone_number INT(9) NOT NULL,
hall_id VARCHAR(4) NOT NULL,
FOREIGN KEY(hall_id) references Hall(hall_id) ON DELETE CASCADE
);





INSERT INTO Customer (first_name, last_name, phone_number, email_address, gender)
VALUES ('Jan' , 'Kowalski', 601123121 , 'jankowalski@gmail.com', 'M' ),
		('Piotr' , 'Nowak', 602123122 , 'piotrnowak@gmail.com', 'M' ),
        ('Klaudia' , 'Bąk', 603123123 , 'klaudiabak@gmail.com', 'F' ),
        ('Joanna' , 'Kot', 604123124 , 'joannakot@gmail.com', 'F' ),
        ('Katarzyna' , 'Miodek', 605123125 , 'katarzynamiodek@wp.pl', 'F' ),
        ('Robert' , 'Latkowski', 606123126 , 'robertlatkowski@wp.pl', 'F' ),
        ('Barbara' , 'Korzeń', 607123127 , 'barbarakorzeń@gmail.com', 'F' ),
        ('Zbigniew' , 'Borkowski', 608123128 , 'zbigniewborkowski@wp.pl', 'M' ),
        ('Marek' , 'Konrad', 609123129 , 'marekkonrad@wp.pl', 'M' ),
        ('Alicja' , 'Piorun', 600123120 , 'alicjapiorun@gmail.com', 'F' );

INSERT INTO Ceremony 
VALUES ('c001' , 'Wedding', 120, 60000 , '2023-06-01', 1, 5),
		('c002' , 'Birthday', 40, 20000 , '2023-07-01', 2, 4),
        ('c003' , 'Wedding', 140, 70000 , '2023-08-01', 3, 3),
        ('c004' , 'Wedding', 160, 80000 , '2023-09-01', 4, 2),
        ('c005' , 'Wake', 80, 40000 , '2023-05-01', 5, 1),
        ('c006' , 'Wake', 70, 35000 , '2024-04-01', 6, 5),
        ('c007' , 'Birthday', 50, 25000 , '2024-06-15', 7, 4),
        ('c008' , 'Prom', 40, 20000 , '2024-05-15', 8, 3),
        ('c009' , 'Birthday', 30, 15000 , '2024-07-15', 9, 2),
        ('c010' , 'Prom', 50, 25000 , '2024-08-15', 10, 1);
        
     
        
INSERT INTO Hall 
VALUES ('h001' , 'Napoleonski', 654209871, 'Struga 20a'),
	('h002' , 'Arkadia', 654219371, 'Marsa 29b'),
	('h003' , 'Sekowski', 654809271, 'Gwiezdna 15'),
	('h004' , 'Qubus', 754209821, 'Fiolkowa 25d'),
	('h005' , 'Kmieniczka', 854206871, 'Ksawerego 87b');
            
INSERT INTO Planner (p_first_name, p_last_name, p_phone_number, hall_id)
VALUES 	('Piotr' , 'Bindas' , 678923452, 'h001'),
		('Jan' , 'Kochanek' , 230987624, 'h002'),
		('Patryk' , 'Fiołek' , 871296172, 'h003'),
		('Krzysztof' , 'Bindas' , 761289345, 'h004'),
		('Kondrad' , 'Rozenek' , 739812398, 'h005');
        
       
/* poprawienie wartości w kolumnie gender */
UPDATE Customer
SET
gender = 'M'
WHERE 
first_name = 'Robert' AND last_name = 'Latkowski';
        
        
        
        
/* zebranie najważniejszych informacji ze wszystkich tabel znajdujących się w bazie danych  */
SELECT 
c.first_name AS customer_name,
c.last_name AS customer_surname,
c.phone_number AS customer_phone_number,
ce.type_of_ceremony,
ce.ceremony_date,
ce.number_of_people,
ce.cost AS cermony_cost,
p.p_first_name AS planner_name,
p.p_last_name AS planner_surname,
p.p_phone_number AS planner_phone_number,
h.hall_name
FROM
ceremony ce
	JOIN
customer c ON ce.customer_id = c.customer_id
	JOIN
planner p ON ce.planner_id = p.planner_id
	JOIN
hall h ON p.hall_id = h.hall_id
ORDER BY ce.ceremony_date;
   
/* ekstracja infromacji na temat klientów znajdujących się na 3 i 4 pozycji pod względem wysokości poniesionych kosztów  */
SELECT c.first_name AS customer_name, c.last_name AS customer_surname, ce.cost AS ceremony_cost
FROM customer c
JOIN ceremony ce
ON c.customer_id = ce.customer_id
ORDER BY ceremony_cost DESC
LIMIT 2 OFFSET 2;    
    
    
/* określenie ilości wystąpień każdego rodzaju uroczystości  */ 
SELECT ce.type_of_ceremony, COUNT(ce.type_of_ceremony) AS number_of_ceremony
FROM ceremony ce
GROUP BY ce.type_of_ceremony
ORDER BY number_of_ceremony;
	
/* zestawienie maksymalnych i minimalnych kosztów oraz różnicy między nimi dla każdego typu ceremonii  */ 
SELECT ce.type_of_ceremony, ROUND(MAX(ce.cost), 2) AS max_cost, ROUND(MIN(ce.cost), 2) AS min_cost, ROUND(MAX(ce.cost) - MIN(ce.cost), 2) AS difference_cost
FROM ceremony ce
GROUP BY ce.type_of_ceremony
ORDER BY max_cost DESC;
    
/* przedstawienie ilości uroczystości weselnych pogrupowanych według dat tylko w roku 2023 */ 
SELECT 
ce.type_of_ceremony,
COUNT(ce.type_of_ceremony) AS number_of_weedings,
ce.ceremony_date,
p.p_first_name AS planner_name,
p.p_last_name AS planner_surname,
h.hall_name
FROM Ceremony ce
JOIN
Planner p
ON ce.planner_id = p.planner_id
JOIN 
Hall h
ON p.hall_id = h.hall_id
WHERE ce.ceremony_date < '2024-01-01' AND ce.type_of_ceremony = 'Wedding'
GROUP BY ce.ceremony_date;
    
    
/* zestawienie średniego kosztu dla każdego rodzaju uroczystości */ 
SELECT ce.type_of_ceremony , ROUND(AVG(ce.cost),2) AS average_cost
FROM ceremony ce
GROUP BY ce.type_of_ceremony
ORDER BY average_cost DESC;
   
 
  
  
  