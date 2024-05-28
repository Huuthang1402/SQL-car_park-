#Part 1
#Below is the scenario where I have to create a database structute for a car park in University


Create TABLE `Car Park` (
`carpark id` INT UNSIGNED NOT NULL,
`map reference` VARCHAR(10) NOT NULL,
`description` VARCHAR(200),
PRIMARY KEY (`carpark id`));

CREATE TABLE `Spot Reservation Parking Area`(
`area id` INT UNSIGNED NOT NULL,
`carpark id` INT UNSIGNED NOT NULL,
`area name` VARCHAR(45),
PRIMARY KEY(`area id`),
CONSTRAINT FK_CARPARK_AREA FOREIGN KEY (`carpark id`) REFERENCES `Car Park`(`carpark id`));

CREATE TABLE `Numbered Parking Spot`(
`parking spot id` INT UNSIGNED NOT NULL,
`area id` INT UNSIGNED NOT NULL,
`location description` VARCHAR(100),
PRIMARY KEY (`parking spot id`),
CONSTRAINT FK_AREA_SPOT FOREIGN KEY (`area id`) REFERENCES `Spot Reservation Parking Area`(`area id`));

CREATE TABLE `Swipe Card`(
`card id` INT UNSIGNED NOT NULL,
`name on card` VARCHAR(100) NOT NULL,
`staff number` VARCHAR(10),
`contact phone` VARCHAR(20),
PRIMARY KEY (`card id`));

CREATE TABLE `Spot Area Entry Attempt`(
`attempt id` INT UNSIGNED NOT NULL,
`card id` INT UNSIGNED NOT NULL,
`area id` INT UNSIGNED NOT NULL,
`date and time of entry` DATETIME NOT NULL,
PRIMARY KEY (`attempt id`),
CONSTRAINT FK_SWIPECARD_ATTEMPT FOREIGN KEY (`card id`) REFERENCES `Swipe Card`(`card id`),
CONSTRAINT FK_AREA_ATTEMPT FOREIGN KEY (`area id`) REFERENCES `Spot Reservation Parking Area`(`area id`));

CREATE TABLE `Car`(
`number plate` VARCHAR(10) NOT NULL,
`car brand` VARCHAR(45) NOT NULL,
`car model` VARCHAR(45) NOT NULL,
PRIMARY KEY (`number plate`));

CREATE TABLE `Time slot`(
`Year` YEAR(4) NOT NULL,
`Semester` CHAR(2) NOT NULL,
PRIMARY KEY (`Year`, `Semester`));

CREATE TABLE `Spot Reservation`(
`reservation id` INT UNSIGNED NOT NULL,
`card id` INT UNSIGNED NOT NULL,
`number plate` VARCHAR(10) NOT NULL,
`payment amount` DECIMAL(5,2) NOT NULL,
`when create` DATETIME NOT NULL,
PRIMARY KEY (`reservation id`),
CONSTRAINT FK_SWIPECARD_RESERVATION FOREIGN KEY (`card id`) REFERENCES `Swipe card`(`card id`),
CONSTRAINT FK_CAR_RESERVATION FOREIGN KEY (`number plate`) REFERENCES `Car`(`number plate`));

CREATE TABLE `Allocation` (
`parking spot id` INT UNSIGNED NOT NULL,
`Timeslot_Year` YEAR(4) NOT NULL,
`Timeslot_Semester` CHAR(2) NOT NULL,
`Spot Reservation_reservation id` INT UNSIGNED NOT NULL,
PRIMARY KEY (`parking spot id`, `Timeslot_Year`, `Timeslot_Semester`),
CONSTRAINT FK_ALLOCATION FOREIGN KEY (`Timeslot_Year`, `Timeslot_Semester`) REFERENCES `Time slot`(`Year`, `Semester`),
CONSTRAINT FK_SPOT_ALLOCATION FOREIGN KEY (`parking spot id`) REFERENCES `Numbered Parking Spot`(`parking spot id`),
CONSTRAINT FK_RESERVATION_ALLOCATION FOREIGN KEY (`Spot Reservation_reservation id`) REFERENCES `Spot Reservation`(`reservation id`)
);



# === Part 2

# After that I need to insert few sample data
# ===
INSERT INTO `Swipe Card`
VALUES
(123456,"John Cena","S01","0433567891"),
(134523,"Tran Thang","S02","0487692313"),
(123457,"John Cena","S01","0433567891"),
(123458,"John Cena","S01","0433567891"),
(134522,"Tran Thang","S02","0487692313"),
(56231,"Kayne West","S03","0412322312");

INSERT INTO `Car`
VALUES
("AP59JJ","Toyota","Camry"),
("ABCXY1","Toyota","Lexus"),
("EGM64Z","Huyndai","Accent"),
("AA321A","Mercedes","GLC300");

INSERT INTO `spot reservation`
VALUES
(1,123456,"AP59JJ",50,'2023-09-21'),
(2,123457,"ABCXY1",50,'2023-09-21'),
(3,123458,"ABCXY1",50,'2023-09-22'),
(4,134522,"EGM64Z",50,'2023-09-22'),
(5,134523,"EGM64Z",50,'2023-09-23'),
(6,56231,"AA321A",50,'2023-09-23'), 
(7,56231,"AA321A",50,'2023-09-23');

INSERT INTO `spot reservation`
VALUES
(8,56231,"AA321A",50,'2022-09-23'),
(9,123456,"AP59JJ",100,'2021-09-23');

INSERT INTO `Car Park`
VALUES
(1,"mapzone1","carpark1"),
(2,"mapzone2","carpark2"),
(3,"mapzone3","carpark3");

INSERT INTO `Spot Reservation Parking Area`
VALUES
(1,1,"area_1"),
(2,1,"area_2"),
(3,2,"area_3");

INSERT INTO `Spot Area Entry Attempt`
VALUES
(1,123456,1,'2023-09-21'),
(2,123456,2,'2023-09-21'),
(3,123456,1,'2023-09-22'),
(4,56231,3,'2023-09-23');

INSERT INTO `Numbered Parking Spot`
VALUES
(1,1,"location_1"),
(2,1,"location_2"),
(3,2,"location_3"),
(4,3,"location_4");

INSERT INTO `Time slot`
VALUES 
('2023',"S1"),
('2023',"S2");
INSERT INTO `Time slot`
VALUES 
('2022',"S1"),
('2022',"S2"),
('2021',"S1"),
('2021',"S2");

INSERT INTO `Allocation`
VALUES
(1,"2023","S1",1);
INSERT INTO `Allocation`
VALUES 
(2,"2023","S1",2),
(3,"2023","S1",3),
(4,"2023","S1",4),
(1,"2023","S2",5),
(2,"2023","S2",6),
(3,"2023","S2",7),
(1,"2022","S1",8),
(2,"2021","S1",9);

# === Part 3

# A2 Then, I now need to write some queries based on the business needs:

#a. List each staff number and the number of swipe card records that exist for each staff number. Sort by the largest number of records
#first to the smallest number of records being last.
#b. List the distinct staff names and staff numbers (from the staff card) of all staff who have 2 or more spot reservations. Sort by staff
#surname in ascending dictionary order.
#c. Show all entry attempts for a chosen swipe card (use where `card id` = to choose the card id you want to use for your query).
#Leave a comment above your query indicating which card id you want the marker to test with. (e.g. 61688)
#d. List the details of each Car Park and the total number of numbered parking spots in each car park.
#e. How many cars has each swipe card ever been associated with? List each swipe card id and count of different number plates.
#f. For a given timeslot (your choice of year and semester), how many parking spots are not allocated in each car park?
#Leave a comment above your query indicating which year and semester you want the marker to test with. (e.g. 2021, s2)
#g. What is the total $ amount that each staff member has paid for parking during the lifetime of this system? In the query, list the
#staff number and the total $ amount for that staff member.
#h.  How much revenue (payments total) has each car park brought in each year? List the car park id, year, and total $ amount for that
#car park for that year.

# query a)
SELECT `staff number`, count(*) as swipecard_count
from `swipe card`
group by `staff number`
order by swipecard_count desc;

# Part 3 query b)
SELECT s.`name on card`, s.`staff number`, count(sp.`reservation id`) as reservation_count
from `swipe card` s join `spot reservation` sp
on s.`card id` = sp.`card id`
group by s.`name on card`, s.`staff number`
having count(sp.`reservation id`) >=2
order by s.`name on card` asc;


# Part 3 query c)
SELECT * FROM 
`spot area entry attempt`
where `card id`=123456;

# Part 3 query d)
SELECT c.`carpark id`, 
count(n.`parking spot id`) as numbered_parking_spots_count
from `car park` c left join `spot reservation parking area` a
on c.`carpark id` = a.`carpark id`
left join `numbered parking spot` n
on a.`area id` = n.`area id`
group by c.`carpark id`;


# Part 3 query e)
SELECT s.`card id`,count(distinct e.`number plate`) as number_of_assoicated_plate_count
from `swipe card` s join `spot reservation` e
on s.`card id` = e.`card id`
group by s.`card id`;

# Part 3 query f)
With parking_spot_id_allocation As (Select *
from `allocation` a join `Time slot` t
on a.`Timeslot_Year` = t.`Year`
and a.`Timeslot_Semester` = t.`Semester`
where t.`Year` = 2022
and t.`Semester`= 'S1'),

 parking_spot_id_not_allocation as
(Select * from
`numbered parking spot` p
where p.`parking spot id`  not in ( select `parking spot id` from parking_spot_id_allocation))

Select c.`carpark id`, count(parking_spot_id_not_allocation.`parking spot id`) as not_allocated_spot_count
from `car park` c left join `spot reservation parking area` a
on c.`carpark id` = a.`carpark id`
left join parking_spot_id_not_allocation on a.`area id` = parking_spot_id_not_allocation.`area id`
group by c.`carpark id`;

# Part 3 query g)
SELECT s.`staff number`, sum(sp.`payment amount`) as total_amount
from `swipe card` s join `spot reservation` sp
on s.`card id` = sp.`card id`
group by s.`staff number`
order by total_amount desc;

# Part 3 query h)
select c.`carpark id`, t.`Year`, sum(spr.`payment amount`) as total_revenue
from `car park` c left join `spot reservation parking area` r
on c.`carpark id` = r.`carpark id`
left join `numbered parking spot` n
on r.`area id` = n.`area id`
left join `allocation` a
on n.`parking spot id` = a.`parking spot id`
left join `time slot` t 
on a.`Timeslot_Year` = t.`Year` and a.`Timeslot_Semester` = t.`Semester`
left join `spot reservation` spr
on a.`Spot Reservation_reservation id` = spr.`reservation id`
group by c.`carpark id`, t.`Year`
order by t.`Year` desc;
