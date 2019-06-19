************************USE database_figure 3_4.dta

label variable newloanspersonalcredit "Personal"
label variable  newloansautomobile "Auto"
label variable yearrateauto "Auto"
label variable yearratepersonal "Personal"

reg newloanspersonalcredit data
predict fitted_loans_personal
label variable fitted_loans_personal "Fitted Values: personal"

reg newloansautomobile data
predict fitted_loans_auto
label variable fitted_loans_auto "Fitted Values: Auto"

reg yearratepersonal data
predict fitted_rate_personal
label variable fitted_rate_personal "Fitted Values: personal"

reg yearrateauto data
predict fitted_rate_auto
label variable fitted_rate_auto "Fitted Values: Auto"

*Figure 3
twoway (line newloanspersonalcredit data) (line newloansautomobile data) (line  fitted_loans_auto data) (line  fitted_loans_personal data), ytitle(R$ Billion) xtitle(, size(zero)) title(Fig. 3 Monthly New Concessions Before Chartering in 2004) subtitle(April 2004) caption(Source: Banco Central do Brasil) legend(on cols(2) position(10) ring(0))
* Figure 4
twoway (line  yearrateauto data) (line  yearratepersonal data) (line  fitted_rate_auto data) (line  fitted_rate_personal data), ytitle(%) xtitle(, size(zero)) title(Fig. 4 Yearly Interest Rates Before Chartering in 2004) subtitle(April 2004) caption(Source: Banco Central do Brasil) legend(on cols(2) position(9) ring(0))


drop fitted_rate_auto fitted_rate_personal fitted_loans_auto fitted_loans_personal
