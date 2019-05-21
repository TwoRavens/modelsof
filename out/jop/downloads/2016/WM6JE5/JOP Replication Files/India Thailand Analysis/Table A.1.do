*
*This file replicates the Table A.1 analysis reported in "Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

*clear workspace
clear

*set more off
set more off

*set working directory to the location of the India and Thailand data
cd "\JOP Replication Files\India Thailand Analysis"

*read in and analyze India data first
use "district_year_India", clear 

***************************************
*********Table A.1 Results: India******
***************************************

*Probit Estimates: Land Expropriation (Column 1)
xtprobit exprop forest drought

*Probit Estimates: Land Expropriation (Column 2)
xtprobit  exprop exproplag mineral forest drought

*NB Estimates: Civilian Deaths (Column 3)
xtnbreg civdeath civdeathlag drought, fe

*NB Estimates: Civilian Deaths (Column 4)
xtnbreg civdeath civdeathlag mineral forest scstfrac drought, fe



*read in and analyze Thailand data
use "thailand_province_data", clear 

***************************************
*******Table A.1 Results: Thailand*****
***************************************

*Probit Estimates: Land Expropriation (Column 1)
xtprobit exprop forest drought

*Probit Estimates: Land Expropriation (Column 2)
xtprobit exprop exproplag forest drought muslimfrac tobacco ruralspend

*NB Estimates: Civilian Deaths (Column 3)
xtnbreg civkilled1 civkilled1lag tobacco drought, fe

*NB Estimates: Civilian Deaths (Column 4)
xtnbreg civkilled1 civkilled1lag tobacco drought muslimfrac ruralspend forest, fe
