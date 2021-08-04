-- Looking at Death Probability through time in a particular country, ordered by highest likelihood first
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioSQL..Deaths
where location = 'Spain'
order by 5 desc

-- Looking at Highest Death Probability for each country, ordered by highest Death Percentage.
--(Total_Cases was set >300 to show only relevant results)(Continent='' designates Continents so we exlcude them)
select location, max(total_cases) as TotalCasesCount, Max((cast(total_deaths as int))/total_cases)*100 as HighestDeathPercentage
from PortfolioSQL..Deaths
where continent!='' and total_cases>300
group by location
order by 3 desc

-- Looking at Infection Rate through time in a particular country 
select location, date, population, total_cases, (total_cases/population)*100 as InfectionRate
from PortfolioSQL..Deaths
where location = 'China'
order by 2 asc

-- Looking at Highest Infection Rate for each country, ordered by highest Infection Rate.
-- (Total_Cases was set >300 to show only relevant results) (Continent='' designates Continents so we exlcude them)
select location, max(total_cases) as TotalCasesCount, Max(total_cases/population)*100 as HighestInfectionRate
from PortfolioSQL..Deaths
where continent!='' and total_cases>300
group by location	
order by 3 desc

-- Looking at where the virus had a highest total mortality per population, by continents
select location, max((cast(total_deaths as int)/population)*100) as TotalMortality
from PortfolioSQL..Deaths
where continent='' and location!='World'
group by location
order by 2 desc

-- Looking at global tendencies. New Cases and New Deaths each day by continents
select location, date, new_cases, new_deaths
from PortfolioSQL..Deaths
where location='World'
order by 2


-- Looking at Total Population vs Vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CummulativeSum
, (sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)/dea.population)*100 as VaccinatedPercentage
from PortfolioSQL..Deaths dea
join PortfolioSQL..Vaccination vac
	on dea.location = vac.location
where dea.continent!=''
	and dea.date = vac.date
order by 2,3


-- Creating views to store data for later visualizations
create view DeathProbabilityOneCountry as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioSQL..Deaths
where location = 'Spain'
--order by 5 desc

create view HighestDeathProbabilityAllCountries as
select location, max(total_cases) as TotalCasesCount, Max((cast(total_deaths as int))/total_cases)*100 as HighestDeathPercentage
from PortfolioSQL..Deaths
where continent!='' and total_cases>300
group by location
--order by 3 desc

create view InfectionRateOneCountry as
select location, date, population, total_cases, (total_cases/population)*100 as InfectionRate
from PortfolioSQL..Deaths
where location = 'China'
--order by 2 asc

create view HighestInfectionRateAllCountries as
select location, max(total_cases) as TotalCasesCount, Max(total_cases/population)*100 as HighestInfectionRate
from PortfolioSQL..Deaths
where continent!='' and total_cases>300
group by location	
--order by 3 desc

create view HighestMortalityContinents as
select location, max((cast(total_deaths as int)/population)*100) as TotalMortality
from PortfolioSQL..Deaths
where continent='' and location!='World'
group by location
--order by 2 desc

create view GlobalTendenciesContinents as
select location, date, new_cases, new_deaths
from PortfolioSQL..Deaths
where location='World'
--order by 2

create view TotalPopulationVaccination as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CummulativeSum
, (sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)/dea.population)*100 as VaccinatedPercentage
from PortfolioSQL..Deaths dea
join PortfolioSQL..Vaccination vac
	on dea.location = vac.location
where dea.continent!=''
	and dea.date = vac.date
--order by 2,3