/*Table 2 in Hegre, Oneal, and Russett, "Trade Does Promote Peace: New Simultaneous Estimates of the Reciprocal Effects 
of Trade and Conflict," Journal of Peace Research, 2010 47(6):763-774; Replication and reanalysis of Kim and Rousseau, JPR 2005; 
modified k&r_table1.do, which is k&r's do-file: 12-03-2010*/


*log using C:\KIM_ROUSSEAU_JPR\K&R_TABLEI.log
/* produces analyses for TABLES I in Hyung Min Kim & David L. Rousseau, "The
Classical Liberals Were Half Right (or Half Wrong): New Tests of the 'Liberal
Peace,' 1960-88," Journal of Peace Research (run: 12/23/2004) */

/* TABLE I: Using Primary Measure for Economic Interdependence "TRADE DEPENDENCE OR
ECONOMY DEPENDENCE (MONADIC)" */


set mem 200m

/*use k&r's posted data*/
use "C:\simul\kimrouss\KIM & ROUSSEAU (JPR).dta", clear
compress

#del ;
/*Table 2, columns 1 & 2*/
cdsimeq (depend_m dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd
region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s
iisbd peaceyrs _spline1 _spline2 _spline3), nof nos;

/*Table 2, columns 3 & 4: substitute gdp for major power indicator*/
cdsimeq (depend_m dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd
region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist gdp civil_s iisbd
peaceyrs _spline1 _spline2 _spline3), nof nos;

/*probit only*/
probit uof depend_m dem_a dem_b dem_ab bof bof2 allies satis contig dist major
civil_s iisbd peaceyrs _spline1 _spline2 _spline3;

probit uof depend_m dem_a dem_b dem_ab bof bof2 allies satis contig dist gdp civil_s
iisbd peaceyrs _spline1 _spline2 _spline3;

exit;
