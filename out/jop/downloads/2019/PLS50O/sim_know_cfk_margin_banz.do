
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      sim_know_cfk_margin_banz.do                     * 
*       Date:           April 5, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	Marginal Effect Graphs for CF coalition         *  
*                       to generate Figures A3 & A5 in Appendix         *
* 	    Input File:     analysis.dta                                    * 
*       Data Output:    know_b_cf_marginb.pdf,         (Fig. A3)        *                
*                       know_center_cf_marginb.pdf,    (Fig. A3)        *      
*                       know_leader_cf_marginb.pdf,    (Fig. A5)        *
*                       know_party_cf_marginb.pdf      (Fig. A5)        *             
*     ****************************************************************  * 
*     ****************************************************************  *






clear


set more off
use analysis, clear



******************************************************************
*                           Estimate Model                       *
******************************************************************
*nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  know_center_i_cf  know_v_cf  know_ivcenter_i_cf   know_cand_cf  know_scalo_cf
nlcl cdu fdp  center_i_cf b_rat_cf ibrcenter_i_cf    cand_cf  scalo_cf  know  know_center_i_cf  know_b_rat_cf  know_ibrcenter_i_cf   know_cand_cf  know_scalo_cf
gen keep = 1 if e(sample)
drop if keep ~=1
save temp, replace

sum keep
drawnorm gamma0-gamma11, seed(1234) n(`r(N)') means(e(b)) cov(e(V)) clear
sum gamma*
merge using temp

sum gamma0
local obs = `r(N)'

*****************************************
* Marginal Effect of Banzhaf  [0;1]     * 
*****************************************


capture drop alpha* evalaxis
 
			 gen alphahatlo_b = .
			 gen alphahathi_b = .
			 gen alphahatm_b = .
			 generate evalaxis = ((_n-1)/10) in 1/11
	
			 
forvalues j = 1/11 {
             gen alphahat_b`j' = .

               forvalues i = 1/`obs' {
			                                                                                               
                    #delimit ;
                    gen alphahat_b0_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*(0) + gamma3[`i']*center_i_cf*(0) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*(0)*(((`j')-1)/10) + gamma9[`i']*(0)*center_i_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
					
					gen alphahat_b1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*(1) + gamma3[`i']*center_i_cf*(1) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*(1)*(((`j')-1)/10) + gamma9[`i']*(1)*center_i_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
                    #delimit cr
					
					gen alphahat_b_`i'= alphahat_b1_`i' - alphahat_b0_`i'
                    sum alphahat_b_`i', meanonly
                    replace alphahat_b`j' = r(mean) in `i'
                    drop alphahat_b1_`i' alphahat_b0_`i' alphahat_b_`i'
                }

_pctile alphahat_b`j', p(2.5,97.5)
      replace alphahatlo_b = r(r1) if evalaxis==float((((`j')-1)/10))
      replace alphahathi_b = r(r2) if evalaxis==float((((`j')-1)/10))
      replace alphahatm_b = alphahathi_b-(alphahathi_b-alphahatlo_b)/2  if evalaxis==float((((`j')-1)/10))
 }



 
#delimit ;
twoway
rarea alphahatlo_b alphahathi_b evalaxis, sort bcolor(gs12) ||
line  alphahatm_b evalaxis ||
, legend(off) ytitle("Marginal Effect of Banzhaf" "(Difference in Predicted Probability)", color(black)) 
yline(0, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(-.5(.5)1,  ticks angle(0)) 
xtitle("Political Knowledge", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(know_b_cf_marginb, replace)
;
#delimit cr


graph export know_b_cf_marginb.pdf, replace




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
                    gen alphahat_c_10_`i' = invlogit(gamma0[`i']+ gamma1[`i']*(-10)  + gamma2[`i']*b_rat_cf + gamma3[`i']*b_rat_cf*(-10) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*(-10)*(((`j')-1)/10)  + gamma8[`i']*b_rat_cf*(((`j')-1)/10) + gamma9[`i']*(-10)*b_rat_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
					
					gen alphahat_c10_`i' = invlogit(gamma0[`i']+ gamma1[`i']*(10)  + gamma2[`i']*b_rat_cf + gamma3[`i']*b_rat_cf*(10) + gamma4[`i']*cand_cf + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*(10)*(((`j')-1)/10)  + gamma8[`i']*b_rat_cf*(((`j')-1)/10) + gamma9[`i']*(10)*b_rat_cf*(((`j')-1)/10)
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
, legend(off) ytitle("Marginal Effect of {&Delta}Ideo. Centrality" "(Difference in Predicted Probability)", color(black)) 
yline(0, lstyle(grid))
yscale(titlegap(2) range(0 1)) ylabel(-.5(.5)1,  ticks angle(0)) 
xtitle("Political Knowledge", color(black) alignment(bottom )) xscale(titlegap(3) ) 
xlabel(0(.1)1, nogrid labsize(2.5))
scheme(s1mono) saving(know_center_cf_marginb, replace)
;
#delimit cr

graph export know_center_cf_marginb.pdf, replace



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
                    gen alphahat_c_1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*b_rat_cf + gamma3[`i']*b_rat_cf*center_i_cf + gamma4[`i']*(-1) + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*b_rat_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*b_rat_cf*(((`j')-1)/10)
 					+ gamma10[`i']*(-1)*(((`j')-1)/10) + gamma11[`i']*scalo_cf*(((`j')-1)/10) );
					
					gen alphahat_c1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*b_rat_cf + gamma3[`i']*b_rat_cf*center_i_cf + gamma4[`i']*(1) + gamma5[`i']*scalo_cf + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*b_rat_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*b_rat_cf*(((`j')-1)/10)
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
scheme(s1mono) saving(know_leader_cf_marginb, replace)
;
#delimit cr


graph export know_leader_cf_marginb.pdf, replace




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
                    gen alphahat_c_1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*b_rat_cf + gamma3[`i']*b_rat_cf*center_i_cf + gamma4[`i']*cand_cf + gamma5[`i']*(-1) + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*b_rat_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*b_rat_cf*(((`j')-1)/10)
 					+ gamma10[`i']*cand_cf*(((`j')-1)/10) + gamma11[`i']*(-1)*(((`j')-1)/10) );
					
					gen alphahat_c1_`i' = invlogit(gamma0[`i']+ gamma1[`i']*center_i_cf  + gamma2[`i']*b_rat_cf + gamma3[`i']*b_rat_cf*center_i_cf + gamma4[`i']*cand_cf + gamma5[`i']*(1) + gamma6[`i']*(((`j')-1)/10) 
 					+ gamma7[`i']*center_i_cf*(((`j')-1)/10)  + gamma8[`i']*b_rat_cf*(((`j')-1)/10) + gamma9[`i']*center_i_cf*b_rat_cf*(((`j')-1)/10)
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
scheme(s1mono) saving(know_party_cf_marginb, replace)
;
#delimit cr

graph export know_party_cf_marginb.pdf, replace


exit
 
 
