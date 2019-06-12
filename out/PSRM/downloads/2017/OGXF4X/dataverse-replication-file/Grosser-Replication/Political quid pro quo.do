log using "Political quid pro quo.log", replace

// ************************************ Label variables ************************************
use candidatedata.dta, clear
la var transfers "Transfers to candidates are possible"
la def lbtransfer 0 "No transfers" 1 "Transfers", modify
la val transfers lbtransfer
la var matching "Type of matching"
la def lbmatching 0 "Strangers" 1 "Partners", modify
la val matching lbmatching
la var treatment "Type of matching"
la def lbtreatment 0 "Strangers-No transfers" 1 "Strangers-Transfers" 10 "Partners-No transfers" 11 "Partners-Transfers", modify
la val treatment lbtreatment
la var sessions "Session ID"
la var group "Group ID"
la var candidatenum "Candidate number within group (1 or 2)"
la var subject "Candidate ID"
la var part "Part number (each part is 15 periods)"
la var period "Period number within part"
la var periodtotal "Overall period number"
la var transfer "Transfer from rich voter"
la var transferother "Transfer to other candidate from rich voter"
la var transferall "Transfer to both candidates from rich voter"
la var tax "Chosen tax policy"
la var taxother "Other candidate's tax policy"
la var taxavg "Average tax policy"
la var taxchange "Number of times taxes changed before being accepted by candidates"
la var votes "Number of votes received"
la var votesother "Number of votes received by other candidate"
la var win "Winner of the election"
la def lbwin 0 "Loser" 1 "Winner", modify
la val win lbwin
la var taxwin "Winnig tax policy"
la var profit10 "Profit of poor voters"
la var profit130 "Profit of the rich voter"
la var profit "Candidate's profit"
save candidatedata.dta, replace

use voterdata.dta, clear
la var transfers "Transfers to candidates are possible"
la def lbtransfer 0 "No transfers" 1 "Transfers", modify
la val transfers lbtransfer
la var matching "Type of matching"
la def lbmatching 0 "Strangers" 1 "Partners", modify
la val matching lbmatching
la var treatment "Type of matching"
la def lbtreatment 0 "Strangers-No transfers" 1 "Strangers-Transfers" 10 "Partners-No transfers" 11 "Partners-Transfers", modify
la val treatment lbtreatment
la var sessions "Session ID"
la var group "Group ID"
la var subject "Voter ID"
la var type "Type of voter"
la def lbtype 10 "Poor" 130 "Rich", modify
la val type lbtype
la var part "Part number (each part is 15 periods)"
la var period "Period number within part"
la var periodtotal "Overall period number"
la var candidate1 "Candidate 1 ID"
la var candidate2 "Candidate 2 ID"
la var transfer1 "Transfer to candidate 1"
la var transfer2 "Transfer to candidate 2"
la var transferall "Transfer to both candidates"
la var tax1 "Candidate 1's tax policy"
la var tax2 "Candidate 2's tax policy"
la var taxavg "Average tax policy"
la var vote "Vote for candidate"
la var candidatewin "Winner of the election"
la def lbwin 0 "Loser" 1 "Winner", modify
la val candidatewin lbwin
la var taxwin "Winnig tax policy"
la var profit "Voter's profit"
save voterdata.dta, replace

// ************************************ Descriptive statistics ************************************
use candidatedata, clear
gen tax100 = tax == 100
gen taxwin100 = taxwin==100
gen transfer0 = transfer==0
gen irrationalelect = 0
replace irrationalelect = 1 if tax > taxother & taxwin == taxother
replace irrationalelect = 1 if tax < taxother & taxwin == tax
// ** Table 1 – Summary statistics **
tabstat tax tax100 taxwin taxwin100 transfer transfer0 irrationalelect, s(me sd n) by(treatment)

// ************************************ Elections ************************************
use candidatedata, clear
// majority of elections pit two candidates with identical tax policies
gen equaltax = tax == taxother
tabstat equaltax, s(me sd n) by(treatment)
// with different tax policies the higher-tax candidate overwhelmingly wins
gen irrationalelectedifftax = 0 if equaltax == 0
replace irrationalelectedifftax = 1 if tax > taxother & taxwin == taxother & equaltax == 0
replace irrationalelectedifftax = 1 if tax < taxother & taxwin == tax & equaltax == 0
tabstat irrationalelectedifftax, s(me sd n) by(treatment)

// High rates of sincere voting
use voterdata.dta, clear
keep if tax1!=tax2
gen sincerevote = cond(type == 130, vote == 1, vote == 2) if tax1 < tax2
replace sincerevote = cond(type == 130, vote == 2, vote == 1) if tax1 > tax2
gen sincerevote10 = sincerevote if type==10
gen sincerevote130 = sincerevote if type==130
collapse sincerevote*, by(treatment group)
tabstat sincerevote*, s(me sd n) by(treatment)

// ************************************ Tax Policies ************************************
// ** Figure 1 – Tax policies per treatment and society **
use candidatedata.dta, clear
keep tax taxwin treatment group part matching transfers
ren tax tax0
ren taxwin tax1
collapse tax* part matching transfers, by(treatment group)
reshape long tax, i(group part) j(type)
egen taxmeanM = mean(tax), by(type treatment)
egen taxC = count(tax), by(type tax treatment)
gen position = 1 + transfers * 2 + matching * 4
la def lbtax 0 "All tax policies" 1 "Winning tax policies"
la val type lbtax
gsort treatment -tax
graph set window fontface "Times New Roman"
twoway (bar taxmeanM position if type == 0, fcolor(emidblue) lcolor(black) barwidth(1.3)) (bar taxmeanM position if type == 1, fcolor(forest_green) lcolor(black) barwidth(1.3)) (scatter tax position [fweight = taxC], msymbol(circle) mfcolor(cranberry) mlcolor(black) mlwidth(medthick)), text(-16 1 "No Transfers", size(vlarge) place(c)) text(-16 3 "Transfers", size(vlarge) place(c)) text(-16 5 "No Transfers", size(vlarge) place(c)) text(-16 7 "Transfers", size(vlarge) place(c)) ytitle(Percent, size(large)) yscale(range(0 105)) yscale(noline) yline(100, lwidth(thin) lpattern(shortdash) lcolor(gs10)) ylabel(0(20)100, labsize(large) angle(horizontal) nogrid) xtitle("") xscale(range(0 8)) xscale(noline) xlabel(1 "Strangers-" 3 "Strangers-" 5 "Partners-" 7 "Partners-", labsize(vlarge)) by(, note("")) by(, legend(off)) by(, graphregion(margin(0 0 8 0) lcolor(white) fcolor(white))) by(type, rows(1)) subtitle(, margin(bottom) size(huge) nobox) name(meantaxesall, replace) xsize(10) ysize(4) plotregion(margin(sides) lcolor(black))

// ** Compare tax policies across treatments **
use candidatedata, clear
gen r = treatment
xi i.r, noomit prefix(T)

// Tobit regression with the tax policy as the dependent variable (censored at 1) and treatment dummies as independent variables. Nested model with candidate and society random effects, and robust standard errors clustered at the society level.
gen tax_cen = cond(tax >= 100, 1, tax)
gen off = cond(tax >= 100, -100,0)
gen var = cond(tax >= 100, 2, 1)
gllamm tax_cen Tr_0 Tr_1 Tr_10, offset(off) i(subject group) fam(gauss binom) link(ident sprobit) lv(var) fv(var) adapt cluster(group) nolog dots
test Tr_0 = Tr_10
test Tr_0 = Tr_1
test Tr_1 = Tr_10

// Tobit regression with the winning tax policy as the dependent variable (censored at 1) and treatment dummies as independent variables. Nested model with society random effects, and robust standard errors clustered at the society level.
keep if candidatenum == 1
replace tax_cen = cond(taxwin >= 100, 1, taxwin)
replace off = cond(taxwin >= 100, -100,0)
replace var = cond(taxwin >= 100, 2, 1)
gllamm tax_cen Tr_0 Tr_1 Tr_10, offset(off) i(group) fam(gauss binom) link(ident sprobit) lv(var) fv(var) adapt cluster(group) nolog dots
test Tr_0 = Tr_10
test Tr_0 = Tr_1
test Tr_1 = Tr_10

// Conover squared-rank test for variance
local stat = "tax" // change to "wintax" to run the test for winning tax policies
local mgroup = 1 // change depending on the treatment comparision 0=Strangers-No transfers; 1=Strangers-Transfers; 10=Partners-No transfers; 11=Partners-Transfers
local ngroup = 11 // change depending on the treatment comparision 0=Strangers-No transfers; 1=Strangers-Transfers; 10=Partners-No transfers; 11=Partners-Transfers
quietly egen taxM = mean(`stat'), by(treatment)
quietly gen absdifftax = abs(`stat' - taxM)
quietly egen scores = rank(absdifftax) if treatment == `mgroup' | treatment == `ngroup'
quietly replace scores = scores^2
quietly sum scores
local Sumscores = r(sum)
quietly sum scores if treatment == `mgroup'
local mobs = r(N)
local mSumscores = r(sum)
quietly sum scores if treatment == `ngroup'
local nobs = r(N)
local nSumscores = r(sum)
quietly replace scores = scores^2
quietly sum scores
local Sumscores2 = r(sum)
local VarT = (`Sumscores2' - (`Sumscores' * `Sumscores') / (`mobs' + `nobs')) * (`mobs' * `nobs') / ((`mobs' + `nobs') * (`mobs' + `nobs' - 1))
local Zstat = (`mSumscores' - `Sumscores' * `mobs' / (`mobs' + `nobs')) / sqrt(`VarT')
local Pval = 2 * (1 - normal(abs(`Zstat')))
drop scores taxM absdifftax
tabstat `stat' if treatment == `mgroup' | treatment == `ngroup', by(treatment) s(me sd var n)
di "Z statistic: " `Zstat'
di "two-sided p-value: " `Pval'

// ************************************ Tacit agreements and mutual reciprocation ************************************
// ** Compare transfers across treatments **
use voterdata.dta, clear
drop if transfers == 0 | type == 10

// Tobit regression with the total amount transfers to candidates as the dependent variable (censored at 1) and treatment dummies as independent variables. Nested model with voter and society random effects, and robust standard errors clustered at the society level.
gen transfer_cen = cond(transferall <= 0, 0, transferall)
gen var = cond(transferall <= 0, 2, 1)
gllamm transfer_cen matching, i(subject group) fam(gauss binom) link(ident sprobit) lv(var) fv(var) adapt cluster(group) nolog dots

// ** Figure 2 – Transfers and tax policies **
use candidatedata, clear
quietly drop if transfers == 0 | candidatenum==2
quietly gen travg = transferall / 2
quietly collapse travg taxavg taxwin matching, by(group)
ren taxavg tax1
ren taxwin tax2
quietly reshape long tax, i(group) j(type)
la def lbtax 1 "both tax policies" 2 "winning tax policy"
la val type lbtax
la def lbmatch 0 "Strangers" 1 "Partners"
la val matching lbmatch
quietly set obs 60
quietly replace matching = mod(_n,2) if group == .
quietly replace type = mod(round(_n/2,1),2) + 1 if group == .
quietly replace travg = 25 if group == .
quietly tobit tax travg if matching == 0 & type==1, r nolog ul(100)
predict taxgraph01, ystar(.,100)
quietly tobit tax travg if matching == 0 & type==2, r nolog ul(100)
predict taxgraph02, ystar(.,100)
quietly tobit tax travg if matching == 1 & type==1, r nolog ul(100)
predict taxgraph11, ystar(.,100)
quietly tobit tax travg if matching == 1 & type==2, r nolog ul(100)
predict taxgraph12, ystar(.,100)
quietly gen taxgraph = taxgraph01 if matching == 0 & type==1
quietly replace taxgraph = taxgraph02 if matching == 0 & type==2
quietly replace taxgraph = taxgraph11 if matching == 1 & type==1
quietly replace taxgraph = taxgraph12 if matching == 1 & type==2
quietly bysort matching type: egen id = rank(_n)
quietly gen taxarea = 100 * (1 - 25/45) if id==1
quietly replace taxarea = 100 if id==2
quietly gen trarea = 25 if id==1
quietly replace trarea = 0 if id==2
graph set window fontface "Times New Roman"
twoway (area taxarea trarea, fcolor(gs15) lcolor(gs15))(function y = 100 * (1 - x/45), range(travg) lcolor(black) lwidth(medthick)) (function y = 100 * (1 - x/30), range(travg) lcolor(emidblue) lwidth(medthick)) (line taxgraph travg, sort lcolor(forest_green) lwidth(medthick) lpattern(longdash)) (scatter tax travg, sort msize(medlarge) msymbol(circle) mfcolor(cranberry) mlcolor(black) mlwidth(medium)), text(30 9 "Tacit agreements", placement(c) size(medium)) ytitle(Mean tax policy (in percent), size(medsmall)) yscale(noline) ylabel(20(20)100, labsize(small) angle(horizontal) nogrid) xtitle(Mean transfer per candidate (in points), size(medsmall)) xscale(noline) xlabel(0(5)25, labsize(small)) by(, note("")) by(, legend(on span position(6))) legend(order(2 "Break-even" 3 "Split-the-difference" 4 "Best fit") rows(1) size(medsmall) margin(zero) region(margin(zero) lcolor(white)) bmargin(top)) name(taxtransfergroup, replace) xsize(10) ysize(8) by(, graphregion(margin(10 10 0 0) fcolor(white) lcolor(white))) by(match type, imargin(medsmall) rows(2)) subtitle(, size(medlarge) margin(bottom) nobox) plotregion(margin(vsmall) lcolor(black))

// Best fit lines between the average amount transfered to candidates and their tax policies. Tobit regressions with robust standard errors
use candidatedata, clear
gen travg = transferall / 2
collapse travg tax taxwin matching if transfers == 1, by(treatment group)
// In Stangers the best fit lines display statistically insignificant coefficients for all tax policies and for winning tax policies
tobit tax travg if matching == 0, r nolog ul(100)
tobit taxwin travg if matching == 0, r nolog ul(100)
// In Partners there is a clear statistically significant negative relationship between transfers and tax policies
tobit tax travg if matching == 1, r nolog ul(100)
tobit taxwin travg if matching == 1, r nolog ul(100)

// ** Table 2 – Candidates: determinants of tax policy changes in Partners-Transfers **
use candidatedata, clear
keep if transfers == 1 & matching == 1
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10
xtset subject period
gen d_tax = tax - L.tax
gen d_transfer = transfer - L.transfer
gen l_taxdiffpos = max(L.tax - L.taxother, 0) if L.tax < .
gen l_taxdiffneg = max(L.taxother - L.tax, 0) if L.tax < .
gen d_trXperiod = d_transfer * period

// OLS regressions with changes in candidate j’s tax policy from period x-1 to period x as the dependent variable and robust standard errors clustered on societies
// All societies
xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) i(subject) fe
// High-tax and low-tax societies 
xtreg d_tax i.HighTax#c.d_transfer i.HighTax#c.d_trXperiod i.HighTax#c.l_taxdiffpos i.HighTax#c.l_taxdiffneg i.HighTax#c.period, cluster(group) i(subject) fe

// Test differences in coefficients by running a single regression with the appropriate interaction terms
xtreg d_tax i.HighTax##c.d_transfer i.HighTax##c.d_trXperiod i.HighTax##c.l_taxdiffpos i.HighTax##c.l_taxdiffneg i.HighTax##c.period, cluster(group) i(subject) fe

// ** Table 3 – Rich voters: determinants of transfer changes in Partners-Transfers **
use voterdata.dta, clear
keep if transfers == 1 & type == 130 & matching == 1
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10
ren transferall transfer
gen taxlose = taxavg * 2 - taxwin
xtset subject period
gen d_transfer = transfer - L.transfer
gen l_posDtr = L.transfer > L2.transfer if L.transfer < .
gen l_nDXDtax = (1 - l_posDtr) * (L.taxwin - L2.taxwin) if L.transfer < .
gen l_pDXDtax = l_posDtr * (L.taxwin - L2.taxwin) if L.transfer < .
gen l_nDXDtaxl = (1 - l_posDtr) * ((L.taxwin - L.taxlose) - (L2.taxwin - L2.taxlose)) if L.transfer < .
gen l_pDXDtaxl = l_posDtr * ((L.taxwin - L.taxlose) - (L2.taxwin - L2.taxlose)) if L.transfer < .
gen l_pDXDtaxXperiod = l_pDXDtax*period
gen l_nDXDtaxXperiod = l_nDXDtax*period

// OLS regressions with changes in the rich voters’ total transfers from period x-1 to period x as the dependent variable and robust standard errors clustered on societies
// All societies
xtreg d_transfer l_pDXDtax l_pDXDtaxXperiod l_nDXDtax l_nDXDtaxXperiod l_pDXDtaxl l_nDXDtaxl l_posDtr period, cluster(group) i(subject) fe
// High-tax and low-tax societies 
xtreg d_transfer i.HighTax#c.l_pDXDtax i.HighTax#c.l_pDXDtaxXperiod i.HighTax#c.l_nDXDtax i.HighTax#c.l_nDXDtaxXperiod i.HighTax#c.l_pDXDtaxl i.HighTax#c.l_nDXDtaxl i.HighTax#c.l_posDtr i.HighTax#c.period, cluster(group) i(subject) fe

// Test differences in coefficients by running a single regression with the appropriate interaction terms
xtreg d_transfer i.HighTax##c.l_pDXDtax i.HighTax##c.l_pDXDtaxXperiod i.HighTax##c.l_nDXDtax i.HighTax##c.l_nDXDtaxXperiod i.HighTax##c.l_pDXDtaxl i.HighTax##c.l_nDXDtaxl i.HighTax##c.l_posDtr i.HighTax##c.period, cluster(group) i(subject) fe

// ************************************ Tacit agreements and earnings ************************************
use candidatedata, clear
// Mean earnings per role and treatment
gen profitnet = 25 + 20 * win + transfer if transfers == 1
replace profitnet = 25 + 20 * win if transfers == 0
gen changecostper = 100 * (profit - 20 * win - 25 - cond(transfers == 0, 0, transfer) ) / profit
tabstat profit* changecostper, s(me sd n) by(treatment)
// For high-tax and low-tax societies
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10 & treatment == 11
tabstat profit* changecostper if treatment == 11, s(me sd n) by(HighTax)

// Earnings treatment comparisions with Wilcoxon signed-ranks tests using society means as the unit observations.
collapse profit* HighTax part, by(treatment matching transfers group)
reshape wide profit*, i(group part) j(transfers)
collapse profit* HighTax matching, by(group)
// Candidates
signrank profit0 = profit1 if matching==0
signrank profit0 = profit1 if matching==1
// Poor voters
signrank profit100 = profit101 if matching==0
signrank profit100 = profit101 if matching==1
// Rich voters
signrank profit1300 =  profit1301 if matching==0
signrank profit1300 =  profit1301 if matching==1
bysort HighTax: signrank profit1300 =  profit1301 if matching==1

// ************************************ Supporting Information: Additional Statistical Analysis ************************************

// ** Nonparametric Tests **
// Tax policies
use candidatedata.dta, clear
collapse tax matching transfers part, by(treatment group)
fprank tax if transfers==0, by(treatment)
fprank tax if transfers==1, by(treatment)
reshape wide tax, i(group part) j(transfers)
collapse tax* matching, by(group)
signrank tax0 = tax1 if matching==0
signrank tax0 = tax1 if matching==1

// Winning tax policies
use candidatedata.dta, clear
collapse taxwin matching transfers part, by(treatment group)
fprank taxwin if transfers==0, by(treatment)
fprank taxwin if transfers==1, by(treatment)
reshape wide taxwin, i(group part) j(transfers)
collapse taxwin* matching, by(group)
signrank taxwin0 = taxwin1 if matching==0
signrank taxwin0 = taxwin1 if matching==1

// Transfers
use candidatedata.dta, clear
collapse transfer matching part if transfers == 1, by(treatment group)
fprank transfer, by(treatment)

// ** Reciprocity in Transfers-Strangers **
// Table A1 – Determinants of changes in tax policies in Transfers-Strangers
use candidatedata, clear
keep if transfers == 1 & matching == 0
egen round = rank(period), by(subject)
xtset subject round
gen d_tax = tax - L.tax
gen d_transfer = transfer - L.transfer
gen l_taxdiffpos = max(L.tax - L.taxother, 0) if L.tax < .
gen l_taxdiffneg = max(L.taxother - L.tax, 0) if L.tax < .
gen d_trXperiod = d_transfer * period
gen id = group * 10 + candidatenum
xtset id period
gen d_taxALT = tax - (L.tax + L.taxother)/2
gen d_transferALT = transfer - L.transferall/2
gen d_trALTXperiod = d_transferALT * period 
gen l_taxdiffALT = abs(L.taxother - L.tax)
egen cand1 = sum(subject * (candidatenum == 1) ), by(group period)
egen cand2 = sum(subject * (candidatenum == 2) ), by(group period)
gen l_played = L.cand1 == subject | L.cand2 == subject if L.cand1<.
replace d_transferALT = 0 if l_played == 1
replace d_trALTXperiod = 0 if l_played == 1
replace l_taxdiffALT = 0 if l_played == 1

// OLS regression with changes in candidate j’s tax policy from period x-d to period x as the dependent variable and robust standard errors clustered on societies
xtreg d_tax d_transfer d_trXperiod d_transferALT d_trALTXperiod l_taxdiffpos l_taxdiffneg l_taxdiffALT period, cluster(group) i(subject) fe

// Alternate OLS regression with the difference between the tax policy chosen by candidate j in period x and the mean tax policy chosen in period x-1 as the dependent variable
xtreg d_taxALT d_transferALT d_trALTXperiod d_transfer d_trXperiod l_taxdiffALT l_taxdiffpos l_taxdiffneg period if l_played==0, cluster(group) i(group) fe

// Table A2 – Determinants of changes in transfers in Transfers-Strangers
use voterdata.dta, clear
keep if transfers == 1 & type == 130 & matching == 0
ren transferall transfer
gen taxlose = taxavg * 2 - taxwin
bysort subject: egen round = rank(period)
xtset subject round
gen d_transfer = transfer - L.transfer
gen l_posDtr = L.transfer > L2.transfer if L.transfer < .
gen l_nDXDtax = (1 - l_posDtr) * (L.taxwin - L2.taxwin) if L.transfer < .
gen l_pDXDtax = l_posDtr * (L.taxwin - L2.taxwin) if L.transfer < .
gen l_nDXDtaxl = (1 - l_posDtr) * ((L.taxwin - L.taxlose) - (L2.taxwin - L2.taxlose)) if L.transfer < .
gen l_pDXDtaxl = l_posDtr * ((L.taxwin - L.taxlose) - (L2.taxwin - L2.taxlose)) if L.transfer < .

// Own experience: OLS regression with the change in the rich voters’ total transfers from period x-d_1 to period x as the dependent variable and robust standard errors clustered on societies
xtreg d_transfer l_posDtr l_pDXDtax l_nDXDtax l_pDXDtaxl l_nDXDtaxl period, i(group) cluster(group) fe

xtset group period
gen d_transferALT = transfer - L.transfer/2
gen l_posDtrALT = L.transfer > L2.transfer if L.transfer < .
gen l_nDXDtaxALT = (1 - l_posDtr) * (L.taxwin - L2.taxwin) if L.transfer < .
gen l_pDXDtaxALT = l_posDtr * (L.taxwin - L2.taxwin) if L.transfer < .
gen l_nDXDtaxlALT = (1 - l_posDtr) * ((L.taxwin - L.taxlose) - (L2.taxwin - L2.taxlose)) if L.transfer < .
gen l_pDXDtaxlALT = l_posDtr * ((L.taxwin - L.taxlose) - (L2.taxwin - L2.taxlose)) if L.transfer < .

// Other's experience: OLS regression with the change in the rich voters’ total monetary transfers from period x-1 to period x as the dependent variable and robust standard errors clustered on societies
xtreg d_transferALT l_posDtrALT l_pDXDtaxALT l_nDXDtaxALT l_pDXDtaxlALT l_nDXDtaxlALT period if matching==0,  i(group) cluster(group) fe

log close
