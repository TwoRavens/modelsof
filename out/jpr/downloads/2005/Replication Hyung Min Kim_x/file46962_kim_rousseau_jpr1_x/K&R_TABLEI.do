log using C:\KIM_ROUSSEAU_JPR\K&R_TABLEI.log
*/ produces analyses for TABLES I in Hyung Min Kim & David L. Rousseau, "The Classical Liberals Were Half Right (or Half Wrong): New Tests of the 'Liberal Peace,' 1960-88," Journal of Peace Research (run: 12/23/2004)  /*
use "C:\KIM_ROUSSEAU_JPR\KIM & ROUSSEAU (JPR).dta", clear
*/ TABLE I: Using Primary Measure for Economic Interdependence "TRADE DEPENDENCE OR ECONOMY DEPENDENCE (MONADIC)" /*
probit uof depend_m dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3
cdsimeq (depend_m dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
log close
