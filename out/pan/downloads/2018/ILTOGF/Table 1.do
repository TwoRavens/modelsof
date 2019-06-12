*Table 1
timer clear
timer on 1
*cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use clean_sesExperiment.dta, clear

*Store the register covariates
local covariates male age age1824 age2534 age3544 age4554 age5564 age6574 age75p ///
german french italian centCityAgg othMunicAgg isolatedTown ruralMunic popGT100k pop50_lt100 pop20_lt50 pop10_lt20 pop5_lt10 pop2_lt5 pop1_lt2 poplt1k ///
gr_reg_lemanique gr_espace_mittelland gr_northwest gr_zurich gr_ostschweiz gr_zentralschweiz gr_ticino


*Compute Means and SD for the control arm.

mean `covariates'  if incentive==0
estat sd
eststo control
matrix cmeans = r(mean)'
matrix csd = r(sd)'
ereturn list
local Nc = e(N)



*Compute Means and SD for the treatment arm.
mean `covariates'  if incentive==1
estat sd
eststo treat
matrix tmeans = r(mean)'
matrix tsd = r(sd)'
ereturn list
local Nt = e(N)

*Compute mean difference and post them to e()
matrix meanDiff = (tmeans - cmeans)'
matrix list meanDiff
ereturn clear
ereturn post meanDiff
eststo meanDiff
local Ntot = `Nt' + `Nc'
estadd scalar N = `Ntot'

*Compute Mean Difference
svmat tmeans 
svmat cmeans
gen meanDiff = tmeans - cmeans
keep tmeans cmeans meanDiff
drop if tmeans == .

*Compute Pooled Variance
svmat tsd
svmat csd 
gen cvar = csd^2
gen tvar = tsd^2
gen poolSD = sqrt((cvar + tvar)/2)
 
*Compute Cohen's D 
gen dstat = abs(meanDiff / poolSD)
mkmat dstat
matrix d = dstat'
matrix colnames d = `covariates'
ereturn clear
ereturn post d
eststo cohensD
estadd scalar N = `Ntot'

*Make  Table 1
esttab treat control meanDiff cohensD using table1.rtf, replace nostar not nose nonumbers ///
mtitles("Incentive" "Control" "Mean Diff" "Cohen's D")

timer off 1
timer list 1

