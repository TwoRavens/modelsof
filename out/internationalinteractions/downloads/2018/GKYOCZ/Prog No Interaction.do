/* STEP 1: RUN FIRST
global variablelist Y X1 X2 X3 X4
xtset ccode year
set seed 12345
estsimp logit Y X1 X2 X3 X4, cl(ccode)
setx X1 0 X2 mean X3 mean X4 median
*To get the marginal effect of a variable from min to max in 20 ticks
clarifyone X3 20
*/
capture program drop clarifyone
program define clarifyone
qui g `1'MU=.
qui g `1'LI=.
qui g `1'HI=.
qui su `1'
qui scalar min`1'=r(min)
qui scalar max`1'=r(max)
qui scalar inc`1'=(max`1'-min`1')/`2' //the increment in each x value
qui g xaxis_`1'=min`1' in 1/`2' //the x axis values
forvalues h=0/`2' {
qui local m=`h'+1
	qui replace xaxis_`1'=xaxis_`1'+`h'*inc`1' in `m'
	qui su xaxis_`1'
	qui scalar xaxis_`1'_`m'=r(max)
	qui setx `1' xaxis_`1'_`m'
	qui set seed 12345
	qui simqi, prval(1) genpr(pi)
	qui _pctile pi, p(2.5,97.5)
	qui replace `1'LI = r(r1) in `m' if `m'<=`2'
	qui replace `1'HI = r(r2) in `m' if `m'<=`2'
	qui su pi
	qui replace `1'MU=r(mean) in `m' if `m'<=`2'
	qui drop pi
	}
g yline=0 in 1/`2'
loc `1'label: var l `1'
di "``1'label'"
su  xaxis_`1'
tempvar `1's
gen ``1's'=`1'
replace ``1's'=. if `1'>r(max)
#delimit ;
twoway (hist `1', percent color(gs14) yaxis(1))
(line `1'MU xaxis_`1', clwidth(medium) clcolor(blue) clcolor(black) yaxis(2))
       (line `1'LI xaxis_`1', clpattern(dash) clwidth(thin) clcolor(red) yaxis(2))
       (line `1'HI xaxis_`1', clpattern(dash) clwidth(thin) clcolor(red) yaxis(2)) 
       (line yline xaxis_`1', clwidth(thin) clcolor(black) clpattern(dash) yaxis(2))  
	   
       ||,  	
			xtitle("``1'label'")
			ytitle("Pr(Y=1)")
            scheme(s1mono);	
#delimit cr 
drop yline `1'MU `1'LI `1'HI xaxis_`1'
end

