--create the first table for csv file : electricity-production-by-source.csv
CREATE TABLE electricityProductionBySource (
	entity TEXT, 
	code TEXT, 
	year INT, 
	coal DECIMAL, 
	gas DECIMAL, 
	nuclear DECIMAL,
	hydro DECIMAL,
	solar DECIMAL, 
	oil DECIMAL,
	wind DECIMAL, 
	bioenergy DECIMAL,
	Other_renewables_excluding_bioenergy DECIMAL
);

--import the data from csv file and print all the info
SELECT * from electricityProductionBySource;

--sort in descending order the entities (countries only; exluding the regions and other collective entities) and year where bioenergy is used  
SELECT 
entity, 
year, 
bioenergy as electricityFromBioenergy_TWh
FROM electricityProductionBySource
WHERE entity NOT IN ('World', 'Asia (Ember)', 'G20 (Ember)', 'Asia', 'Non-OECD (EI)', 'Asia Pacific (EI)', 'Middle East (Ember)', 'Low-income countries', 'Upper-middle-income countries', 'OECD (EI)', 'High-income countries', 'G7 (Ember)', 'OECD (Ember)', 'European Union (27)', 'Lower-middle-income countries', 'Europe (Ember)', 'Europe (EI)', 'Europe', 'ASEAN (Ember)', 'North America (Ember)', 'North America (EI)', 'North America', 'South America', 'Latin America and Caribbean (Ember)', 'Africa (Ember)', 'Africa (EI)')
GROUP BY entity, year, bioenergy
HAVING bioenergy > 0
ORDER BY bioenergy DESC;


--Create the second table for another data: primary-energy-consumption-by-source.csv
CREATE TABLE energyConsumptionBySource (
	entity TEXT,
	code TEXT,
	year INT,
	oil DECIMAL,
	gas DECIMAL,
	coal DECIMAL,
	hydro DECIMAL,
	solar DECIMAL,
	wind DECIMAL,
	nuclear DECIMAL,
	other_renewables_including_geothermal_and_biomass DECIMAL
);

--In order to keep a specific list of countries and not individually mentioning other entities to exclude, a table of countries is added in the database.
--This is also a good way to practice subqueries later. 		
CREATE TABLE countries ( 
	entity TEXT)
;
SELECT * FROM countries;

--Show the year(s) with the highest production of bioenergy per country
SELECT * from electricityProductionBySource;
SELECT 
	year,
	entity, 
	bioenergy as "electricityFromBioenergy_TWh"
FROM electricityProductionBySource ep1
WHERE entity IN (SELECT entity FROM countries ) AND
		bioenergy = (SELECT max(bioenergy) FROM electricityProductionBySource ep2 WHERE ep1.entity = ep2.entity)
GROUP BY year, entity, bioenergy
ORDER BY bioenergy DESC;

