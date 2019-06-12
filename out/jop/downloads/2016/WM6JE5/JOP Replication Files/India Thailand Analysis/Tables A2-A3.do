*
*This file replicates the Tables A.2-A.3 analysis reported in "Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

*clear workspace
clear

*set more off
set more off

*set working directory to location of India and Thailand data
cd "\JOP Replication Files\India Thailand Analysis"

*read in India data
use "district_year_India", clear 

***************************************
*********Table A.2 Results: India******
***************************************

*Probit Estimates: Land Expropriation (Column 1)
firthlogit exprop forest drought

*Probit Estimates: Land Expropriation (Column 2)
firthlogit  exprop exproplag mineral forest drought

***************************************
*********Table A.3 Results: India******
***************************************

*summarize expropriation variable
summarize exprop, detail



*read in Thailand data
use "thailand_province_data_14sep2015", clear 

***************************************
*******Table A.2 Results: Thailand*****
***************************************

*Probit Estimates: Land Expropriation (Column 1)
firthlogit exprop forest drought

*Probit Estimates: Land Expropriation (Column 2)
firthlogit exprop exproplag forest drought muslimfrac tobacco ruralspend

***************************************
*******Table A.3 Results: Thailand*****
***************************************

*summarize expropriation variable
summarize exprop, detail
