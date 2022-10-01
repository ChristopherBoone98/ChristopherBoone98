-- In this project, I will be looking at 2 nascar datasets, "nascarr" and "nascard".
-- "nascarr" goes over the race results that contains 17 columns
-- "nascard" goes over the driver results that contains 10 columns
-- Both of these datasets are similar because it goes over the seasons between 1975 and 2003.
-- In this project, I will be focusing on the 1992 season.

Select *
From nascarr

SELECT *
FROM nascard
Order by 1,2

-- 1992 season

SELECT *
FROM nascard
WHERE year = '1992'
ORDER by 1,2

SELECT *
FROM nascarr
Where year = '1992'
Order by 1,2

-- Race example: Daytona in serRace 506

SELECT *
FROM nascarr
WHERE year = '1992' and serRace = 506
ORDER by 1,2

SELECT *
FROM nascard
Where year = '1992' and serRace = 506
Order by 1,2

-- Number of races in 1992

SELECT COUNT(cast(yrRacr as int)) as NumOfRaces
FROM nascarr
WHERE year = '1992'

-- Track Types: Ovals

Select track, roadTrk
From nascarr
Where roadTrk = 0 and year = '1992'
Group by track, roadTrk

-- Track Types: Road Course

Select track, roadTrk
From nascarr
Where roadTrk = 1 and year = '1992'
Group by track, roadTrk

-- Manufacturers in 1992

SELECT carMake 
FROM nascard
Where year = '1992' 
Group by carMake

-- Most races by a driver in 1992

Select driver, COUNT(yearRace) as NumOfRaces
FROM nascard
Where year = '1992'
Group by driver
order by NumOfRaces Desc

-- Most wins by a driver in 1992

Select driver, COUNT(finish) as Wins
FROM nascard
Where finish = 1 AND year = '1992'
Group by driver
order by Wins Desc

-- Most Top 5s in 1992

Select TOP 10 driver, COUNT(finish) as Top5s
FROM nascard
Where finish <= 5 AND year = '1992'
Group by driver
order by Top5s Desc

-- Most Top 10s in 1992

Select TOP 10 driver, COUNT(finish) as Top10s
FROM nascard
Where finish <= 10 AND year = '1992'
Group by driver
order by Top10s Desc

-- Best Average finish in 1992 for drivers who ran 22 or more races

Select driver, COUNT(yearRace) as NumOfRaces,  ROUND(AVG(cast(finish as float)),1) as AvgFinish
FROM nascard
Group by driver, year
HAVING COUNT(yearRace) >= 22 AND year = '1992'
order by AvgFinish

-- Most Earnings by a driver in 1992

Select TOP 10 driver, Sum(cast(prize as int)) as TotalEarnings
FROM nascard
Where year = '1992'
Group by driver
Order by TotalEarnings desc

-- Most wins by Manufacturer

Select carMake as Manufacturer, COUNT(finish) as Wins
From nascard
Where year = '1992' and finish = 1
Group by carMake
Order by Wins desc

-- Creating Joins using both datasets

Select race.serRace, race.year, yrRacr, numCars, race.prize AS prize,
race.laps, roadTrk, track, driver AS RaceWinner, carMake, driver.prize AS WinningPrize
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 and race.year = '1992'

-- Joins with case statements

Select race.serRace, race.year, yrRacr, numCars, race.prize AS prize,
race.laps, track, 
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType, driver AS RaceWinner, driver.prize AS WinningPrize, carMake
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 AND race.year = '1992'
ORDER BY serRace

-- Where did Bill Elliotts 5 wins come from?

Select race.serRace, race.year, yrRacr, numCars, race.prize AS prize,
race.laps, track, 
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType, driver AS RaceWinner, driver.prize AS WinningPrize, carMake
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 AND race.year = '1992' AND driver = 'BillElliott'
ORDER BY serRace

