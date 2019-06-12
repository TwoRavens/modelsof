
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	if ("`absorb'" == "`cluster'") local absorb = "`newcluster'"
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			if ("`absorb'" ~= "") {
				capture `anything', cluster(`newcluster') `robust' absorb(`absorb')
				}
			else {
				capture `anything', cluster(`newcluster') `robust'
				}
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = "school_code"

use DatBBLP, clear

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
*Note that s_sexo is not in this set because girl is used as an interaction variable.  So, it is included seperately in each regression;
global varbaseline1 "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"

global BASELINE1 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*dropped grades & suba, as these vary by specification (will add in manually)

global BASELINE2 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*drop s_years_back - colinear in some regressions

global BASELINE3 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL4-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL2 S_ESTCIVIL3 don't vary in some regressions

global BASELINE4 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL2 S_ESTCIVIL4 S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL3 doesn't vary in some regressions

global BASELINE5 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*dropped s_age_sorteo - colinear in some regressions

global BASELINE6 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*s_age_sorteo, S_ESTCIVIL2-SESTCIVIL4

global BASELINE7 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*s_years_back

global BASELINE8 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL*

global BASELINE9 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL*, s_sexo

global BASELINE10 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back S_ESTCIVIL2 S_ESTCIVIL4-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL3, s_sexo

global BASELINES1 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*no s_sexo

global i = 1
global j = 1

*Table 3 
mycmd (T1_treat T2_treat) reg at_msamean T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
mycmd (T1_treat T2_treat) reg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
mycmd (T1_treat T2_treat) areg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) reg at_msamean T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
mycmd (T3_treat) reg at_msamean T3_treat GRADE5 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
mycmd (T3_treat) areg at_msamean T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg at_msamean T1_treat T2_treat T3_treat $BASELINE1 suba if SS ~= 1 & grade ~= 11 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)

*Table 4
mycmd (T1_treat T2_treat) reg m_enrolled T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
mycmd (T1_treat T2_treat) reg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
mycmd (T1_treat T2_treat) areg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T3_treat) reg m_enrolled T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
mycmd (T3_treat) reg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
mycmd (T3_treat) areg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg m_enrolled T1_treat T2_treat T3_treat $BASELINE4 suba if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)

*Table 5
mycmd (T1_treat T2_treat T1_treat_girl T2_treat_girl) areg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_treat_girl T2_treat_girl) areg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_inc_380 T2_inc_380) areg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_inc_380 T2_inc_380) areg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_treat_patt T2_treat_patt) areg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_treat_pen T2_treat_pen) areg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)

*Table 6 
mycmd (T1_treat T2_treat) areg fu_self_attendance T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg fu_self_attendance T3_treat GRADE4 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg fu_self_attendance T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat) areg fu_currently_attending T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg fu_currently_attending T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg fu_currently_attending T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Table 7 
mycmd (T1_treat T2_treat) areg graduated T1_treat T2_treat $BASELINE5 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg graduated T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg graduated T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat) areg tertiary T1_treat T2_treat $BASELINE7 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg tertiary T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg tertiary T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Table 8
foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
	mycmd (T1_treat T2_treat) areg `var' T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & ~suba, absorb(school_code) cluster(school_code)
	mycmd (T3_treat) areg `var' T3_treat $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
	}
foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
	mycmd (T1_treat T2_treat) areg `var' T1_treat T2_treat $BASELINE7 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & ~suba, absorb(school_code) cluster(school_code)
	mycmd (T3_treat) areg `var' T3_treat $BASELINE6 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
	}

*Table 9 & 10
mycmd (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINE10 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (treatment) areg at_msamean treatment suba GRADE2-GRADE4 $BASELINE4 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (treatment) areg m_enrolled treatment suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg at_msamean tsib suba GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)

use ip\BS1, clear
forvalues i = 2/62 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/62 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapBBLP, replace

