*------------------------------------------------------------------------------*
* Cunningham, Gleditsch, Gonzalez, Vidovic, White - JPR 2017
* Paper: "Words and Deeds: From Incompatibilities to Outcomes in Anti-Government Disputes"
* Code: Replication for quantities of interest graphs (Figure 2&3 in the paper)
*------------------------------------------------------------------------------*
*
clear all
set more off
*
*
*PREDICTED PROBABILITIES - customizing plots -----------------------------------
*
*(1) claim incidence-logit
logit claim2year l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3, robust cluster(ccode) 
*
margins l.Xregime, post
est store incident
*
*(2) claim onset-logit
logit claimonset l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2onset_pyrs claim2onset_pyrs2 claim2onset_pyrs3 if l.claim2year==0, robust cluster(ccode) 
*
margins l.Xregime , post
est store onset
*
* Code for FIGURE 2 in the paper
* (GRAPH) claim incidence & onset (logit models)
#delimit ;
coefplot (incident , label(Claims incidence)  msymbol(O) mlcolor(gs0)       msize(1.5)  mlwidth(.2) mfcolor(gs0)       ciopts(lwidth(*1) lcolor(gs0)) )
		 (onset	   , label(Claims onset)      msymbol(S) mlcolor(cranberry) msize(1.5)  mlwidth(.2) mfcolor(cranberry) ciopts(lwidth(*1) lcolor(cranberry))),
		  scheme(s1mono) 
	 	  ylabel(0(.1).7, labsize(medsmall) angle(horizontal) nogrid)
    	  levels(95)
		  vertical
          xsc(r(1 3.5)) 
          xtitle("")
          xlabel(1 `" "Democracy" "(unconsolidated)" "' 2"Anocracy" 3"Autocracy")
          ytitle(Probability of claims) 
		  title("")
		  legend(label(1 "Claims incidence") label(3 "Claims onset") 
		  region(lcolor(white)) region(lwidth(none) lcolor(none)) cols(2)
		  symy(1.5) si(small) nobox)
		  ;
#delimit cr
*
*
*PREDICTIONS for nv campaign, given claim==1 -----------------------------------
*
*(3)non-violent campaign incidence
heckprob navco l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 
margins l.Xregime, predict(pcond) post
est store incident2
*
*
*(4)non-violent campaign onset
heckprob navco_onset l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 
margins l.Xregime, predict(pcond) post
est store onset2
*
* Code for FIGURE 3 in the paper
* (GRAPH) non-violent campaign incident & onset (heckman models)
#delimit ;
coefplot (incident2 , label(Non-violent campaign incidence)  msymbol(O) mlcolor(gs0)       msize(1.5)  mlwidth(.2) mfcolor(gs0)       ciopts(lwidth(*1) lcolor(gs0)) )
		 (onset2	, label(Non-violent campaign onset)      msymbol(S) mlcolor(cranberry) msize(1.5)  mlwidth(.2) mfcolor(cranberry) ciopts(lwidth(*1) lcolor(cranberry))),
		  scheme(s1mono) 
    	  levels(95)
		  vertical
          xsc(r(1 3.5)) 
          xtitle("")
          xlabel(1 `" "Democracy" "(unconsolidated)" "' 2"Anocracy" 3"Autocracy")
		  ysc(r(-0.01 .13)) 
	 	  ylabel(0(.02).12, labsize(medsmall) angle(horizontal) nogrid)
          ytitle(Probability of non-violent campaign) 
		  title("")
		  legend(label(1 "Non-violent campaign incidence") label(3 "Non-violent campaign onset") 
		  region(lcolor(white)) region(lwidth(none) lcolor(none)) cols(2)
		  symy(1.5) si(small) nobox)
		  ;
#delimit cr
*
*
*------------------------------------------------------------------------------*
** End of do file
*------------------------------------------------------------------------------*
