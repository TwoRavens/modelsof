clear *
args tlog flog tloga floga

set seed 12345678 // replicably randomly-select coders

// analyses conducted 10 times to average across random choices of coders for 'truth'
forval i=1/10 {
	use dataSets/codelevel_work1
	calcmeta , saving(auxds/metaMSEc_`i', replace) stub(cm`i') 
}	

// combine 10 replications 
use auxds/metaMSEc_1
forval i=2/10 {
	merge 1:1 Var metasize using auxds/metaMSEc_`i'
	assert _merge==3
	drop _merge
}

// collapse replicates
reshape long e2_cm rmse_cm pct_cm, i(Var metasize) j(replication)
collapse e2* rmse* pct* (semean) se_rmse_cm = rmse_cm , by(Var metasize)
by Var (metasize), sort: gen PCT_cm  = rmse_cm/rmse_cm[1]

do auxSyntax/vllabel.do
save auxds/metaGainSummary, replace

merge m:1 Var using rawData/TableSortOrder, keep(match master)
drop _merge
levelsof sort, local(levs)
foreach ll of local levs {
	di `"--> sum Var if sort==`ll', meanonly"'
	sum Var if sort==`ll'
	di `"la de sort `ll' `"`: label vllabel `r(mean)''"', add"'
	la de sort `ll' `"`: label vllabel `r(mean)''"', add
}
la val sort sort

************************
* CREATE FIGURE
************************
#delimit ;
graph twoway connected rmse_cm metasize, 
	xlab(1/8) 
	by(sort, 
		iyax 
		yrescale 
		l1title(RMSE)
		b1title("Meta-coder size (Number of averaged coders)")
		note("Results averaged across ten replications in which RMSE was calculated for meta-coder made up of 1 through 8" 
		"randomly-selected individual coders.  Error calculated relative to ‘truth’ that is calculated from the other coders."
		"Analysis on subset of 221 ads for which we have 18 or more mTurk coders"
		, span size(vsmall))
	)
	ylab(#3) 
	msize(vsmall)
	ysca(ra(0))
	name(metaGain, replace)
	;
#delimit cr
`cmd'

local pdffn  metaGain.pdf
nwgexport latexOutput/plots/`pdffn', replace
local thecap Decreasing \textsc{rmse} as a function of meta-coder size
latexfigure plots/`pdffn' , log(`floga') append precaption caption(`thecap')

********************
// Summary table
********************
collapse pct_cm, by(metasize)
gen delta =  pct_cm[_n-1]-pct_cm
la var pct_cm "Average \textsc{rmse} relative to single coder"
la var delta "Incremental reduction"
format delta pct_cm %4.3f
la var metasize "Size of meta-coder"

local caption 		Gains to aggregation for meta-coders made up of between 2 and 8 individuals
local kappalist 	metasize pct_cm delta
local width 		2.5in
local notes			\item Table depicts \textsc{rmse} for meta-coders, relative to a single coder.

dumptotex "\clearpage " using "`tloga'", append 

local lastcol = `: word count `kappalist''
local topmatter `"\begin{table}[ht]\begin{center}\begin{threeparttable} \caption{`caption'} \begin{tabularx}{`width'}{ p{0.6in} YYYYYYYYY  } \toprule"'
listtab_vars `kappalist', rstyle(tabular) substitute(varlab) local(titleline)
local headline `"`topmatter' `titleline' \cmidrule(lr){2-`lastcol'}"'
local footline `"\bottomrule\end{tabularx}\begin{tablenotes}`notes'\end{tablenotes}\end{threeparttable}\end{center}\end{table} \clearpage"'

listtab `kappalist' , type rstyle(tabular)  head(`"`headline'"') foot(`"`footline'"') appendto(`tloga')
