/*##############################################*/
/* ECHP data					*/
/*##############################################*/

*STATA SETTINGS

clear
set more off
set type double
pause on
set seed 546
set mem 500m

*PROGRAM FOR DISPLAYING THE RESULTS OF THE RESULTS FROM THE AGGREGATE FORMULA

capture program drop conind
program define conind, rclass
version 7.0
syntax varname [if] [in], rnk(varname) wght(varname) [dir(string)]

tempvar cumw temp frnk meanlhs lhs rhs1 rhs2 cumw_1 cumlhs cumlhs1 cumwr cumwr_1
tempname sumw sigma2 ci seci

quietly replace `wght'=. if `wght'==0

marksample touse
markout `touse' `rnk' `wght'

gsort -`touse' `rnk'
quietly {
	egen double `sumw'=sum(`wght') if `touse'
	gen double `cumw'=sum(`wght') if `touse'
	gen double `cumw_1'=`cumw'[_n-1] if `touse'
	replace `cumw_1'=0 if `cumw_1'==.
	bys `rnk': egen double `cumwr'=max(`cumw') if `touse'
	bys `rnk': egen double `cumwr_1'=min(`cumw_1') if `touse'
	gen double `frnk'=(`cumwr_1'+0.5*(`cumwr'-`cumwr_1'))/`sumw' if `touse'

	gen double `temp'=(`wght'/`sumw')*((`frnk'-0.5)^2) if `touse'
	egen double `sigma2'=sum(`temp') if `touse'
	replace `temp'=`wght'*`varlist'
	egen double `meanlhs'=sum(`temp') if `touse'
	replace `meanlhs'=`meanlhs'/`sumw'
	gen double `lhs'=2*`sigma2'*(`varlist'/`meanlhs')*sqrt(`wght') if `touse'
	gen double `rhs1'=sqrt(`wght') if `touse'
	gen double `rhs2'=`frnk'*sqrt(`wght') if `touse'

	regress `lhs' `rhs1' `rhs2' if `touse', noconstant vce(bootstrap, reps(1000)) cluster(`rhs2')
	}

mat ci=e(b)
return scalar ci=ci[1,2]
mat seci=e(V)
return scalar seci=(seci[2,2])^0.5
return scalar obs=e(N)
end

capture program drop results
program define results
di in text "{hline 5}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}" /*
	*/ in text "{c TRC}"
di in text _col(6) "{c |} gini" /*
	*/ _col(17) "{c |} bias" /*
	*/ _col(28) "{c |} s.e." /*
	*/ _col(39) "{c |} Our" /*
	*/ _col(50) "{c |} Our bias" /*
	*/ _col(61) "{c |} covar" /*
	*/ _col(72) "{c |} "
di in text "{hline 5}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c RT}"
di in text "full" _col(6) "{c |}" _col(6) as result eqinc_full /*
	*/ _col(17) as text "{c |}" /*
	*/ _col(28) as text "{c |}" _col(28) as result eqinc_se /*
	*/ _col(39) as text "{c |}" /*
	*/ _col(50) as text "{c |}" /*
	*/ _col(61) as text "{c |}" /*
	*/ _col(72) as text "{c |}"
di in text "{hline 5}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c RT}"
foreach num of numlist 50/2 {
	di in text "`num'" _col(6) "{c |}" _col(7) as result eqinc_`num' /*
		*/ _col(17) as text "{c |}" _col(17) as result 100*(eqinc_`num'/eqinc_full) /*
		*/ _col(28) as text "{c |}" _col(28) as result eqinc_se_`num' /*
		*/ _col(39) as text "{c |}" _col(39) as result eqinc_`num'*((`num'^2)/((`num'^2)-1)) /*
		*/ _col(50) as text "{c |}" _col(50) as result 100*((eqinc_`num'*((`num'^2)/((`num'^2)-1)))/eqinc_full) /*
		*/ _col(61) as text "{c |}" _col(61) as result (eqinc_`num'*((`num'^2)/((`num'^2)-1))-eqinc_full)*(((`num'^2)-1)/(12*(`num'^2))) /*
		*/ _col(72) as text "{c |}"
}
di in text "{hline 5}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}" /*
	*/ in text "{c BRC}"
end

*PROGRAM FOR GENERATING THE ANALYSES

cap program drop grouped
program define grouped

*PROGRAM SETTINGS + INITIATE LOOP OVER SAMPLE SIZES

global path="c:\data"

*LOAD DATA (we exclude Luxembourg (SPELL) as it has no health information)

foreach x of numlist 1/16 18 {

	use "c:\data\ECuity`x'", clear

	if `x'==1 {
		global y="Germany(ECHP)"
	}
	else if `x'==2 {
		global y="Denmark"
	}
	else if `x'==3 {
		global y="Netherlands"
	}
	else if `x'==4 {
		global y="Belgium"
	}
	else if `x'==5 {
		global y="Luxembourg(ECHP)"
	}
	else if `x'==6 {
		global y="France"
	}
	else if `x'==7 {
		global y="UK(ECHP)"
	}
	else if `x'==8 {
		global y="Ireland"
	}
	else if `x'==9 {
		global y="Italy"
	}
	else if `x'==10 {
		global y="Greece"
	}
	else if `x'==11 {
		global y="Spain"
	}
	else if `x'==12 {
		global y="Portugal"
	}
	else if `x'==13 {
		global y="Austria"
	}
	else if `x'==14 {
		global y="Finland"
	}
	else if `x'==15 {
		global y="Sweden"
	}
	else if `x'==16 {
		global y="Germany(SOEP)"
	}
	else if `x'==18 {
		global y="UK(BHPS)"
	}

	*CHECK INCONSISTENCY OF TIME INVARIANT VARIABLES AND DROP REDUNDANT OBSERVATIONS

	if `x'~=15 {
		replace male=. if sex==.
		bys pid: egen temp=max(male)
		bys pid: egen temp1=min(male)
		drop if temp~=temp1
		bys pid: egen temp2=max(rd003)
		gen temp3=wave*rd003
		bys pid: egen temp4=max(wave) if temp3~=.
		bys pid: egen temp5=max(temp4)
		gen temp6=temp2-temp5+wave
		gen temp7=1 if temp6~=rd003 & rd003~=.
		bys pid: egen temp8=max(temp7)
		drop if temp6<0
		drop if temp8==1
		replace rd003=temp6
		drop temp*
	 	keep if pid~=.
	}

	*SELECT VARIABLES

	if `x'==13 {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==2
	}
	else if `x'==14 {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==3
	}
	else if `x'==15 {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==4
	}
	else {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==1
	}

	/* we keep wave 1 for all countries (preference for earlier waves due to more observations), except for wave 2 (Austria) wave 3 (Finland) and */
	/* wave 4 (Sweden) */

	*TRANSFORM VARIABLES

	rename rd003 age
	recode hh_size -9 -8 = .

	bys hid: egen temp=count(age)
	bys hid: egen temp1=count(temp)
	replace hh_size=. if temp1>temp
	bys hid: egen temp2=count(age) if age<=14 & age~=.
	bys hid: egen age_under_14=max(temp2)
	replace age_under_14=0 if age_under_14==. & age~=. & hh_size~=.
	replace age_under_14=. if temp1>temp
	drop temp*

	gen oecdscale=1+0.5*(hh_size-age_under_14-1)+0.3*age_under_14
	gen eqinc=totalinc_h/oecdscale

	*DROPPING VARS & OBS

	gen drop_ind=0
	for var wave country pid age hh_size eqinc pweight: replace drop_ind=1 if X==.
	replace drop_ind=1 if age<16
	drop if drop_ind>0

	*GET RID OF WEIGHTS

	replace pweight=1

	*ANALYSIS

	quietly {
		conind eqinc, rnk(eqinc) wght(pweight)
		scalar eqinc_full=r(ci)
		scalar eqinc_se=r(seci)
		foreach num of numlist 50/2 {
			xtile decinc=eqinc [aw=pweight], nq(`num')
			conind eqinc, rnk(decinc) wght(pweight)
			scalar eqinc_`num'=r(ci)
			scalar eqinc_se_`num'=r(seci)
			drop decinc
		}
	}

	log using "$path\_$y.log", replace
	sum eqinc [aw=pweight], detail
	results
	log close
}
end
grouped
