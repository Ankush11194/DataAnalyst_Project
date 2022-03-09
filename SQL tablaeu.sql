/*
Queries used for Tableau Visualization
*/


/*
This query will tell us about the total cases, total death and the deathpercentage due to covid
*/

select sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths,
sum(cast(new_deaths as bigint))/sum(new_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
--where location ='india'
where continent is not null
--group by date
order by 1,2

/*
 This query will give all continent total death counts
 */
 
select location, sum(cast(new_deaths as bigint)) as TotalDeathcount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is null
and location not in ('World', 'European Union','International','Upper middle income','High income', 'Lower middle income', 'Low income')
group by location
order by TotalDeathcount desc

/*
This query will give the population count in each countries and their highest infection count and percentage population infected
*/

select location, Population, max(total_cases) as HighestInfectionCount, 
max(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location ='india'
group by location, population
order by PercentPopulationInfected desc

/*
This query is same as above just we have return the date
*/

select location, population, date,max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location='india'
group by location, population,date
order by PercentPopulationInfected desc





