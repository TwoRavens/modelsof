/*tex

Stata/SE 13.1; required packages: fre, estout, estwrite, rrreg, rrlogit

\subsection{Response rates}

tex*/

texdoc stlog

use data.dta
local N 10000 // gross sample
// calculate response rates
mat R = J(6,2,.)
mat coln R = "N" "RR"
mat rown R = "Sample" "Started" "Started2" "Completed" "Completed2" "SQ"
*
mat R[1,1] = `N', 1
qui count // accessed survey/submitted introduction page
mat R[2,1] = r(N), r(N)/R[1,1]
qui count if submit2!=.b // submitted first page with questions
mat R[3,1] = r(N), r(N)/R[1,1]
qui count if completed==1 // completed
mat R[4,1] = r(N), r(N)/R[1,1]
qui count if (senstec==2 & submit30!=.b) | (senstec==1 & submit36!=.b) // submitted last page with questions (before resp' comments)
mat R[5,1] = r(N), r(N)/R[1,1]
qui count if senstec<. // reached first page after sensitive question intro
mat R[6,1] = r(N), r(N)/R[1,1]

// Sample:     Gross sample (PsyWeb-Members addressed)
// Started:    Started the survey/submitted at least intro page
// Started2:   Submitted at least the first page containing questions
// Completed:  Completed questionnaire to very end (excluding raffle information)
// Completed2: Completed the questionnaire to last page containing questions
// SQ: Submitted at least sensitive questions introduction page
mat list R


texdoc stlog close
/*tex

\subsection{Selection of sample for analysis}

tex*/
texdoc stlog

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

\subsection{Overall response time}

tex*/
texdoc stlog

gen duration=minutes(enddate-startdate)
su dur, detail // accessed survey/submitted introduction page
su dur if completed==1, detail // if completed to very end
su dur if (senstec==2 & submit30!=.b) | (senstec==1 & submit36!=.b), detail // if submitted last page with questions (before resp' comments)
su dur if senstec<., detail // if reached first page after sensitive question intro


texdoc stlog close
/*tex

\subsection{Sample descriptives}

tex*/
texdoc stlog

gen age = 2015-q25_1
su age, det

fre q25_2 q25_3 q28_1_1 q26_2
fre poccupation pedudegree 
drop age

texdoc stlog close
/*tex

\subsection{Number of observations per item and technique}

tex*/
texdoc stlog

// SELECTION: ALL OBS
qui estpost tabstat blood organ drinks recipient chagas, by(senstec) stat(count) ///
    columns(statistics) nototal
esttab ., main(count) unstack compress not noobs nonote nostar nonum nomti

// SELECTION: Only GOOD LANGUAGE SKILLS
qui estpost tabstat blood organ drinks recipient chagas if language, by(senstec) stat(count) ///
    columns(statistics) nototal
esttab ., main(count) unstack compress not noobs nonote nostar nonum nomti


texdoc stlog close
/*tex

\subsection{Question sensitivity}

tex*/
texdoc stlog

preserve
keep id language q24_?
fre q24_1
qui reshape long q24_, i(id) j(question)
recode question (4=5) (5=3) (3=4)
lab def question ///
    1 "Never donated blood" ///
    2 "Unwilling to donate organs" ///
    3 "Excessive drinking" ///
    4 "Received a donated organ" ///
    5 "Suffered from Chagas disease"
lab val question question

// (very touchy or rather touchy)
qui gen touchy = inlist(q24_,4,5)*100 if inlist(q24_,1,2,3,4,5)

// SELECTION: ALL OBS
qui estpost tabstat touchy, by(question) s(mean count) nototal
esttab, cell((mean count)) ///
    varlab(`e(labels)') varwidth(35) noobs nonum nomti

// SELECTION: GOOD LANGUAGE SKILLS
qui estpost tabstat touchy if language, by(question) s(mean count) nototal
esttab, cell((mean count)) ///
    varlab(`e(labels)') varwidth(35) noobs nonum nomti
	
restore


texdoc stlog close
/*tex

\subsection{Comparative validation: estimates}

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
        keep if language
    }
    else di _n as res "==> SELECTION: ALL OBS"
    // prevalence by implementation
    foreach v in blood organ drinks recipient chagas  {
        di _n as res `"==> `v': `:var lab `v''"'
        // least-squares
        rrreg `v' DQ CM ///
            , nocons hc2 pyes(`v'_pyes) pno(`v'_pno) pwarner(`v'_pcm)
        est sto `v'
        nlcom (CM:_b[CM]-_b[DQ]), post
        est sto `v'_d
        // nonlinear least-squares
        nl rrreg: `v' DQ CM, vce(robust)
        est sto `v'_nl
        nlcom (CM:_b[/CM]-_b[/DQ]), post
        est sto `v'_nl_d
        // maximum likelihood
        rrlogit `v' DQ CM ///
            , nocons robust nolog pyes(`v'_pyes) pno(`v'_pno) pwarner(`v'_pcm)
        if "`v'" == "recipient" { 
		nlcom  (DQ:-99) (CM:_b[CM]), post  // because DQ is dropped due to zero variance (prevalence = 0)
		} 
        est sto `v'_ml
		nlcom (CM:_b[CM]-_b[DQ]), post
        est sto `v'_ml_d
    }
    qui estwrite * using log/comparative`i', replace
    est clear
    restore
}


texdoc stlog close
/*tex

\subsection{Indvidual-level validation: estimates}

(Fachhochschulreife excluded, because unequivocal whether they consider this as "Abitur" or not.)

tex*/
texdoc stlog

est clear
forv i = 0/1 {
    preserve
	keep if !inlist(pedudegree,5,7,.) // exclude if "Fachhochschulreife", missing, or other
    if `i'==1 {
        di _n as res "==> SELECTION: GOOD LANGUAGE SKILLS"
        keep if language
    }
    else di _n as res "==> SELECTION: ALL OBS"
	
  	// individual-level individual by implementation
	di _n as res `"==> diploma: `:var lab diploma'"'
	gen DQyesval = cond(senstec==1 & pedudegree!=6,1,0)
	fre DQyesval if DQ==1
	gen DQnoval = cond(senstec==1 & pedudegree==6,1,0)
	gen CMyesval = cond(senstec==2 & pedudegree!=6,1,0)
	fre CMyesval if CM==1
	gen CMnoval = cond(senstec==2 & pedudegree==6,1,0)
	// least-squares
	rrreg diploma DQ CM ///
		, nocons hc2 pyes(diploma_pyes) pno(diploma_pno) pwarner(diploma_pcm)
	est sto aggreg
	nlcom (CM:_b[CM]-_b[DQ]), post
	est sto aggreg_d
	*
	rrreg diploma DQyesval DQnoval CMyesval CMnoval ///
		, nocons hc2 pyes(diploma_pyes) pno(diploma_pno) pwarner(diploma_pcm)
	est sto temp
	nlcom (DQ:1-_b[DQyesval]) (CM:1-_b[CMyesval]), post
	est store falneg
	*
	est restore temp
	nlcom (DQ:_b[DQnoval]) (CM:_b[CMnoval]), post
	est store falpos
	*
	est restore temp
	nlcom (CM:_b[CMnoval]-_b[DQnoval]), post
	est store falpos_d
	*
	est restore temp
	nlcom (CM:_b[DQyesval]-_b[CMyesval]), post
	est sto falneg_d
	// nonlinear least-squares
	nl rrreg: diploma DQ CM, vce(robust)
	est sto temp
	nlcom (DQ:_b[/DQ]) (CM:_b[/CM]), post
	est sto aggreg_nl
	est restore temp
	nlcom (CM:_b[/CM]-_b[/DQ]), post
	est sto aggreg_nl_d
	*
	nl rrreg: diploma DQyesval DQnoval CMyesval CMnoval, vce(robust)
	est sto temp
	nlcom (DQ:1-_b[/DQyesval]) (CM:1-_b[/CMyesval]), post
	est store falneg_nl
	*
	est restore temp
	nlcom (DQ:_b[/DQnoval]) (CM:_b[/CMnoval]), post
	est store falpos_nl
	*
	est restore temp
	nlcom (CM:_b[/CMnoval]-_b[/DQnoval]), post
	est store falpos_nl_d
	*
	est restore temp
	nlcom (CM:_b[/DQyesval]-_b[/CMyesval]), post
	est sto falneg_nl_d
	// maximum likelihood
	rrlogit diploma DQ CM ///
		, nocons robust nolog pyes(diploma_pyes) pno(diploma_pno) pwarner(diploma_pcm)
	est sto aggreg_ml
	nlcom (CM:_b[CM]-_b[DQ]), post
	est sto aggreg_ml_d
	*
	recode diploma (0 = 1) (1 = 0), gen(diploma_inv)
	rrlogit diploma_inv DQyesval DQnoval CMyesval CMnoval ///
		, nocons robust nolog pyes(diploma_pyes) pno(diploma_pno) pwarner(diploma_pcm)
	est sto temp
	nlcom (DQ:_b[DQyesval]) (CM:_b[CMyesval]), post
	est store falneg_ml
	*
	est restore temp
	nlcom (CM:_b[DQyesval]-_b[CMyesval]), post
	est sto falneg_ml_d
	*
	rrlogit diploma DQyesval DQnoval CMyesval CMnoval ///
		, nocons robust nolog pyes(diploma_pyes) pno(diploma_pno) pwarner(diploma_pcm)
	est sto temp
	nlcom (DQ:_b[DQnoval]) (CM:_b[CMnoval]), post
	est store falpos_ml
	*
	est restore temp
	nlcom (CM:_b[CMnoval]-_b[DQnoval]), post
	est store falpos_ml_d
	*
	
    qui estwrite * using log/individual`i', replace
    est clear
    restore
}


texdoc stlog close
/*tex

\subsection{Causes and correlates of false positives}

tex*/
texdoc stlog

capt prog drop appendmodels
*! version 1.0.0  14aug2007  Ben Jann
program appendmodels, eclass
  // using first equation of model
  version 8
    syntax namelist
    tempname b V tmp
    foreach name of local namelist {
        qui est restore `name'
         mat `tmp' = e(b)
           local eq1: coleq `tmp'
           gettoken eq1 : eq1
           mat `tmp' = `tmp'[1,"`eq1':"]
          local cons = colnumb(`tmp',"_cons")
          if `cons'<. & `cons'>1 {
              mat `tmp' = `tmp'[1,1..`cons'-1]
          }
          mat `b' = nullmat(`b') , `tmp'
          mat `tmp' = e(V)
          mat `tmp' = `tmp'["`eq1':","`eq1':"]
          if `cons'<. & `cons'>1 {
              mat `tmp' = `tmp'[1..`cons'-1,1..`cons'-1]
          }
          capt confirm matrix `V'
          if _rc {
              mat `V' = `tmp'
          }
          else {
              mat `V' = ///
			 ( `V' , J(rowsof(`V'),colsof(`tmp'),0) ) \ ///
             ( J(rowsof(`tmp'),colsof(`V'),0) , `tmp' )
         }
     }
     local names: colfullnames `b'
     mat coln `V' = `names'
     mat rown `V' = `names'
     eret post `b' `V'
     eret local cmd "whatever"
end

est clear
forv i = 0/1 {
	preserve
    if `i'==1 {
        di _n as res "==> SELECTION: GOOD LANGUAGE SKILLS"
        keep if language
    }
    else di _n as res "==> SELECTION: ALL OBS"

	keep if CM
	drop diploma* blood* organ* drinks* uq*
	
	local j 0
	foreach v in recipient chagas {
		local ++j
		rename `v' sq`j'
		rename `v'_pyes sq_pyes`j'
		rename `v'_pno  sq_pno`j'
		rename `v'_pcm  sq_pcm`j'
		rename `v'_uq   sq_uq`j'
		rename `v'_pos  sq_pos`j'
	}
	reshape long sq sq_pyes sq_pno sq_pcm sq_uq sq_pos, i(id) j(sqid)
	* 
	gen byte diffsame = cond(cmresponsedo==2, 1, 0) if !missing(cmresponsedo)
	gen byte uq_father = cond(inlist(sq_uq,3,4,9,10),1,0) // mother vs. father vs. acquaintance
	gen byte uq_acquaint = cond(inlist(sq_uq,5,6,11,12),1,0)
	gen byte uq_day = cond(inlist(sq_uq,2,4,6,8,10,12),1,0) // month vs. day
	gen byte uq_phigh = cond(inrange(sq_uq,7,12),1,0) if !missing(sq_uq) // phigh vs. plow
	gen pos12 = cond(inlist(sq_pos,1,2),1, ///
					cond(inlist(sq_pos,4,5),0, ///
						.))
	* 
	gen durationsq = (submit11 + submit12 + submit13 + submit14 + submit15)/60
	su durationsq, det
	gen byte fastsq10 = cond(durationsq<=r(p10),1,0) if !missing(durationsq)
	gen durationintro = submit9/60
	su durationintro, det
	gen byte fastintro10 = cond(durationintro<=r(p10),1,0) if !missing(durationintro)	
	gen byte abitur = cond(inlist(pedudegree,5,6),1,0) if !missing(pedudegree)
	gen age = 2015-q25_1
	gen byte female = cond(q25_2==1,1, ///
					  cond(q25_2==2,0,.))
	su q9link
	*
	local exp sensdk diffsame uq_father uq_acquaint uq_day uq_phigh sq_pos pos12
	local cov fastintro10 fastsq10 q9link q23 abitur age female
	foreach group in exp cov {
		// least-squares
		forvalues k = 1/`: word count ``group''' {
			local var : word `k' of ``group''
			rrreg sq `var' ///
				, hc2 pyes(sq_pyes) pno(sq_pno) pwarner(sq_pcm) cluster(id)
			est sto `var'
			if `k' == 1 {
				est sto `group'
			}
			else eststo `group' : appendmodels `group' `var'
			// nonlinear least-squares
			nl rrreg: sq `var' CM, cluster(id)
			nlcom (`var': _b[/`var']), post
			est sto `var'_nl
			if `k' == 1 {
				est sto `group'_nl
			}
			else eststo `group'_nl : appendmodels `group'_nl `var'_nl
			// maximum likelihood
			rrlogit sq `var' ///
				, robust nolog pyes(sq_pyes) pno(sq_pno) pwarner(sq_pcm) cluster(id)
			est sto `var'_ml
			if `k' == 1 {
				est sto `group'_ml
			}
			else eststo `group'_ml : appendmodels `group'_ml `var'_ml
		}
	}
	qui estwrite * using log/falsepos`i', replace
	est clear
	restore
}
fre recipient chagas if sensdk==1 & senstec==2


texdoc stlog close
/*tex

\subsection{Simulation of effect of most likely misreporting patterns on false positive rate}

tex*/
texdoc stlog

* CM equation with s = true status, and y = response (0 = different, 1 = same)
* s = (`y' + `pyesuq'-1)/(2*`pyesuq'-1)
mean recipient_pcm if senstec==2 & pleveluq==1
local pyesuq .178
* average p-level if pleveluq is low (for high it is exactly the inverse, .82)
mean recipient if senstec==2 & pleveluq==1
mean recipient if senstec==2 & pleveluq==2
local y = (.780 + (1-.234))/2
local cmprevalence "(`y' + `pyesuq'-1)/(2*`pyesuq'-1)"
dis `cmprevalence'

* y (response) if no misreporting and prevalence of s = 0 
* y = `s'*`pyesuq'+(1-`s')*(1-`pyesuq')
local pyesuq .178
local s 0.00
dis `s'*`pyesuq'+(1-`s')*(1-`pyesuq')
local y .822

* random answering (corresponds to y = .5)
local cmprevalence_rnd "(`y'*(1-x)+.5*x + `pyesuq'-1)/(2*`pyesuq'-1)"
twoway (function y=`cmprevalence_rnd', lwidth(medthick) lcol(black) range(0 .3))  ///
	(pci .0760 	0 		.0760 	.152, lpatt(dash) lcol(black)) ///
	(pci .0477 	0 		.0477 	.0954, lpatt(dash) lcol(black)) ///
	(pci .0760 	.152  	0 		.152, lpatt(dash) lcol(black)) ///
	(pci .0477 	.0954 	0 		.0954, lpatt(dash) lcol(black)) ///
	, ytitle(false positive rate) ///
	ylab(0 .1 .2  .0760 "organ" ///
	.0477 "Chagas", labsize(small) angle(horizontal)) ///
	xlab(0 .1 .2 .3, labsize(small)) ///	
	legend(off) ///
	xtitle(share random answering) ///
	name(random, replace)

* share of random answering necessary to reproduce the found bias:
dis "share random answering recipient:" (.0760*(2*`pyesuq'-1)-`pyesuq'+1-`y')/(-`y'+.5)
dis "share random answering Chagas:" (.0477*(2*`pyesuq'-1)-`pyesuq'+1-`y')/(-`y'+.5) 

* biased unrelated quesiton outcome (pyesuq)
local cmprevalence_rnd "(`y'*(1-x)+(1-`y')*x + `pyesuq'-1)/(2*`pyesuq'-1)"
twoway (function y=`cmprevalence_rnd', lwidth(medthick) lcol(black) range(-.20 .2)) ///
	(pci .0760 	-.2 	.0760 	.0760, lpatt(dash) lcol(black)) ///
	(pci .0477 	-.2 	.0477 	.0477, lpatt(dash) lcol(black)) ///
	(pci .0760	.0760  	-.2		.0760, lpatt(dash) lcol(black)) ///
	(pci .0477  .0477 	-.2	.0477, lpatt(dash) lcol(black)) ///
	, yline(0, lstyle(grid)) xline(0, lstyle(grid)) ///
	ylab(-.2(.1).2 .0760 "organ" ///
	.0477 "Chagas", labsize(medsmall) angle(horizontal)) ///
	xlab(-.2(.1).2) ///
	legend(off) ///
	ytitle("") xtitle(unrelated question bias) ///
	name(uqbias, replace)
* extent of bias to explain empirical result:
dis "Unrelated question bias recipient:" (.0760* (2*`pyesuq'-1) -`pyesuq'+ 1 -`y')/(-`y'+(1-`y'))
dis "Unrelated question bias bias Chagas:" (.0477* (2*`pyesuq'-1) -`pyesuq'+ 1 -`y')/(-`y'+(1-`y'))
	
graph combine random uqbias, ysize(2.5) scale(1.8)	
qui graph export log/simulation.pdf, replace

texdoc stlog close
exit
