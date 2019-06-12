log using "C:\Documents and Settings\patrick\My Documents\Midwest_09\TNC_GC\ISQ\final\b_m_isq2010_rep.scml", replace 

/** Replication do-file for Patrick Bernhagen and Neil J. Mitchell, "The Private Provision of Public Goods:
  Corporate Commitments and the United Nations Global Compact." International Studies Quarterly 54, 4, pp. 1175–1187 (December 2010) **/

set memory 200m
set matsize 800
set more off
use "C:\Documents and Settings\patrick\My Documents\Midwest_09\TNC_GC\ISQ\final\b_m_isq2010_rep.dta" 



/* Get tables for Figure 1 (for graph to be created in Excel) */

tab country goodgc
tab country goodgc, row nofreq


/* Estimate models for Table 1; robust to (country) spatial autocorrelation and heteroskedasticity; 
 all GC firms first; then reporting firms only */

logit globalco logsales profits extracti unvendor greenavg un_phil merger fdigdp partdem autocrac, cluster(country)
logit goodgc logsales profits extracti unvendor greenavg un_phil merger fdigdp partdem autocrac, cluster(country)

* robustness checks using industry fixed effects (not printed in article)
xi: logit globalco logsales profits unvendor greenavg un_phil merger fdigdp partdem autocrac i.industry, cluster(country)
xi: logit goodgc logsales profits unvendor greenavg un_phil merger fdigdp partdem autocrac i.industry, cluster(country)


/* Estimate models for Table 2;  robust to (country) spatial autocorrelation and heteroskedasticity */

logit hr_state logsales profits extracti unvendor greenavg un_phil merger fdigdp partdem autocrac, cluster(country)
logit hr_state goodgc logsales profits extracti unvendor greenavg un_phil merger fdigdp partdem autocrac, cluster(country)
mfx, nodiscrete

* robustness checks using industry fixed effects (not printed in article)
xi: logit hr_state logsales profits unvendor greenavg un_phil merger fdigdp partdem autocrac i.industry, cluster(country)
xi: logit hr_state goodgc logsales profits unvendor greenavg un_phil merger fdigdp partdem autocrac i.industry, cluster(country)


/* Estimate models for Table 3; robust to (country) spatial autocorrelation and heteroskedasticity */

logit g100_09 logsales profits extracti unvendor greenavg un_phil merger fdigdp partdem autocrac, cluster(country)
logit g100_09 goodgc logsales profits extracti unvendor greenavg un_phil merger fdigdp partdem autocrac, cluster(country)
mfx

* robustness checks using industry fixed effects (not printed in article)
xi: logit g100_09 logsales profits unvendor greenavg un_phil merger fdigdp partdem autocrac i.industry, cluster(country)
xi: logit g100_09 goodgc logsales profits unvendor greenavg un_phil merger fdigdp partdem autocrac i.industry, cluster(country)

