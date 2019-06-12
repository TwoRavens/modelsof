** Replication do file for "Exiting the Coalition: When Do States Abandon 
** Coalition Partners during War?"

** This do file replicates reported results in the following order:
** 1) crosstabs for key independent variables and withdrawal
** 2) replicating results from the two tables in the main text
** 3) conducting robustness checks reported in the statistical appendix
** 4) replicating figures that appear in the main text and the appendix

set more off
use coalition_exit_final, clear

log using coalitionexit.log, replace

** descriptive statistics

** Countries fighting at least partially independently are four times more likely to abandon coalition partners
gen commonfront=0
replace commonfront=1 if foverlap==1
tab commonfront withdraw if finalobs==1
** Worsening battlefield results also descriptively associated with higher probability of withdrawal
sum ctrend60 if finalobs==1, d
gen worsening=0
replace worsening=1 if ctrend60>r(p90)
tab worsening withdraw if finalobs==1

** Replicating Table 1

stset warday, id(idvar) f(withdraw)

stcox foverlap ctrend60, cluster(coalid) nohr
eststo base1

stcox foverlap otrend60, cluster(coalid) nohr
eststo base2

stset warday, id(idvar) f(volunt)
stcox foverlap ctrend60, cluster(coalid) nohr
eststo base3

stcox foverlap otrend60, cluster(coalid) nohr
eststo base4

** Replicating Table 2

stset warday, id(idvar) f(withdraw)

stcox recexit pvict imptce newlead demdum sepdum, cluster(coalid) nohr
eststo contwd

stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum, cluster(coalid) nohr
eststo fullwd1

stcox foverlap ctrend60 pvict imptce recexit demdum newlead intdum cooppc, cluster(coalid) nohr
eststo fullalt

stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum if warnum!=106 & warnum!=139, cluster(coalid) nohr
eststo fullwd2

stset warday, id(idvar) f(volunt)

stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum, cluster(coalid) nohr
eststo fullvol1

** Robustness results

** coding cases of withdrawal that result in war termination as non-withdrawal
gen withdraw2=withdraw
replace withdraw2=0 if warnum==22 | warnum==28 | warnum==155
stset warday, id(idvar) f(withdraw2)
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum, cluster(coalid) nohr
eststo nowarend

** dropping the only coalition in which no evidence of coordination of policy exists
stset warday, id(idvar) f(withdraw)
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum if (warnum!=108 | side==1), cluster(coalid) nohr
eststo nogerrus

** dropping cases in which the country contributes less than 10% of total coalition forces
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum if contribpc>.1, cluster(coalid) nohr
eststo nominor

** inserting controls for war aims
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum terraim regaim, cluster(coalid) nohr
eststo waraim

** inserting a control for country battle deaths
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum lnodead, cluster(coalid) nohr
eststo batdead1

** inserting a control for country battle deaths (alternate specification)
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum lnodead2, cluster(coalid) nohr
eststo batdead2

** inserting a control for late intervention into the war
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum latejoin, cluster(coalid) nohr
eststo latejoin

** using Polity in lieu of demdum
stcox foverlap ctrend60 pvict imptce recexit polity2 newlead sepdum, cluster(coalid) nohr
eststo polity

** Other approaches to recent exit
stcox foverlap ctrend60 pvict imptce recexit2 demdum newlead sepdum, cluster(coalid) nohr
eststo recexit2

** other approaches to alliance variable
stcox foverlap ctrend60 pvict imptce recexit demdum newlead seppc, cluster(coalid) nohr
eststo ally1
stcox foverlap ctrend60 pvict imptce recexit demdum newlead actdum, cluster(coalid) nohr
eststo ally2
stcox foverlap ctrend60 pvict imptce recexit demdum newlead actpc, cluster(coalid) nohr
eststo ally3

** using share of troop commitments rather than CINC scores to measure coalition importance
stcox foverlap ctrend60 pvict contribpc recexit demdum newlead sepdum, cluster(coalid) nohr
eststo soldier

** Separate peace agreements are endogenous to tough circumstances

probit sepdum foverlap if warday==1, cluster(coalid)
eststo sepdum1
probit sepdum foverlap if finalobs==1, cluster(coalid)
eststo sepdum2

** Generating tables

lab var foverlap "Common Front"
lab var ctrend60 "War Worsening"
lab var pvict "Relative Capabilities"
lab var imptce "Importance"
lab var recexit "Recent Ally Exit"
lab var recexit2 "Alt. Recent Exit"
lab var demdum "Democracy"
lab var polity2 "Polity Score"
lab var newlead "New Leader"
lab var sepdum "No Separate Peace"
lab var lnodead "log(Battle Deaths)"
lab var lnodead2 "log(Battle Deaths/Pop.)"
lab var seppc "\% No Sep. Peace"
lab var actdum "Alliance Agreement"
lab var actpc "\% Allied"
lab var latejoin "Late Joiner"
lab var terraim "Territorial War Aim"
lab var regaim "Regime War Aim"
lab var cooppc "Coalition History"
lab var intdum "Integrated Command"
lab var contribpc "Importance (Soldiers)"

#del ;
esttab base1 base2 base3 base4 using results_final.tex, tex b(a2) star(\dag .1 * .05 ** .01)
se l mtitles("Coalition Trend" "Own Trend" "Coalition Trend" "Own Trend") scalars(N_sub N_fail)
title("Battlefield Situation and Abandonment of Allies\label{tab-results1}")
nonotes addnotes("Standard errors clustered by coalition. \sym{\dag} \(p<.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)")
replace
;

esttab contwd fullwd1 fullvol1 fullalt fullwd2 using results_final.tex, tex b(a2) star(\dag .1 * .05 ** .01)
se l mtitles("Controls" "Full Model" "Voluntary Exit" "Ally Relations" "No World Wars") scalars(N_sub N_fail)
title("Determinants of Defection from War Coalitions\label{tab-results2}")
o(foverlap ctrend60)
nonotes addnotes("Standard errors clustered by coalition. \sym{\dag} \(p<.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)")
append
;

esttab nowarend nogerrus nominor using results_final.tex, tex b(a2) star(\dag .1 * .05 ** .01)
se l mtitles("No WD. if War Ends" "No Non-Coord." "No Minor Participants") scalars(N_sub N_fail)
title("Robustness Checks for Determinants of Coalition Defection\label{tab-robust1}")
o(foverlap ctrend60)
nonotes addnotes("Standard errors clustered by coalition. \sym{\dag} \(p<.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)")
append
;

esttab waraim batdead1 batdead2 latejoin soldier using results_final.tex, tex b(a2) star(\dag .1 * .05 ** .01)
se l mtitles("War Aims" "Battle Deaths" "Alt. Deaths" "Late Joiner" "Alt. Impt.") scalars(N_sub N_fail)
title("Robustness Checks for Determinants of Coalition Defection\label{tab-robust1a}")
o(foverlap ctrend60 pvict imptce contribpc)
nonotes addnotes("Standard errors clustered by coalition. \sym{\dag} \(p<.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)")
append
;

esttab polity recexit2 ally1 ally2 ally3 using results_final.tex, tex b(a2) star(\dag .1 * .05 ** .01)
se l mtitles("Polity" "Alt. Recent Exit" "\% Sep. Pce." "Alliance" "\% Allied") scalars(N_sub N_fail)
title("Robustness Checks for Determinants of Coalition Defection\label{tab-robust2}")
o(foverlap ctrend60 pvict imptce demdum polity2 newlead recexit recexit2 sepdum)
nonotes addnotes("Standard errors clustered by coalition. \sym{\dag} \(p<.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)")
append
;

esttab sepdum1 sepdum2 using results_final.tex, tex b(a2) star(\dag .1 * .05 ** .01)
se l mtitles("First Day" "Last Day")
title("Common Front as a Determinant of Separate Peace Agreements\label{tab-robust4}")
nonotes addnotes("Standard errors clustered by coalition. \sym{\dag} \(p<.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)")
append
;
#del cr;

** Replicating the figures

** Figure 1

egen dte=concat(year month day), p("/")
gen date=date(dte,"YMD")

#del ;
scatter foverlap date if warnum==139 & ccode==2 & day==1, symbol(Oh) mc(black) || 
scatter foverlap date if warnum==139 & ccode==200 & day==1, symbol(X) mc(black) || 
scatter foverlap date if warnum==139 & ccode==365 & day==1, symbol(Sh) mc(black) ||
scatter foverlap date if warnum==139 & ccode==255 & day==1, symbol(Th) mc(black) 
xlabel(-5687 "D-Day" -5352 "VE Day" -6599 "Pearl Harbor" -7132 "Fall of France" -6226 "Stalingrad")
graphregion(fcolor(white)) 
legend(label(1 "USA") label(2 "Britain") label(3 "Russia/USSR") label(4 "Germany"))
ytitle("Front Overlap with Allies")
xtitle("")
title("World War II")
name(WWII, replace)
;

#del cr;

#del ;
scatter foverlap date if warnum==106 & ccode==2 & day==1, symbol(Oh) mc(black) ||
scatter foverlap date if warnum==106 & ccode==200 & day==1, symbol(X) mc(black) ||
scatter foverlap date if warnum==106 & ccode==365 & day==1, symbol(Sh) mc(black) || 
scatter foverlap date if warnum==106 & ccode==255 & day==1 & (year!=1914 | month!=8), symbol(Th) mc(black)
xlabel(-15599 "US entry" -15367 "Russian exit" -15832 "Romanian entry" -16436 "1/1/1915" -16071 "1/1/1916")
graphregion(fcolor(white))
legend(off)
ytitle("Front Overlap with Allies")
xtitle("")
title("World War I")
fysize(35)
name(WWI, replace)
;

graph combine WWI WWII, graphregion(fcolor(white)) cols(1)
;

** Figure 2

#del ;
sort idvar warday;
lab var ctrend60 "Coalition War Trend";
lab var otrend60 "Country War Trend";

twoway line ctrend60 warday if warnum==106 & ccode==2 & year==1918, lp(dash) lc(black) || 
line otrend60 warday if warnum==106 & ccode==2 & year==1918, lc(black) legend(off) xtitle(" ") graphregion(fcolor(white))
xlabel(260 "1/1/1918" 411 "6/1/1918" 574 "11/11/1918") name(ctrend_WWI, replace) fysize(45)
ytitle("War Trend: Positive Values" "Imply Worsening Outcomes");

twoway line ctrend60 warday if warnum==139 & ccode==2 & year==1944, lp(dash) lc(black) || 
line otrend60 warday if warnum==139 & ccode==2 & year==1944, lc(black) xtitle(" ") graphregion(fcolor(white))
xlabel( 756 "1/1/1944" 937 "7/1/1944" 1122 "1/1/1945") name(ctrend_WWII, replace)
ytitle("War Trend: Positive Values" "Imply Worsening Outcomes");

graph combine ctrend_WWI ctrend_WWII, graphregion(fcolor(white)) cols(1);
#del cr;

** Figure 3

#del ;
stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum, cluster(coalid) nohr;
stcurve, survival at1(foverlap=0 ctrend60=0 pvict=.5 demdum=0 newlead=0 sepdum=0 recexit=0)
at2(foverlap=1 ctrend60=0 pvict=.5 demdum=0 newlead=0 sepdum=0 recexit=0) lp(dash) lc(black black)
graphregion(fcolor(white)) legend(label(2 "Common front") label(1 "Wholly independent")) title("") 
xlabel(182 "6" 365 "12" 547 "18" 730 "24" 912 "30" 1095 "36" 1277 "42" 1460 "48") range(0 1500)
xtitle("Months") yscale(range(0)) ylabel(0(.2)1) ytitle("Proportion Not Yet Abandoning Coalition")
name("fronts", replace)
;
#del cr;

** Figure 5: full replication requires first running the baseline analysis
** with all the different battlefield trend variables and storing the results.

stset warday, id(idvar) f(withdraw)
drop val est estlo esthi
gen val=_n+14
replace val=. if val>120
gen est=.
gen estlo=.
gen esthi=.
forvalues i=15/120 {
di `i'
qui stcox foverlap ctrend`i' pvict imptce recexit demdum newlead sepdum, cluster(coalid) nohr
qui replace est=_b[ctrend`i'] if val==`i'
qui replace esthi=_b[ctrend`i']+invnormal(.975)*_se[ctrend`i'] if val==`i'
qui replace estlo=_b[ctrend`i']-invnormal(.975)*_se[ctrend`i'] if val==`i'
}

#del ;
twoway rarea esthi estlo val if est!=., color(gs12) || line est val if est!=., 
lc(black) || function y=0, lc(black) range(val)
graphregion(fcolor(white)) legend(off) xtitle("Window Size in Days") ytitle("Estimate for War Worsening")
yscale(range(-15)) ylabel(-15(5)15) name(windows, replace)
;

#del cr;

** Figure 4: Again, there are some front end calculations that need to be done

foreach var in foverlap ctrend60 pvict imptce {
	qui sum `var'
	qui replace `var'=(`var'-r(mean))/r(sd)
}

stset warday, id(idvar) f(withdraw)

stcox foverlap ctrend60 pvict imptce recexit demdum newlead sepdum, cluster(coalid) nohr

gen esti=.
gen estilo=.
gen estihi=.
gen vari=""
gen p=.

local n=1
forvalues i=1/99 {
	di `i'
	foreach var in foverlap ctrend60 pvict imptce {
		qui margins, at((p`i') `var')
		mat def A=r(b)
		mat def B=r(V)
		qui replace vari="`var'" in `n'
		qui replace p=`i' in `n'
		qui replace esti=A[1,1] in `n'
		qui replace estilo=A[1,1]-invnormal(.975)*sqrt(B[1,1]) in `n'
		qui replace estihi=A[1,1]+invnormal(.975)*sqrt(B[1,1]) in `n'
		local n=`n'+1
	}
}
forvalues i=0/1 {
	foreach var in recexit demdum newlead sepdum {
		qui margins, at(`var'=`i')
		mat def A=r(b)
		mat def B=r(V)
		qui replace vari="`var'" in `n'
		qui replace p=`i' in `n'
		qui replace esti=A[1,1] in `n'
		qui replace estilo=A[1,1]-invnormal(.975)*sqrt(B[1,1]) in `n'
		qui replace estihi=A[1,1]+invnormal(.975)*sqrt(B[1,1]) in `n'
		local n=`n'+1
	}
}
replace p=100 if p==1 & (vari=="demdum" | vari=="sepdum" | vari=="newlead" | vari=="recexit")

#del ;
line esti p if vari=="foverlap", lp(solid) || line esti p if vari=="ctrend60", lp(dash) || 
line esti p if vari=="pvict", lp(shortdash) || line esti p if vari=="imptce", lp(longdash) || 
line esti p if vari=="newlead", lp(longdash_dot) || line esti p if vari=="demdum", lp(dash_dot) || 
line esti p if vari=="sepdum", lp(shortdash_dot) graphregion(fcolor(white)) 
legend(label(1 "Common Front") label(2 "Battlefield Trend") label(3 "Relative Cap.") 
label(4 "Importance to Coal.") label(5 "New Leader") label(6 "Democracy") 
label(7 "No Sep. Peace")) ytitle("Marginal Probability of Abandonment") 
xtitle("Percentile in Observed Data")
;
#del cr;

** And now for the figure in the appendix

replace p=1 if p==100 & (vari=="demdum" | vari=="sepdum" | vari=="newlead" | vari=="recexit")
twoway rarea estihi estilo p if vari=="ctrend60", color(gs10) || line esti p if vari=="ctrend60", graphregion(fcolor(white)) name(ctrend60, replace) legend(off) title("Common Front") xtitle("")
twoway rarea estihi estilo p if vari=="foverlap", color(gs10) || line esti p if vari=="foverlap", graphregion(fcolor(white)) name(foverlap, replace) legend(off) title("Battlefield Trend") xtitle("")
twoway rarea estihi estilo p if vari=="pvict", color(gs10) || line esti p if vari=="pvict", graphregion(fcolor(white)) name(pvict, replace) legend(off) title("Probability of Victory") xtitle("")
twoway rarea estihi estilo p if vari=="imptce", color(gs10) || line esti p if vari=="imptce", graphregion(fcolor(white)) name(imptce, replace) legend(off) title("Importance to Coalition") xtitle("")
twoway rcap estihi estilo p if vari=="demdum" || scatter esti p if vari=="demdum", graphregion(fcolor(white)) name(demdum, replace) xscale(range(-.5 1.5)) xlabel(0 1) legend(off) title("Democracy") xtitle("")
twoway rcap estihi estilo p if vari=="newlead" || scatter esti p if vari=="newlead", graphregion(fcolor(white)) name(newlead, replace) xscale(range(-.5 1.5)) xlabel(0 1) legend(off) title("New Leader") xtitle("")
twoway rcap estihi estilo p if vari=="sepdum" || scatter esti p if vari=="sepdum", graphregion(fcolor(white)) name(sepdum, replace) xscale(range(-.5 1.5)) xlabel(0 1) legend(off) title("No Separate Peace") xtitle("")
twoway rcap estihi estilo p if vari=="recexit" || scatter esti p if vari=="recexit", graphregion(fcolor(white)) name(recexit, replace) xscale(range(-.5 1.5)) xlabel(0 1) legend(off) title("Recent Coalition" "Member Exit") xtitle("")

graph combine foverlap ctrend60 pvict imptce demdum newlead sepdum recexit, cols(4) graphregion(fcolor(white))

log close
