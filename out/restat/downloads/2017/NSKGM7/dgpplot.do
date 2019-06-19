clear all
set more off

// this function plots Figures A.1 and A.3 
// Figure A.2 and A.4 are plotted manually using the simulation results
set seed 123
local numl=5
local n=1000000
scalar numl=`numl'
set obs `n'
// subfigure for the b=0 case. to get subfigures for the b=2 and b=3 cases,
// just change the following parameter
local b=0
gen x=2*ceil(runiform()*numl)/numl
tab x
gen z=round(runiform())
gen v=rnormal()
gen u0=rnormal()
gen u1=rnormal()
gen e=rnormal()
gen y0=x+v+0.8*u0	
gen y1=y0+0.25*(x+v)+0.6*u1 
gen t=z
gen y=y0*(1-t)+y1*t	
corr t z
sum t

qui levelsof x, local(level)
scalar numqt=49
local numqt=numqt
matrix Frank1=J(numqt,numl,.)
matrix Frank0=J(numqt,numl,.)
matrix Mrank1=J(numl,1,.)
matrix Mrank0=J(numl,1,.)
qui gen qtindicator1=.
qui gen qtindicator0=.
gen qtgrid=.
gen xgrid=.

cumul y1, generate(rank1)
cumul y0, generate(rank0)

forval qind=1/`numqt' {
	local indqt=1/(`numqt'+1)*`qind'
	qui replace qtgrid=`indqt' in `qind'
	qui replace qtindicator1=(rank1<=`indqt')
	qui replace qtindicator0=(rank0<=`indqt')
	local lind=0
		foreach l of local level {
		local lind=`lind'+1
		qui sum qtindicator1 if x==float(`l')
		matrix Frank1[`qind',`lind']=r(mean)
	    qui sum qtindicator0 if x==float(`l')
		matrix Frank0[`qind',`lind']=r(mean)
	}
	}
	
	svmat Frank1, names(Frank1)
	svmat Frank0, names(Frank0)
	svmat Mrank1, names(Mrank1)
	svmat Mrank0, names(Mrank0)

	line Frank11 qtgrid, lpattern(solid) lcolor(navy) /*
	*/|| line Frank01 qtgrid, lpattern(dash) lcolor(navy) /*
	*/|| line Frank12 qtgrid, lpattern(solid) lcolor(gray) /*
	*/|| line Frank02 qtgrid, lpattern(dash) lcolor(gray) /*	
	*/|| line Frank13 qtgrid, lpattern(solid) lcolor(green)/*
	*/|| line Frank03 qtgrid, lpattern(dash) lcolor(green) /*
	*/|| line Frank14 qtgrid, lpattern(solid) lcolor(purple) /*
	*/|| line Frank04 qtgrid, lpattern(dash) lcolor(purple) /*	
	*/|| line Frank15 qtgrid, lpattern(solid) lcolor(orange)/*
	*/|| line Frank05 qtgrid, lpattern(dash) lcolor(orange)/*
	*/ xtitle("Potential rank") ytitle("Conditional CDF") title("b=`b'") /*
	*/legend(label(1 "X=0.4, Y(1)") label(2 "X=0.4, Y(0)") label(3 "X=0.8, Y(1)") /*
	*/label(4 "X=0.8, Y(0)") label(5 "X=1.2, Y(1)") label(6 "X=1.2, Y(0)")  /*
	*/ label(7 "X=1.6, Y(1)") label(8 "X=1.6, Y(0)") label(9 "X=2.0, Y(1)") label(10 "X=2.0, Y(0)"))/*
	*/ graphregion(color(white))
	
	graph export "b`b'Exogenous.eps", replace
	graph export "b`b'Exogenous.pdf", replace


drop Frank*
drop Mrank* 
replace t=(0.15*(y1-y0)+z-0.5>0)
replace y=y0*(1-t)+y1*t
gen comply=(0.15*(y1-y0)+0.5>0 & 0.15*(y1-y0)-0.5<0)
sum comply
cumul y1 if comply==1, generate(rank1c)
cumul y0 if comply==1, generate(rank0c)

local numqt=numqt
matrix Frank1=J(numqt,numl,.)
matrix Frank0=J(numqt,numl,.)
forval qind=1/`numqt' {
	local indqt=1/(`numqt'+1)*`qind'	
	qui replace qtindicator1=(rank1c<=`indqt')
	qui replace qtindicator0=(rank0c<=`indqt')
	local lind=0
		foreach l of local level {
		local lind=`lind'+1
		qui sum qtindicator1 if comply==1 & x==float(`l')
		matrix Frank1[`qind',`lind']=r(mean)
	    qui sum qtindicator0 if comply==1 & x==float(`l')
		matrix Frank0[`qind',`lind']=r(mean)
	}
	}
	
	
	svmat Frank1, names(Frank1)
	svmat Frank0, names(Frank0)

	line Frank11 qtgrid, lpattern(solid) lcolor(navy) /*
	*/|| line Frank01 qtgrid, lpattern(dash) lcolor(navy) /*
	*/|| line Frank12 qtgrid, lpattern(solid) lcolor(gray) /*
	*/|| line Frank02 qtgrid, lpattern(dash) lcolor(gray) /*	
	*/|| line Frank13 qtgrid, lpattern(solid) lcolor(green)/*
	*/|| line Frank03 qtgrid, lpattern(dash) lcolor(green) /*
	*/|| line Frank14 qtgrid, lpattern(solid) lcolor(purple) /*
	*/|| line Frank04 qtgrid, lpattern(dash) lcolor(purple) /*	
	*/|| line Frank15 qtgrid, lpattern(solid) lcolor(orange)/*
	*/|| line Frank05 qtgrid, lpattern(dash) lcolor(orange)/*
	*/ xtitle("Potential rank") ytitle("Conditional CDF") title("b=`b'") /*
	*/legend(label(1 "X=0.4, Y(1)") label(2 "X=0.4, Y(0)") label(3 "X=0.8, Y(1)") /*
	*/label(4 "X=0.8, Y(0)") label(5 "X=1.2, Y(1)") label(6 "X=1.2, Y(0)")  /*
	*/ label(7 "X=1.6, Y(1)") label(8 "X=1.6, Y(0)") label(9 "X=2.0, Y(1)") label(10 "X=2.0, Y(0)"))/*
	*/ graphregion(color(white))
	graph export "b`b'Endogenous.eps", replace
	graph export "b`b'Endogenous.pdf", replace
