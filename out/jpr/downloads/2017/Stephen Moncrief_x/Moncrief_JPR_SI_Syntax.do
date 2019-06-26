*Use "Moncrief_JPR_SI_Data.xlsx"

gen log_m_size = log(m_size)
gen log_gdppc = log(gdppc)


*Table I: Model 1
nbreg sea_mil off_prop_total cdu_mil m_size gdppc rape, cluster(nummiss) 

*Table I: Model 2
nbreg sea_mil off_prop_total cdu_mil log_m_size log_gdppc rape, cluster(nummiss)

*Table I: Model 3
nbreg sea_mil off_prop_total cdu_mil log_m_size log_gdppc rape social_barrier, cluster(nummiss)



*Appendix (Table II)
*Regressions excluding missions with CDTs based in other missions

keep if nummiss != 23
keep if nummiss != 20
keep if nummiss != 10
keep if nummiss != 9

*Table II: Model 1
nbreg sea_mil off_prop cdu_mil m_size gdppc rape, cluster(nummiss)

*Table II: Model 2
nbreg sea_mil off_prop cdu_mil log_m_size log_gdppc rape, cluster(nummiss)

*Table II: Model 3
nbreg sea_mil off_prop cdu_mil log_m_size log_gdppc rape social_barrier, cluster(nummiss)



*Appendix (Table III)
clear
*Reload dataset
gen log_m_size = log(m_size)
gen log_gdppc = log(gdppc)
keep if cdu_mil < 92

*Table III: Model 1
nbreg sea_mil off_prop cdu_mil m_size gdppc rape, cluster(nummiss)

*Table III: Model 2
nbreg sea_mil off_prop cdu_mil log_m_size log_gdppc rape, cluster(nummiss)

*Table III: Model 3
nbreg sea_mil off_prop cdu_mil log_m_size log_gdppc rape social_barrier, cluster(nummiss)

