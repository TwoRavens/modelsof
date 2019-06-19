use "Data_ZAF.dta", clear
*use InvestDummies_ZAF_total_T, clear
*use InvestDummies_ZAF_avg_T, clear
*use InvestDummies_ZAF_total_adjusted, clear
/*I am using the new version that has the total employment instead of the average employment per country*/

replace employ_mwi = . if Date<=14060 /*Ineligible before 6/30/1998*/
replace employ_gmb = . if Date<=14578 /*Ineligible before 11/30/1999*/
replace employ_gnq = . if Date>=14518 /*Ineligible after 10/1/1999*/

egen total_employ = rsum(employ_*) /*Equal weight on each HIPC country where invested*/
replace total_employ = . if total_employ==0 /*Command above assign zeros to all missing data. there is no real zero in our data*/
*egen avg_employ = rmean(employ_*) /*Equal weight on each HIPC country where invested*/

label var total_employ "Total labor force over subsidiaries at each point in time"
*label var avg_employ "Average labor force over subsidiaries at each point in time"

keep ticker Date total_employ
rename Date date
sort ticker date
save Subsidiaries_employment_adjusted_holdings_T, replace
