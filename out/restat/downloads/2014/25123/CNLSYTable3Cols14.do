clear all

set mem 300m
set more off
set matsiz 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear



/*PIAT*/

scalar B1 = 1.33305939592453E-26
scalar B2 = 0.0338082359805415
scalar B3 = 0.00191017752220908
scalar B4 = -0.0000690517381140018
scalar B5 = -1.92428688013601E-07
scalar B6 = 1.34570452940933E-08
scalar k = 4.852657601
scalar N1 = 0.45919629476928
***********************************
gen piattransform = B1*(PIATreadcomraw + k) + B2*(PIATreadcomraw + k)^2 + B3*(PIATreadcomraw + k)^3 + B4*(PIATreadcomraw + k)^4 + B5*(PIATreadcomraw + k)^5 + B6*(PIATreadcomraw + k)^6 - N1



/*PPVT*/

scalar B1 = 2.8622362189904E-27
scalar B2 = 0.019175009412964
scalar B3 = 0.000014276995922288
scalar B4 = -2.65405674756929E-06
scalar B5 = 2.35935354335936E-08
scalar B6 = -8.70461218109283E-11
scalar k = 29.87955862
scalar N1 = 15.8845662687485
***********************************
gen earlyppvttransform = B1*(earlyppvt + k) + B2*(earlyppvt + k)^2 + B3*(earlyppvt + k)^3 + B4*(earlyppvt + k)^4 + B5*(earlyppvt + k)^5 + B6*(earlyppvt + k)^6 - N1

egen earlyppvttranstd = std(earlyppvttransform) if grade==0 & PIATreadcomraw!=.
egen earlypiattranstd = std(piattransform) if grade==0 & earlyppvt!=.

reg earlyppvttranstd earlypiattranstd if grade==0

/*Gradewise PIAT - transformed gap*/
forv i=0(1)3   {
     qui: egen piatnorm = std(piattransform) if grade==`i'
	 qui: reg piatnorm black, robust
	 est sto A`i'
	 drop piatnorm  
	                  }
					  
/*Gradewise PIAT -- baseline*/
forv i=0(1)3   {
     qui: egen piatnorm = std(PIATreadcomraw) if grade==`i'
	 qui: reg piatnorm black, robust
	 est sto B`i'
	 drop piatnorm  
	                  }
/*Column 1*/
est tab B0 B1 B2 B3, b se keep(black)

/*Column 4*/
est tab A0 A1 A2 A3, b se keep(black)


