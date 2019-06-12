version 11.0
set more off
capture log close
log using "isq_figures.txt", text replace



*******************************************************************************
***** Replication code for                                                *****
***** Johannes Kleibl. "Tertiarization, Infustrial Adjustment, and the    *****
***** Domestic Politics of Foreign Aid." International Studies Quarterly. *****
***** October 3, 2011                                                     *****
*******************************************************************************




*******************************************************************************
***** Replication of Figure 1.                                            ***** 
***** Share of services employment and change in industrial employment    *****
***** across the OECD donor countries in 1980 and 2000.                   *****
*******************************************************************************




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year




// generate variable that selects observations included in the graph
gen plot = 0
replace plot = 1 if (year == 1980 | year == 2000) & /// years 1980 and 2000
					recipient_label == "India"	& /// restrict plot==1 to one observation per donor
					(donor_label != "Portugal" & donor_label != "Spain" & donor_label != "Greece") // do not includes Portugal, Spain and Greece

// generate variable with share of services employment in 1980
gen seremp1980 = .
replace seremp1980 = cempserclabf if year == 1980
bysort cow_donor: egen serempl1980 = mean(seremp1980) 

// generate variable with share of services employment in 2000
gen seremp2000 = .
replace seremp2000 = cempserclabf if year == 2000
bysort cow_donor: egen serempl2000 = mean(seremp2000) 

// create the left half of the figure
graph hbar seremp1980 seremp2000 if plot == 1, ///
		over(donor_abbr, sort(serempl2000) label(labsize(small)) axis(noline)) ///
		blabel(bar, position(outside) format(%5.1f) size(small)) ///
		exclude0 yscale(range(40 75) noextend) ///
		ylabel(, labsize(small)) ///
		ytitle("Share of services employment in 1980 and 2000", size(small)) ///
		bargap(-100) intensity(40) lintensity(40) ///
		ylabel(, nogrid) plotregion(style(none)) ///
		graphregion(color(white)) ///
		legend(off) scheme(s1mono) name(figure1a, replace)

// generate variable with share of industrial employment in 1980		
gen indemp1980 = .
replace indemp1980 = cempindclabf if year == 1980
bysort cow_donor: egen indempl1980 = mean(indemp1980) 

// generate variable with share of industrial employment in 2000	
gen indemp2000 = .
replace indemp2000 = cempindclabf if year == 2000
bysort cow_donor: egen indempl2000 = mean(indemp2000) 

// generate variable with change in industrial employment between 1980 and 2000	
gen indempl19802000 = indempl2000 - indempl1980

// create the right half of the figure
graph hbar indempl19802000 if plot == 1, ///
		over(donor_abbr, sort(indempl19802000) label(labsize(small)) axis(noline)) /// 
		blabel(bar, position(outside) format(%5.1f) size(small)) ///
		exclude0 yscale(range(-15 0) noextend) ///
		ylabel(, labsize(small)) /// 
		ytitle("Change in share of industrial employment from 1980 to 2000", size(small)) ///
		bargap(-100) intensity(40) lintensity(40) ///
		ylabel(, nogrid) plotregion(style(none)) ///
		graphregion(color(white)) ///
		legend(off) scheme(s1mono) xalternate name(figure1b, replace)

// combine the two graphs into one figure
graph combine figure1a figure1b, rows(1) cols(2) imargin(tiny) ///
              graphregion(color(white) icolor(white) fcolor(white) lcolor(white)) 	


	
	

	



*******************************************************************************
***** Replication of Figure 2.                                            ***** 
***** Marginal effect plots of donors’ exports, donors’ raw material      *****
***** imports, and recipients’ GDP per capita based on Models 2 to 7      *****
***** in Table 1.                                                         *****
***** (The code for creating the marginal effect plots is based on code   *****
***** written by Brambor, Clark and Golder (2006).)                       *****
*******************************************************************************




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year




// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"




/// Plot for Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

sum Lcempserclabf if e(sample), d
generate MV=(_n-1) // create MV for the mediating variable used in the graph (Lcempsercemp)
replace  MV=. if MV>r(max) | MV<r(min)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,13] // b exports
scalar b2=b[1,11] // b level of employment
scalar b3=b[1,15] // b interaction
scalar varb1=V[13,13] 
scalar varb2=V[11,11] 
scalar varb3=V[15,15]
scalar covb1b3=V[13,15]
scalar covb2b3=V[11,15]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3
gen conb=b1+b3*MV if MV<=r(max) & MV>=r(min)
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if MV<=r(max) & MV>=r(min)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(none) xmtick(45 50 55 60 65 70)
             ylabel(-0.2 0 0.2 0.4 0.6 0.8, labsize(2.5)) ymtick(-0.1 0.1 0.3 0.5 0.7)
             yscale(noline)
             xscale(noline)
             legend(col(1) order(1 2) label(1 "Marginal effect of ln exports") 
                                      label(2 "95% confidence interval") 
                                      label(3 " "))
             yline(0, lcolor(black))
			 yline(-0.2 0.2 0.4 0.6 0.8, lcolor(gs14) lwidth(vthin))
             title("")
             xtitle("")
             xscale(range(43.62323 74.66242) titlegap(2))
             yscale(titlegap(2))
			 fxsize(100) fysize(100)
             ytitle("Marginal effects" "of ln exports", size(3)) text(0.7 72 "Model 2", size(3))
			 graphregion(color(white) icolor(white) fcolor(white) lcolor(white))
			 legend(off) scheme(s1mono) name(empexp, replace);
#delimit cr
drop  MV-lower 




/// Plot for Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

sum Lcempserclabf if e(sample), d
generate MV=(_n-1) // create MV for the mediating variable used in the graph (Lcempsercemp)
replace  MV=. if MV>r(max) | MV<r(min)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,14] // b imports
scalar b2=b[1,11] // b level of employment
scalar b3=b[1,15] // b interaction
scalar varb1=V[14,14] 
scalar varb2=V[11,11] 
scalar varb3=V[15,15]
scalar covb1b3=V[14,15]
scalar covb2b3=V[11,15]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3
gen conb=b1+b3*MV if MV<=r(max) & MV>=r(min)
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if MV<=r(max) & MV>=r(min)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(none) xmtick(45 50 55 60 65 70)
             ylabel(-0.2 0 0.2 0.4, labsize(2.5)) ymtick(-0.1 0.1 0.3 0.5)
             yscale(noline)
             xscale(noline)
             legend(col(1) order(1 2) label(1 "Marginal effect of ln raw material imports") 
                                      label(2 "95% confidence interval") 
                                      label(3 " "))
             yline(0, lcolor(black)) 
			 yline(-0.2 0.2 0.4, lcolor(gs14) lwidth(vthin))			 
             title("")
             xtitle("")
             xscale(range(43.62323 74.66242) titlegap(2))
             yscale(titlegap(2))
			 fxsize(100) fysize(100)
             ytitle("Marginal effects" "of ln raw material imports", size(3)) text(0.44 72 "Model 3", size(3))
			 graphregion(color(white) icolor(white) fcolor(white) lcolor(white))
			 legend(off) scheme(s1mono) name(empimp, replace);
#delimit cr
drop  MV-lower 




/// Plot for  Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

sum Lcempserclabf if e(sample), d
generate MV=(_n-1) // create MV for the mediating variable used in the graph (Lcempsercemp)
replace  MV=. if MV>r(max) | MV<r(min)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,5]  // b recipient GDPPC
scalar b2=b[1,11] // b level of employment
scalar b3=b[1,15] // b interaction
scalar varb1=V[5,5] 
scalar varb2=V[11,11] 
scalar varb3=V[15,15]
scalar covb1b3=V[5,15]
scalar covb2b3=V[11,15]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3
gen conb=b1+b3*MV if MV<=r(max) & MV>=r(min)
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if MV<=r(max) & MV>=r(min)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(none) xmtick(45 50 55 60 65 70) 
             ylabel(-3 -2 -1 0, labsize(2.5)) ymtick(-3.5 -2.5 -1.5 -0.5)
             yscale(noline)
             xscale(noline)
             legend(col(1) order(1 2) label(1 "Marginal effect of recipient GDPPC") 
                                      label(2 "95% confidence interval") 
                                      label(3 " "))
             yline(0, lcolor(black))   
			 yline(-3 -2 -1, lcolor(gs14) lwidth(vthin))	
             title("")
             xtitle("")
             xscale(range(43.62323 74.66242) titlegap(2))
             yscale(titlegap(2))
			 fxsize(100) fysize(100)
             ytitle("Marginal effects" "of ln recipient GDPPC", size(3)) text(-0.3 72 "Model 4", size(3))
			 graphregion(color(white) icolor(white) fcolor(white) lcolor(white))
			 legend(off) scheme(s1mono) name(emprgdppc, replace);
#delimit cr
drop MV-lower 




/// Plot for Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

sum cempindclabfchy3 if e(sample), d 
generate MV=((_n-1)/10 + r(min)) // create MV for the mediating variable used in the graph (cempindclabfchy3)
replace  MV=. if MV>r(max)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,13] // b exports
scalar b2=b[1,12] // b change in employment
scalar b3=b[1,15] // b interaction
scalar varb1=V[13,13] 
scalar varb2=V[12,12] 
scalar varb3=V[15,15]
scalar covb1b3=V[13,15]
scalar covb2b3=V[12,15]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3
gen conb=b1+b3*MV if MV<=r(max) & MV>=r(min)
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if MV<=r(max) & MV>=r(min)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(none) xmtick(-6 -4 -2 0 2 4)
             ylabel(none) ymtick(-0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8)
             yscale(noline)
             xscale(noline)
             legend(col(1) order(1 2) label(1 "Marginal effect of ln exports") 
                                      label(2 "95% confidence interval") 
                                      label(3 " "))
             yline(0, lcolor(black))
			 yline(-0.2 0.2 0.4 0.6 0.8, lcolor(gs14) lwidth(vthin))
             title("")
             xtitle("")
             xscale(range(-7.507576 4.056601) titlegap(2))
             yscale(titlegap(2))
			 fxsize(87.5) fysize(100)
             ytitle("") text(0.7 3.1 "Model 5", size(3))
			 graphregion(color(white) icolor(white) fcolor(white) lcolor(white))
			 legend(off) scheme(s1mono) name(chempexp, replace);
#delimit cr
drop  MV-lower 




/// Plot for  Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

sum cempindclabfchy3 if e(sample), d 
generate MV=((_n-1)/10 + r(min)) // create MV for the mediating variable used in the graph (cempindclabfchy3)
replace  MV=. if MV>r(max)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,14] // b imports
scalar b2=b[1,12] // b change in employment
scalar b3=b[1,15] // b interaction
scalar varb1=V[14,14] 
scalar varb2=V[12,12] 
scalar varb3=V[15,15]
scalar covb1b3=V[14,15]
scalar covb2b3=V[12,15]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3
gen conb=b1+b3*MV if MV<=r(max) & MV>=r(min)
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if MV<=r(max) & MV>=r(min)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(none) xmtick(-6 -4 -2 0 2 4)
             ylabel(none) ymtick(-0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5)
             yscale(noline)
             xscale(noline)
             legend(col(1) order(1 2) label(1 "Marginal effect of ln raw material imports") 
                                      label(2 "95% confidence interval") 
                                      label(3 " "))
             yline(0, lcolor(black))
			 yline(-0.2 0.2 0.4, lcolor(gs14) lwidth(vthin))
             title("")
             xtitle("")
             xscale(range(-7.507576 4.056601) titlegap(2))
             yscale(titlegap(2))
			 fxsize(87.5) fysize(100)
             ytitle("") text(0.44 3.1 "Model 6", size(3))
			 graphregion(color(white) icolor(white) fcolor(white) lcolor(white))
			 legend(off) scheme(s1mono) name(chempimp, replace);
#delimit cr
drop  MV-lower 




/// Plot for  Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

sum cempindclabfchy3 if e(sample), d 
generate MV=((_n-1)/10 + r(min)) // create MV for the mediating variable used in the graph (cempindclabfchy3)
replace  MV=. if MV>r(max)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,5]  // b recipient GDPPC 
scalar b2=b[1,12] // b change in employment
scalar b3=b[1,15] // b interaction
scalar varb1=V[5,5] 
scalar varb2=V[12,12] 
scalar varb3=V[15,15]
scalar covb1b3=V[5,15]
scalar covb2b3=V[12,15]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3
gen conb=b1+b3*MV if MV<=r(max)-r(mean)
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if MV<=r(max)-r(mean)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(shortdash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(none) xmtick(-6 -4 -2 0 2 4) 
             ylabel(none) ymtick(-3.5 -3 -2.5 -2 -1.5 -1 -0.5 0)
             yscale(noline)
             xscale(noline)
             legend(col(1) order(1 2) label(1 "Marginal effect of recipient GDPPC") 
                                      label(2 "95% confidence interval") 
                                      label(3 " "))   
			 yline(0, lcolor(black)) 
			 yline(-3 -2 -1, lcolor(gs14) lwidth(vthin))
             title("")
             xtitle("")
             xscale(range(-7.507576 4.056601) titlegap(2))
             yscale(titlegap(2))
			 fxsize(87.5) fysize(100)
             ytitle("") text(-0.3 3.1 "Model 7", size(3))
			 graphregion(color(white) icolor(white) fcolor(white) lcolor(white))
			 legend(off) scheme(s1mono) name(chemprgdppc, replace);
#delimit cr
drop  MV-lower 




// Plot of the distribution of the level of services employment.
graph twoway hist Lcempserclabf if e(sample), percent bin(25) ///
     xlabel(45 50 55 60 65 70, labsize(2.5)) ///
	 ylabel(0 5 10 15, labsize(2.5) nogrid) /// 
	 xtitle("Employment in services" "(as % of civilian labour force)", size(3)) ///
	 ytitle("% share of" "observations" " ", size(3)) ///
	 title("") ///
	 xscale(range(43.62323 74.66242) titlegap(2)) ///
	 yscale(titlegap(-0.9)) ///
	 color(gs13) lwidth(0) ///
     graphregion(color(white) lstyle(none) icolor(white) fcolor(white) lcolor(white)) ///
     legend(off) ///
	 fxsize(100) fysize(100) name(empdens, replace)

	 
	 
	 
// Plot of the distribution of the change in industrial employment.
graph twoway hist cempindclabfchy3 if e(sample), percent bin(25) ///
     xlabel(-6 -4 -2 0 2 4, labsize(2.5)) ///
	 ylabel(none, nogrid) ymtick(0 5 10 15) ///
	 xtitle("Change in employment in industry" "(as % of civilian labour force)", size(3)) ///
	 ytitle("") ///
	 title("") ///
	 xscale(range(-7.507576 4.056601) titlegap(2)) ///
	 yscale(titlegap(2.1)) ///
	 color(gs13) lwidth(0) ///
     graphregion(color(white) lstyle(none) icolor(white) fcolor(white) lcolor(white)) ///
     legend(off) ///
	 fxsize(87.5) fysize(100) name(chempdens, replace)
	 
	 
	 
	 
/// Combining the graphs
graph combine empexp chempexp empimp chempimp emprgdppc chemprgdppc empdens chempdens, ///
              rows(4) cols(2) ysize(7) xsize(6.2) imargin(tiny) graphregion(color(white) ///
			  icolor(white) fcolor(white) lcolor(white))


 
  
log close  
  
	
		
		
	
		
		
		
		
		
