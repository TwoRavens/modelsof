clear
set more off
#delimit ;
/*****************************************************************************************************************;
**This dofile runs all the other dofiles to generate the final datasets and then make all the tables;
*****************************************************************************************************************/;

*****************************************************************************************************************;
*Paths;
*****************************************************************************************************************;

*generate subdirectory to store generated dtafiles;
cap mkdir dtafiles;

*****************************************************************************************************************;
*Generate data;
*****************************************************************************************************************;


qui do 1_expandgps_allyears.do;
qui do 2_mergegps_allyears.do;
qui do 3_mergehh2004.do;
qui do 4_mergehh2007.do;
qui do 5_mergehh1999.do;
*qui do 6_simulatearsenicmeasures.do;
qui do 7_generatingchildleveldata.do;
qui do 8_matchnearest2004.do;
qui do 9_arsenicdataprep.do;
qui do 10_mergeinmoredata.do;

qui do tables1and2.do;
qui do figures2and3.do;
qui do maintables.do;

