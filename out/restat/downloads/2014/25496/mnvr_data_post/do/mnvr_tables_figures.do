clear
cd ..\do

/*

"Has ICT Polarized Skill Demand? Evidence from Eleven Countries over 25 years"
Guy Michaels, Ashwini Natraj, and John Van Reenen

The files included here generate the tables and figures for the paper.
The files that generate the datasets for use in the regressions are in a separate directory.


*/

****************************** GENERATING RESULTS************************************************************
clear

cd ..\do

*generating Tables 1 and 2- summary statistics of routineness across occupations

do mnvr_tab1_tab2.do


clear

cd ..\do

*generating Tables 3 and 4- summary statistics of NACE 2-digit industries from EUKLEMS

do mnvr_tab3_tab4.do

clear


clear

cd ..\do

*generating Table 5- MAIN results of correlation between ICT upgrading and changes in wagebill shares (high, middle and low)

do mnvr_tab5.do

clear

cd ..\do

*generating Table 6- results with saturated specification and instruments

do mnvr_tab6.do

clear

cd ..\do

*generating Table 7- disaggregating wagebill share into prices and employment

do mnvr_tab7.do

clear

cd ..\do

*generating Table 8- trade, R&D and the Feenstra-Hanson offshoring measure

do mnvr_tab8.do

**************************************** APPENDIX TABLES*************************************************

* Appendix Tables 1 and 2 are taken directly from EUKLEMS's documentation.

clear

cd ..\do

*generating Appendix Table 3: total trade, trade with OECd countries, trade with nonOECD coutnries (all traded industries+ countries with R&D data)

do mnvr_taba3.do

clear

cd ..\do

*generating Appendix Table 4- "back-of-the-envelope" calculations

do mnvr_taba4.do

****************************************FIGURES***********************************************************

clear

cd ..\do

*generating Figures 1,2 3, 4 and 5

do mnvr_fig_1_2_3_4_5.do

