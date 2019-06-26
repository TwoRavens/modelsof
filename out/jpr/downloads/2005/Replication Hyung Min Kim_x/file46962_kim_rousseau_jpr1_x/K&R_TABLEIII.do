log using C:\KIM_ROUSSEAU_JPR\K&R_TABLEIII.log
set memory 800m
*/ produces analyses for TABLE III (using Oneal & Russett data (from ISQ2003 & JPR2003)) in Hyung Min Kim & David L. Rousseau, "The Classical Liberals Were Half Right (or Half Wrong): New Tests of the 'Liberal Peace,' 1960-88," Journal of Peace Research (run: 12/23/2004)  /*
use "C:\KIM_ROUSSEAU_JPR\ONEAL & RUSSETT (FOR K&R, JPR).dta", clear
*/ TABLE III /*
probit newmid smalldep smldmat lcaprat2 allies contigkb logdstab majpower peaceyrs _spline1 _spline2 _spline3
cdsimeq (smalldep smldmat allies logdstab lnrgdps lntpops) (newmid smldmat lcaprat2 allies contigkb logdstab majpower peaceyrs _spline1 _spline2 _spline3)
log close
