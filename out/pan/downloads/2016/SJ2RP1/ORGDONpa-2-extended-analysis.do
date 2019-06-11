/*tex

Stata/SE 13.1; required packages: fre, estout, rrreg

\subsection{Selection of sample for analysis}

tex*/
texdoc stlog

use data.dta
* - exclude 36 observations who did not reach the sensitive questions intro page
drop if senstec==.b
* - exclude 1 observation whose self-assessed German skills are "rather poor"
fre q28_2
drop if q28_2==4
* - generate language filter variable for well or very well german skills (excluding medium)
gen byte language = inlist(q28_2,1,2)
fre language
gen byte DQ      = senstec==1
gen byte CM	     = senstec==2
* recoding of sensitive questions for analysis
recode blood (1=0) (0=1)
	lab var blood "Have you (n)ever donated blood?"
recode organ (1=0) (0=1)
	lab var blood "Are you (un)willing to donate organs or tissues after death?"
recode diploma (1=0) (0=1)
	lab var diploma "Have you (not) accomplished the 'Abitur'?"

texdoc stlog close
/*tex

\subsection{Quality criteria}

Breakoff, Item-Nonresponse, Answering time, don't know responses
note: sample already restricted to the ones who reached the sensitive 
questions (i.e. obs with valid senstec)

tex*/
texdoc stlog

// - breakoff
qui gen byte breakoff = (senstec==2 & submit30==.b) | (senstec==1 & submit30==.b) // did not reach last page before uq-test
                               // (i.e. did not submit last page with questions)
fre breakoff
// - item nonresponse (proportion of items not answered)
gen nonresp = 0
foreach v in blood organ drinks recipient chagas {
    qui replace nonresp = nonresp + 1 if inlist(`v', .a, .b, .e)
}
qui replace nonresp = nonresp / 5
fre nonresp
// - dk-response (proportion of items with dk)
gen dkresp = 0 if sensdk==1
foreach v in blood organ drinks recipient chagas {
    qui replace dkresp = dkresp + 1 if inlist(`v', .e) & sensdk==1
}
qui replace dkresp = dkresp / 5
fre dkresp
// - total time to answer sensitive question block (only respondents who
//   completed the block)
gen time = 0
foreach v of var submit9-submit15 {
    qui replace time = time + `v' if `v'!=.c // => missing if breakoff, but not if filter .b
}
su time, d
gen time2 = 0
foreach v of var submit9 submit10-submit15 { // only the actual questions without instruction pages
    qui replace time2 = time2 + `v' if `v'!=.c // => missing if breakoff , but not if filter .c
}
su time2, d

capt prog drop mymedian // (by Ben Jann)
program mymedian, eclass
    syntax varname [if] [in], over(varname) [ level(passthru) * ]
    marksample touse
    markout `touse' `over'
    qui count if `touse'
    local N = r(N)
    tempname b se _N V df
    local coln
    qui levelsof `over'
    foreach l in `r(levels)' {
        local coln `"`coln' `"`: lab (`over') `l''"'"' // '""'
        qui qreg `varlist' if `touse' & (`over'==`l'), quantile(.5) `options'
        mat `b' = nullmat(`b'), _b[_cons]
        mat `se' = nullmat(`se'), _se[_cons]
        mat `df' = nullmat(`df'), e(df_r)
        mat `_N' = nullmat(`_N'), e(N)
    }
    mat coln `b' = `coln'
    mat coln `se' = `coln'
    mat coln `df' = `coln'
    mat coln `_N' = `coln'
    mat `V' = diag(vecdiag(`se'' * `se'))
    eret post `b' `V', esample(`touse') obs(`N')
    eret local cmd "mymedian"
    eret local depvar "`varlist'"
    eret local over   "`over'"
    eret matrix _N = `_N'
    eret matrix df = `df'
    _coef_table_header
    eret di
end

local d (dCM: _b[CM]-_b[DQ])
forv i = 0/1 {
    preserve
    if `i'==1 {
        di _n as res "==> SELECTION: GOOD LANGUAGE SKILLS"
        keep if language
    }
    else di _n as res "==> SELECTION: ALL OBS"
    qui mean breakoff, over(senstec) citype(logit)
    est sto breakoff
    nlcom `d'
    qui mean nonresp, over(senstec) citype(logit)
    est sto nonresp
    nlcom `d'
    qui mean dkresp, over(senstec) citype(logit)
    est sto dkresp
    nlcom `d'
    qui mymedian time, over(senstec)
    est sto time
    nlcom `d'
    qui mymedian time2, over(senstec)
    est sto time2
    nlcom `d'
    qui estwrite * using log/eval`i', replace
    restore
}


texdoc stlog close
/*tex

\subsection{Comparison of elicited and theoretical “yes”-prevalence to unrelated questions in CM}

tex*/
texdoc stlog

forv i = 0/1 {
    preserve
    if `i'==1 {
        di _n as res "==> SELECTION: GOOD LANGUAGE SKILLS"
        keep if language
    }
    else di _n as res "==> SELECTION: ALL OBS"
	keep if DQ
	keep id language uq*
	drop *_pos
	forvalues j = 1/12 {
		rename uq`j'_pyes pyes`j'
	}
	reshape long uq pyes, i(id) j(uqid)

	tab uq uqid
	mean uq, over(uqid) citype(logit)
	est sto uq
	mean pyes, over(uqid) citype(logit)
	est sto pyes
	gen diff = uq-pyes
	mean diff, over(uqid)
	est sto diff
	qui estwrite * using log/testuq`i', replace
	est clear
	restore
}

texdoc stlog close
/*tex

\subsection{Comparative validation without potentially problematic unrelated questions}

tex*/
texdoc stlog

capt prog drop nlrrreg
program nlrrreg, rclass // nonlinear randomized response regression (by Ben Jann)
    version 13.1
    syntax varlist(min=2) [aw fw iw] if
    gettoken lhs rhs : varlist
    local xb
    local plus
    foreach v in `rhs' {
        local xb `xb' `plus' {`v'}*`v'
        local plus "+"
    }
    return local eq "`lhs' = (1-`lhs'_pyes-`lhs'_pno)*((2*`lhs'_pcm-1)*(`xb')-`lhs'_pcm+1)+`lhs'_pyes"
    return local title "`lhs' = (1 - pyes - pno)*((2*pcm - 1)*{xb} - pcm + 1) + pyes"
end

est clear
forv i = 0/1 {
    preserve
    if `i'==1 {
        di _n as res "==> SELECTION: GOOD LANGUAGE SKILLS"
    }
    else di _n as res "==> SELECTION: ALL OBS"
    // prevalence by implementation
    foreach v in blood organ drinks recipient chagas  {
        di _n as res `"==> `v': `:var lab `v''"'
        // least-squares	
        rrreg `v' DQ CM if !inlist(`v'_uq,5,6,9) ///
            , nocons hc2 pyes(`v'_pyes) pno(`v'_pno) pwarner(`v'_pcm)
        est sto `v'
        nlcom (CM:_b[CM]-_b[DQ]), post
        est sto `v'_d
        // nonlinear least-squares
        nl rrreg: `v' DQ CM if !inlist(`v'_uq,5,6,9), vce(robust)
        est sto `v'_nl
        nlcom (CM:_b[/CM]-_b[/DQ]), post
        est sto `v'_nl_d
        // maximum likelihood
        rrlogit `v' DQ CM  if !inlist(`v'_uq,5,6,9) ///
            , nocons robust nolog pyes(`v'_pyes) pno(`v'_pno) pwarner(`v'_pcm)
        if "`v'" == "recipient" { 
		nlcom  (DQ:-12) (CM:_b[CM]), post // because DQ is dropped due to zero variance (prevalence = 0)
		} 
		est sto `v'_ml
        nlcom (CM:_b[CM]-_b[DQ]), post
		est sto `v'_ml_d
    }
    qui estwrite * using log/comparative_selecteduq`i', replace
    est clear
    restore
}


texdoc stlog close
/*tex

\subsection{Comparative validation without fastest 10\% on CM introduction screen}

tex*/
texdoc stlog

est clear
forv i = 0/1 {
    preserve
    if `i'==1 {
        di _n as res "==> SELECTION: GOOD LANGUAGE SKILLS"
    }
    else di _n as res "==> SELECTION: ALL OBS"
    // prevalence by implementation
   	gen durationintro = submit9/60 if senstec==2
	su durationintro if senstec==2, det
	gen fastintro10 = cond(durationintro<=r(p10),1,0) if !missing(durationintro)
	*
	foreach v in blood organ drinks recipient chagas  {
        di _n as res `"==> `v': `:var lab `v''"'
        // least-squares
        rrreg `v' DQ CM if fastintro10!=1 ///
            , nocons hc2 pyes(`v'_pyes) pno(`v'_pno) pwarner(`v'_pcm)
        est sto `v'
        nlcom (CM:_b[CM]-_b[DQ]), post
        est sto `v'_d
        // nonlinear least-squares
        nl rrreg: `v' DQ CM  if fastintro10!=1, vce(robust)
        est sto `v'_nl
        nlcom (CM:_b[/CM]-_b[/DQ]), post // why the / ?
        est sto `v'_nl_d
        // maximum likelihood
        rrlogit `v' DQ CM  if fastintro10!=1 ///
            , nocons robust nolog pyes(`v'_pyes) pno(`v'_pno) pwarner(`v'_pcm)
        if "`v'" == "recipient" { 
		nlcom  (DQ:-12) (CM:_b[CM]), post // because DQ is dropped due to zero variance (prevalence = 0)
		} 
		est sto `v'_ml
        *if "`v'" == "recipient" {
		*nlcom  (CM:_b[CM]), post // 
		*} 
		*else nlcom (CM:_b[CM]-_b[DQ]), post
        nlcom (CM:_b[CM]-_b[DQ]), post
		est sto `v'_ml_d
    }
    qui estwrite * using log/comparative_nofastintro`i', replace
    est clear
    restore
}

texdoc stlog close
exit
