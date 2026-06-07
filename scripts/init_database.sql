/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
This script creates a new database, 'datawarehouse'. Additionally, this script also sets up three schemas within the database:
'bronze', 'silver', and 'gold'.
*/


create database datawarehouse;

create schema bronze;
create schema silver;
create schema gold;
