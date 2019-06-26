
*/run the analysis on the 21 datasets

clear all
forval num_i = 1/12 {
	use "Data\Replicating\Results\candidate`num_i'.dta", clear
	sort pcperiod pduration
	capture ge entryr=pduration-1
	capture by pcperiod: ge fentryr=entryr[1]
	sleep 2000
	save, replace

	stset  pduration, id(pcperiod) f( peacefailed) en(fentryr)
	eststo: streg  logGDPCap2 gdpgrowth1 lUNexp UNexp_m noUNpeaceop plussfour, nohr robust dist (exponential)
	*eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)
}
esttab
esttab using "Data\Replicating\Results\Analysing_1_12 datasets_nocontroll.rtf", replace

clear all
forval num_i = 13/21 {
	use "Data\Replicating\Results\candidate`num_i'.dta", clear
	sort pcperiod pduration
	capture ge entryr=pduration-1
	capture by pcperiod: ge fentryr=entryr[1]
	sleep 2000
	save, replace

	stset  pduration, id(pcperiod) f( peacefailed) en(fentryr)
	eststo: streg  logGDPCap2 gdpgrowth1 lUNexp UNexp_m noUNpeaceop plussfour, nohr robust dist (exponential)
	*eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)
}
esttab
esttab using "Data\Replicating\Results\Analysing_13_21datasets_nocontroll.rtf", replace

*/Compare the datasets
*/Comparing the datasets*/
use "Data\Original\Data\CHS2008.dta", clear
codebook gwno
codebook warnumb
sort primkey
tab pcens
save, replace

*/How does the candidate dataset's countryyears match CHS?*/
forval num_i = 1/21 {
	sleep 2000
	use "Data\Replicating\Results\candidate`num_i'.dta", clear
	codebook peacefailed	
	codebook gwno
	codebook pcperiod
	sort primkey
	merge primkey using "Data\Original\Data\CHS2008.dta", _merge (gwnoymerge)
	tab gwnoymerge
}

*/How large share of the countries are the same?*/
use "Data\Original\Data\CHS2008.dta", clear
save "Data\Original\Data\CHS2008_2.dta", replace
sort gwno
by gwno: gen n=_n
drop if n>1
sort gwno
save, replace

forval num_i = 1/21 {
	sleep 2000
	use "Data\Replicating\Results\candidate`num_i'.dta", clear
	sort gwno
	by gwno: gen n=_n
	drop if n>1
	sort gwno
	merge gwno using "Data\Original\Data\CHS2008_2.dta", _merge (gwnomerge)
	tab gwnomerge
}
	
*/comparing criterion 1 high with CHS' dataset*/
*/comparing thw two datasets*/

clear all

*/CHS without autonomy and election*/
use "Data\Original\Data\CHS2008.dta", clear
sort warnumb pdur
capture ge entryr=pdur-365
capture by warnumb: ge fentryr=entryr[1]
stset pdur, id(warnumb) f(pcens) en(fentryr)
capture rename lpcgdp_2 logGDPCap2
capture rename dy_1 gdpgrowth1
capture rename d2 plussfour
save, replace
eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)


*/ACD*/
use "Data\Replicating\Results\candidate3.dta", clear
stset  pduration, id(pcperiod) f( peacefailed) en(fentryr)
eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)

*/CHS from dates till year*/
use "Data\Original\Data\CHS2008.dta", clear
sort warnumb year
capture by warnumb: gen peaceduration=_n
sort warnumb peaceduration
capture ge entryr2=peaceduration-1
capture by warnumb: ge fentryr2=entryr2[1]
stset peaceduration, id(warnumb) f(pcens)en(fentryr2)
save, replace 
eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)

*/Influential observations*/
*/ We use efficient score residuals on Cox, and presupposes that the influential observations will be the same when using a peacewise ecponential model*/
*/CHS*/
use "Data\Original\Data\CHS2008.dta", clear
stcox logGDPCap2 gdpgrowth1 plussfour, efron esr(esr*)
capture set matsize 10000
capture mkmat esr1 esr2 esr3, matrix(esr)
capture mat V=e(V)
capture mat Inf=esr*V
capture svmat Inf, names(s)
capture scatter s1 _t, mlab(warnumb) s(i)
capture scatter s2 _t, mlab(warnumb) s(i)

*/None of the observations score above [0.5], and are therefore not considered to be influential*/

*/We perform the same analysis on criterion1-high*/ 
use "Data\Replicating\Results\candidate3.dta", clear
stset pduration, id(pcperiod) f(peacefailed)
stcox logGDPCap2 gdpgrowth1 plussfour, efron esr(esr*)
capture set matsize 10000
capture mkmat esr1 esr2 esr3, matrix(esr)
capture mat V=e(V)
capture mat Inf=esr*V
capture svmat Inf, names(s)
capture scatter s1 _t, mlab(pcperiod) s(i)
capture scatter s2 _t, mlab(pcperiod) s(i)

gen dum36=1 if pcperiod==36
replace dum36=0 if dum36==.
eststo: streg logGDPCap2 gdpgrowth1 dum36 plussfour, nohr robust dist (exponential)

gen dum38=1 if pcperiod==38
replace dum38=0 if dum38==.
eststo: streg logGDPCap2 gdpgrowth1 dum38 plussfour, nohr robust dist (exponential)

*/COW updated*/
use "Data\Replicating\Data\CHS updated.dta", clear
save "Data\Replicating\Data\CHSupd1", replace
gen primkey=(gwno*10000)+year
sort primkey
merge primkey using "Data\Original\Data\GDP Capita WorldBank.dta", keep(gdpgrowth1 logGDPCap2) _merge(gdpmerge)
tab gdpmerge
drop if gdpmerge==2

sort warnumb year
capture by warnumb: gen peaceduration=_n
sort warnumb peaceduration
capture ge entryr2=peaceduration-1
capture by warnumb: ge fentryr2=entryr2[1]
stset peaceduration, id(warnumb) f(pcens)en(fentryr2)

capture drop plussfour
gen plussfour=1 if peaceduration>= 5
replace plussfour=0 if plussfour==.
sort warnumb pdur
capture ge entryr=pdur-365
capture by warnumb: ge fentryr=entryr[1]
capture rename lpcgdp_2 logGDPCap2
capture rename dy_1 gdpgrowth1
capture rename d2 plussfour
stset pdur, id(warnumb) f(pcens) en(fentryr)
eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)
save "Data\Replicating\Data\CHS updated_2.dta", replace


*/only countries that appear in both datasets*/
use "Data\Original\Data\CHS2008.dta", clear
sort gwno
save, replace
use "Data\Replicating\Data\Candidate criterion1_3_part2.dta", clear
sort gwno
merge gwno using "Data\Original\Data\CHS2008.dta"
tab _merge
keep if _merge==3
sort gwno
by gwno: gen n=_n
keep if n==1
keep gwno
save "Data\Replicating\Data\fellesgwno.dta", replace

*/COW*/
use "Data\Replicating\Data\CHS updated_2.dta", clear
sort gwno
merge gwno using "Data\Replicating\Data\fellesgwno.dta"
tab _merge
keep if _merge==3
stset pdur, id(warnumb) f(pcens) en(fentryr)
eststo: streg logGDPCap2 gdpgrowth1 plussfour, nohr robust dist(exponential)

*/ACD*/
use "Data\Replicating\Results\candidate3.dta", clear
sort gwno
merge gwno using "Data\Replicating\Data\fellesgwno.dta"
tab _merge
keep if _merge==3
stset  pduration, id(pcperiod) f( peacefailed) en(fentryr)
eststo: streg  logGDPCap2 gdpgrowth1 plussfour, nohr robust dist (exponential)


*/Only conflicts that appear in both datasets*/
*/COW's start and end dates*/
do "Data\Replicating\Do-file\Mutual conflicts_COW's start and end dates.do"

*/ACD's start and end dates- criterion 1 high*/
do "Data\Replicating\Do-file\Mutual conflicts_ criterion 1-high start and end dates.do"
esttab
esttab using "Data\Replicating\Comparing_datasets.rtf", replace






