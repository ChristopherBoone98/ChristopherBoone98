SELECT driver, COUNT(yearRace) as NumOfRaces
FROM nascard
WHERE year = '1998'
GROUP BY driver
ORDER BY NumOfRaces DESC

-- The dataset
Select *
From nascard

SELECT *
FROM nascarr

-- Most wins from 1975 - 2003 (Top 10)

SELECT TOP 10 driver, COUNT(finish) AS Wins
FROM nascard
WHERE finish = 1
GROUP BY driver
ORDER BY Wins DESC

-- Most manufacturer wins from 1975 - 2003

SELECT carMake, COUNT(finish) AS Wins
FROM nascard
WHERE finish = 1
GROUP BY carMake
ORDER BY Wins DESC

-- Most Ford wins by a driver from 1975 - 2003

SELECT carMake, driver, COUNT(finish) AS Wins
FROM nascard
WHERE finish = 1 AND carMake = 'Ford'
GROUP BY carMake, driver
ORDER BY Wins DESC

-- Create Joins

Select race.serRace, race.year, yrRacr, numCars, race.prize AS prize,
race.laps, roadTrk, track, driver AS RaceWinner, carMake, driver.prize AS WinningPrize
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1

-- Most Talladega wins by a driver from 1975 - 2003

Select track, driver, COUNT(finish) as Wins
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 and track LIKE 'T%a%l%l%a%'
GROUP BY track, driver
ORDER BY Wins DESC

-- Most road course wins

Select roadTrk, driver, COUNT(finish) as Wins
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 and roadTrk = 1
GROUP BY roadTrk, driver
ORDER BY Wins DESC

-- History of Jeff Gordon's wins on a road course

Select race.year, track, roadTrk, driver, finish
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 and roadTrk = 1 and driver = 'JeffGordon'
ORDER BY race.year ASC


-- Determine which is a Road Course or Oval

Select track, roadTrk,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr
GROUP BY track, roadTrk

-- Tracks: Road Courses

Select track,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr
WHERE roadTrk = 1
GROUP BY track, roadTrk

-- Tracks: Oval

Select track,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr
WHERE roadTrk = 0
GROUP BY track, roadTrk

-- Partition by total wins in the 1998 season and seeing the track type.

Select race.serRace ,race.year, yrRacr, numCars, race.prize AS prize,
race.laps, track, driver AS RaceWinner, carMake, COUNT(finish) OVER
(PARTITION BY driver) as TotalWins,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1 AND race.year = '1998'
ORDER BY serRace

-- Number of races in different types of tracks

Select track, COUNT(track) as NumberOfRaces,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr
GROUP BY track, roadTrk
ORDER BY COUNT(track) DESC

SELECT TOP 10 driver, year, COUNT(finish) AS Top5s
FROM nascard
WHERE finish <= 5 AND year = '1998'
GROUP BY driver, year
ORDER BY Top5s DESC

-- Average Finish in 1998

Select race.year, driver, COUNT(yearRace) as NumOfRaces, AVG(cast(finish as decimal)) as AvgFinish
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
Group by driver, race.year
HAVING COUNT(yearRace) >= 27 AND race.year = '1998'
ORDER BY AvgFinish


-- Create Temp table

DROP Table if exists #Nascar
Create Table #Nascar
(
Year numeric,
YrRacr numeric,
NumCars numeric,
Prize numeric,
Laps numeric,
Track nvarchar(255),
RaceWinner nvarchar(255),
CarMake nvarchar(255),
TotalWins numeric,
TrackType nvarchar(255)
)

Insert into #Nascar
Select race.year as Year, yrRacr, numCars, race.prize AS prize,
race.laps, track, driver AS RaceWinner, carMake, COUNT(finish) OVER
(PARTITION BY driver) as TotalWins,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1
ORDER BY race.year, yearRace ASC

Select *
From #Nascar
Order by Year, YrRacr

Create View Nascar as
Select race.year as Year, yrRacr, numCars, race.prize AS prize,
race.laps, track, driver AS RaceWinner, carMake, COUNT(finish) OVER
(PARTITION BY driver) as TotalWins,
CASE
   WHEN roadTrk = 1 THEN 'Road Course'
   ELSE 'Oval'
END AS TrackType
FROM nascarr AS race
JOIN nascard AS driver
   ON race.serRace = driver.serRace
WHERE finish = 1
ORDER BY race.year, yearRace