
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      sim_cfk_i.do                                    * 
*       Date:           April 4, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	Graph results for CF coalition  & knowledge     * 
*                        + interaction party size *  ideo centrality    *
* 	    Input File:     analysis.dta                                    * 
*       Data Output:    center_new_cf_i.pdf,  v_new_cf_i.pdf            *
*                       as part of figure 4                             *               
*     ****************************************************************  * 
*     ****************************************************************  * 




clear


set more off
use analysis, clear



******************************************************************
*                           Estimate Model                       *
******************************************************************
nlcl cdu fdp  v_cf  center_i_cf ivcenter_i_cf   cand_cf  scalo_cf  know
gen keep = 1 if e(sample)
drop if keep ~=1
save temp, replace

sum keep
drawnorm gamma0-gamma6, seed(1234) n(`r(N)') means(e(b)) cov(e(V)) clear
sum gamma*
merge using temp

sum gamma0
local obs = `r(N)'


* Graph with Ideological Centrality (-10; 10)

			 gen alphahatlo = .
			 gen alphahathi = .
			 gen alphahatm = .
			 gen evalaxis = .
forvalues j = 1/21 {
             gen alphahat`j' = .

               forvalues i = 1/`obs' {
                    gen alphahat_`i' = invlogit(gamma0[`i']+ gamma1[`i']*v_cf  + gamma2[`i']*((`j')-11) + gamma3[`i']*((`j')-11)*v_cf + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*know)
                    sum alphahat_`i', meanonly
                    replace alphahat`j' = r(mean) in `i'
                    drop alphahat_`i'
                }
				
	_pctile alphahat`j', p(2.5,97.5)
      replace alphahatlo = r(r1) in  `j'
      replace alphahathi = r(r2) in  `j'
      replace alphahatm = alphahathi-(alphahathi-alphahatlo)/2  in  `j'
	  replace evalaxis = ((`j')-11) in  `j'
 }


#delimit ;
twoway
rarea alphahatlo alphahathi evalaxis, sort bcolor(gs12) ||
line  alphahatm evalaxis ||
(hist  center_i_cf, discrete bcolor(gs14))
, legend(off) ytitle("{&alpha} [Coalition Weight]", color(black)) 
yline(.5, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(0(.5)1,  ticks angle(0)) 
xtitle("{&Delta}Ideological Centrality", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(-10(1)10, nogrid labsize(2.5))
scheme(s1mono) saving(center_new_cf_i, replace)
;
#delimit cr


graph export center_new_cf_i.pdf, replace





* Graph with Party Size (v_cf) for (`j')-1)/100 on 1/101 => [0,1]

* j increases from 11 to 101 in order to facilitate interpretation
* How many respondents habe Gamsonian expectationa?
 
 capture drop alpha* evalaxis
 
			 gen alphahatlo = .
			 gen alphahathi = .
			 gen alphahatm = .
			 generate evalaxis = ((_n-1)/100) in 1/101
forvalues j = 1/101 {
             gen alphahat`j' = .

               forvalues i = 1/`obs' {
                    gen alphahat_`i' = invlogit(gamma0[`i']+ gamma1[`i']*(((`j')-1)/100)  + gamma2[`i']*center_i_cf + gamma3[`i']*center_i_cf*(((`j')-1)/100) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*know)
                    sum alphahat_`i', meanonly
                    replace alphahat`j' = r(mean) in `i'
                    drop alphahat_`i'
                }
				
	_pctile alphahat`j', p(2.5,97.5)
      replace alphahatlo = r(r1) if evalaxis==float((((`j')-1)/100))
      replace alphahathi = r(r2) if evalaxis==float((((`j')-1)/100))
      replace alphahatm = alphahathi-(alphahathi-alphahatlo)/2  if evalaxis==float((((`j')-1)/100))
 }

 
gen where = -0.009
gen pipe = "|" 


* Results for 2009
* CDU/CSU 33.8%
* SPD 23.0%
* FDP 9.8%

*CDU share is .775
dis .338/(.338 + .098)
 
#delimit ;
twoway
function y=x, range(.3 1) lstyle(grid)||
rarea alphahatlo alphahathi evalaxis if evalaxis>=.3 , sort bcolor(gs12) ||
line  alphahatm evalaxis if evalaxis>=.3  ||
(scatter where v_cf if v_cf>=.3, ms(none) mlabel(pipe) mlabpos(0))
, legend(off) ytitle("{&alpha} [Coalition Weight]", color(black)) 
yline(.5, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(0(.5)1,  ticks angle(0)) 
xtitle("CDU Vote Share (of respective coalition)", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0.3(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(v_new_cf_i, replace)
;
#delimit cr

graph export v_new_cf_i.pdf, replace





** Interpretation in text: How many respondnets have Gamsonian expectations?

list  alphahatlo alphahathi  evalaxis if alphahatm!=.

* Generate variable to calculate for how many voters have Gamsonian expectations
* For about 9% of the respondents does Gamsons's Law hold
* the hard-coded values are from listing above, i.e., the simulated lower 
* and upper bounds that intersect with Gamson's Law prediction (y=x) 
* i.e., for evalaxis==.37, alphahatlo<evalaxis & for evalaxis==.66, alphahathi>evalaxis

capture drop gamson
gen gamson = (.37<v_cf & .66>v_cf)
replace gamson = . if v_cs==.
tab gamson 



