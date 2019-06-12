
use "CCL_bjps_data.dta", clear
**fig 1country by country figure w/ elections
twoway (line approval qtr, sort) (bar presidentialelection_c qtr, yaxis(2)) if  admin~=. & approval~=., legend(off) yscale(off axis(2))  xlabel(, angle(forty_five)) by(, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) by(country, cols(3) note(`""')) 

twoway(line approval qtr, sort) (bar presidentialelection_gr qtr,  yaxis(2) barwidth(.5) yscale(off axis(2)) ylabel(0(1)1, axis(2)) if e(sample) & admin~=., by(country)



 **Fig 1
 twoway (lpolyci approval std_ticker, degree(1) ciplot(rspike)), ytitle( Approval) by(female)
 
 
***gender and approval
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "approval and gender", excel replace label
	
	xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log   l(0/2).presidentialelection_corrected##female f(1/2).presidentialelection_corrected##female i.country_code, cor(psar1) i

margins , dydx(presidentialelection_corrected ) at( female=(0 1)) saving(file1, replace) pwcompare(cieffects pveffects effects cimargins groups)
margins , dydx(l.presidentialelection_corrected ) at( female=(0 1)) saving(file2, replace) pwcompare(cieffects pveffects effects cimargins groups)
margins , dydx(l2.presidentialelection_corrected ) at( female=(0 1)) saving(file3, replace) pwcompare(cieffects pveffects effects cimargins groups)
margins , dydx(f.presidentialelection_corrected ) at( female=(0 1)) saving(file4, replace) pwcompare(cieffects pveffects effects cimargins groups)
margins , dydx(f2.presidentialelection_corrected ) at( female=(0 1)) saving(file5, replace) pwcompare(cieffects pveffects effects cimargins groups)


combomarginsplot file1 file2 file3 file4 file5 , labels("HM, 1st Qtr" "HM, 2nd Qtr" "HM, 3rd Qtr"  "2 Qtrs Pre Election" "1 Qtrs Pre Election") recast(scatter)  by(_filenumber)  yline(0, lcolor(red)) scheme(sj) graphregion(fcolor(white)) xscale(range(-.5 1.5)) title(Honeymoon/Election Effects by Gender) ytitle(Marginal Effects of Honeymoons/Elections)
graph save Graph "Fig 2.gph", replace

margins , dydx( female) at( presidentialelection_corrected=(  1 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(1 0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) pwcompare(cieffects  ) saving(file6, replace)
preserve
use "file6.dta"
keep if _pw==4
replace _pw=1
twoway (rcap _ci_lb _ci_ub _pw) (scatter _margin _pw), yline(0) yscale(alt)
restore



margins , dydx(l2.presidentialelection_corrected ) at( female=(0 1)) pwcompare  pwcompare(cieffects pveffects effects cimargins groups)



margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 1) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) saving(file1, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(1) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) saving(file2, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(1) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) saving(file3, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(1) f2.presidentialelection_corrected=(0)) saving(file4, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(1)) saving(file5, replace)
combomarginsplot file1 file2 file3 file4 file5, labels("HM, 1st Qtr" "HM, 2nd Qtr" "HM, 3rd Qtr"  "2 Qtrs Pre Election" "1 Qtrs Pre Election") recast(scatter)  by(_filenumber)   scheme(sj) graphregion(fcolor(white)) xscale(range(-.5 1.5)) title("") ytitle("Predicted Presidential Approval")  yline(45.3, lcolor(red))


xtpcse approval l(0/1).c.q_grow_pc##c.female  l(0/1).c.q_log##c.female   l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "growth and inflation", excel replace label
	

**corruption
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_vdem_corr  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "corruption", excel replace label

	quietly: margins,  at(q_vdem_corr=(.1 (.01) .7) female=(0 1)) 
	marginsplot, xdimension(q_vdem_corr) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval)  title("Public Corruption") scheme(sj) graphregion(fcolor(white) lcolor(white))
graph save Graph "fig3_1.gph", replace




***terrorism
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.event  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "terrorism", excel replace label

	quietly: margins,  at(event=(0 (10) 150) female=(0 1)) 
	marginsplot, xdimension(event) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title("Terrorist Attacks") scheme(sj) graphregion(fcolor(white) lcolor(white))
	graph save Graph "fig3_2.gph", replace

	


***homicide rates
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_homicide   l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "homicide", excel replace label

	quietly: margins,  at(q_homicide=(0 (1) 28) female=(0 1)) 
	marginsplot, xdimension(q_homicide) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title(" Homicide Rates") scheme(sj) graphregion(fcolor(white) lcolor(white))
		graph save Graph "fig3_3.gph", replace







***********appendix**********


***gender and approval
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female i.b1.exec_ideo l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "appendix_approval and gender", excel replace label
	
	xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  i.b1.exec_ideo l(0/2).presidentialelection_corrected##female f(1/2).presidentialelection_corrected##female i.country_code, cor(psar1) i

margins , dydx(presidentialelection_corrected ) at( female=(0 1)) saving(file1, replace)
margins , dydx(l.presidentialelection_corrected ) at( female=(0 1)) saving(file2, replace)
margins , dydx(l2.presidentialelection_corrected ) at( female=(0 1)) saving(file3, replace)
margins , dydx(f.presidentialelection_corrected ) at( female=(0 1)) saving(file4, replace)
margins , dydx(f2.presidentialelection_corrected ) at( female=(0 1)) saving(file5, replace)

combomarginsplot file1 file2 file3 file4 file5 , labels("HM, 1st Qtr" "HM, 2nd Qtr" "HM, 3rd Qtr"  "2 Qtrs Pre Election" "1 Qtrs Pre Election") recast(scatter)  by(_filenumber)  yline(0, lcolor(red)) scheme(sj) graphregion(fcolor(white)) xscale(range(-.5 1.5)) title(Honeymoon/Election Effects by Gender) ytitle(Marginal Effects of Honeymoons/Elections)
graph save Graph "Fig 2.gph", replace


margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 1) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) saving(file1, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(1) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) saving(file2, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(1) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(0)) saving(file3, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(1) f2.presidentialelection_corrected=(0)) saving(file4, replace)
margins , dydx( ) at( female=(0 1) presidentialelection_corrected=( 0) l.presidentialelection_corrected=(0) l2.presidentialelection_corrected=(0) f.presidentialelection_corrected=(0) f2.presidentialelection_corrected=(1)) saving(file5, replace)
combomarginsplot file1 file2 file3 file4 file5, labels("HM, 1st Qtr" "HM, 2nd Qtr" "HM, 3rd Qtr"  "2 Qtrs Pre Election" "1 Qtrs Pre Election") recast(scatter)  by(_filenumber)   scheme(sj) graphregion(fcolor(white)) xscale(range(-.5 1.5)) title("") ytitle("Predicted Presidential Approval")  yline(45.3, lcolor(red))

**growth and inflation

xtpcse approval l(0/1).c.q_grow_pc##c.female  l(0/1).c.q_log##c.female i.b1.exec_ideo   l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "appensix_growth and inflation", excel replace label
	

**corruption
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_vdem_corr i.b1.exec_ideo l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "appendix_corruption", excel replace label
	margins,  at(q_vdem_corr=(.02 (.1) .9) female=(0 1)) 
	marginsplot, xdimension(q_vdem_corr) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval)  title("Predicted Approval Across Level of Corruption, by Gender") scheme(sj) graphregion(fcolor(white) lcolor(white))
graph save Graph "Fig 3.gph", replace
***terrorism
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.event i.b1.exec_ideo l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "appendix_terrorism", excel replace label
	
	margins,  at(event=(0 (10) 250) female=(0 1)) 
	marginsplot, xdimension(event) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title("Predicted Approval Across Terrorist Attacks, by Gender") scheme(sj) graphregion(fcolor(white) lcolor(white))
graph save Graph "Fig 4.gph", replace


***homicide rates
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_homicide  i.b1.exec_ideo l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "appendix_homicide", excel replace label
	
	margins,  at(q_homicide=(0 (10) 110) female=(0 1)) 
	marginsplot, xdimension(q_homicide) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title("Predicted Approval Across Homicide Rates, by Gender") scheme(sj) graphregion(fcolor(white) lcolor(white))
	graph save Graph "Fig 5.gph", replace
	



********R&R, female leaders have similar, and sometimes a bit better conditions in their first 6 months in office**********
sum q_grow_pc q_log event q_vdem_corr q_ti_cpi q_homicide if female==1 & admin_ticker<3
sum q_grow_pc q_log event q_vdem_corr q_ti_cpi q_homicide if female==0 & admin_ticker<3

sum q_grow_pc q_log event q_vdem_corr q_ti_cpi q_homicide if female==1 & admin_ticker<3 & country_w_female==1
sum q_grow_pc q_log event q_vdem_corr q_ti_cpi q_homicide if female==0 & admin_ticker<3 & country_w_female==1

ttest q_homicide if admin_ticker<3 & country_w_female==1, by (female)
ttest q_grow_pc if admin_ticker<3 & country_w_female==1, by (female)
ttest q_log if admin_ticker<3 & country_w_female==1, by (female)
ttest event if admin_ticker<3 & country_w_female==1, by (female)
ttest q_vdem_corr if admin_ticker<3 & country_w_female==1, by (female)
ttest q_ti_cpi if admin_ticker<3 & country_w_female==1, by (female)




***********models with sample only from countries with female presidents




***gender and approval
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if country_w_female==1, cor(psar1) i
	outreg2 using "approval and gender_female_countries", excel replace label
	
	
**growth and inflation

xtpcse approval l(0/1).c.q_grow_pc##c.female  l(0/1).c.q_log##c.female   l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if country_w_female==1, cor(psar1) i
	outreg2 using "growth and inflation_female_countries", excel replace label
	

**corruption
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_vdem_corr  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if country_w_female==1, cor(psar1) i
	outreg2 using "corruption_female_countries", excel replace label

	quietly: margins,  at(q_vdem_corr=(.1 (.01) .7) female=(0 1)) 
	marginsplot, xdimension(q_vdem_corr) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval)  title("Public Corruption") scheme(sj) graphregion(fcolor(white) lcolor(white))
graph save Graph "fig3_1_female_countries.gph", replace




***terrorism
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.event  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if country_w_female==1,  cor(psar1) i
	outreg2 using "terrorism_female_countries", excel replace label

	quietly: margins,  at(event=(0 (10) 150) female=(0 1)) 
	marginsplot, xdimension(event) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title("Terrorist Attacks") scheme(sj) graphregion(fcolor(white) lcolor(white))
	graph save Graph "fig3_2_female_countries.gph", replace

	


***homicide rates
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_homicide   l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if country_w_female==1, cor(psar1) i
	outreg2 using "homicide_female_countries", excel replace label

	quietly: margins,  at(q_homicide=(0 (1) 28) female=(0 1)) 
	marginsplot, xdimension(q_homicide) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title(" Homicide Rates") scheme(sj) graphregion(fcolor(white) lcolor(white))
		graph save Graph "fig3_3._female_countriesgph", replace






****EXCLUDE ASIA
gen asia_country=LA_country
recode asia_country 1=0 0=1
 **Fig 1
 twoway (lpolyci approval std_ticker if LA_country==1, degree(1) ciplot(rspike)), ytitle( Approval) by(female)
 
 
 
 

***gender and approval w/o asia 

***gender and approval w/o asia 
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if LA_country==1, cor(psar1) i
	outreg2 using "appendix_approval and gender--no asia", excel replace label
	
	
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female i.b1.exec_ideo l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code if LA_country==1, cor(psar1) i
	outreg2 using "appendix_approval and gender--no asia_w ideology", excel replace label
	
	

	
	xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log   l(0/2).presidentialelection_corrected##female f(1/2).presidentialelection_corrected##female i.country_code if LA_country==1, cor(psar1) i

margins , dydx(presidentialelection_corrected ) at( female=(0 1)) saving(file1, replace)
margins , dydx(l.presidentialelection_corrected ) at( female=(0 1)) saving(file2, replace)
margins , dydx(l2.presidentialelection_corrected ) at( female=(0 1)) saving(file3, replace)
margins , dydx(f.presidentialelection_corrected ) at( female=(0 1)) saving(file4, replace)
margins , dydx(f2.presidentialelection_corrected ) at( female=(0 1)) saving(file5, replace)

combomarginsplot file1 file2 file3 file4 file5 , labels("HM, 1st Qtr" "HM, 2nd Qtr" "HM, 3rd Qtr"  "2 Qtrs Pre Election" "1 Qtrs Pre Election") recast(scatter)  by(_filenumber)  yline(0, lcolor(red)) scheme(sj) graphregion(fcolor(white)) xscale(range(-.5 1.5)) title(Honeymoon/Election Effects by Sex) ytitle(Marginal Effects of Honeymoons/Elections)
graph save Graph "Fig 2_no Asia.gph", replace

***Asian country dummy
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected asia_country i.country_code , cor(psar1) i
	outreg2 using "appendix_approval and gender w/asian country dummy", excel replace label
***Asian country dummy
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log female  i.b1.exec_ideo l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected asia_country i.country_code , cor(psar1) i
	outreg2 using "appendix_approval and gender w/asian country dummy with ideology", excel replace label


*****TI scale
**corruption
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.q_ti_cpi  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "corruption_ti_appendix", excel replace label

	quietly: margins,  at(q_ti_cpi=(23 (1) 73) female=(0 1)) 
	marginsplot, xdimension(q_ti_cpi) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval)  title("Public Corruption--TI Scale") scheme(sj) graphregion(fcolor(white) lcolor(white))
graph save Graph "fig3a.gph", replace



****no international terrorist attacks


***terrorism
xtpcse approval l(0/1).q_grow_pc  l(0/1).q_log  female##c.event  l(0/2).presidentialelection_corrected f(1/2).presidentialelection_corrected i.country_code, cor(psar1) i
	outreg2 using "terrorism_no_int", excel replace label

	quietly: margins,  at(event=(0 (10) 150) female=(0 1)) 
	marginsplot, xdimension(event) recast(line) plot1opts(lpattern(dash)) recastci(rline) ciopts(lpattern(tight_dot)) ytitle(Presidential Approval) title("Terrorist Attacks") scheme(sj) graphregion(fcolor(white) lcolor(white))
	graph save Graph "fig terrorism_no_in.gph", replace

	
