clear *
args tlog flog tloga floga

// -------------------------
// Time spent on coding
// -------------------------
use dataSets/validity_dataset_full.dta
keep if inrange(codingType,1,4)     // only individual mTurk hits
keep if wmp_l == 30                 // only 30-second ads for this analysis
drop if time<wmp_l

do auxSyntax/Label_coderSeqGroup.do
la val coderSeqGroup coderSeqGroup

// coder characteristics
local ivs1  i.coderEd2 c.coderKnow##c.coderKnow coderFemale coderStudent ib2.coderPid3 i.coderAgeGroup i.coderIncome coderBlack coderAsian coderLatinx i.coderPastcoding i.coderNAdsGroup i.coderSeqGroup 
mktab (time = `ivs1'), log(`tloga', append)  ///
	longtable noi ///
	stuff latex xlab ylab novarnames cluster(workerId) ///
	title("Impact of coder characteristics on coding time") ///
	note("Run among mTurk worker coding of 30-second ads. Robust standard errors, clustered by worker.")

//ad characteristics
la var SadLevel "Race type"
la var wmp_sponsor "Ad sponsor"
la var wmp_per_ply "Ad focus"
la var wmp_ad_tone "Ad tone"

local ivs2  i.SadLevel i.wmp_sponsor i.wmp_ad_tone ib2.wmp_per_ply 
mktab (time = `ivs2'), ///
	log(`tloga', append)  ///
	noi ///
	stuff latex xlab ylab cluster(workerId) ///
	title("Impact of ad characteristics on coding time") ///
	note("Run among mTurk worker coding of 30-second ads. Robust standard errors, clustered by worker.")


// ===========================
// 10. coding time --> quality
// ===========================
// 10.a reliability
// ----------------
use dataSets/codelevel_work1.dta, clear
keep if inrange(codingType,1,4)
keep if wmp_l==30
keep if time>=wmp_l

do auxSyntax/Label_timeGnoQt
la val timeGroup timeGnoQt

mktab (mIt1_AbsError = i.VarGrp##i.timeGroup) if vToUse	,  ///
	cluster(workerId) latex log("`tloga'", append) stuff xlab ylab novarname longtable ///
	note("Regression at the coding-decision level, clustered by worker.") ///
	title("Impact of time spent coding on reliability") ///
	noiflabel

la val timeGroup timeG2
margins VarGrp#timeGroup
marginsplot, by(VarGrp) ylab(0 .25 .5)         ///
	xtitle("Time spent coding") ytitle("")     ///
	ylabel(0(.25).5) ysca(ra(.6))              ///
	byopt(                                     ///
		title("Average absolute “error” size") ///
		rows(2)                                ///
	)

nwgexport latexOutput/plots/timeCoding_reliability.pdf, replace
latexfigure plots/timeCoding_reliability.pdf, log("`floga'") append nofloat  ///
	caption("Impact of time spent coding on reliability") precaption postbreak prebreak

// 10.b validity
// -------------
use dataSets/validity_dataset_full, clear
keep if inrange(codingType,1,4)     // only individual mTurk hits
keep if wmp_l == 30                 // only 30-second ads for this analysis
drop if time<wmp_l

do auxSyntax/Label_timeGnoQt
la val timeGroup timeGnoQt

mktab  (ideologyFc = c.bonica_dwnominate##(i.timeGroup)), base cluster(workerId)  ///
	latex log(`tloga', append) stuff xlab ylab novarname longtable ///
	title("Impact of time spent coding on validity") ///
	noiflabel

la val timeGroup timeG2
margins timeGroup, dydx(bonica_dwnominate)
marginsplot, recast(scatter) horizontal yscal(reverse) xtitle("") ///
	plotregion(margin(b 10 t 10)) ///
	xlab(.0(.1).4, format(%02.1f)) ///
	ytitle("") ///
	note("Marginal effect of DW-NOMINATE on favored candidate ideology coding.") ///
	title("Validity estimation for favored candidate ideology, by time spent coding") ///
	name(coderSeq, replace)
nwgexport latexOutput/plots/timeCoding_validity.pdf, replace
latexfigure plots/timeCoding_validity.pdf, log("`floga'") append  nofloat  ///
	caption("Impact of time spent coding on validity") precaption postbreak



// ==========================================
// 8. Impact of experience on coding quality  (learning/fatigue)
// ==========================================
// 8.a reliability
// ------------
use dataSets/codelevel_work1, clear
keep if inrange(codingType,1,4)
keep if wmp_l==30
keep if time>=wmp_l

do auxSyntax/Label_coderSeqGroup.do
la val coderSeqGroup coderSeqGroup

mktab (mIt1_AbsError = i.VarGrp##i.coderSeqGroup) if vToUse & coderNAdsCoded>=10 ,  ///
	cluster(workerId) latex log("`tloga'", append) stuff xlab ylab novarname longtable ///
	note("Among coders who code at least 10 ads overall. Regression at the coding-decision level, clustered by worker.") ///
	title("Coder learning or fatigue (reliability)") ///
	noiflabel

la val coderSeqGroup coderSeqGroup2
margins VarGrp#coderSeqGroup
marginsplot, by(VarGrp)  ///
	xtitle("Ad number for coder") ytitle("") ///
	ylabel(0(.25).5) ysca(ra(.6)) ///
	byopt(  ///
		note("Among coders who code at least 10 ads overall") ///
		title("Average absolute “error” size") ///
		rows(2) ///
	)
nwgexport latexOutput/plots/codeSeq_reliability.pdf, replace
latexfigure plots/codeSeq_reliability.pdf, log("`floga'") append nofloat caption("Coder learning or fatigue (reliability)") precaption postbreak

// 8.b validity
// ------------
use dataSets/validity_dataset_full, clear
keep if inrange(codingType,1,4)     // only individual mTurk hits
keep if wmp_l == 30                 // only 30-second ads for this analysis
drop if time<wmp_l

do auxSyntax/Label_coderSeqGroup.do
la val coderSeqGroup coderSeqGroup

// sequence, among 10+coders
mktab  (ideologyFc = c.bonica_dwnominate##(i.coderSeqGroup)) if coderNAdsCoded>=10, base cluster(workerId)  ///
	latex log(`tloga', append) stuff xlab ylab novarname longtable ///
	note("Among coders who code at least 10 ads overall") ///
	title("Coder learning or fatigue (validity)") ///
	noiflabel

margins coderSeqGroup, dydx(bonica_dwnominate)
marginsplot, recast(scatter) horizontal yscal(reverse) xtitle("") ///
	plotregion(margin(b 10 t 10)) ///
	xlab(.0(.1).4, format(%02.1f)) ///
	ytitle("") ///
	note("Marginal effect of DW-NOMINATE on favored candidate ideology coding.") ///
	title("Validity estimation for favored candidate ideology, by ad sequence" "Among workers who code at least 50 ads overall") ///
	name(coderSeq, replace)
nwgexport latexOutput/plots/codeSeq_validity.pdf, replace
latexfigure plots/codeSeq_validity.pdf, log("`floga'") append nofloat caption("Coder learning or fatigue (validity)") precaption

// ===========================
//  Coder demographics
// ===========================
use dataSets/coderAndANES_forRandR.dta, clear

ta dataset, matcell(tots)
local coderVars coderFemale cAgeSum coderRaceCollapsed coderEd2 coderStudent coderIncome coderPid3 
#delimit ;
nwtabout `coderVars' dataset using `tloga', append
	c(col) 
	svy mult(100)
	style(tex) font(bold)
	width(0.5\textwidth)
	caption(Demographics of mTurk workers and the American public)
	note("\textsc{anes} estimates are weighted")
	dropc(4)
	atbottom("\midrule\textbf{N} & `:di %6.0fc `=tots[1,1]'' & `:di %6.0fc `=tots[2,1]'' \\")
	h1(nil)
	;
#delimit cr

