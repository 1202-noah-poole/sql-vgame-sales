#data collected from https://www.kaggle.com/datasets/gregorut/videogamesales
CREATE DATABASE vgame_database;
USE vgame_database;
#DROP DATABASE vgame_database;

CREATE TABLE vgame_sales (
	vg_rank INT,
    vg_name VARCHAR(255),
    platform VARCHAR(20),
    vg_year YEAR,
    genre VARCHAR(25),
    publisher VARCHAR(25),
    NA_sales FLOAT,
    EU_sales FLOAT,
    JP_sales FLOAT,
    other_sales FLOAT
);

#Load Data
LOAD DATA LOCAL INFILE 'C:/Users/noahs/Desktop/SQL/Video Games Sales Project/vgsales.csv'
INTO TABLE vgame_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Take an overview of the data; ensure it was imported properly 
SELECT * FROM vgame_sales;

#I don't like that the sales columns are seperated. . . let's combine them in a view
CREATE VIEW vgame_total_sales AS
SELECT vg_rank, vg_name, platform, vg_year, genre, publisher, (NA_sales + EU_sales + JP_sales + other_sales) AS total_sales
FROM vgame_sales;

#Let's take a look. . .
SELECT * FROM vgame_total_sales;

#Much better, now we can find more interesting stuff. Let's start with the top-selling platforms, with total video game sales.
SELECT platform,  SUM(total_sales) as total_sales
FROM vgame_total_sales
GROUP BY platform
ORDER BY total_sales desc
LIMIT 5;

#1255 Million, or 1.255 BILLION, video games were sold on the PS2 according to this database. This isn't comprehensive, of course, as the dataset
#only inlcudes games that have sold more than 100,000 copies, so the actual number may be much higher. Still, that's a very impressive number.

#Let's now do something similar, but for the year.
SELECT vg_year as 'Year', SUM(total_sales) as 'Total Sales'
FROM vgame_total_sales
GROUP BY vg_year
ORDER BY 2 desc
LIMIT 10;

#Looks like the late 2000's were a good year for video games.

#Though, I wonder if this list includes newer years. . .
SELECT DISTINCT vg_year FROM vgame_sales
ORDER BY vg_year DESC;

#Interestingly, the years 2018-2019 seem to be missing, but 2020 is included. If the list was outdated, then why would 2020 be on there?

SELECT vg_name, platform, total_sales
FROM vgame_total_sales
WHERE vg_year = 2020;

#After some quick research, I found that this DS game definitely did not come out in 2020, but rather came out in 2009. Some other users on the website where
#I got the dataset have said similarly. I'm glad I caught this error!

UPDATE vgame_sales
SET vg_year = 2009
WHERE vg_name = 'Imagine: Makeup Artist';

#Just to satisfy my personal curiosity, I wonder which version of Minecraft has the most sales. . .
SELECT * FROM vgame_total_sales
WHERE vg_name = 'Minecraft'
ORDER BY total_sales DESC;

#Now, let's use a regular expression to see which Playstation console has the most sales (btw, 'PSV' is referring to the ps vita, not the ps 5, like I initially thought).
SELECT platform, SUM(total_sales) as total_sales
FROM vgame_total_sales
WHERE platform LIKE 'PS_'
GROUP BY platform
ORDER BY total_sales DESC;

#Now let's go back to the basics, and look at the top selling genres.
SELECT genre, SUM(total_sales) as total_sales
FROM vgame_total_sales
GROUP BY genre
ORDER BY total_sales DESC
LIMIT 5;

#Not too surprising. . .

#Now let's take a look at the worst selling genres. . .
SELECT genre, SUM(total_sales) AS total_sales
FROM vgame_total_sales
GROUP BY genre
ORDER BY total_sales
LIMIT 5;

#Ahh, includes 4 out of the 5 genres I most play.
# :/
