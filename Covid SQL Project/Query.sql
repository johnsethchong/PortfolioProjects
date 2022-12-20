-- COVID 19 Data Exploration

SELECT 
	location, date, total_cases, new_cases, total_deaths, population
FROM
	CovidDeaths
ORDER BY 
	1,2

-- Total Cases vs Total Deaths 
-- Shows likelihood of dying if you contract COVID in your country
SELECT 
	location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM
	CovidDeaths
WHERE 
	location like '%states%'
ORDER BY 
	1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with COVID
SELECT 
	location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM
	CovidDeaths
WHERE 
	location like '%states%'
ORDER BY 
	1,2

-- Countries with highest infection rate vs Population
SELECT 
	location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM
	CovidDeaths
--WHERE location like '%states%'
GROUP BY
	location, population
ORDER BY 
	PercentPopulationInfected DESC


-- Countries with Highest Death Count per Population
SELECT 
	location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM
	CovidDeaths
WHERE continent is not null
GROUP BY
	location
ORDER BY 
	TotalDeathCount DESC

-- Broken down showing continents with the highest death count per pulation
SELECT 
	continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM
	CovidDeaths
WHERE continent is not null
GROUP BY
	continent
ORDER BY 
	TotalDeathCount DESC


-- Global Numbers
SELECT 
	SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM
	CovidDeaths
WHERE 
	continent is not null
ORDER BY 
	1,2


SELECT 
	date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM
	CovidDeaths
WHERE 
	continent is not null
	--location like '%states%'
GROUP BY
	date
ORDER BY 
	1,2


-- Looking at Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM 
	CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location and dea.date = vac.date
WHERE 
	dea.continent is not null
ORDER BY
	2,3


-- Use CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT 
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM 
	CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location and dea.date = vac.date
WHERE 
	dea.continent is not null
--ORDER BY 2,3
	)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM
PopvsVac



-- Temp Table to perform Calculation on Partition By in previous query
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
SELECT 
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM 
	CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location and dea.date = vac.date
WHERE 
	dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM
#PercentPopulationVaccinated

-- Create View to store for later visualizations
CREATE VIEW PercentPopulationVaccinated AS

SELECT 
	dea.continent, 
	dea.location, 
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM 
	CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location and dea.date = vac.date
WHERE 
	dea.continent is not null



SELECT * FROM PercentPopulationVaccinated