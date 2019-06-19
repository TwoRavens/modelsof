*****comparing quit rates, fire rates and turnover rates with training share
***** Table 9

use basefile.dta

keep if typeofschemelastyear == 1 		//only large fims report the reason why an employee left the firm

tsset mark year
gen outsh = outfte/(infte + l.endemplfte)
drop if outsh > 1 &  outsh ~= .

gen outdismsh = outdism/(infte+l.endemplfte)
gen outothsh = outoth/(infte+l.endemplfte)

gen insh = infte/(outfte + endemplfte)
tsset mark year
gen lagendemplfte = l.endemplfte

set more off
xi: xtreg outdismsh l.trainlshare insh l.insh l2.insh i.year, fe
eststo FE_1lag_dism
xi: xtreg outothsh l.trainlshare insh l.insh l2.insh i.year, fe
eststo FE_1lag_oth

xi: xtreg outdismsh l.trainlshare l2.trainlshare insh l.insh l2.insh i.year, fe
eststo FE_2lags_dism
xi: xtreg outothsh l.trainlshare l2.trainlshare insh l.insh l2.insh i.year, fe
eststo FE_2lags_oth

esttab FE_1lag_dism FE_1lag_oth  FE_2lags_dism FE_2lags_oth /*
	*/ , keep(L.trainlshare L2.trainlshare) se star( * 0.10 ** 0.05) b(%9.3g)


