** APPX SECTION 2: MEANS

**** USE: "jeps diverse pre-treatment data" ****

svyset [pweight=weight]

 * immigration, wave 1
	svy: mean q3_imm
	svy: mean q3_imm, over(treat_w2)

 * immigration, wave 2
	svy: mean q3_wave2_immig
	svy: mean q3_wave2_immig, over(treat_w2)

 * HC, wave 1
	svy: mean q3_hc
	svy: mean q3_hc, over(treat_w2)

 * HC, wave 2
	svy: mean q3_wave2_health
	svy: mean q3_wave2_health, over(treat_w2)

 ** these means were used to create two separate Stata data files, which are used to generate the plots below

 
**** USE: APPX FIG1.DATA ****

 ** label variables of the treatment
	label define tname 1 "Overall" 2 "Control" 3 "R1" 4 "R2" 5 "R3"
	label values treatment tname

	eclplot mean min95 max95 treatment, horizontal eplottype(scatter) rplottype(rcap) supby(model, spaceby(.25)) estopts( sort ) ciopts( ) ytitle(Treatment Group) ylabel(1(1)5, valuelabel labsize(small)) xtitle(Mean opinion) scheme(s2mono) legend(order(2 "Opinion, pre" 4 "Opinion, post"))

 ** figure edited in Stata graph editor to make background white and x-axis range from 1-5 
 ** save with "graph save [location] **
 
	graph export appx_fig1.png
	clear

	
**** USE: APPX FIG2.DATA ****

 ** label variables of the treatment
	label define tname 1 "Overall" 2 "Control" 3 "R1" 4 "R2" 5 "R3"
	label values treatment tname

	eclplot mean min95 max95 treatment, horizontal eplottype(scatter) rplottype(rcap) supby(model, spaceby(.25)) estopts( sort ) ciopts( ) ytitle(Treatment Group) ylabel(1(1)5, valuelabel labsize(small)) xtitle(Mean opinion) scheme(s2mono) legend(order(2 "Opinion, pre" 4 "Opinion, post"))

 ** figure edited in Stata graph editor to make background white and x-axis range from 1-5 
 ** save with "graph save [location] **
 
	graph export appx_fig2.png
