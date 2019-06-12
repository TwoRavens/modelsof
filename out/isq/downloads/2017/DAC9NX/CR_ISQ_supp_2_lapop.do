cd "c:\users\\`c(username)'\dropbox\TingleyCostaRica\ISQ\data\supplement"
use lapop.dta, clear

estimates clear
local control "ed  male age "
local pty "pac_06vote pln_06vote  libertarian_06vote"
local i=1
probit cafta_vote ftzdum  , robust
est store model`i'
local i=`i'+1
probit cafta_vote ftzdum ManufExports  , robust
est store model`i'
local i=`i'+1
probit cafta_vote ftzdum ManufExports `pty', robust
est store model`i'
local i=`i'+1
probit cafta_vote ftzdum ManufExports `pty' middle_income upper_income `control', robust
est store model`i'
local i=`i'+1
local order "order(pln_06vote  pac_06vote libertarian_06vote)"
esttab model* using "table8", `order' title("LAPOP survey on CAFTA vote") addnotes("Probit regression with robust standard errors. All variables at individual level except FTZ and Manuf%.") starlevels(+ 0.10 * 0.05 ** 0.01)  se(%8.2f)   nom nonum nodep nogaps  b(%8.2f)  label brackets  compress replace

*** % IN FTZ VOTING FOR CAFTA
ttest cafta_vote, by(ftzdum)


*** TIMING OF DECISION OVER CAFTA
recode cosvr5 (1/4=1) (5/6=0), gen(recent)
prtest recent, by(cafta_vote)
