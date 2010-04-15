/* NOTE: Be sure that you have a database created to import into 
   and all the map files are located in the databases data directory
   for example - c:/mysql/data/db_name 

   To load the map data, just copy and paste the following in to
   the MySql command line.
*/
select 'Creating Destination Tables' as '';
-- Create Tables
CREATE TABLE cities (
	id int AUTO_INCREMENT NOT NULL ,
	country_id smallint NOT NULL ,
	region_id smallint NOT NULL ,
	city varchar (45) NOT NULL ,
	latitude float NOT NULL ,
	longitude float NOT NULL ,
	time_zone varchar (10) NOT NULL ,
	dmas_id smallint NULL ,
	county varchar (25) NULL ,
	code varchar (4) NULL ,
	PRIMARY KEY(id)
	); 

CREATE TABLE regions (
	id smallint AUTO_INCREMENT NOT NULL ,
	country_id smallint NOT NULL ,
	region varchar (45) NOT NULL ,
	code varchar (8) NOT NULL ,
	adm1_code char (4) NOT NULL ,
	PRIMARY KEY(id)
	);

CREATE TABLE countries (
	id smallint AUTO_INCREMENT NOT NULL ,
	country varchar (50) NOT NULL ,
	fips104 varchar (2) NOT NULL ,
	iso2 varchar (2) NOT NULL ,
	iso3 varchar (3) NOT NULL ,
	ison varchar (4) NOT NULL ,
	internet varchar (2) NOT NULL ,
	capital varchar (25) NULL ,
	map_reference varchar (50) NULL ,
	nationality_singular varchar (35) NULL ,
	nationality_plural varchar (35) NULL ,
	currency varchar (30) NULL ,
	currency_code varchar (3) NULL ,
	population bigint NULL ,
	title varchar (50) NULL ,
	Comment varchar (255) NULL ,
	PRIMARY KEY(id)
	);

CREATE TABLE dmas (
	id smallint NOT NULL ,
	country_id smallint NULL ,
	dma varchar (3) NULL ,
	market varchar (50) NULL
	);



select 'Loading Data Files Please Wait ...' as '';
-- Load Data From Flat Files

LOAD DATA INFILE 'cities.txt' INTO TABLE cities
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE 'regions.txt' INTO TABLE regions
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE 'countries.txt' INTO TABLE countries
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA INFILE 'dmas.txt' INTO TABLE dmas
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


