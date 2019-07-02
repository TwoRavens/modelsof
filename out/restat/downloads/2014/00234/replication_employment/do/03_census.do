/* REPLICATION FILES for the article:
Spillovers from High-Skill Consumption to Low-Skill Labor Markets 
Francesca Mazzolari and Giuseppe Ragusa
REStat, March 2013, 95(1), 74-86

do file: 03_census.do

  This do file prepares the city-level datasets:
    1. msa80_90_00_05.dta
      The generated variables are population figures (number of "bodies", as of the census year)
	  and employment figures (number of hours worked, in the year prior to the census)
	  by educational level and sector
    2. msa80_90_00_05_wg.dta
      The generated variables are wage figures (mean and median hourly wages)
      by educational level and sector
*/


* Set path to WORKING DIRECTORY
cd ~/scratch/Rep
************ 1. Generate msa80_90_00_05.dta ***********





*******************************************************
*********** 2. Generate msa80_90_00_05_wg.dta *********
*******************************************************