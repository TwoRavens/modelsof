cd "C:/Users/gwill_000/Dropbox/Research/3 - Decline and Retrenchment/Stats"
log using RetrenchmentLogRR
***********RECOVERY MODELS (Tables 2 and 3)
***One Year Threshold (Table 2)
use Retrench1yr, clear
*Milex only
logit  gdpcaprec l_logmilperc 															gdpcapdurct* if gdpcapx==1, cluster(ccode)
*Milex with controls
logit  gdpcaprec l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq	gdpcapdurct* if gdpcapx==1, cluster(ccode)
*Milex with controls and fixed effects
logit gdpcaprec l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq 	gdpcapdurct* ibn.ccode if gdpcapx==1, cluster(ccode)
*Predicted probability plot
margins, at(l_logmilperc=(-30(1)30))
marginsplot, xtitle(Percent Change in Logged Military Expenditures (t-1)) xlab(-30(5)30) ///
ytitle(Probability of Recovery) ylab(, nogrid) yline(0, lcol(black)) ///
title("") graphregion(margin(zero) fcolor(white)) recastci(rarea)  ///
plotopts(lcolor(black) lwidth(medthick) lpattern(solid) mcolor(black) msymbol(point)) 

///
set scheme s1mono

***Five Year Threshold (Table 3)
use Retrench5yr, clear
*Milex only
logit  gdpcaprec l_logmilperc 															gdpcapdurct* if gdpcapx==1, cluster(ccode)
*Milex with controls
logit  gdpcaprec l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq	gdpcapdurct* if gdpcapx==1, cluster(ccode)
*Milex with controls and fixed effects
logit gdpcaprec l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq 	gdpcapdurct* ibn.ccode if gdpcapx==1, cluster(ccode)

**********PREDATION MODELS (Table 4)
use Retrench1yr, clear
*Fatal MIDs 
logit midfatdummy l_gdpcapx l_logmilperc, cluster(ccode)
*Fatal MIDs with controls
logit midfatdummy l_gdpcapx l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq fatpeaceyr*, cluster(ccode)
*Fatal MIDs with controls and fixed effects
logit midfatdummy l_gdpcapx l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq fatpeaceyr* ibn.ccode, cluster(ccode)
*Predicted probability plot
margins, at(l_logmilperc=(-30(1)30))
marginsplot, xtitle(Percent Change in Logged Military Expenditures (t-1)) xlab(-30(5)30) ///
ytitle(Probability of Fatal MID Onset) ylab(, nogrid) yline(0, lcol(black)) ///
title("") graphregion(margin(zero) fcolor(white)) ///
plotopts(lcolor(black) lwidth(medthick) lpattern(solid) mcolor(black) msymbol(point)) recastci(rarea)

**********APPENDIX MODELS
use Retrench5yr, clear
*Fatal MIDs 
logit midfatdummy l_gdpcapx l_logmilperc, cluster(ccode)
*Fatal MIDs with controls
logit midfatdummy l_gdpcapx l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq fatpeaceyr*, cluster(ccode)
*Fatal MIDs with controls and fixed effects
logit midfatdummy l_gdpcapx l_logmilperc l_loggdpcap l_gdpper l_s_lead nukposs polity2 polity2sq fatpeaceyr* ibn.ccode, cluster(ccode)

log close
