
/* 
 Covid-19 Data Exploration
 Skills used: JOINS, CTE's, TEMP RABLE, WINDOWS FUNCTIONS, AGGREGATE FUNCTIONS, CONVERTING DATA TYPES
 */


SELECT*
FROM CovidDeaths_csv cdc
ORDER BY location;

--SELECT*
--FROM CovidVaccinations_csv cvc
--ORDER BY location;


--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths_csv cdc
ORDER BY location;


-- Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, 
((total_deaths*1.0/total_cases)*100) AS DeathPercentage
FROM CovidDeaths_csv cdc
ORDER BY location;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, date, population, total_cases, 
(total_cases*1.0/population)*100 AS PercentagePopulationInfected
FROM CovidDeaths_csv cdc
ORDER BY location;


-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
MAX(total_cases*1.0/population)*100 AS PercentPopulationInfected
FROM CovidDeaths_csv cdc
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths_csv cdc
WHERE continent <> ""
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Showing continents with the highest death count per population

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths_csv cdc
WHERE continent <> ""
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths_csv cdc
WHERE continent <> ""
ORDER BY 1,2;



-- Total Population vs Vaccinations
-- Shows Perecentage of Population that has recieved at least one Covid Vaccine

SELECT cdc.continent, cdc.location, cdc.date, cdc.population, cvc.new_vaccinations,
SUM(CAST(cvc.new_vaccinations AS INT)) 
OVER (PARTITION BY cdc.location ORDER BY cdc.location, cdc.date) AS RollingPeopleVaccinated
FROM CovidDeaths_csv cdc
JOIN CovidVaccinations_csv cvc
ON cdc.location = cvc.location
AND cdc.date = cvc.date
WHERE cdc.continent <> ""
ORDER BY cdc.location, cvc.date;


-- Using CTE to perform calculation on partition by in prevous query 


WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(SELECT cdc.continent, cdc.location, cdc.date, cdc.population, cvc.new_vaccinations,
SUM(CAST(cvc.new_vaccinations AS INT)) 
OVER (PARTITION BY cdc.location ORDER BY cdc.location, cdc.date) AS RollingPeopleVaccinated
FROM CovidDeaths_csv cdc
JOIN CovidVaccinations_csv cvc
ON cdc.location = cvc.location
AND cdc.date = cvc.date
WHERE cdc.continent <> ""
)
SELECT *, (RollingPeopleVaccinated*1.0/Population)*100
FROM PopvsVac;



-- Using Temp Table to perform calculations on partition by in previous query
 
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMP TABLE PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
RoolingPeopleVaccinated NUMERIC
)
INSERT INTO PercentPopulationVaccinated
SELECT cdc.continent, cdc.location, cdc.date, cdc.population, cvc.new_vaccinations,
SUM(CAST(cvc.new_vaccinations AS INT)) 
OVER (PARTITION BY cdc.location ORDER BY cdc.location, cdc.date) AS RollingPeopleVaccinated
FROM CovidDeaths_csv cdc
JOIN CovidVaccinations_csv cvc
ON cdc.location = cvc.location
AND cdc.date = cvc.date
SELECT *, (RollingPeopleVaccinated*1.0/Population)*100
FROM PercentPopulationVaccinated;
