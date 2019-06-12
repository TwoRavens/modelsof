** Author: 	abouchat@hu-berlin.de
**			orlowsma@hu-berlin.de
** Project: Moderate as necessary - The role of electoral competitiveness in 
** 			explaining parties' policy shifts 
** Content: Generate derived variables and replicate all analyses reported in the
**			paper. 			
** Notes:	You need to install cgmreg to run this do file. The ado is available
** 			at http://gelbach.law.upenn.edu/~gelbach/ado/cgmreg.ado

version 13
set more off

insheet using  "comp_ppos.csv", clear

cap drop time
bys country date: gen time=1 if _n==1
bys country: replace time=sum(time)

xtset party time


********************************************************************************
************************** Generate Variables **********************************
********************************************************************************


***** Moderation *****
gen abslog=abs(logrile)
gen logmod=l.abslog-abslog
label var logmod "Moderation"

* rile
gen absrile = abs(rile)
gen mod = l.absrile-absrile
label var mod "Moderation (rile)"

* Country demeaned
bys country: egen logrilemean=mean(logrile)
sort party time
gen logdemean=logrile-logrilemean
gen absdemean=abs(logdemean)
gen moddemean=l.absdemean-absdemean
label var moddemean "Moderation (De-Meaned)"

* Significant changes
gen pos_change = 0 if logrile > l.logrile -  1.96*l.logrilese &  logrile < l.logrile + 1.96*l.logrilese & logrile != .
replace pos_change = 1 if pos_change != 0 & logrile != . & l.logrile != .
tab pos_change


***** Competition *****
gen competition=pty_comp
gen dcompetition=d.competition
gen lcompetition=l.competition
label var dcompetition "$\Delta$ Competition"


***** Party size *****
gen voteshare = pervote/100	
gen lvote = l.voteshare
gen l2vote = l2.voteshare
gen l3vote = l3.voteshare
egen votesize=rowmean(lvote l2vote l3vote)
label var votesize "Party Size"

* Overall average
bys party: egen pty_size=mean(voteshare)
label var pty_size "Party Size (Mean)"

* Large party
cap drop maxsize minsize
bys party: egen maxsize=max(voteshare)
bys party: egen minsize=min(voteshare)
gen largep = .
replace largep = 1 if minsize >= 0.2  & minsize!=.
replace largep = 0 if maxsize < 0.2
label var largep "Large Party"


***** Party type *****
cap drop niche
gen niche=.
replace niche=0 if parfam == 30 | parfam==40 | parfam==50 | parfam==60 | parfam==80
replace niche=1 if parfam != 30 & parfam!=40 & parfam!=50 & parfam!=60 & parfam!=80 & parfam != .
label var niche "Niche Party"

***** Vote change *****
cap drop votediff
gen votediff = d2.voteshare
label var votediff "Vote Change"


***** Extremism *****
gen labslog = l.abslog
label var labslog "Extremism"

gen labsrile = l.absrile
label var labsrile "Extremism (rile)"

gen labsdemean=l.absdemean
label var labsdemean "Extremism (De-Meaned)"


***** Avg. extremism *****
gen l2abslog = l2.abslog
gen l3abslog = l3.abslog
egen extreme = rowmean(labslog l2abslog l3abslog) 
label var extreme "Avg. Extremism"


***** Electoral system *****
gen pr = .
replace pr = 0 if country == 51 | country == 61 | country == 62
replace pr = 1 if country != 51 & country != 61 & country != 62
label var pr "PR"

* District magnitude
gen magnitude=tier1_avemag

* Use lower tier magnitude for Germany
gen eyear = floor(date/100)
replace magnitude=45 if country==41 & eyear < 1990
replace magnitude=41 if country==41 & eyear >= 1990 & eyear < 2000
replace magnitude=38 if country==41 & eyear > 2000
gen lnmag=ln(magnitude)
label var lnmag "Avg. District Magnitude (ln)"

***** Government Party *****
label var pty_cab "Government Party"

***** Party Organization *****
label var leadact "Party Organization"


********************************************************************************
******************************* Analysis ***************************************
********************************************************************************

** Table 1
cgmreg logmod dcompetition votesize pr votediff pty_cab labslog ///
	, cluster (party date)

cgmreg logmod c.dcompetition##c.votesize pr votediff pty_cab labslog ///
	, cluster (party date)
margins, dydx(dcompetition) at(votesize=(.05 0.35))
margins, dydx(dcompetition) at(votesize=(0 (0.05) 0.6))
marginsplot, scheme(s1mono) title("") ytitle(Marginal Effect) xtitle(Party Size) yline(0) leg(reg(lp(blank))) recast(line) recastci(rarea) 


** Table 2
cgmreg moddemean c.dcompetition##c.votesize pr votediff pty_cab labsdemean ///
	, cluster (party date)

cgmreg logmod c.dcompetition##c.votesize pr votediff pty_cab labslog if pos_change == 1 ///
	, cluster (party date)
margins, dydx(dcompetition) at(votesize=(.05 0.35))
margins, dydx(dcompetition) at(votesize=(0 (0.05) 0.6))
marginsplot, scheme(s1mono) title("") ytitle(Marginal Effect) xtitle(Party Size) yline(0) leg(reg(lp(blank))) recast(line) recastci(rarea) 

cgmreg logmod c.dcompetition##c.largep pr votediff pty_cab labslog ///
	, cluster (party date)
margins, dydx(dcompetition) at(largep=(0 1))


** Table A1
quiet: reg logmod labslog dcompetition pr votesize votediff pty_cab
sum logmod labslog dcompetition pr votesize votediff pty_cab largep niche leadact ///
	extreme if e(sample)
	
	
** Table A3
cgmreg logmod c.dcompetition##c.votesize niche leadact pr votediff pty_cab labslog if pos_change == 1 ///
	, cluster (party date)
margins, dydx(dcompetition) at(votesize=(0 (0.05) 0.6))
marginsplot, scheme(s1mono) title("") ytitle(Marginal Effect) xtitle(Party Size) yline(0) leg(reg(lp(blank))) recast(line) recastci(rarea) 

cgmreg logmod c.dcompetition##i.niche votesize leadact pr votediff pty_cab labslog if pos_change == 1  ///
	, cluster (party date)
margins, dydx(dcompetition) at(niche=(0 1))

cgmreg logmod c.dcompetition##c.extreme votesize leadact pr votediff pty_cab if pos_change == 1 ///
	, cluster (party date)
margins, dydx(dcompetition) at(extreme=(0 (0.1) 4))
marginsplot, scheme(s1mono) title("") ytitle(Marginal Effect) xtitle(Avg. Extremism) yline(0) leg(reg(lp(blank))) recast(line) recastci(rarea) 


*** Additional tests
** Leave one country out (FN1)
foreach c in 11 12 13 14 22 33 41 42 43 51 62 {
 
	cgmreg logmod c.dcompetition##c.votesize pr votediff pty_cab labslog ///
		if country != `c' , cluster (party date) 
 
}

** Country fixed effects (FN1)
cgmreg logmod c.dcompetition##c.votesize pr votediff pty_cab labslog i.country ///
	, cluster (party date)
	
** Standard rile (FN3)
cgmreg mod c.dcompetition##c.votesize pr votediff pty_cab labsrile ///
	, cluster (party date)

** Leaving out retrospective question cases (FN4): AUT 1995, CAN 1980, DEN 1981, 
** DEN 1988, DEU 1969, NLD 1981, NLD 2003
gen compyear = substr(lhelc_date, 1, 4)
destring compyear, replace

gen retro = 0
replace retro = 1 if (ctr_ccode == "AUT" & compyear == 1995) ///
					| (ctr_ccode == "CAN" & compyear == 1980) ///
					| (ctr_ccode == "DEN" & (compyear == 1981 | compyear == 1988)) ///
					| (ctr_ccode == "DEU" & compyear == 1969) ///
					| (ctr_ccode == "NLD" & (compyear == 1981 | compyear == 2003))

cgmreg logmod c.dcompetition##c.votesize pr votediff pty_cab labslog if retro == 0 ///
	, cluster (party date)
	
** Alternative vote size (average over entire period) (FN5)
cgmreg logmod dcompetition pty_size pr votediff pty_cab labslog ///
	, cluster (party date)
	
cgmreg logmod c.dcompetition##c.pty_size pr votediff pty_cab labslog ///
	, cluster (party date)
	
** District magnitude (FN6)
cgmreg logmod c.dcompetition c.votesize lnmag votediff pty_cab labslog ///
	, cluster (party date)
cgmreg logmod c.dcompetition##c.votesize lnmag votediff pty_cab labslog ///
	, cluster (party date)

** Different cut-offs for largep (FN8)
foreach c in .17 .18 .19 .2 .21 .22 .23 {
	disp `c'
	cap drop lpalt
	gen lpalt = .
	replace lpalt = 1 if minsize >= `c'  & minsize!=.
	replace lpalt = 0 if maxsize < `c'
	quiet: cgmreg logmod c.dcompetition##i.lpalt pr votediff pty_cab labslog ///
		, cluster (party date) 
	margins, dydx(dcompetition) at(lpalt=(0 1))
}

** Not controlling for party organization in size + type models (FN10)
cgmreg logmod c.dcompetition##c.votesize niche pr votediff pty_cab labslog if pos_change == 1 ///
	, cluster (party date)
cgmreg logmod c.dcompetition##i.niche votesize pr votediff pty_cab labslog if pos_change == 1 ///
	, cluster (party date)
cgmreg logmod c.dcompetition##c.extreme votesize pr votediff pty_cab if pos_change == 1 ///
	, cluster (party date)


********************************************************************************
********** Export results for plotting marginal effects using R ****************
********************************************************************************

gen compsize = dcompetition*votesize
quietly: cgmreg logmod dcompetition votesize compsize pr votediff pty_cab labslog ///
	, cluster (party date)

matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_size v_compsize v_pr v_vdiff v_cab v_lrile v_intercept
svmat results, names(col)

export delimited v_* using "m2_vcov.csv", replace
drop v_*

quietly: reg  logmod dcompetition votesize compsize pr votediff pty_cab labslog 
export delimited votesize using "m2_vrange.csv" if e(sample), replace


quiet: cgmreg moddemean dcompetition votesize compsize pr votediff pty_cab labsdemean  ///
	, cluster (party date)

matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_size v_compsize v_pr v_vdiff v_cab v_lrile v_intercept
svmat results, names(col)

export delimited v_* using "mr1_vcov.csv", replace
drop v_*

quiet: reg moddemean dcompetition votesize compsize pr votediff pty_cab labsdemean
export delimited votesize using "mr1_vrange.csv" if e(sample), replace


quiet: cgmreg logmod dcompetition votesize compsize pr votediff pty_cab labslog if pos_change!=0 ///
	, cluster (party date)
	
matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_size v_compsize v_pr v_vdiff v_cab v_lrile v_intercept
svmat results, names(col)

export delimited v_* using "mr2_vcov.csv", replace
drop v_*

quiet: reg logmod dcompetition compsize votesize pr votediff pty_cab labslog if pos_change!=0
export delimited votesize using "mr2_vrange.csv" if e(sample), replace


gen complargep = dcompetition*largep
quiet: cgmreg logmod dcompetition largep complargep pr votediff pty_cab labslog ///
	, cluster (party date)
	
matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_largep v_complargep v_pr v_vdiff v_cab v_lrile v_intercept
svmat results, names(col)

export delimited v_* using "mr3_vcov.csv", replace
drop v_*

quiet: cgmreg logmod dcompetition votesize compsize niche leadact pr votediff pty_cab labslog  if pos_change == 1 ///
	, cluster (party date)

matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_size v_compsze v_niche v_leadact v_pr v_vdiff v_cab v_lrile v_intercept
svmat results, names(col)

export delimited v_* using "m_activ1_vcov.csv", replace
drop v_*

quietly: reg logmod dcompetition votesize compsize niche leadact pr votediff pty_cab labslog  if pos_change == 1
export delimited votesize using "m_activ1_vrange.csv" if e(sample), replace

gen compniche = dcompetition*niche
quiet: cgmreg logmod dcompetition niche compniche votesize leadact pr votediff pty_cab labslog if pos_change == 1 ///
	, cluster (party date)
	
matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_niche v_compnche v_size v_leadact v_pr v_vdiff v_cab v_lrile v_intercept
svmat results, names(col)

export delimited v_* using "m_activ2_vcov.csv", replace
drop v_*

gen compext = dcompetition * extreme
quiet: cgmreg logmod dcompetition extreme compext leadact pr votesize votediff pty_cab if pos_change == 1 ///
	, cluster (party date)

matrix define vcov= e(V)
matrix list vcov
matrix define coeff=e(b)
matrix results = coeff\vcov
matrix colnames results = v_dcomp v_extr v_compextr v_leadact v_pr v_size v_vdiff v_cab v_intercept
svmat results, names(col)

export delimited v_* using "m_activ3_vcov.csv", replace
drop v_*

quietly: reg logmod dcompetition extreme compext leadact pr votesize votediff pty_cab  if pos_change == 1
export delimited extreme using "m_activ3_erange.csv" if e(sample), replace
