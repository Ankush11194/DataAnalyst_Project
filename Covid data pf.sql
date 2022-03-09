/* Covid 19 Data Exploration

skill used: Insert, Delete, Aggregate Functions, Creating Views, Converting Data Types
*/


select * from PortfolioProject..CovidDeaths
order by 3,4

select * from PortfolioProject..Covidvaccinations
order by 3,4

--select Data that we are going to be using

select location,date,total_cases, new_cases,total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases Vs total deaths
--Shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

--Looking at Total cases vs Population
--shows what percentage of population got Covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%india%'
order by 1,2

--Looking at the countries with Highest infection rate compared to population

select location, population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 
as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%india%'
group by location,population
order by PercentagePopulationInfected desc

--Countries with the highest Death count per population

select location, max(cast(total_deaths as bigint)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
group by location
order by totaldeathcount desc

--Let's break things down by continent

select continent, max(cast(total_deaths as bigint)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
group by continent
order by totaldeathcount desc

--showing continent with the higest death counts per population

select continent, max(cast(total_deaths as bigint)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
group by continent
order by totaldeathcount desc



--Global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths, 
sum(cast(new_deaths as bigint))/sum(new_cases)*100 
as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccinations

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by 2,3


	select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date)
	--as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by 2,3


--use common table expression(CTE)

with PopvsVac(Continent, location ,date, population,new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date)
	--as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths dea
join PortfolioProject..Covidvaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	--order by 2,3
	)
	select * , (RollingPeopleVaccinated/Population)*100 from PopvsVac
