
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************



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

matrix B = J(112,2,.)
global j = 1

*Table 3 
global i = 0
mycmd (T1_treat T2_treat) reg at_msamean T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
mycmd (T1_treat T2_treat) reg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
mycmd (T1_treat T2_treat) areg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) reg at_msamean T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
mycmd (T3_treat) reg at_msamean T3_treat GRADE5 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
mycmd (T3_treat) areg at_msamean T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg at_msamean T1_treat T2_treat T3_treat $BASELINE1 suba if SS ~= 1 & grade ~= 11 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 4
global i = 0
mycmd (T1_treat T2_treat) reg m_enrolled T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
mycmd (T1_treat T2_treat) reg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
mycmd (T1_treat T2_treat) areg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T3_treat) reg m_enrolled T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
mycmd (T3_treat) reg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
mycmd (T3_treat) areg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg m_enrolled T1_treat T2_treat T3_treat $BASELINE4 suba if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 5
global i = 0
mycmd (T1_treat T2_treat T1_treat_girl T2_treat_girl) areg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_treat_girl T2_treat_girl) areg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_inc_380 T2_inc_380) areg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_inc_380 T2_inc_380) areg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_treat_patt T2_treat_patt) areg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T1_treat_pen T2_treat_pen) areg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table 6 
global i = 0
mycmd (T1_treat T2_treat) areg fu_self_attendance T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg fu_self_attendance T3_treat GRADE4 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg fu_self_attendance T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat) areg fu_currently_attending T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg fu_currently_attending T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg fu_currently_attending T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7 
global i = 0
mycmd (T1_treat T2_treat) areg graduated T1_treat T2_treat $BASELINE5 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg graduated T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg graduated T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat) areg tertiary T1_treat T2_treat $BASELINE7 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T3_treat) areg tertiary T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)
mycmd (T1_treat T2_treat T3_treat) areg tertiary T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

*Table 8
global i = 0
foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
	mycmd (T1_treat T2_treat) areg `var' T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & ~suba, absorb(school_code) cluster(school_code)
	mycmd (T3_treat) areg `var' T3_treat $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
	}
foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
	mycmd (T1_treat T2_treat) areg `var' T1_treat T2_treat $BASELINE7 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & ~suba, absorb(school_code) cluster(school_code)
	mycmd (T3_treat) areg `var' T3_treat $BASELINE6 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
	}

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)

*Table 9 
global i = 0
mycmd (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg at_msamean tsib GRADE2-GRADE4 $BASELINE10 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)

*Table 10
global i = 0
mycmd (treatment) areg at_msamean treatment suba GRADE2-GRADE4 $BASELINE4 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (treatment) areg m_enrolled treatment suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg at_msamean tsib suba GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)
mycmd (tsib) areg m_enrolled tsib suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)

quietly suest $M, cluster(school_code)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 10)

drop _all
svmat double F
svmat double B
save results/SuestBBLP, replace






