
use "C:\Users\alexgkuo\Dropbox\Spain Income Perception Study\Analyses\PSRM Inc Study Replication Code Nov 2015\Fernandez-Albertos Kuo PSRM Inc Study Data.dta", clear

*Note graph reproduction requires installation of: ciplot.ado

*Recode female binary*
recode female 1=0 2=1
label define female 0 "male" 1 "female"
label values female female
rename female female

*Recode education terciles*
recode educ 1/3=1 4/6=2 7/11=3 12=., gen(educ_3)
tab educ_3

*Recode unemployment binary*
recode lmstatus 1/2=0 3/4=1 5/7=0, gen(unemployed)
tab unemployed

*Generate income quintile
recode decile 1/2=1 3/4=2 5/6=3 7/8=4 9/10=5, gen(quintile)

*Label deciles
label define decile 1 "1-poorer" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10-richer"
label values decile decile
label values decile perceived_decile

*Recode missing ideology indicators*
gen ideology=ideo if ideo<11

*Generate perceived decile
recode relinc_lower 0/10=1 10/20=2 20/30=3 30/40=4 40/50=5 ///
50/60=6 60/70=7 70/80=8 80/90=9 90/100=10, gen(perceived_decile) 

*Generate difference between real and perceived deciles
gen difference=decile-perceived_decile
label variable difference "Real decile-Perceived decile"

*Generate variables indicating priors of richer or poorer than prior
gen richer=0
replace richer=1 if difference>0
label var richer "Resp is actually richer than thought"

gen poorer=0
replace poorer=1 if difference<0
label var poorer "Resp is actually poorer than thought"

gen right=0
replace right=1 if difference==0
 
*Generate mean tax measure to derive inc concentration
gen meantax=(tax_1200+tax_2100+tax_3400+tax_10000)/4
label var meantax "mean tax on all inc groups"

*Deriving Kakwani/Concentration measures, preserving baseline directionality of preferences
gen concentration=(.25*tax_1200*.125)+(.25*tax_2100*.375)+(.25*tax_3400*.625)+(.25*tax_10000*.875) if (tax_1200<=tax_2100 & tax_2100<= tax_3400 & tax_3400<=tax_10000)
replace concentration=(2*concentration)/meantax
replace concentration=concentration-1
label var concentration "Kakwani concentration"

*Generate log ratio of highest to lowest income tax rates, preventing listwise deletion of data with baseline directionality of preferences
gen tax_1200_nm=tax_1200
replace tax_1200_nm=1 if tax_1200==0
gen logratio=log(tax_10000/tax_1200_nm) if (tax_1200<=tax_2100 & tax_2100<= tax_3400 & tax_3400<=tax_10000)

*Generate inc treatment indicators
tabulate inc_treat, generate(inc_treat_bi)

label define inc_treat_bi1 0 "other" 1 "control" 
label values inc_treat_bi1 inc_treat_bi1

label define inc_treat_bi2 0 "other" 1 "primed" 
label values inc_treat_bi2 inc_treat_bi2

label define inc_treat_bi3 0 "other" 1 "primed&informed" 
label values inc_treat_bi3 inc_treat_bi3

*Generate binary variables for perceive poor v perceived rich
gen ppoor=0
replace ppoor=1 if perceived_decile<6

gen prich=0
replace prich=1 if perceived_decile>5

*Generate relevant interaction terms for learning
gen learnpoorer=inc_treat_bi3*poorer
gen learnricher=inc_treat_bi3*richer
gen learncorrect=right*inc_treat_bi3

*Generating interaction of treatment in info group & amount learned
gen learn_amt = inc_treat_bi3*difference
tab learn_amt
label var learn_amt "info treatment x difference"

*END VARIABLE GENERATION*

*REPRODUCING TABLES

*reproducing Table 2: Explaining Perceived Income Decile
reg perceived_decile decile [iweight=catweight]
est sto M1

reg perceived_decile decile ideology age female unemployed hhsize educ_3  [iweight=catweight]
est sto M2

reg perceived_decile decile ideology age female  unemployed hhsize educ_3  inc_treat_bi2 inc_treat_bi3 [iweight=catweight]
est sto M3

esttab M1 M2 M3 using table2.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 3: Explaining Preferences for Tax Progressivity in the Control Group
reg logratio decile perceived_decile ideology age female unemployed hhsize educ_3  if inc_treat==1 [iweight=catweight]
est sto M1 

reg concentration decile perceived_decile ideology  age female  unemployed hhsize educ_3  if inc_treat==1 [iweight=catweight]
est sto M2 

esttab M1 M2 using table3.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 4: Baseline directional learning effects
reg logratio inc_treat_bi3 decile age female  educ_3 unemployed if inc_treat>1 & poorer==1  [iweight=catweight]
est sto M1

reg logratio inc_treat_bi3 decile age female  educ_3 unemployed if inc_treat>1 & richer==1  [iweight=catweight]
est sto M2

reg logratio inc_treat_bi3 decile age female  educ_3 unemployed if inc_treat>1 & right==1  [iweight=catweight]
est sto M3

reg concentration inc_treat_bi3 decile age female  educ_3 unemployed if inc_treat>1 & poorer==1  [iweight=catweight]
est sto M4

reg concentration inc_treat_bi3 decile age female  educ_3 unemployed if inc_treat>1 & richer==1  [iweight=catweight]
est sto M5

reg concentration inc_treat_bi3 decile age female  educ_3 unemployed  if inc_treat>1 & right==1 [iweight=catweight]
est sto M6

esttab M1 M2 M3 M4 M5 M6 using Table4_baseline.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 5: Information Effects Conditioning on Priors of Being Poor
reg logratio inc_treat_bi3 poorer learnpoorer if inc_treat>1 & ppoor==1 [iweight=catweight]
est sto M1

reg logratio inc_treat_bi3 poorer learnpoorer decile age female  educ_3 unemployed  if inc_treat>1 & ppoor==1 [iweight=catweight]
est sto M2

reg concentration inc_treat_bi3 poorer learnpoorer if inc_treat>1 & ppoor==1 [iweight=catweight]
est sto M3

reg concentration inc_treat_bi3 poorer learnpoorer decile age female  educ_3 unemployed  if inc_treat>1 & ppoor==1 [iweight=catweight]
est sto M4

esttab M1 M2 M3 M4 using Table5priors_poor.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 6: Information Effects Conditioning on Priors of Being Rich
reg logratio inc_treat_bi3 richer learnricher if inc_treat>1 & prich==1 [iweight=catweight]
est sto M1

reg logratio inc_treat_bi3 richer learnricher decile age female  educ_3 unemployed  if inc_treat>1 & prich==1 [iweight=catweight]
est sto M2

reg concentration inc_treat_bi3 richer learnricher if inc_treat>1 & prich==1 [iweight=catweight]
est sto M3

reg concentration inc_treat_bi3 richer learnricher decile age female  educ_3 unemployed  if inc_treat>1 & prich==1 [iweight=catweight]
est sto M4

esttab M1 M2 M3 M4 using Table6priors_rich.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 7: Effect of Magnitude of Learning on Progressivity Preferences
reg logratio inc_treat_bi3 difference learn_amt right learncorrect  if inc_treat>1 [iweight=catweight]
est sto M1

reg logratio inc_treat_bi3 difference learn_amt right learncorrect decile age female  educ_3 unemployed  if inc_treat>1 [iweight=catweight]
est sto M2

reg concentration inc_treat_bi3 difference learn_amt right learncorrect if inc_treat>1 [iweight=catweight]
est sto M3

reg concentration inc_treat_bi3 difference learn_amt right learncorrect decile  age female  educ_3 unemployed  if inc_treat>1 [iweight=catweight]
est sto M4

esttab M1 M2 M3 M4 using Table7_magnitude.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 8: Effect of Information Treatment on Support for Rich/Poor Tax Ratio, by Income Quintile
reg logratio inc_treat_bi3 age female educ_3 unemployed if quintile==1 & inc_treat>1 [iweight=catweight] 
est sto M1

reg logratio inc_treat_bi3 age female educ_3 unemployed if quintile==2 & inc_treat>1 [iweight=catweight] 
est sto M2

reg logratio inc_treat_bi3 age female educ_3 unemployed if quintile==3 & inc_treat>1 [iweight=catweight] 
est sto M3

reg logratio inc_treat_bi3 age female educ_3 unemployed if quintile==4 & inc_treat>1 [iweight=catweight] 
est sto M4

reg logratio inc_treat_bi3 age female educ_3 unemployed if quintile==5 & inc_treat>1 [iweight=catweight] 
est sto M5

esttab M1 M2 M3 M4 M5 using Table8_quintilelogratio.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*reproducing Table 9: Effect of Information Treatment on Kakwani Concentration Coefficient, by Income Quintile
reg concentration  inc_treat_bi3 age female educ_3 unemployed if quintile==1 & inc_treat>1 [iweight=catweight] 
est sto M1

reg concentration  inc_treat_bi3 age female educ_3 unemployed if quintile==2 & inc_treat>1 [iweight=catweight] 
est sto M2

reg concentration  inc_treat_bi3 age female educ_3 unemployed if quintile==3 & inc_treat>1 [iweight=catweight] 
est sto M3

reg concentration  inc_treat_bi3 age female educ_3 unemployed if quintile==4 & inc_treat>1 [iweight=catweight] 
est sto M4

reg concentration  inc_treat_bi3 age female educ_3 unemployed if quintile==5 & inc_treat>1 [iweight=catweight] 
est sto M5

esttab M1 M2 M3 M4 M5 using Table9_quintileconc.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01) 

*REPRODUCING FIGURES
*reproducing Figure 1: Distribution of Self-Perceived Income Decile and Actual Income Decile
twoway histogram perceived_decile, percent discrete start(1) barw(.6) bfcolor(gs10) blcolor(gs10) || ///
histogram decile, percent start(1) discrete blcolor(gs1) barw(0.9) bfcolor(none) ///
xlabel(1 "Poorer" 2 3 4 5 6 7 8 9 10 "Richer") legend(label(1 "Perceived") label(2 "Actual")) 

*reproducing Figure 2: Average Perceived Decile by Income Group
gr bar perceived_decile, over(decile, relabel(1 "Poorer" 10 "Richer")) ///
blabel(bar, format(%9.2f)) ytitle("Mean perceived decile") aspect(1)

*reproducing Figure 3a, Information effects and priors, Perceived Income Above Median, left panel
set scheme s1mono

ciplot logratio if difference<0 & perceived_decile>5 & inc_treat>1,  ///
 by(inc_treat) xlabel(2 "Non-treated" 5 "Treated") ///  
level(95) ylabel(1.25 1.5 1.75 2) ytitle("Ratio TaxRich/TaxPoor (log)") xtitle("") subtitle("Poorer than thought") ///
legend(off) 

*reproducing Figure 3a, Information effects and priors, Perceived Income Above Median, right panel
set scheme s1mono

ciplot logratio if difference>0 & perceived_decile>5 & inc_treat>1,  ///
 by(inc_treat) xlabel(2 "Non-treated" 5 "Treated") ///  
level(95) ylabel(1.25 1.5 1.75 2) ytitle("Ratio TaxRich/TaxPoor (log)") xtitle("") subtitle("Richer than thought")

*reproducing Figure 3b, Information effects and priors, Perceived Income Below Median, left panel
set scheme s1mono

ciplot logratio if difference<0 & perceived_decile<6 & inc_treat>1,  ///
 by(inc_treat) xlabel(2 "Non-treated" 5 "Treated") ///  
level(95) ylabel(1.25 1.5 1.75 2) ytitle("Ratio TaxRich/TaxPoor (log)") xtitle("") subtitle("Poorer than thought")

*reproducing Figure 3b, Information effects and priors, Perceived Income Below Median, right panel
set scheme s1mono

ciplot logratio if difference>0 & perceived_decile<6 & inc_treat>1,  ///
 by(inc_treat) xlabel(2 "Non-treated" 5 "Treated") ///  
level(95) ylabel(1.25 1.5 1.75 2) ytitle("Ratio TaxRich/TaxPoor (log)") xtitle("") subtitle("Richer than thought")

*reproducing Figure 4, Information effects by income quintile, Preferences for tax progressivity by income quintile, left panel
set scheme s1mono

ciplot logratio if inc_treat==2, ylabel(1.25 1.5 1.75 2) by(quintile) ytitle("Ratio TaxRich/TaxPoor (log)") ///
subtitle("Untreated") level(90) note("") xtitle("")

*reproducing Figure 4, Information effects by income quintile, Preferences for tax progressivity by income quintile, right panel

ciplot logratio if inc_treat==3, ylabel(1.25 1.5 1.75 2) by(quintile) ytitle("Ratio TaxRich/TaxPoor (log)") ///
subtitle("Treated") level(90) note("") xtitle("")

*REPRODUCING APPENDIX TABLES
*Reproducing appendix A

sum logratio
sum concentration
sum decile
sum perceived_decile
sum ideology
sum age
sum unemployed
sum hhsize
sum educ_3

*Reproducing appendix B
gen absdiff=difference
replace absdiff=(-1*difference) if difference<0

reg absdiff decile ideology age female unemployed hhsize educ_3  [iweight=catweight]
est sto M1

reg absdiff decile ideology age female unemployed hhsize educ_3 inc_treat_bi2 inc_treat_bi3 [iweight=catweight]
est sto M2

esttab M1 M2 using appendixb.rtf, replace b(a2) se(a2) r2 se star(* 0.10 ** 0.05 *** 0.01)

*END REPRODUCTION FILE
