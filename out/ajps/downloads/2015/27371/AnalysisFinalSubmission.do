/**************************************************/
/*This do file runs analysis etc for Knutsen and */
/*NygŒrd on inconsistent regimes		         */
/*prepdata.do must already have been run		 */
/*************************************************/

clear all
set scheme s1mono
set seed 1234
capture cd Collaborations
capture cd "C:/Users/havnyg/Dropbox/Collaborations"
capture cd "/Users/havard/Dropbox/Collaborations/"

stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)


by ourtype year, sort: egen meansurvival = mean(_t)
twoway ///
 (line meansurvival year if ourtype == 0, lpattern(dash) lwidth(.6)) || /// 
 (line meansurvival year if ourtype == 2, lpattern(solid)  lwidth(.6)) || ///
 (line meansurvival year if ourtype == 3, lpattern(longdash)  lwidth(.6) ///
  ytitle(Average years of survival) xtitle(Year) ///
  legend(lab(1 "Semi-Democracies") lab(2 "Autocracies") lab(3 "Democracies")))
graph export "CHKHMNdemstab/Figures/averagesurvival.pdf", replace as(pdf)


*********************************
/* RE-SET STSET				*/
********************************

stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)

************************
/*OVB AND INSTABILITY */
***********************

eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol i.period 

/*gates et al replication */
eststo: xi: streg i.ourtype `controls'  ///
	, dist(llogistic) robust tr 

	
/*gates et al replication with reduced time frame */
eststo: xi: streg i.ourtype `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. ///
	, dist(llogistic) robust tr 


/*instability */
eststo: xi: streg i.ourtype pressure sip2status pastinstability `controls' if polity88!=. ///
	, dist(llogistic) robust tr 
	
/*Coup d'etats */
eststo: xi: streg i.ourtype coup10year `controls' ///
	, dist(llogistic) robust tr

/*Ruling Coalition*/
eststo: xi: streg i.ourtype lnrulingcoalitionduration `controls' ///
	, dist(llogistic) robust tr 

/*Polity -88: Transitions*/
eststo: xi: streg i.ourtype polity88 `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. ///
	, dist(llogistic) robust tr
	
/*Fixed effects*/
eststo: xi: streg i.ourtype `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. ///
	, dist(llogistic) tr shared(gwno) forceshared

*esttab using "CHKHMNdemstab/Tables/ovbandinstability.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gate et al." "Gate et al." "Instability" "Coups" "Ruling Coalition" "Transitions"  "Shared frailty") ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	 mon "HT Monarchy" mil "HT Military" mul "HT Multi-party" onep "HT One-party" nop "HT No-party" ///
	 lagcoup "Coup, t-1" coup10year "Coups, 10 years") ///
	order(_Iourtype_2  _Iourtype_3 pastinstability pressure sip2status coup10year ///
	 lnrulingcoalitionduration polity88)

****************************************************
/*OVB AND INSTABILITY -- Disaggregated Closed only */
*****************************************************

eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

/*gates et al replication */
eststo: xi: streg  cpart cxconst dual cxconpart partdual `controls' if xrec!=4   ///
	, dist(llogistic) robust tr 
capture drop closedorigpred
predict closedorigpred, median time  
/*instability */
eststo: xi: streg cpart cxconst dual cxconpart partdual pressure sip2status pastinstability `controls' if polity88!=. & xrec!=4 ///
	, dist(llogistic) robust tr 
capture drop closedinstabilitypred
predict closedinstabilitypred, median time  

/*Coup d'etats */
xi: streg part cxconst dual cxconpart coup10year `controls' ///
	, dist(llogistic) robust tr
capture drop closedcoupspred
predict closedcoupspred, median time  

/* Calculating cell counts for Table 5*/
capture drop cons4
gen cons4 = xconst
replace cons4 = xconst if app==0
recode cons4 2/3=2 4/5=3 6/7=4 if app==0
capture drop part4
gen part4 = 0 if part !=.
replace part4 = 0 if part ~=. & app==0
recode part4 0=1 if part > 0 & exp(part)<=7 & app==0
recode part4 0=2 if exp(part)>7 & exp(part)<=30 & app==0
recode part4 0=3 if exp(part)>30 & app==0

tabulate part4 cons4 if orig== 1 & xrec==4 & cgdpcap ~=. & avgnabo ~=. & firstpol~=. & app == 0
table part4 cons4, c(mean closedorigpred)
tabout part4 cons4 using "CHKHMNdemstab/Tables/closedpredictionsorig.tex", c(mean closedorigpred) sum replace style(tex)
table part4 cons4, c(mean closedinstabilitypred)
tabout part4 cons4 using "CHKHMNdemstab/Tables/closedpredictionsinstability.tex", c(mean closedinstabilitypred) sum replace style(tex)
tabout part4 cons4 using "CHKHMNdemstab/Tables/closedpredictionscoups.tex", c(mean closedcoupspred) sum replace style(tex)

*esttab using "CHKHMNdemstab/Tables/ovbandinstabilitydisaggregatedclosed.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gate et al." "Instability" ) ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	 mon "HT Monarchy" mil "HT Military" mul "HT Multi-party" onep "HT One-party" nop "HT No-party" ///
	 lagcoup "Coup, t-1" coup10year "Coups, 10 years" cpart "Participation" cxconst "Constraints" dual "Dual" cxconpart "Participation*Constraints" partdual "Dual*Participation") ///
	order(cpart cxconst dual cxconpart partdualpastinstability pressure sip2status)

****************************************************
/*OVB AND INSTABILITY -- Disaggregated Open only */
*****************************************************

eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

/*gates et al replication */
eststo: xi: streg  cpart cxconst cxconpart `controls' if xrec==4  ///
	, dist(llogistic) robust tr 
capture drop openorigpred
predict openorigpred, median time  
/*instability */
eststo: xi: streg cpart cxconst cxconpart pressure sip2status pastinstability `controls' if polity88!=. & xrec==4 ///
	, dist(llogistic) robust tr 
capture drop openinstabilitypred
predict openinstabilitypred, median time 

/* Calculating parameters for Table X*/
capture drop cons4
gen cons4 = xconst
replace cons4 = xconst if app==0
recode cons4 2/3=2 4/5=3 6/7=4 if app==0
capture drop part4
gen part4 = 0 if part !=.
replace part4 = 0 if part ~=. & app==0
recode part4 0=1 if part > 0 & exp(part)<=7 & app==0
recode part4 0=2 if exp(part)>7 & exp(part)<=30 & app==0
recode part4 0=3 if exp(part)>30 & app==0
/* END Calculating parameters for Table X*/

/* Calculating cell counts for Table X*/
tabulate part4 cons4 if orig== 1 & xrec==4 & cgdpcap ~=. & avgnabo ~=. & firstpol~=. & app == 0
table part4 cons4, c(mean openorigpred)
tabout part4 cons4 using "CHKHMNdemstab/Tables/openpredictionsorig.tex", c(mean openorigpred) sum replace style(tex)
table part4 cons4, c(mean openinstabilitypred)
tabout part4 cons4 using "CHKHMNdemstab/Tables/openpredictionsinstability.tex", c(mean openinstabilitypred) sum replace style(tex)
/* END Calculating cell counts  for Table X*/

*esttab using "CHKHMNdemstab/Tables/ovbandinstabilitydisaggregatedopen.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gate et al." "Instability" ) ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	 mon "HT Monarchy" mil "HT Military" mul "HT Multi-party" onep "HT One-party" nop "HT No-party" ///
	 lagcoup "Coup, t-1" coup10year "Coups, 10 years" cpart "Participation" cxconst "Constraints" dual "Dual" cxconpart "Participation*Constraints" partdual "Dual*Participation") ///
	order(cpart cxconst cxconpart pastinstability pressure sip2status )	 
	

*********************************
/* RE-SET STSET				*/
********************************

stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

************************
/*REGIME CATEGORIES*/
************************

eststo clear
/*gates et al replication*/
eststo: xi: streg i.ourtype `controls'  if regime1ny!=. ///
	, dist(llogistic) robust tr

/*gates et al with geddes regime types*/
eststo: xi: streg i.ourtype gwf_monarch gwf_party gwf_personal gwf_military `controls' if regime1ny!=. ///
	, dist(llogistic) robust tr

/* with hadenius and teorell regime dummies */
eststo: xi: streg i.ourtype hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty `controls'  ///
	, dist(llogistic) robust tr 
	
/*gates et al with geddes regime types*/
eststo: xi: streg i.ourtype gwf_monarch gwf_party gwf_personal gwf_military `controls'  ///
	, dist(llogistic) robust tr

/*competitive autoc*/
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol i.period 
eststo: xi: streg i.ourtype HEGEMONIC COMPETITIVE `controls' ///
	, dist(llogistic) robust tr

	
*esttab using "CHKHMNdemstab/Tables/regimedummies.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gates et al" "G Regime type" "HL Regime type" "G Regime type full" "Comp. auth.") ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" ///
	avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	hlmonarchy "HT Monarchy" hlmilitary "HT Military" hlmultiparty "HT Multi-party" hloneparty "HT One-party" hlnoparty "HT No-party" ///
	hlother "HL Other" hlnoparty "HL No party") ///
	order(_Iourtype_2  _Iourtype_3 gwf_monarch gwf_party gwf_personal gwf_military ///
	hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty HEGEMONIC COMPETITIVE) ///
	addnote(Hadenius and Teorell No-party and Other categories collapsed)

****************************************************
/*REGIME CATEGORIES Disaggregated  -- closed only */
****************************************************
	
eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

/*gates et al replication */
eststo: xi: streg  cpart cxconst dual cxconpart partdual `controls' if xrec!=4 & gwf_monarch !=.  ///
	, dist(llogistic) robust tr 
capture drop closedorigpred
predict closedorigpred, median time  

/* with hadenius and teorell regime dummies */
eststo: xi: streg cpart cxconst dual cxconpart partdual hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty `controls' if xrec!=4  ///
	, dist(llogistic) robust tr 
capture drop closedhlpred
predict closedhlpred, median time  
	
/*gates et al with geddes regime types*/
eststo: xi: streg cpart cxconst dual cxconpart partdual gwf_monarch gwf_party gwf_personal gwf_military `controls' if xrec!=4  ///
	, dist(llogistic) robust tr
capture drop closedgeddespred
predict closedgeddespred, median time  

stci if gwf_military==1, by(part4 cons4)

/*competitive autoc*/
eststo: xi: streg cpart cxconst dual cxconpart partdual HEGEMONIC COMPETITIVE `controls' if xrec!=4  ///
	, dist(llogistic) robust tr
capture drop closedcomppred
predict closedcomppred, median time  


/* Calculating cell counts for Table X*/
tabout part4 cons4 using "CHKHMNdemstab/Tables/regimetypeclosedpredictionsorig.tex", c(mean closedorigpred) sum replace style(tex)
tabout part4 cons4 using "CHKHMNdemstab/Tables/regimetypeclosedpredictionsdisagghl.tex", c(mean closedhlpred) sum replace style(tex)
tabout part4 cons4 using "CHKHMNdemstab/Tables/regimetypeclosedpredictionsdisagggeddes.tex", c(mean closedgeddespred) sum replace style(tex)
tabout part4 cons4 using "CHKHMNdemstab/Tables/regimetypeclosedpredictionsdisaggcompauth.tex", c(mean closedcomppred) sum replace style(tex)

/*Calculate cell counts for specific Geddes regime Categories */
tabout part4 cons4 if gwf_monarch == 1 using "CHKHMNdemstab/Tables/monarchiesclosedpredictionsdisagggeddes.tex", c(mean closedgeddespred) sum replace style(tex)
tabout part4 cons4 if gwf_party == 1 using "CHKHMNdemstab/Tables/partyclosedpredictionsdisagggeddes.tex", c(mean closedgeddespred) sum replace style(tex)
tabout part4 cons4 if gwf_personal == 1 using "CHKHMNdemstab/Tables/personalclosedpredictionsdisagggeddes.tex", c(mean closedgeddespred) sum replace style(tex)
tabout part4 cons4 if gwf_military == 1 using "CHKHMNdemstab/Tables/militaryclosedpredictionsdisagggeddes.tex", c(mean closedgeddespred) sum replace style(tex)

/* END Calculating cell counts  for Table X*/

*esttab using "CHKHMNdemstab/Tables/regimedummiesdisaggregatedclosed.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gates et al" "G Regime type" "HL Regime type" "G Regime type full" "Comp. auth.") ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" ///
	avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	hlmonarchy "HT Monarchy" hlmilitary "HT Military" hlmultiparty "HT Multi-party" hloneparty "HT One-party" hlnoparty "HT No-party" ///
	hlother "HL Other" hlnoparty "HL No party") ///
	order(cpart cxconst dual cxconpart partdual gwf_monarch gwf_party gwf_personal gwf_military ///
	hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty HEGEMONIC COMPETITIVE) ///
	addnote(Hadenius and Teorell No-party and Other categories collapsed)	

***********************************************************
/**	END OF DO FILE 	Main Analysis						*/
***********************************************************

***********************************************************
/**	Appendix tables										*/
***********************************************************
stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
/*generate logit sip */

gen logitsip = ln((sip2)/(1-sip2))
gen logitsipsq = logitsip^2
gen politysq = polity2^2


/*Table 2*/ 
eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol i.period 

eststo: xi: stcox i.ourtype `controls' if pressure!=. & sip2status!=. & pastinstability!=. ///
	, robust 
eststo: xi: stcox i.ourtype pressure sip2status pastinstability `controls'  ///
	, robust 
eststo: xi: streg polity politysq `controls'  if pressure!=. & sip2status!=. & pastinstability!=. ///
	, dist(llogistic) robust tr
eststo: xi: streg polity politysq pressure sip2status pastinstability `controls'  ///
	, dist(llogistic) robust tr
eststo: xi: streg sip2 sip2sq  `controls' if logitsipsq!=. & pressure!=. & sip2status!=. & pastinstability!=.  ///
	, dist(llogistic) robust tr
eststo: xi: streg sip2 sip2sq pressure sip2status pastinstability `controls' if logitsipsq!=. ///
	, dist(llogistic) robust tr
eststo: xi: streg logitsip logitsipsq  `controls' if pressure!=. & sip2status!=. & pastinstability!=. ///
	, dist(llogistic) robust tr
eststo: xi: streg logitsip logitsipsq pressure sip2status pastinstability `controls' ///
	, dist(llogistic) robust tr
	
*esttab using "CHKHMNdemstab/Tables/appendixtable2.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Cox" "Cox" "Polity" "Polity" "SIP" "SIP" "logit(SIP)" "logit(SIP)") ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" polity "Polity" politysq "Polity^2" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" ///
	avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	hlmonarchy "HT Monarchy" hlmilitary "HT Military" hlmultiparty "HT Multi-party" hloneparty "HT One-party" hlnoparty "HT No-party" ///
	hlother "HL Other" hlnoparty "HL No party" sip2 "SIP" sip2sq "SIP^2" logitsip "logit(SIP)" logitsipsq "logit(SIP^2)") ///
	order(_Iourtype_2 _Iourtype_3 polity politysq sip2 sip2sq logitsip logitsipsq)
/*END table 2*/

/*Table 3*/ 

eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol

/*gates et al replication */
eststo: xi: streg cpart cxconst cxconpart `controls' if xrec==4   ///
	, dist(llogistic) robust tr 
/*gates et al replication with reduced time frame */
eststo: xi: streg cpart cxconst cxconpart `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. & xrec==4  ///
	, dist(llogistic) robust tr 
/*instability */
eststo: xi: streg cpart cxconst cxconpart pressure sip2status pastinstability `controls' if polity88!=. & xrec==4 ///
	, dist(llogistic) robust tr 
/*Coup d'etats */
eststo: xi: streg cpart cxconst cxconpart coup10year `controls' if xrec==4  ///
	, dist(llogistic) robust tr
/*Ruling Coalition*/
eststo: xi: streg cpart cxconst cxconpart lnrulingcoalitionduration `controls' if xrec==4  ///
	, dist(llogistic) robust tr 
/*Polity -88: Transitions*/
eststo: xi: streg cpart cxconst cxconpart polity88 `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. & xrec==4 ///
	, dist(llogistic) robust tr
/*Fixed effects*/
eststo: xi: streg cpart cxconst cxconpart `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. & xrec==4  ///
	, dist(llogistic) tr shared(gwno) forceshared
*esttab using "CHKHMNdemstab/Tables/appendixtable3.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gate et al." "Gate et al." "Instability" "Coups" "Ruling Coalition" "Transitions"  "Shared frailty") ///
	coeflabels(cpart "Participation" cxconst "Exec. Const." dual "Dual" cxconpart "Participation*Constraints" ///
	partdual "Dual*Participation"  cgdpcap "GDP" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	 mon "HT Monarchy" mil "HT Military" mul "HT Multi-party" onep "HT One-party" nop "HT No-party" ///
	 lagcoup "Coup, t-1" coup10year "Coups, 10 years") ///
	order(cpart cxconst cxconpart pastinstability pressure sip2status coup10year ///
	 lnrulingcoalitionduration polity88)
/*END table 3*/



/*Table 4*/ 

eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

/*gates et al replication */
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls' if xrec!=4  ///
	, dist(llogistic) robust tr 
/*gates et al replication with reduced time frame */
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. & xrec!=4   ///
	, dist(llogistic) robust tr 
/*instability */
eststo: xi: streg cpart cxconst dual cxconpart partdual pressure sip2status pastinstability `controls' if polity88!=. &xrec!=4   ///
	, dist(llogistic) robust tr 
/*Coup d'etats */
eststo: xi: streg cpart cxconst dual cxconpart partdual coup10year `controls' if xrec!=4   ///
	, dist(llogistic) robust tr
/*Ruling Coalition*/
eststo: xi: streg cpart cxconst dual cxconpart partdual lnrulingcoalitionduration `controls' if xrec!=4   ///
	, dist(llogistic) robust tr 
/*Polity -88: Transitions*/
eststo: xi: streg cpart cxconst dual cxconpart partdual polity88 `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. & xrec!=4  ///
	, dist(llogistic) robust tr
/*Fixed effects*/
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls' if pastinstability!=. & sip2status!=. & pastinstability!=. & polity88!=. & xrec!=4   ///
	, dist(llogistic) tr shared(gwno) forceshared
*esttab using "CHKHMNdemstab/Tables/appendixtable4.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gate et al." "Gate et al." "Instability" "Coups" "Ruling Coalition" "Transitions"  "Shared frailty") ///
	coeflabels(cpart "Participation" cxconst "Exec. Const." dual "Dual" cxconpart "Participation*Constraints" ///
	partdual "Dual*Participation"  cgdpcap "GDP" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	 mon "HT Monarchy" mil "HT Military" mul "HT Multi-party" onep "HT One-party" nop "HT No-party" ///
	 lagcoup "Coup, t-1" coup10year "Coups, 10 years") ///
	order(cpart cxconst dual cxconpart partdual pastinstability pressure sip2status coup10year ///
	 lnrulingcoalitionduration polity88)
/*END table 4*/


/*Appendix table 5*/
eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

eststo: xi: streg cpart cxconst cxconpart `controls'  if regime1ny!=. & xrec==4  ///
	, dist(llogistic) robust tr
eststo: xi: streg cpart cxconst cxconpart gwf_monarch gwf_party gwf_personal gwf_military `controls' if regime1ny!=. & xrec==4 ///
	, dist(llogistic) robust tr
eststo: xi: streg cpart cxconst cxconpart hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty `controls'  if xrec==4 ///
	, dist(llogistic) robust tr 
eststo: xi: streg cpart cxconst cxconpart gwf_monarch gwf_party gwf_personal gwf_military `controls'  if xrec==4 ///
	, dist(llogistic) robust tr
eststo: xi: streg cpart cxconst cxconpart HEGEMONIC COMPETITIVE `controls' if xrec==4 ///
	, dist(llogistic) robust tr
*esttab using "CHKHMNdemstab/Tables/appendixtable5.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gates et al" "G Regime type" "HL Regime type" "G Regime type full" "Competitive authoritarianism" ///
	"Gates et al" "G Regime type" "HL Regime type" "G Regime type full" "Competitive authoritarianism") ///
	coeflabels(cpart "Participation" cxconst "Exec. Const." dual "Dual" cxconpart "Participation*Constraints" ///
	partdual "Dual*Participation"  cgdpcap "GDP" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" ///
	avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	hlmonarchy "HT Monarchy" hlmilitary "HT Military" hlmultiparty "HT Multi-party" hloneparty "HT One-party" hlnoparty "HT No-party" ///
	hlother "HL Other" hlnoparty "HL No party") ///
	order(cpart cxconst cxconpart  gwf_monarch gwf_party gwf_personal gwf_military ///
	hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty HEGEMONIC COMPETITIVE) ///
	addnote(Hadenius and Teorell No-party and Other categories collapsed)
/*END table 5*/

/*Appendix table 6*/	
eststo clear
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls'  if regime1ny!=. & xrec!=4 ///
	, dist(llogistic) robust tr
eststo: xi: streg cpart cxconst dual cxconpart partdual gwf_monarch gwf_party gwf_personal gwf_military `controls' if regime1ny!=. & xrec!=4 ///
	, dist(llogistic) robust tr
eststo: xi: streg cpart cxconst dual cxconpart partdual hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty `controls' if xrec!=4 ///
	, dist(llogistic) robust tr 
eststo: xi: streg cpart cxconst dual cxconpart partdual gwf_monarch gwf_party gwf_personal gwf_military `controls'  if xrec!=4 ///
	, dist(llogistic) robust tr
eststo: xi: streg cpart cxconst dual cxconpart partdual HEGEMONIC COMPETITIVE `controls' if xrec!=4 ///
	, dist(llogistic) robust tr
	
*esttab using "CHKHMNdemstab/Tables/appendixtable6.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gates et al" "G Regime type" "HL Regime type" "G Regime type full" "Competitive authoritarianism" ///
	"Gates et al" "G Regime type" "HL Regime type" "G Regime type full" "Competitive authoritarianism") ///
	coeflabels(cpart "Participation" cxconst "Exec. Const." dual "Dual" cxconpart "Participation*Constraints" ///
	partdual "Dual*Participation"  cgdpcap "GDP" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" ///
	avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	hlmonarchy "HT Monarchy" hlmilitary "HT Military" hlmultiparty "HT Multi-party" hloneparty "HT One-party" hlnoparty "HT No-party" ///
	hlother "HL Other" hlnoparty "HL No party") ///
	order(cpart cxconst dual cxconpart partdual gwf_monarch gwf_party gwf_personal gwf_military ///
	hlmonarchy hlmilitary hloneparty hlmultiparty hlnoparty HEGEMONIC COMPETITIVE) ///
	addnote(Hadenius and Teorell No-party and Other categories collapsed)
/*END table 6*/

/*Appendix table 7*/

eststo clear	
local controls cgdpcap gdpsq laggdpgr avgnabo firstpol 

/*run seperate analysis for democratizations and autocratizations */

stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst cxconpart `controls' if xrec==4  ///
	, dist(llogistic) robust tr
stset endnd, id(stsetpolid) failure(democratization ==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst cxconpart `controls'  if xrec==4 ///
	, dist(llogistic) robust tr 
stset endnd, id(stsetpolid) failure(autocratization ==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst cxconpart `controls'   if xrec==4 ///
	, dist(llogistic) robust tr 
stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst cxconpart ceiling floor `controls'   if xrec==4 ///
	, dist(llogistic) robust tr 

stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls' if xrec!=4  ///
	, dist(llogistic) robust tr 
stset endnd, id(stsetpolid) failure(democratization ==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls'  if xrec!=4 ///
	, dist(llogistic) robust tr 
stset endnd, id(stsetpolid) failure(autocratization ==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst dual cxconpart partdual `controls' if xrec!=4 ///
	, dist(llogistic) robust tr 
stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
eststo: xi: streg cpart cxconst dual cxconpart partdual ceiling floor `controls'  if xrec!=4 ///
	, dist(llogistic) robust tr 
	
*esttab using "CHKHMNdemstab/Tables/appendixtable7.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Baseline" "Democratization only" "Autocratization only" "Floor and Ceiling" "Baseline" "Democratization only" "Autocratization only" "Floor and Ceiling") ///
	coeflabels(cpart "Participation" cxconst "Exec. Const." dual "Dual" cxconpart "Participation*Constraints" ///
	partdual "Dual*Participation"  lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	 mon "HT Monarchy" mil "HT Military" mul "HT Multi-party" onep "HT One-party" nop "HT No-party" ceiling "Ceiling dummy" floor "Floor dummy") ///
	 order(cpart cxconst cxconpart dual partdual ceiling floor)  
	
/*END table 7*/



/*Table 8*/ 
stset endnd, id(stsetpolid) failure(status==1) origin(time entrydate) scale(365.25)
eststo clear
capture drop region
gen region = 0
replace region = 2 if gwno == 41 | gwno == 42 | gwno == 51 | gwno == 52 | gwno == 70 | gwno == 90 | gwno == 40
replace region = 2 if gwno == 31 | gwno == 53 | gwno == 80 | gwno == 115 | gwno == 135
replace region = 2 if gwno == 91 | gwno == 92 | gwno == 93 | gwno == 94 | gwno == 95
replace region = 2 if gwno == 100 | gwno == 101 | gwno == 110 | gwno == 130 | gwno == 140 | gwno == 145 | gwno == 150 | gwno == 155 | gwno == 160 | gwno == 165
replace region = 3 if gwno == 200 | gwno == 205 | gwno == 210 | gwno == 211 | gwno == 212 | gwno == 220 | gwno == 225 | gwno == 230 | gwno == 235 | gwno == 260
replace region = 3 if gwno == 2 | gwno == 20
replace region = 3 if gwno == 900 | gwno == 910 | gwno == 920 | gwno == 940 | gwno == 950
replace region = 3 if gwno == 305 | gwno == 325 | gwno == 350 | gwno == 352
replace region = 3 if gwno == 265 | gwno == 338
replace region = 3 if gwno == 375 | gwno == 380 | gwno == 385 | gwno == 390 | gwno == 395
replace region = 4 if gwno == 355 | gwno == 359 | gwno == 360 | gwno == 365 | gwno == 366 | gwno == 367 | gwno == 368 | gwno == 369 | gwno == 370
replace region = 4 if gwno == 290 | gwno == 310 | gwno == 316 | gwno == 317 | gwno == 339 | gwno == 343 | gwno == 344 | gwno == 345 | gwno == 346 | gwno == 349
replace region = 4 if gwno == 341 | gwno == 315
replace region = 5 if gwno == 371 | gwno == 372 | gwno == 373 | gwno == 678 | gwno == 680
replace region = 5 if gwno == 600 | gwno == 615 | gwno == 616 | gwno == 620 | gwno == 625 | gwno == 640 | gwno == 645 | gwno == 651 | gwno == 652 | gwno == 660 | gwno == 663
replace region = 5 if gwno == 666 | gwno == 670 | gwno == 690 | gwno == 692 | gwno == 694 | gwno == 696 | gwno == 698
replace region = 6 if gwno == 402 | gwno == 404 | gwno == 411 | gwno == 420 | gwno == 432 | gwno == 433 | gwno == 434 | gwno == 435 | gwno == 436 | gwno == 437
replace region = 6 if gwno == 438 | gwno == 439 | gwno == 450 | gwno == 451 | gwno == 452 | gwno == 461 | gwno == 475
replace region = 7 if gwno == 471 | gwno == 481 | gwno == 482 | gwno == 483 | gwno == 484 | gwno == 490 | gwno == 500 
replace region = 7 if gwno == 501 | gwno == 510 | gwno == 516 | gwno == 517
replace region = 7 if gwno == 522 | gwno == 530 | gwno == 531 | gwno == 511 | gwno == 520 
replace region = 1 if gwno == 540 | gwno == 541 | gwno == 551 | gwno == 552 | gwno == 553 | gwno == 560 | gwno == 565 
replace region = 1 if gwno == 580 | gwno == 581 | gwno == 590 |  gwno == 570 | gwno == 571 
replace region = 1 if gwno == 572
replace region = 8 if gwno == 630 | gwno == 750 | gwno == 770 | gwno == 771 | gwno == 780 | gwno == 781
replace region = 8 if gwno == 700 | gwno == 701 | gwno == 702 | gwno == 703 | gwno == 704 | gwno == 705
replace region = 9 if gwno == 710 | gwno == 712 | gwno == 713 | gwno == 731 | gwno == 732 | gwno == 740 | gwno == 760 | gwno == 775 | gwno == 790 | gwno == 800 | gwno == 811
replace region = 9 if gwno == 812 | gwno == 816 | gwno == 820 | gwno == 830 | gwno == 840 | gwno == 850
replace region = 9 if gwno == 817 | gwno == 835 | gwno == 860

eststo: xi: streg i.ourtype  cgdpcap gdpsq laggdpgr avgnabo firstpol i.period if pastinstability!=. & sip2status!=. & pastinstability!=.  ///
	, dist(llogistic) robust tr	
eststo: xi: streg i.ourtype pressure sip2status pastinstability cgdpcap gdpsq laggdpgr avgnabo firstpol i.period   ///
	, dist(llogistic) robust tr
	
eststo: xi: streg i.ourtype  cgdpcap laggdpgr avgnabo firstpol i.period if pastinstability!=. & sip2status!=. & pastinstability!=.  ///
	, dist(llogistic) robust tr
eststo: xi: streg i.ourtype pressure sip2status pastinstability cgdpcap laggdpgr avgnabo firstpol i.period   ///
	, dist(llogistic) robust tr
	
eststo: xi: streg i.ourtype  cgdpcap gdpsq laggdpgr firstpol i.period if pastinstability!=. & sip2status!=. & pastinstability!=.  ///
	, dist(llogistic) robust tr
eststo: xi: streg i.ourtype pressure sip2status pastinstability cgdpcap gdpsq laggdpgr firstpol i.period   ///
	, dist(llogistic) robust tr
	
eststo: xi: streg i.ourtype  cgdpcap gdpsq laggdpgr avgnabo firstpol i.period i.region if pastinstability!=. & sip2status!=. & pastinstability!=. ///
	, dist(llogistic) robust tr	
eststo: xi: streg i.ourtype pressure sip2status pastinstability cgdpcap gdpsq laggdpgr avgnabo firstpol i.period i.region  ///
	, dist(llogistic) robust tr	
	
*esttab using "CHKHMNdemstab/Tables/appendixtable8.tex", replace ///
	nogaps eform stats(aic ll N N_sub N_fail gamma) ///
    mtitles("Gates et al" "Gates et al" "Gates et al" "Gates et al" "Gates et al" "Gates et al" "Gates et alm region" "Gates et alm region") ///
	coeflabels(_Iourtype_2 "Autocracy" _Iourtype_3 "Democracy" polity "Polity" politysq "Polity^2" lnrulingcoalitionduration "Ruling Col. Duration" ///
	pressure "Pressure to Democratize" gwf_monarch "G Monarchy" gwf_party "G Party regime" gwf_personal "G Personalist" ///
	gwf_military "G Military" pastinstability "Past instability" sip2status "SIP change" ///
	lnrulingcoalitionduration "Ruling Col. Duration"  cgdpcap "GDP" gdpsq "GDP squared" laggdpgrowth "GDP growth" ///
	avgnabo "Neigboruing regimes" firstpol "First polity dummy" ///
	hlmonarchy "HT Monarchy" hlmilitary "HT Military" hlmultiparty "HT Multi-party" hloneparty "HT One-party" hlnoparty "HT No-party" ///
	hlother "HL Other" hlnoparty "HL No party" sip2 "SIP" sip2sq "SIP^2" logitsip "logit(SIP)" logitsipsq "logit(SIP^2)") ///
	order(_Iourtype_2 _Iourtype_3 polity politysq sip2 sip2sq logitsip logitsipsq)
/*END table 8*/

