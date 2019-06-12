// Ansell 2008 IO

// Load original dataset
clear
use "A2008 IO Rep Data.dta"

//REPLICATION
summarize
display c(k)
mdesc
tabmiss
codebook ccode
codebook year
gen eloggdpcap = exp(loggdpcap)
summarize

// Table 1
//Model A
xtpcse pubed lagpubed polity2 logopen pop14 loggdp loggdpsq logpop govex2 regdum1-regdum10 comm year if pop>1000000, pairwise correlation(ar1)
codebook year if e(sample)
codebook ccode if e(sample)
mdesc pubed lagpubed polity2 logopen pop14 loggdp loggdpsq logpop govex2 regdum1-regdum10 comm year

//Model B
xtreg pubed lagpubed polity2 logopen pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe
codebook year if e(sample)
codebook ccode if e(sample)
mdesc pubed lagpubed polity2 logopen pop14 loggdp loggdpsq logpop govex2 year

//Model C
xtivreg pubed lagpubed (polity2 logopen = l5pol l5open) pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe
codebook year if e(sample)
codebook ccode if e(sample)
mdesc pubed lagpubed polity2 logopen l5pol l5open pop14 loggdp loggdpsq logpop govex2 year

//Model D
xtivreg pubed lagpubed (polity2 = regpol) logopen pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe
codebook year if e(sample)
codebook ccode if e(sample)
mdesc pubed lagpubed polity2 regpol logopen pop14 loggdp loggdpsq logpop govex2 year

//Model E
xtpcse pubed lagpubed polity2 pctACFE pop14 loggdp loggdpsq logpop govex2 regdum1-regdum10 comm year if pop>1000000, pairwise correlation(ar1)
codebook year if e(sample)
codebook ccode if e(sample)
mdesc pubed lagpubed polity2 pctACFE pop14 loggdp loggdpsq logpop govex2 regdum1-regdum10 comm year

//Model F
xtreg pubed lagpubed polity2 pctACFE pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe
codebook year if e(sample)
codebook ccode if e(sample)
mdesc pubed lagpubed polity2 pctACFE pop14 loggdp loggdpsq logpop govex2 year

// Note: Models G and H excluded due to absence of data

// IMPUTATION
clear
use "A2008 IO Imp Data.dta"
summarize

mi import flong, m(imp) id(ccode year) imp(oecd-lprived2)

encode ccode, generate (cnum)
mi xtset cnum year

// Table One
//Model A
mi estimate, cmdok esampvaryok post: xtpcse pubed lagpubed polity2 logopen pop14 loggdp loggdpsq logpop govex2 regdum1-regdum10 commexcomm year if pop>1000000, pairwise correlation(ar1)

//Model B
mi estimate, esampvaryok post: xtreg pubed lagpubed polity2 logopen pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe

//Model C
mi estimate, cmdok esampvaryok post: xtivreg pubed lagpubed (polity2 logopen = l5pol2 l5open) pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe

//Model D
mi estimate, cmdok esampvaryok post: xtivreg pubed lagpubed (polity2 = regpol) logopen pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe

//Model E
mi estimate, cmdok esampvaryok post: xtpcse pubed lagpubed polity2 pctACFE pop14 loggdp loggdpsq logpop govex2 regdum1-regdum10 comm year if pop>1000000, pairwise correlation(ar1)

//Model F
mi estimate, esampvaryok post: xtreg pubed lagpubed polity2 pctACFE pop14 loggdp loggdpsq logpop govex2 year if pop>1000000, fe

