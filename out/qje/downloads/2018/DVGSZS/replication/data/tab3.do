/*************************************************************************************************************
This .do file makes table 3 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
qui tsset

preserve
summarystats, variables(u_trigger_error Tstarnoadj T_hat epsilon u_revised phi v e aw w) filename(tab3a) ///
	statistics(mean sd zsd p25 p75 N) label(`"Mean"' `"S.D."' `"Within S.D."' `"P25"' `"P75"' `"Obs."')
restore

/*Length of non-zero error spells and months with nonzero error*/
qui gen errorstartmonth = monthly if sign(T_hat)!=sign(L.T_hat) & !missing(T_hat,L.T_hat)
qui replace errorstartmonth = L.errorstartmonth if sign(T_hat)==sign(L.T_hat)
qui egen episodelength = count(monthly), by(state_n errorstartmonth)
/*Note: mean episodelength * number of unique episodes is not exactly equal to number of months with an error, because of how we treat months in which EUC was partially expired*/

errorsummarystats Tstarnoadj if baseline_sample & T_hat!=0, filename(tab3b) statistics(count(fmt(%9.0fc)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p75(fmt(%9.2f))) labels(N Mean SD P25 P75) varlabel(T_hat `"Non-zero UI months errors"') header
errorsummarystats T_hat if baseline_sample & T_hat!=0, filename(tab3b) statistics(count(fmt(%9.0fc)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p75(fmt(%9.2f))) varlabel(T_hat `"Non-zero UI months errors"') 
errorsummarystats epsilon if baseline_sample & S.T_hat!=0, filename(tab3b) statistics(count(fmt(%9.0fc)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p75(fmt(%9.2f))) varlabel(T_hat `"Non-zero UI months errors"') 
errorsummarystats episodelength if baseline_sample & errorstartmonth==monthly & T_hat!=0, filename(tab3b) statistics(count(fmt(%9.0fc)) mean(fmt(%9.2f)) sd(fmt(%9.2f)) p25(fmt(%9.2f)) p75(fmt(%9.2f))) varlabel(episodelength `"Length of non-zero episodes"') footer
