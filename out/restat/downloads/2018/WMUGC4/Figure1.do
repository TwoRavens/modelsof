use "data.dta", clear
tw (pci 0 40 0 100,lcolor(gs6) lwidth(medthick ) plotregion(color(white)) legend(off)  graphregion(color(white)) xlabel("") ylabel("") ////
yscale(range(0 100) off) xscale(range(38 100) off) xsize(2) ysize(1)) ///
(scatteri 48 50, msize(ehuge) mfcolor(white) mcolor(gs6) msymbol(smcircle_hollow))  ///
	(pci 100 100 0 100,lcolor(gs6) lwidth(medthick)) ///
	(pci 100 40 100 100,lcolor(gs6) lwidth(medthick)) ///
	(pci 100 100 100 40,lcolor(gs6) lwidth(medthick)) ///
	(pci 0 50 100 50,lcolor(gs6) lwidth(medthick)) ///
	(pci 78.9 100 78.9 83,lcolor(gs6) lwidth(medthick)) ///
	(pci 78.9 83 21.1 83,lcolor(gs6) lwidth(medthick)) ////
	(pci 36.8 100 36.8 94.2,lcolor(gs6) lwidth(medthick)) ///
	(pci 21.1 100 21.1 83,lcolor(gs6) lwidth(medthick)) ///
	(pci 63.2 100 63.2 94.2,lcolor(gs6) lwidth(medthick)) ///
	(pci 63.2 94.2 36.8 94.2,lcolor(gs6) lwidth(medthick)) ///
	(scatteri 50 88.5 50 50, msize(medium) mcolor(gs6)) ///
	(pci 42.9 100 58.15 100,lcolor(gs6) lwidth(vthick )) ///
	(pcarrowi 0 39 100 39 ,lcolor(gs6)  mcolor(gs6)  ) ///
	(pcarrowi 100 39 0 39 , lcolor(gs6) mcolor(gs6) ) ///
	(scatteri 50 38 "68 meters",  msymbol(i) mlabpos(0) mlabangle(90) mlabcolor(gs6)) ////
	(pcarrowi  -2 50  -2 100,lcolor(gs6)  mcolor(gs6)  ) ///
	(pcarrowi -2 100 -2 50  , lcolor(gs6) mcolor(gs6) ) ///
	(scatteri -4 75 "52.5 meters",  msymbol(i) mlabpos(0)  mlabcolor(gs6)) ////
	(function y = sqrt(1-(x-100)^2)*2, range(98 100) lcolor(gs6) ) ////
	(function y = -sqrt(1-(x-100)^2)*2+100, range(98 100) lcolor(gs6) ) ///
	(function y = sqrt(1-(x-88.7)^2/7^2)*7*2+48.8,range(75 83) lcolor(gs6) ) ///
	(function y = -sqrt(1-(x-88.7)^2/7^2)*7*2+51.2, range(75 83) lcolor(gs6) ) ///
	(scatter absy3 absx3 if postin==1, msize(small) mcolor(gs11)) 

graph export "Figure1in.png", as(png) hei(900) wid(1100)replace

tw (pci 0 40 0 100,lcolor(gs6) lwidth(medthick ) plotregion(color(white)) legend(off)  graphregion(color(white)) xlabel("") ylabel("") ////
yscale(range(0 100) off) xscale(range(38 100) off) xsize(2) ysize(1)) ///
(scatteri 48 50, msize(ehuge) mfcolor(white) mcolor(gs6) msymbol(smcircle_hollow))  ///
	(pci 100 100 0 100,lcolor(gs6) lwidth(medthick)) ///
	(pci 100 40 100 100,lcolor(gs6) lwidth(medthick)) ///
	(pci 100 100 100 40,lcolor(gs6) lwidth(medthick)) ///
	(pci 0 50 100 50,lcolor(gs6) lwidth(medthick)) ///
	(pci 78.9 100 78.9 83,lcolor(gs6) lwidth(medthick)) ///
	(pci 78.9 83 21.1 83,lcolor(gs6) lwidth(medthick)) ////
	(pci 36.8 100 36.8 94.2,lcolor(gs6) lwidth(medthick)) ///
	(pci 21.1 100 21.1 83,lcolor(gs6) lwidth(medthick)) ///
	(pci 63.2 100 63.2 94.2,lcolor(gs6) lwidth(medthick)) ///
	(pci 63.2 94.2 36.8 94.2,lcolor(gs6) lwidth(medthick)) ///
	(scatteri 50 88.5 50 50, msize(medium) mcolor(gs6)) ///
	(pci 42.9 100 58.15 100,lcolor(gs6) lwidth(vthick )) ///
	(pcarrowi 0 39 100 39 ,lcolor(gs6)  mcolor(gs6)  ) ///
	(pcarrowi 100 39 0 39 , lcolor(gs6) mcolor(gs6) ) ///
	(scatteri 50 38 "68 meters",  msymbol(i) mlabpos(0) mlabangle(90) mlabcolor(gs6)) ////
	(pcarrowi  -2 50  -2 100,lcolor(gs6)  mcolor(gs6)  ) ///
	(pcarrowi -2 100 -2 50  , lcolor(gs6) mcolor(gs6) ) ///
	(scatteri -4 75 "52.5 meters",  msymbol(i) mlabpos(0)  mlabcolor(gs6)) ////
	(function y = sqrt(1-(x-100)^2)*2, range(98 100) lcolor(gs6) ) ////
	(function y = -sqrt(1-(x-100)^2)*2+100, range(98 100) lcolor(gs6) ) ///
	(function y = sqrt(1-(x-88.7)^2/7^2)*7*2+48.8,range(75 83) lcolor(gs6) ) ///
	(function y = -sqrt(1-(x-88.7)^2/7^2)*7*2+51.2, range(75 83) lcolor(gs6) ) ///
	(scatter absy3 absx3 if postin==0, msize(small) mcolor(gs11)) 

graph export "Figure1out.png", as(png) hei(900) wid(1100)replace
