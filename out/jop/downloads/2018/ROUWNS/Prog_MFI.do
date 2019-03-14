
* To run, type: 
* WMEANEFFECTS Treatment Weight Y1 Y2... if..
* NOTE A WEIGHT VARIABLE AND  AN IF STATEMENT MUST BE INCLUDED
* IF NOT NEEDED USE DUMMY WEIGHT (POSSIBLY WEIGHT=1) AND NON BINDING  IF STATEMENT (POSSIBLY IF T!=.) 

program define  WMEANEFFECTS

	** Housekeeping
	version 9.0
	syntax varlist if/, Generate(name)
	gettoken T R : varlist
	gettoken W Y : R
	quietly gen _TT = `T' if `if'
	local i = 0

	** Normalize each Y in list of Ys
	foreach YY of varlist `Y'{
		local i = `i'+1
		display `i'
		quietly summarize `YY' [w=`W'] if _TT==0, detail
		quietly g _Z`i' = (`YY'-r(mean))/r(sd) if `if'
		}

	** Generate index
		egen _Z = rmean(_Z1-_Z`i')

	** Renormalize index
		quietly summarize _Z [w=`W'] if _TT==0, detail
		quietly replace _Z = (_Z-r(mean))/r(sd) if `if'

	** Output
		summarize _Z [w=`W'] if _TT==0
		gen `generate' =  _Z 
		lab var `generate' "Mean Effects index `Y'"
		drop _TT _Z1-_Z`i' _Z
end

* Illustrate
* Illustration does two meaneffects, the second one drops an observation with a screwy weight

	clear
	set obs 20
	set seed 1
	gen treat = _n>10
	gen weight = uniform()
	gen Y1 = treat + invnorm(uniform())
	gen Y2 = -treat + invnorm(uniform())
	replace Y1 = . in 3
	replace weight = . in 5
	replace weight = 1000 in 1
	sum
	WMEANEFFECTS  treat weight Y1 Y2 if treat!=., g(My_New_Index1)
	WMEANEFFECTS  treat weight Y1 Y2 if weight<1000, g(My_New_Index2)
