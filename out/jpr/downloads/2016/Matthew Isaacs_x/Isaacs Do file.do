/*Sacred violence or strategic faith? Disentanglging the Relationship Between Religion and Violence in Armed Conflict

Matthew Isaacs, Department of Politics, Brandeis University
mdisaacs@brandeis.edu

Replication of figures and tables

Note: This do file uses the BTSCS method developed by Beck, Katz & Tucker (1998). 
The .ado file for this command is available here: https://www.prio.org/Global/upload/CSCW/Data/btscs.zip
*/

*Figure 1
sort year
graph twoway (line pviolence_percentage year, ylabel(0(10)40) ytitle("Percent of organizations") legend(order(1 "{it:Participation in violence}" 2 "{it:Religious rhetoric}")) lcolor(gs0) scheme(s2mono)) (line rrhetoric_percentage year, lcolor(gs0) lpattern(shortdash))
graph export figure1.eps

*Table 1
sort org year
tab rrhetoric_dummy pviolence_dummy if orgdup<2, row chi2

*Table 2
btscs pviolence year org, g(yrs_pviolence) nspline(3)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro regime yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_pviolence

*Table 3
btscs intviolence year org, g(yrs_intviolence) nspline(3)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro regime yrs_intviolence _spline1 _spline2 _spline3 if pviolence ==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_intviolence _spline1 _spline2 _spline3 if pviolence ==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrs_intviolence _spline1 _spline2 _spline3 if pviolence ==1, cluster(org)
drop _spline1 _spline2 _spline3 yrs_intviolence

*Table 4
btscs rrhetoric year org, g(yrs_rrhetoric) nspline(3)
logit rrhetoric pviolence_lag5 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, cluster(org)
logit rrhetoric intviolence_lag5 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit rrhetoric durationofconflict lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_rrhetoric

*Figure 2
graph twoway (line rrhetoric_predict pviolence_predict, xtitle("{it:Participation in violence} {it:{subscript:t-5}}") xlabel(0(.1)1) ytitle("Predicted probability of {it:religious rhetoric}") legend(off) ylabel(0(.1).4)) (line rrhetoric_predict_min pviolence_predict, lpattern(dash)) (line rrhetoric_predict_max pviolence_predict, lpattern(dash) scheme(s2mono))
graph export figure2.eps



*Robustness checks and alternative analyses (see Online appendix):

**Table A1
sum rrhetoric pviolence intviolence durationofconflict

**Table A2
sum regime groupstatus legality lngdppc lnpop gpro democratization fh ethnichomeland frag gir age cumulativeintensity sviolence viol_state islam

*Figure A1:
sort year
graph twoway (line rrhetoric_percentage year, ylabel(0(10)60) ytitle("Percent of organizations") legend(order(1 "Religious rhetoric" 2 "Religious ideology" 3 "Religious membership")) scheme(s2mono)) (line rideology_percentage year) (line rmembership_percentage year)

**Table B1:
reg pviolence rrhetoric_lag5 lngdppc lnpop gpro pviolence_lag1 i.year i.org, cluster(org)
reg pviolence rrhetoric_lag5 lngdppc lnpop gpro regime pviolence_lag1 i.year i.org, cluster(org)
reg pviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus pviolence_lag1 i.year i.org, cluster(org)
reg pviolence rrhetoric_lag5 lngdppc lnpop gpro legality pviolence_lag1 i.year i.org, cluster(org)

**Table B2:
btscs pviolence year org, g(yrs_pviolence) nspline(3)
xtgee pviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_pviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee pviolence rrhetoric_lag5 lngdppc lnpop gpro regime yrs_pviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee pviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_pviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee pviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrs_pviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
drop _spline1 _spline2 _spline3 yrs_pviolence

**Table B3:
btscs viol_state year org, g(yrs_pviolence) nspline(3)
logit viol_state rrhetoric_lag5 lngdppc lnpop gpro yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit viol_state rrhetoric_lag5 lngdppc lnpop gpro regime yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit viol_state rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit viol_state rrhetoric_lag5 lngdppc lnpop gpro legality yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_pviolence

**Table B4:
btscs sviolence year org, g(yrs_sviolence) nspline(3)
logit sviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_sviolence _spline1 _spline2 _spline3, cluster(org)
logit sviolence rrhetoric_lag5 lngdppc lnpop gpro regime yrs_sviolence _spline1 _spline2 _spline3, cluster(org)
logit sviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_sviolence _spline1 _spline2 _spline3, cluster(org) 
logit sviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrssup yrs_sviolence _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_sviolence

**Table B5:
btscs pviolence year org, g(yrs_pviolence) nspline(3)
logit pviolence rrhetoric_lag1 lngdppc lnpop gpro yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag1 lngdppc lnpop gpro regime yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag1 lngdppc lnpop gpro groupstatus yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag1 lngdppc lnpop gpro legality yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_pviolence

**Table B6:
btscs pviolence year org, g(yrs_pviolence) nspline(3)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_pviolence _spline1 _spline2 _spline3 if islam==1, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro regime yrs_pviolence _spline1 _spline2 _spline3 if islam==1, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_pviolence _spline1 _spline2 _spline3 if islam==1, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrs_pviolence _spline1 _spline2 _spline3 if islam==1, cluster(org) iter(50)
drop _spline1 _spline2 _spline3 yrs_pviolence

**Table B7:
btscs pviolence year org, g(yrs_pviolence) nspline(3)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro fh yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro democratization yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro ethnichomeland yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro gir yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
logit pviolence rrhetoric_lag5 lngdppc lnpop gpro frag yrs_pviolence _spline1 _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_pviolence

**Table B8:
reg intensityviolence intviolence_lag1 rrhetoric_lag5 lngdppc lnpop gpro i.year i.org, cluster(org)
reg intensityviolence intviolence_lag1 rrhetoric_lag5 lngdppc lnpop gpro regime i.year i.org, cluster(org)
reg intensityviolence intviolence_lag1 rrhetoric_lag5 lngdppc lnpop gpro groupstatus i.year i.org, cluster(org)
reg intensityviolence intviolence_lag1 rrhetoric_lag5 lngdppc lnpop gpro legality i.year i.org, cluster(org)

*Table B9:
btscs intviolence year org, g(yrs_intviolence) nspline(3)
xtgee intviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_intviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee intviolence rrhetoric_lag5 lngdppc lnpop gpro regime yrs_intviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee intviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_intviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee intviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrs_intviolence _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
drop _spline1 _spline2 _spline3 yrs_intviolence

*Table B10:
btscs intviolence year org, g(yrs_intviolence) nspline(3)
logit intviolence rrhetoric_lag1 lngdppc lnpop gpro yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag1 lngdppc lnpop gpro regime yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag1 lngdppc lnpop gpro groupstatus yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag1 lngdppc lnpop gpro legality yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
drop _spline1 _spline2 _spline3 yrs_intviolence

**Table B11:
btscs intviolence year org, g(yrs_intviolence) nspline(3)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1 & islam==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop regime yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1 & islam==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro groupstatus yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1 & islam==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro legality yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1 & islam==1, cluster(org)
drop _spline1 _spline2 _spline3 yrs_intviolence

**Table B12:
btscs intviolence year org, g(yrs_intviolence) nspline(3)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro fh yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro democratization yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro ethnichomeland yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro gir yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
logit intviolence rrhetoric_lag5 lngdppc lnpop gpro frag yrs_intviolence _spline1 _spline2 _spline3 if pviolence==1, cluster(org)
drop _spline1 _spline2 _spline3 yrs_intviolence

**Table B13:
reg rrhetoric pviolence_lag5 lngdppc lnpop gpro religiousrhetoric_lag1 i.year i.org, cluster(org)
reg rrhetoric intviolence_lag5 lngdppc lnpop gpro religiousrhetoric_lag1 i.year i.org if pviolence ==1, cluster(org)
reg rrhetoric durationofconflict lngdppc lnpop gpro religiousrhetoric_lag1 i.year i.org, cluster(org)

**Table B14:
btscs rrhetoric year org, g(yrs_rrhetoric) nspline(3)
xtgee rrhetoric pviolence_lag5 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust
xtgee rrhetoric intviolence_lag5 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3 if pviolence ==1, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
xtgee rrhetoric durationofconflict lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, family(bin) link(logit) i(org) t(year) corr(ar1) robust force
drop _spline1 _spline2 _spline3 yrs_rrhetoric

**Table B15:
btscs rrhetoric year org, g(yrs_rrhetoric) nspline(3)
logit rrhetoric pviolence_lag5 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3 if islam==1, cluster(org)
logit rrhetoric intviolence_lag5 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3 if pviolence ==1 & islam==1, cluster(org)
logit rrhetoric durationofconflict lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3 if islam==1, cluster(org)
drop _spline1 _spline2 _spline3 yrs_rrhetoric

**Table B16:
btscs rrhetoric year org, g(yrs_rrhetoric) nspline(3)
logit rrhetoric pviolence_lag1 lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, cluster(org)
logit rrhetoric cumulativeintensity lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, cluster(org)
logit rrhetoric age lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, cluster(org)
logit rrhetoric frag lngdppc lnpop gpro yrs_rrhetoric _spline1 _spline2 _spline3, cluster(org)
drop _spline1 _spline2 _spline3 yrs_rrhetoric

