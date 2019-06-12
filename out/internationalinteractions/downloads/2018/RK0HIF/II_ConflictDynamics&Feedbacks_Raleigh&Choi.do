* REPLICATION DO-FILE

* Conflict Dynamics and Feedbacks: Explaining Change in Violence against Civilians within Conflicts
* By Clionadh Raleigh & Hyun Jin Choi

* International Interactions



**************************************************************************
* Table 1: Summary Statistics for All Model Variables
sum DRC_VAC_G_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp DRC_Territory_G_log DRC_Territory_R_log DRC_Activeagent ///
    DRC_Newagent DRC_Battles_log DRC_Election DRC_UnitedNations  
	
sum Sudan_VAC_G_log Sudan_VAC_R_log Sudan_VAC_M_log_hp Sudan_Territory_G_log Sudan_Territory_R_log ///
    Sudan_Activeagent Sudan_Newagent Sudan_Battles_log Sudan_Election Sudan_Unitednations 

	
	
**************************************************************************
* Figure 3: DR-Congo, January 1997-December 2014
graph twoway tsline DRC_VAC_G_log if date_01>=tm(1997m1), lcolor(black) tlabel(1998m1 2002m1 2006m1 2010m1 2014m1) name(drc1, replace) subtitle("A: ln(Government VAC)") ytitle("") xtitle("") ylabel(,nogrid) graphregion(margin(small) color(white) lcolor(white)) scheme(s1mono) xscale(noline) 
graph twoway tsline DRC_VAC_R_log DRC_VAC_R_log_hp if date_01>=tm(1997m1), lcolor(black red) tlabel(1998m1 2002m1 2006m1 2010m1 2014m1) name(drc2, replace) subtitle("B: ln(Rebel VAC)") ylabel(-2(2)4) ytitle("") xtitle("") ylabel(,nogrid) graphregion(margin(small) color(white) lcolor(white)) scheme(s1mono) xscale(noline) legend(off)
graph twoway tsline DRC_VAC_M_log DRC_VAC_M_log_hp if date_01>=tm(1997m1), lcolor(black red) tlabel(1998m1 2002m1 2006m1 2010m1 2014m1) name(drc3, replace) subtitle("C: ln(Militia VAC)") ytitle("") xtitle("") ylabel(,nogrid) graphregion(margin(small) color(white) lcolor(white)) scheme(s1mono) xscale(noline) legend(off)
graph combine drc1 drc2 drc3, xsize(8) ysize(7) col(1) graphregion(margin(zero) color(white) lcolor(white) lwidth(thick))

* Figure 4: Sudan, January 1997-December 2014 
graph twoway tsline Sudan_VAC_G_log if date_01>=tm(1997m1), lcolor(black) tlabel(1998m1 2002m1 2006m1 2010m1 2014m1) name(sudan1, replace) subtitle("A: ln(Government VAC)") ytitle("") xtitle("") ylabel(,nogrid) graphregion(margin(small) color(white) lcolor(white)) scheme(s1mono) xscale(noline) 
graph twoway tsline Sudan_VAC_R_log if date_01>=tm(1997m1), lcolor(black) tlabel(1998m1 2002m1 2006m1 2010m1 2014m1) name(sudan2, replace) subtitle("B: ln(Rebel VAC)") ytitle("") xtitle("") ylabel(,nogrid) graphregion(margin(small) color(white) lcolor(white)) scheme(s1mono) xscale(noline) 
graph twoway tsline Sudan_VAC_M_log Sudan_VAC_M_log_hp if date_01>=tm(1997m1), lcolor(black red) tlabel(1998m1 2002m1 2006m1 2010m1 2014m1) name(sudan3, replace) subtitle("C: ln(Militia VAC)") ytitle("") xtitle("") ylabel(,nogrid) graphregion(margin(small) color(white) lcolor(white)) scheme(s1mono) xscale(noline) legend(off)
graph combine sudan1 sudan2 sudan3, xsize(8) ysize(7) col(1) graphregion(margin(zero) color(white) lcolor(white) lwidth(thick))



**************************************************************************
* Figure 5: Positive Feedback in Violence against Civilians in DR-Congo 

**Figure 5A**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar DRC_VAC_G_log DRC_Battles_log DRC_VAC_M_log_hp DRC_VAC_R_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_VAC_G_log DRC_VAC_R_log_hp sirf, level(90) lwidth(medthick) subtitle("A: Government VAC -> Rebel VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 5B**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar DRC_VAC_R_log_hp DRC_Battles_log DRC_VAC_M_log_hp DRC_VAC_G_log, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_VAC_R_log_hp DRC_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("B: Rebel VAC -> Government VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 5C**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar DRC_VAC_R_log_hp DRC_Battles_log DRC_VAC_G_log DRC_VAC_M_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_VAC_R_log_hp DRC_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("C: Rebel VAC -> Militia VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 5D**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar DRC_VAC_M_log_hp DRC_VAC_G_log DRC_Battles_log DRC_VAC_R_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_VAC_M_log_hp DRC_VAC_R_log_hp sirf, level(90) lwidth(medthick) subtitle("D: Militia VAC -> Rebel VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 5E**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar DRC_VAC_G_log DRC_Battles_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_VAC_G_log DRC_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("E: Government VAC -> Militia VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)
			
**Figure 5F**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar DRC_VAC_M_log_hp DRC_Battles_log DRC_VAC_R_log_hp DRC_VAC_G_log, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_VAC_M_log_hp DRC_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("F: Militia VAC -> Government VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

			
**************************************************************************
* Figure 6: Positive Feedback in Violence against Civilians in Sudan 

**Figure 6A**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar Sudan_VAC_G_log Sudan_Battles_log Sudan_VAC_M_log_hp Sudan_VAC_R_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_VAC_G_log Sudan_VAC_R_log sirf, level(90) lwidth(medthick) subtitle("A: Government VAC -> Rebel VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 6B**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar Sudan_VAC_R_log Sudan_Battles_log Sudan_VAC_M_log_hp Sudan_VAC_G_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_VAC_R_log Sudan_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("B: Rebel VAC -> Government VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 6C**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar Sudan_VAC_R_log Sudan_Battles_log Sudan_VAC_G_log Sudan_VAC_M_log_hp, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_VAC_R_log Sudan_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("C: Rebel VAC -> Militia VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 6D**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar Sudan_VAC_M_log_hp Sudan_Battles_log Sudan_VAC_G_log Sudan_VAC_R_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_VAC_M_log_hp Sudan_VAC_R_log sirf, level(90) lwidth(medthick) subtitle("D: Militia VAC -> Rebel VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 6E**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar Sudan_VAC_G_log Sudan_Battles_log Sudan_VAC_R_log Sudan_VAC_M_log_hp, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_VAC_G_log Sudan_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("E: Government VAC -> Militia VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)
			
**Figure 6F**
set more off
matrix A = [1,0,0,0\.,1,0,0\.,.,1,0\.,.,.,1]
matrix list A
matrix B = [.,0,0,0\0,.,0,0\0,0,.,0\0,0,0,.]
matrix list B
svar Sudan_VAC_M_log_hp Sudan_Battles_log Sudan_VAC_R_log Sudan_VAC_G_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_VAC_M_log_hp Sudan_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("F: Militia VAC -> Government VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

			
			
**************************************************************************
* Figure 7: Response of VAC_R to Territory_G 

**Figure 7A**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Territory_G_log DRC_Territory_R_log DRC_Battles_log DRC_VAC_G_log DRC_VAC_R_log_hp, lags(1 2) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Territory_G_log DRC_VAC_R_log_hp sirf, level(90) lwidth(medthick) subtitle("A: Gov. Acquisition of Territory -> Rebel VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") /// 
			ylabel(, nogrid) xsize(8) ysize(8) xlabel(0(3)12) graphregion(margin(zero) color(white)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 7B**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Territory_G_log Sudan_Territory_R_log Sudan_Battles_log Sudan_VAC_G_log Sudan_VAC_R_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar Sudan_Territory_G_log Sudan_VAC_R_log sirf, level(90) lwidth(medthick) subtitle("B: Gov. Acquisition of Territory -> Rebel VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(-0.1(0.05)0.05, nogrid) xsize(8) ysize(8) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)


			
**************************************************************************
* Figure 8: Response of VAC_G to Territory_R

**Figure 8A**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Territory_R_log DRC_Territory_G_log DRC_Battles_log DRC_VAC_R_log_hp DRC_VAC_G_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Territory_R_log DRC_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("A: Rebel Acquisition of Territory -> Gov. VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") /// 
			ylabel(, nogrid) xsize(8) ysize(8) xlabel(0(3)12) graphregion(margin(zero) color(white)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 8B**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B	
svar Sudan_Territory_R_log Sudan_Territory_G_log Sudan_Battles_log Sudan_VAC_R_log Sudan_VAC_G_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Territory_R_log Sudan_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("B: Rebel Acquisition of Territory -> Gov. VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) yline(0, lpattern(dash) lcolor(black)) xtitle("month") xsize(8) ysize(8) ///
            ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

			

**************************************************************************
* Figure 9: Response of VAC to Active Agent in DR-Congo 

**Figure 9A**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Activeagent DRC_Battles_log DRC_VAC_M_log_hp DRC_VAC_G_log DRC_VAC_R_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Activeagent DRC_VAC_R_log_hp sirf, level(90) lwidth(medthick) subtitle("A: Active Agent -> Rebel VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 9B**					
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Activeagent DRC_Battles_log DRC_VAC_G_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Activeagent DRC_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("B: Active Agent -> Militia VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 9C**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Activeagent DRC_Battles_log DRC_VAC_M_log_hp DRC_VAC_R_log_hp DRC_VAC_G_log, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Activeagent DRC_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("C: Active Agent -> Government VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)
			
			

**************************************************************************
* Figure 10: Response of VAC to Active Agent in Sudan 

**Figure 10A**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Activeagent Sudan_Battles_log Sudan_VAC_M_log_hp Sudan_VAC_G_log Sudan_VAC_R_log, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Activeagent Sudan_VAC_R_log sirf, level(90) lwidth(medthick) subtitle("A: Active Agent -> Rebel VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)
			
**Figure 10B**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Activeagent Sudan_Battles_log Sudan_VAC_R_log Sudan_VAC_G_log Sudan_VAC_M_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Activeagent Sudan_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("B: Active Agent -> Militia VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 10C**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Activeagent Sudan_VAC_M_log_hp Sudan_Battles_log Sudan_VAC_R_log Sudan_VAC_G_log, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Activeagent Sudan_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("C: Active Agent -> Government VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

			

**************************************************************************
* Figure 11: Response of VAC to New Agent in DR-Congo 

**Figure 11A**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Newagent DRC_Battles_log DRC_VAC_M_log_hp DRC_VAC_G_log DRC_VAC_R_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Newagent DRC_VAC_R_log_hp sirf, level(90) lwidth(medthick) subtitle("A: New Agent -> Rebel VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 11B**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Newagent DRC_Battles_log DRC_VAC_G_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Newagent DRC_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("B: New Agent -> Militia VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 11C**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar DRC_Newagent DRC_Battles_log DRC_VAC_M_log_hp DRC_VAC_R_log_hp DRC_VAC_G_log, lags(1 2 3) aeq(A) beq(B) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
irf create svar, set(drc) step(12) replace
irf cgraph (svar DRC_Newagent DRC_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("C: New Agent -> Government VAC (DRC)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)



**************************************************************************
* Figure 12: Response of VAC to New Agent in Sudan 
 				
**Figure 12A**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Newagent Sudan_Battles_log Sudan_VAC_M_log_hp Sudan_VAC_G_log Sudan_VAC_R_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Newagent Sudan_VAC_R_log sirf, level(90) lwidth(medthick) subtitle("A: New Agent -> Rebel VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 12B**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Newagent Sudan_Battles_log Sudan_VAC_G_log Sudan_VAC_R_log Sudan_VAC_M_log_hp, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Newagent Sudan_VAC_M_log_hp sirf, level(90) lwidth(medthick) subtitle("B: New Agent -> Militia VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)

**Figure 12C**
set more off
matrix A = [1,0,0,0,0\.,1,0,0,0\.,.,1,0,0\.,.,.,1,0\.,.,.,.,1]
matrix list A
matrix B = [.,0,0,0,0\0,.,0,0,0\0,0,.,0,0\0,0,0,.,0\0,0,0,0,.]
matrix list B
svar Sudan_Newagent Sudan_VAC_R_log Sudan_Battles_log Sudan_VAC_M_log_hp Sudan_VAC_G_log, lags(1 2) aeq(A) beq(B) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 
irf create svar, set(sudan) step(12) replace
irf cgraph (svar Sudan_Newagent Sudan_VAC_G_log sirf, level(90) lwidth(medthick) subtitle("C: New Agent -> Government VAC (Sudan)")), ///
            legend(off) ci1opts(lcolor(bluishgray8) fcolor(bluishgray8)) xsize(8) ysize(8) yline(0, lpattern(dash) lcolor(black)) xtitle("month") ///
			ylabel(, nogrid) xlabel(0(3)12) graphregion(margin(zero)) plot1opts(lcolor(navy)) scheme(s1mono) xscale(noline)
	
	
	
**************************************************************************	
* Appendix I: Unit Root Tests and Parameter Estimates of the Underlying VAR Models	

* Table A1: Results of Unit Root Tests (p-value)
dfuller DRC_VAC_G_log, lag(3)
dfuller DRC_VAC_G_log, lag(3) trend
pperron DRC_VAC_G_log, lag(3) 
pperron DRC_VAC_G_log, lag(3) trend

dfuller DRC_VAC_R_log_hp, lag(3)
dfuller DRC_VAC_R_log_hp, lag(3) trend
pperron DRC_VAC_R_log_hp, lag(3) 
pperron DRC_VAC_R_log_hp, lag(3) trend

dfuller DRC_VAC_M_log_hp, lag(3)
dfuller DRC_VAC_M_log_hp, lag(3) trend
pperron DRC_VAC_M_log_hp, lag(3) 
pperron DRC_VAC_M_log_hp, lag(3) trend

dfuller DRC_Territory_G_log, lag(3)
dfuller DRC_Territory_G_log, lag(3) trend
pperron DRC_Territory_G_log, lag(3) 
pperron DRC_Territory_G_log, lag(3) trend

dfuller DRC_Territory_R_log, lag(3)
dfuller DRC_Territory_R_log, lag(3) trend
pperron DRC_Territory_R_log, lag(3) 
pperron DRC_Territory_R_log, lag(3) trend

dfuller DRC_Activeagent, lag(3)
dfuller DRC_Activeagent, lag(3) trend
pperron DRC_Activeagent, lag(3) 
pperron DRC_Activeagent, lag(3) trend

dfuller DRC_Newagent, lag(3)
dfuller DRC_Newagent, lag(3) trend
pperron DRC_Newagent, lag(3) 
pperron DRC_Newagent, lag(3) trend

dfuller DRC_Battles_log, lag(3)
dfuller DRC_Battles_log, lag(3) trend
pperron DRC_Battles_log, lag(3) 
pperron DRC_Battles_log, lag(3) trend
       
dfuller Sudan_VAC_G_log, lag(3)
dfuller Sudan_VAC_G_log, lag(3) trend
pperron Sudan_VAC_G_log, lag(3) 
pperron Sudan_VAC_G_log, lag(3) trend

dfuller Sudan_VAC_R_log, lag(3)
dfuller Sudan_VAC_R_log, lag(3) trend
pperron Sudan_VAC_R_log, lag(3) 
pperron Sudan_VAC_R_log, lag(3) trend

dfuller Sudan_VAC_M_log_hp, lag(3)
dfuller Sudan_VAC_M_log_hp, lag(3) trend
pperron Sudan_VAC_M_log_hp, lag(3) 
pperron Sudan_VAC_M_log_hp, lag(3) trend

dfuller Sudan_Territory_G_log, lag(3)
dfuller Sudan_Territory_G_log, lag(3) trend
pperron Sudan_Territory_G_log, lag(3) 
pperron Sudan_Territory_G_log, lag(3) trend

dfuller Sudan_Territory_R_log, lag(3)
dfuller Sudan_Territory_R_log, lag(3) trend
pperron Sudan_Territory_R_log, lag(3) 
pperron Sudan_Territory_R_log, lag(3) trend

dfuller Sudan_Activeagent, lag(3)
dfuller Sudan_Activeagent, lag(3) trend
pperron Sudan_Activeagent, lag(3) 
pperron Sudan_Activeagent, lag(3) trend

dfuller Sudan_Newagent, lag(3)
dfuller Sudan_Newagent, lag(3) trend
pperron Sudan_Newagent, lag(3) 
pperron Sudan_Newagent, lag(3) trend

dfuller Sudan_Battles_log, lag(3)
dfuller Sudan_Battles_log, lag(3) trend
pperron Sudan_Battles_log, lag(3) 
pperron Sudan_Battles_log, lag(3) trend

* Table A2: Parameter Estimates for Model 1 
set more off
var DRC_VAC_G_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp DRC_Battles_log, lags(1 2 3) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
var Sudan_VAC_G_log Sudan_VAC_R_log Sudan_VAC_M_log_hp Sudan_Battles_log, lags(1 2) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 

* Table A3: Parameter Estimates for Model 2
set more off
var DRC_VAC_G_log DRC_VAC_R_log_hp DRC_Territory_G_log DRC_Territory_R_log DRC_Battles_log, lags(1 2) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
var Sudan_VAC_G_log Sudan_VAC_R_log Sudan_Territory_G_log Sudan_Territory_R_log Sudan_Battles_log, lags(1 2) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 

* Table A4: Parameter Estimates for Model 3A 
set more off
var DRC_VAC_G_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp DRC_Activeagent DRC_Battles_log, lags(1 2 3) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
var Sudan_VAC_G_log Sudan_VAC_R_log Sudan_VAC_M_log_hp Sudan_Activeagent Sudan_Battles_log, lags(1 2 3) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 

* Table A5: Parameter Estimates for Model 3B
set more off
var DRC_VAC_G_log DRC_VAC_R_log_hp DRC_VAC_M_log_hp DRC_Newagent DRC_Battles_log, lags(1 2 3) exog(L(0/0).DRC_UnitedNations L(0/0).DRC_Election) 
var Sudan_VAC_G_log Sudan_VAC_R_log Sudan_VAC_M_log_hp Sudan_Newagent Sudan_Battles_log, lags(1 2) exog(L(0/0).Sudan_Unitednations L(0/0).Sudan_Election) 

	