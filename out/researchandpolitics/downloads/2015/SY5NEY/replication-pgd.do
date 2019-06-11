use pgd-vote-replication, replace 


* Generate Table 1
tab secondvote firstvote

* Estimate model
* Recode absentees and abstainers to missing
recode secondvote (10/12 =.)

* Analyse second vote & store estimates
logit secondvote  i.party b4.religion sqrtchrismemberships  sqrtdisabmsh i.medback i.female
est store logit 

* Generate Table 2. Requires estout/esttab package from SSC
estadd scalar R2=e(r2_p)
eststo b
margins , dydx(*) post
eststo AME
esttab b AME using logittable  , mtitles label nobaselevels starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) nonum se  tex replace eqlabels(none) scalar(R2)


* Generate Figure 1. Requires Tufte scheme
est restore logit
set scheme tufte

* MCP: Denomination + Memberships
* Requires mcp package from SSC
* generate plot var + transform
range c1 0 3 4
gen sqc1 = sqrt(c1)
mcp chrismembersh (sqrtchrismemb) religion, var1(c1 (sqc1)) at2(1 2 4) plotopts(xtitle(# Christian affiliations) legend(rows(1)) yline(.5) ytitle("Predicted Probability")  legend(note("Denomination:",position(11)) label(1 "Catholic") label(2 "Protestant") label(3 "Not stated")))

graph export margins.eps , replace

scons_returncode "`1'"
