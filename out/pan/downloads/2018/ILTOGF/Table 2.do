*Table 2: Survey Participation Rates In The Incentive Group vs Control Group
timer clear
timer on 1

cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
*cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use clean_sesExperiment.dta, clear

tab complete, gen(c)
rename (c1 c2 c3)(partialResponse completeResponse noResponse)

table incent, c(mean completeResponse mean partialResponse mean noResponse freq)

*Compute control group percentages and store them in a matrix.
matrix define control = J(1,3, .)
matrix colnames control = "Complete Response" "Partial Response" "No Response"

su completeResponse if incent==0
matrix control[1,1] = round((r(mean)*100), .1)

su partialResponse if incent==0
matrix control[1,2] = round(r(mean)*100, .1)

su noResponse if incent==0
matrix control[1,3] = round(r(mean)*100, .1)

*post the results
ereturn clear
ereturn post control
estadd scalar N = r(N)
eststo control

*Compute control group percentages and store them in a matrix.
matrix define treat = J(1,3, .)
matrix colnames treat = "Complete Response" "Partial Response" "No Response"

su completeResponse if incent==1
matrix treat[1,1] = round((r(mean)*100), .1)

su partialResponse if incent==1
matrix treat[1,2] = round(r(mean)*100, .1)

su noResponse if incent==1
matrix treat[1,3] = round(r(mean)*100, .1)

*post the results
ereturn clear
ereturn post treat
estadd scalar N = r(N)
eststo treat

esttab control treat using table2.rtf, ///
replace b(a1) nonumbers nose not nostar ///
mtitles("Control Group" "Incentive Group")

timer off 1
timer list 1
