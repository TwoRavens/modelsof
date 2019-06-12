
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") capture `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") capture `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 62
global b = 112

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

matrix F = J($a,4,.)
matrix B = J($b,2,.)

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

gen Order = _n
sort school_code Order
gen N = 1
gen Dif = (school_code ~= school_code[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop school_code
	rename obs school_code

global i = 1
global j = 1

*Table 3 
mycmd1 (T1_treat T2_treat) reg at_msamean T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
mycmd1 (T1_treat T2_treat) reg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
mycmd1 (T1_treat T2_treat) areg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd1 (T3_treat) reg at_msamean T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
mycmd1 (T3_treat) reg at_msamean T3_treat GRADE5 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
mycmd1 (T3_treat) areg at_msamean T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T3_treat) areg at_msamean T1_treat T2_treat T3_treat $BASELINE1 suba if SS ~= 1 & grade ~= 11 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)

*Table 4
mycmd1 (T1_treat T2_treat) reg m_enrolled T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
mycmd1 (T1_treat T2_treat) reg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
mycmd1 (T1_treat T2_treat) areg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd1 (T3_treat) reg m_enrolled T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
mycmd1 (T3_treat) reg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
mycmd1 (T3_treat) areg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T3_treat) areg m_enrolled T1_treat T2_treat T3_treat $BASELINE4 suba if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)

*Table 5
mycmd1 (T1_treat T2_treat T1_treat_girl T2_treat_girl) areg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T1_treat_girl T2_treat_girl) areg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T1_inc_380 T2_inc_380) areg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T1_inc_380 T2_inc_380) areg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T1_treat_patt T2_treat_patt) areg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T1_treat_pen T2_treat_pen) areg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)

*Table 6 
mycmd1 (T1_treat T2_treat) areg fu_self_attendance T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T3_treat) areg fu_self_attendance T3_treat GRADE4 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T3_treat) areg fu_self_attendance T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat) areg fu_currently_attending T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T3_treat) areg fu_currently_attending T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T3_treat) areg fu_currently_attending T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Table 7 
mycmd1 (T1_treat T2_treat) areg graduated T1_treat T2_treat $BASELINE5 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T3_treat) areg graduated T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T3_treat) areg graduated T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat) areg tertiary T1_treat T2_treat $BASELINE7 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T3_treat) areg tertiary T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd1 (T1_treat T2_treat T3_treat) areg tertiary T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Table 8
foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
	mycmd1 (T1_treat T2_treat) areg `var' T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & ~suba, absorb(school_code) cluster(school_code)
	mycmd1 (T3_treat) areg `var' T3_treat $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
	}
foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
	mycmd1 (T1_treat T2_treat) areg `var' T1_treat T2_treat $BASELINE7 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & ~suba, absorb(school_code) cluster(school_code)
	mycmd1 (T3_treat) areg `var' T3_treat $BASELINE6 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
	}

*Table 9 & 10
mycmd1 (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINE10 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (treatment) areg at_msamean treatment suba GRADE2-GRADE4 $BASELINE4 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (treatment) areg m_enrolled treatment suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg at_msamean tsib suba GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd1 (tsib) areg m_enrolled tsib suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapBBLP, replace

erase aa.dta
erase aaa.dta


