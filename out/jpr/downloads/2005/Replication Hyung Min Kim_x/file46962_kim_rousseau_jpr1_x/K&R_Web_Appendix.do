log using C:\KIM_ROUSSEAU_JPR\K&R_Web_Appendix.log
*/ produces analyses for Web-Appendix in Hyung Min Kim & David L. Rousseau, "The Classical Liberals Were Half Right (or Half Wrong): New Tests of the 'Liberal Peace,' 1960-88," Journal of Peace Research (run: 12/23/2004)  /*
use "C:\KIM_ROUSSEAU_JPR\KIM & ROUSSEAU (JPR).dta", clear
*/ TABLE C: Using Alternative Measure #1 for Economic Interdependence "TRADE SHARE OR PARTNER DEPENDENCE (MONADIC)" /*
probit uof share_m dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3
cdsimeq (share_m dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
*/ TABLE C: Using Alternative Measure #2 for Economic Interdependence "TRADE DEPENDENCE OR ECONOMY DEPENDENCE (DYADIC)" /*
probit uof depend_d dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3
cdsimeq (depend_d dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
*/ TABLE C: Using Alternative Measure #3 for Economic Interdependence "TRADE SHARE OR PARTNER DEPENDENCE (DYADIC)" /*
probit uof share_d dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3
cdsimeq (share_d dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
*/ TABLE C: Using Alternative Measure #4 for Economic Interdependence "TRADE DEPENDENCE OR ECONOMY DEPENDENCE (WEAK-LINK)" /*
probit uof depend_l dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3
cdsimeq (depend_l dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
*/ TABLE C: Using Alternative Measure #5 for Economic Interdependence "BIALTERAL TRADE" /*
probit uof trade dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3
cdsimeq (trade dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
*/ Web-appendix 7: Using the Raw Interdependence Measures: Using the Beck et al. Remedy Approach /*
cdsimeq (r_inter1 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
cdsimeq (r_inter2 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
cdsimeq (r_inter3 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
cdsimeq (r_inter4 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
cdsimeq (r_inter5 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
cdsimeq (r_inter6 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd peaceyrs _spline1 _spline2 _spline3)
*/ Web-appendix 7: Using the Logged Interdependence Measures: Using the Lagged Vars. Approach /*
cdsimeq (depend_m l_inter1 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (share_m l_inter2 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (depend_d l_inter3 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (share_d l_inter4 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (depend_l l_inter5 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (trade l_inter6 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
*/ Web-appendix 7: Using the Raw Interdependence Measures: Using the Lagged Vars. Approach /*
cdsimeq (r_inter1 rl_inter1 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (r_inter2 rl_inter2 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (r_inter3 rl_inter3 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (r_inter4 rl_inter4 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (r_inter5 rl_inter5 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
cdsimeq (r_inter6 rl_inter5 dem_a dem_b dem_ab allies noncomm dist gdp pop pta fcolon oecd region) (uof l_uof dem_a dem_b dem_ab bof bof2 allies satis contig dist major civil_s iisbd)
log close
