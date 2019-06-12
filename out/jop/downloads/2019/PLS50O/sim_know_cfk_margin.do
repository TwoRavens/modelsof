
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      sim_know_cfk_margin.do                          * 
*       Date:           April 5, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	Marginal Effect Graphs for CF coalition         * 
*                       to generate Figures A2 & A4 in Appendix         *
* 	    Input File:     analysis.dta                                    * 
*       Data Output:    know_v_cf_margin.pdf,          (Fig. A2)        *          
*                       know_center_cf_margin.pdf,     (Fig. A2)        *                 
*                       know_leader_cf_margin.pdf,     (Fig. A4)        *
*                       know_party_cf_margin.pdf       (Fig. A4)        *            
*     ****************************************************************  * 
*     ****************************************************************  * 




clear


set more off
use analysis, clear



******************************************************************
*                           Estimate Model                       *
******************************************************************
nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  know_center_i_cf  know_v_cf  know_ivcenter_i_cf   know_cand_cf  know_scalo_cf
gen keep = 1 if e(sample)
drop if keep ~=1
save temp, replace

sum keep
drawnorm gamma0-gamma11, seed(1234) n(`r(N)') means(e(b)) cov(e(V)) clear
sum gamma*
merge using temp

sum gamma0
local obs = `r(N)'

*********************************
* Marginal Effect of Party Size *
*********************************

 capture drop alpha* evalaxis
 
			 gen alphahatlo_v = .
			 gen alphahathi_v = .
			 gen alphahatm_v = .
			 generate evalaxis = ((_n-1)/10) in 1/11  // knowledge axis [0;1]
			 
forvalues j = 1/11 {
             gen alphahat_v`j' = .

               forvalues i = 1/`obs' {
			                                                                                               
                    #delimit ;
                    gen alphahat_v1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*1 + gamma3[`i']*center_i_cf*1 + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*1*(((`j')-1)/10) + gamma9[`i']*center_i_cf*1*(((`j')-1)/10)
					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
					
					gen alphahat_v0_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*0 + gamma3[`i']*center_i_cf*0 + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*0*(((`j')-1)/10) + gamma9[`i']*center_i_cf*0*(((`j')-1)/10)
					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
                    #delimit cr
					
					gen alphahat_v_`i'= alphahat_v1_`i' - alphahat_v0_`i'
                    sum alphahat_v_`i', meanonly
                    replace alphahat_v`j' = r(mean) in `i'
                    drop alphahat_v1_`i' alphahat_v0_`i' alphahat_v_`i'
                }

_pctile alphahat_v`j', p(2.5,97.5)
      replace alphahatlo_v = r(r1) if evalaxis==float((((`j')-1)/10))
      replace alphahathi_v = r(r2) if evalaxis==float((((`j')-1)/10))
      replace alphahatm_v = alphahathi_v-(alphahathi_v-alphahatlo_v)/2  if evalaxis==float((((`j')-1)/10))
 }

 
#delimit ;
twoway
rarea alphahatlo_v alphahathi_v evalaxis, sort bcolor(gs12) ||
line  alphahatm_v evalaxis ||
, legend(off) ytitle("Marginal Effect of Party Size" "(Difference in Predicted Probability)", color(black)) 
yline(0, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(-.5(.5)1,  ticks angle(0)) 
xtitle("Political Knowledge", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(know_v_cf_margin, replace)
;
#delimit cr


graph export know_v_cf_margin.pdf, replace



*************************************
* Marginal Effect of IdeoCentrality *
*************************************


 
capture drop alpha* evalaxis
 
			 gen alphahatlo_c = .
			 gen alphahathi_c = .
			 gen alphahatm_c = .
			 generate evalaxis = ((_n-1)/10) in 1/11
			 
forvalues j = 1/11 {
             gen alphahat_c`j' = .

               forvalues i = 1/`obs' {
			                                                                                               
                    #delimit ;
                    gen alphahat_c_10_`i' = invlogit(gamma0[`i']+ gamma1[`i']*(-10)  + gamma2[`i']*v_cf + gamma3[`i']*v_cf*(-10) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*(-10)*(((`j')-1)/10)  + gamma8[`i']*v_cf*(((`j')-1)/10) + gamma9[`i']*(-10)*v_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
					
					gen alphahat_c10_`i' = invlogit(gamma0[`i']+ gamma1[`i']*(10)  + gamma2[`i']*v_cf + gamma3[`i']*v_cf*(10) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*(10)*(((`j')-1)/10)  + gamma8[`i']*v_cf*(((`j')-1)/10) + gamma9[`i']*(10)*v_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
                    #delimit cr
					
					gen alphahat_c_`i'= alphahat_c10_`i' - alphahat_c_10_`i'
                    sum alphahat_c_`i', meanonly
                    replace alphahat_c`j' = r(mean) in `i'
                    drop alphahat_c10_`i' alphahat_c_10_`i' alphahat_c_`i'
                }

_pctile alphahat_c`j', p(2.5,97.5)
      replace alphahatlo_c = r(r1) if evalaxis==float((((`j')-1)/10))
      replace alphahathi_c = r(r2) if evalaxis==float((((`j')-1)/10))
      replace alphahatm_c = alphahathi_c-(alphahathi_c-alphahatlo_c)/2  if evalaxis==float((((`j')-1)/10))
 }



 
#delimit ;
twoway
rarea alphahatlo_c alphahathi_c evalaxis, sort bcolor(gs12) ||
line  alphahatm_c evalaxis ||
, legend(off) ytitle("Marginal Effect of {&Delta}Ideo. Centrality" "(Difference in Predicted Probability)" , color(black)) 
yline(0, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(-.5(.5)1,  ticks angle(0)) 
xtitle("Political Knowledge", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(know_center_cf_margin, replace)
;
#delimit cr


graph export know_center_cf_margin.pdf, replace




*************************************************
* Marginal Effect of {&Delta} Leader Evaluation *
*************************************************

*nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  know_center_i_cf  know_v_cf  know_ivcenter_i_cf   know_cand_cf  know_scalo_cf
 
capture drop alpha* evalaxis
 
			 gen alphahatlo_c = .
			 gen alphahathi_c = .
			 gen alphahatm_c = .
			 generate evalaxis = ((_n-1)/10) in 1/11
			 
forvalues j = 1/11 {
             gen alphahat_c`j' = .

               forvalues i = 1/`obs' {
			                                                                                               
                    #delimit ;
                    gen alphahat_c_1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*v_cf + gamma3[`i']*v_cf*center_i_cf + gamma4[`i']*(-1) + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*v_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*v_cf*(((`j')-1)/10)
 					+ gamma10[`i']*(-1)*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
					
					gen alphahat_c1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*v_cf + gamma3[`i']*v_cf*center_i_cf + gamma4[`i']*(1) + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*v_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*v_cf*(((`j')-1)/10)
 					+ gamma10[`i']*(1)*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
                    #delimit cr
					
					gen alphahat_c_`i'= alphahat_c1_`i' - alphahat_c_1_`i'
                    sum alphahat_c_`i', meanonly
                    replace alphahat_c`j' = r(mean) in `i'
                    drop alphahat_c1_`i' alphahat_c_1_`i' alphahat_c_`i'
                }

_pctile alphahat_c`j', p(2.5,97.5)
      replace alphahatlo_c = r(r1) if evalaxis==float((((`j')-1)/10))
      replace alphahathi_c = r(r2) if evalaxis==float((((`j')-1)/10))
      replace alphahatm_c = alphahathi_c-(alphahathi_c-alphahatlo_c)/2  if evalaxis==float((((`j')-1)/10))
 }



 
#delimit ;
twoway
rarea alphahatlo_c alphahathi_c evalaxis, sort bcolor(gs12) ||
line  alphahatm_c evalaxis ||
, legend(off) ytitle("Marginal Effect of {&Delta}Leader Evaluation" "(Difference in Predicted Probability)", color(black)) 
yline(0, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(-.5(.5)1,  ticks angle(0)) 
xtitle("Political Knowledge", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(know_leader_cf_margin, replace)
;
#delimit cr

graph export know_leader_cf_margin.pdf, replace




*************************************************
* Marginal Effect of {&Delta} Party Preference  *
*************************************************

*nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  know_center_i_cf  know_v_cf  know_ivcenter_i_cf   know_cand_cf  know_scalo_cf
 
capture drop alpha* evalaxis
 
			 gen alphahatlo_c = .
			 gen alphahathi_c = .
			 gen alphahatm_c = .
			 generate evalaxis = ((_n-1)/10) in 1/11
			 
forvalues j = 1/11 {
             gen alphahat_c`j' = .

               forvalues i = 1/`obs' {
			                                                                                               
                    #delimit ;
                    gen alphahat_c_1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*v_cf + gamma3[`i']*v_cf*center_i_cf + gamma4[`i']*cand_cf + gamma5[`i']*(-1) + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*v_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*v_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*(-1)*(((`j')-1)/10) );
					
					gen alphahat_c1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*v_cf + gamma3[`i']*v_cf*center_i_cf + gamma4[`i']*cand_cf + gamma5[`i']*(1) + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*v_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*v_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*(1)*(((`j')-1)/10) );
                    #delimit cr
					
					gen alphahat_c_`i'= alphahat_c1_`i' - alphahat_c_1_`i'
                    sum alphahat_c_`i', meanonly
                    replace alphahat_c`j' = r(mean) in `i'
                    drop alphahat_c1_`i' alphahat_c_1_`i' alphahat_c_`i'
                }

_pctile alphahat_c`j', p(2.5,97.5)
      replace alphahatlo_c = r(r1) if evalaxis==float((((`j')-1)/10))
      replace alphahathi_c = r(r2) if evalaxis==float((((`j')-1)/10))
      replace alphahatm_c = alphahathi_c-(alphahathi_c-alphahatlo_c)/2  if evalaxis==float((((`j')-1)/10))
 }



 
#delimit ;
twoway
rarea alphahatlo_c alphahathi_c evalaxis, sort bcolor(gs12) ||
line  alphahatm_c evalaxis ||
, legend(off) ytitle("Marginal Effect of {&Delta}Party Preference" "(Difference in Predicted Probability)", color(black)) 
yline(0, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(-.5(.5)1,  ticks angle(0)) 
xtitle("Political Knowledge", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(know_party_cf_margin, replace)
;
#delimit cr


graph export know_party_cf_margin.pdf, replace



exit
 
 
