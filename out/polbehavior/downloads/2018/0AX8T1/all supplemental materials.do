*Name: Martin Vinæs Larsen*
*Date: June 2018*
*Article: "Is the Relationship between Political Responsibility and Electoral Accountability Causal, Adaptive and Policy-specific?"*
*Reproduces: All supplementary materials. 
*Data: 05rep.dta, 09rep.dta, 13rep.dta (2005, 2009 and 2013 Municipal Election Surveys)*
*Version 15.1*
*Dependencies: blindschemes, latab, estout*

*setting seed for random permutations usedn in (S6)
set seed 9854

**Descriptives (S3)**

*Descriptive statistics 2005*

*opening 2013 municipal election data
use "13rep.dta", clear

*compiling and exporting table
file open anyname using "des2013.txt", write text replace 
file write anyname  _newline  _col(0)  "\begin{table} [htbp] \centering \caption{Descriptive statistics 2013\label{des2013}} \footnotesize \begin{tabular}{l*{6}{c}}\hline\hline"
file write anyname _newline _col(0) "&Mean & SD & Min & Median & Max & n\\ \hline"
foreach x of var muni_res power_may {
su `x', d
file write anyname  _newline  _col(0) (`"`: var label `x''"') "&" _col(25) %9.2f  (r(mean)) " &" _col(45) %9.2f  (r(sd)) " &" _col(65) %9.2f  (r(min)) " &"   _col(85) %9.2f  (r(p50)) " &" _col(105) %9.2f  (r(max)) " &" _col(125) %9.0f  (r(N)) " \\"
}
file write anyname _newline _col(0) "\hline\hline"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname

*Descriptive statistics 2009

*opening 2009 municipal election data
use "09rep.dta", clear

*compiling and exporting table
file open anyname using "des2009.txt", write text replace 
file write anyname  _newline  _col(0)  "\begin{table} [htbp] \centering \caption{Descriptive statistics 2009\label{des2009}} \footnotesize \begin{tabular}{l*{6}{c}}\hline\hline "
file write anyname _newline _col(0) "&Mean & SD & Min & Median & Max & n\\ \hline"
foreach x of var  borg_vote ft_vote reg_vote lv lft_v power_may muni_res unemp treat housing elderly admin localmed natmed age  ideology gov_may educn* employmentn*  {
su `x', d
file write anyname  _newline  _col(0) (`"`: var label `x''"') "&" _col(25) %9.2f  (r(mean)) " &" _col(45) %9.2f  (r(sd)) " &" _col(65) %9.2f  (r(min)) " &"   _col(85) %9.2f  (r(p50)) " &" _col(105) %9.2f  (r(max)) " &" _col(125) %9.0f  (r(N)) " \\"
}
file write anyname _newline _col(0) "\hline\hline"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname

*Descriptive statistics 2005

*opening 2013 municipal election data
use "05rep.dta", clear

*compiling and exporting table
file open anyname using "des2005.txt", write text replace 
file write anyname  _newline  _col(0)  "\begin{table} [htbp] \centering \caption{Descriptive statistics 2005\label{des2005}} \footnotesize \begin{tabular}{l*{6}{c}}\hline\hline "
file write anyname _newline _col(0) "&Mean & SD & Min & Median & Max & n\\ \hline"
foreach x of var informed interest unemp_perf attknow elderly housing ideol dontcare obligated demosat pivotal  {
su `x', d
file write anyname  _newline  _col(0) (`"`: var label `x''"') "&" _col(25) %9.2f  (r(mean)) " &" _col(45) %9.2f  (r(sd)) " &" _col(65) %9.2f  (r(min)) " &"   _col(85) %9.2f  (r(p50)) " &" _col(105) %9.2f  (r(max)) " &" _col(125) %9.0f  (r(N)) " \\"
}
file write anyname _newline _col(0) "\hline\hline"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname

*opening 2009 municipal election data
use "09rep.dta"

*adding value labels to treatment var
label define treat 0 "Control" 1 "Treatment"
label values treat treat

*drawing histogram of distribution across treatment and control
ta unemp treat , nofreq col
hist unem, by(treat, note("") iscale(1)) scheme(plotplain) percent xtitle(, size(medlarge)) ytitle(,size(medlarge)) ///
xlabel(, labsize(medlarge)) ylabel(, labsize(medlarge))  
graph export "distunem.eps", replace


**Manipulation Check (S4)**

*doing tests in 2013
use "13rep.dta", clear
ttest power_may, by(treat)
prtest muni_res, by(treat)

*doing test in 2009
use "09rep.dta", clear
ttest power_may, by(treat)
prtest muni_res, by(treat)

*these numbers were entered manually into the table presented in the manucript

*ALTERNATIVE METHODS OF ESTIMATION (S5)*

*multi-level

*opening 2009 municipal election data
use "09rep.dta",

*storing estimates from multilevel logit models
eststo a: melogit borg_vote (c.unemp)##treat c.admin c.housing c.elderly||muni:, vce(cluster muni)
margins, dydx(unemp) over(treat) post  predict(mu fixedonly)
test _b[0bn.treatment]==_b[1.treatment]
local a=(_b[0bn.treatment])
local b=_b[1.treatment]
local c=r(p)
local d=(_se[0bn.treatment])
local e=_se[1.treatment]
est restore a
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

eststo b: melogit borg_vote (c.unemp)##treat c.admin c.housing c.elderly i.localmed i.natmed i.educ i.employment c.age ||muni:, vce(cluster muni)
margins, dydx(unemp) over(treat) post  predict(mu fixedonly)
test _b[0bn.treatment]==_b[1.treatment]
local a=(_b[0bn.treatment])
local b=_b[1.treatment]
local c=r(p)
local d=(_se[0bn.treatment])
local e=_se[1.treatment]
est restore b
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

eststo c: melogit borg_vote (c.unemp)##treat c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.natmed i.educ i.employment c.age || muni: , vce(cluster muni)
margins, dydx(unemp) over(treat) post  predict(mu fixedonly)
test _b[0bn.treatment]==_b[1.treatment]
local a=(_b[0bn.treatment])
local b=_b[1.treatment]
local c=r(p)
local d=(_se[0bn.treatment])
local e=_se[1.treatment]
est restore c
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

eststo d: melogit borg_vote (c.unemp)##treat c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb || muni: , vce(cluster muni)
margins, dydx(unemp) over(treat) post  predict(mu fixedonly)
test _b[0bn.treatment]==_b[1.treatment]
local a=(_b[0bn.treatment])
local b=_b[1.treatment]
local c=r(p)
local d=(_se[0bn.treatment])
local e=_se[1.treatment]
est restore d
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

*compiling and exporting table
la var borg_vote "%nolabel"
esttab a b c d using multilevel.tex, replace se  label nomtitles b(%9.2f) title(Multi-level logistic regression of probability of voting for the mayoral party} \footnotesize \label{multilevel) ///
varlabel(unemp_perf "Unemployment performance" 1.treatment "Treatment" 1.treatment#c.unemp_perf "Treatment * Unemployment performance" elderly "Elderly performance" housing "Housing performance" administration "Administration controls municipality") ///
stats(t t_se c c_se dif p  ll N, layout(@ (@) @ (@) @ @ @ @) labels("AME (Control)" " " "AME (Treatment)" " " "Difference (T-C)" "\hspace{0.1in} \textit{p-value of difference}" "\hline Log likelihood " "Observations" ) fmt(%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f  %8.0f %8.0f)) ///
addnotes("Robust standard errors clustered on municipality in parentheses." "\sym{+} \(p<0.10\), \sym{*} \(p<0.05\)") star(+  0.1 * 0.05) nonotes ///
keep(unemp_perf 1.treatment 1.treatment#c.unemp_perf elderly housing administration)  

*note that I make some small edits to the design of this table manually, before including it in the manuscript

 
*randomization inference
use 09rep.dta, clear

*Running logit models with randomly drawn treatment variable (NB! takes a long time to compute)*
gen simtreat=0
postfile results a1 a2 a3 a4 b1 b2 b3 b4 using RIres, replace
forvalues i=1/10000 {
*creating random treatment variable
qui{
replace simtreat=0
forvalues z=1/14 {
replace simtreat=1 if muni==int(runiform()*97 +1)
}
*running models
logit borg_vote (c.unemp)##c.simtreat c.admin c.elderly c.housing
local a=_b[c.simtreat#c.unemp_perf]
margins, dydx(unemp) at(simtreat=(0 1)) post
local e=_b[2._at]-_b[1bn._at]
logit borg_vote (c.unemp)##c.simtreat c.admin c.housing c.elderly i.localmed i.natmed i.educ i.employment c.age
local b=_b[c.simtreat#c.unemp_perf]
margins, dydx(unemp) at(simtreat=(0 1)) post
local f=_b[2._at]-_b[1bn._at]
logit borg_vote (c.unemp)##c.simtreat c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.natmed i.educ i.employment c.age 
local c=_b[c.simtreat#c.unemp_perf]
margins, dydx(unemp) at(simtreat=(0 1)) post
local g=_b[2._at]-_b[1bn._at]
logit borg_vote (c.unemp)##c.simtreat c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb
local d=_b[c.simtreat#c.unemp_perf]
margins, dydx(unemp) at(simtreat=(0 1)) post
local h=_b[2._at]-_b[1bn._at]

*posting result of permutations
post results (`a') (`b') (`c') (`d') (`e') (`f') (`g') (`h')
}
di `i'
}
postclose results 
 
*opening dataset with simulations*
use "RIres.dta", clear
*calculating and storing p-values
gen p1=0
replace p1=1 if a1 > 1.00 
su p1
local a=r(mean)
gen ss1="`a'"
gen p2=0
replace p2=1 if a2 > 0.98
su p2
local a=r(mean)
gen ss2="`a'"
gen p3=0
replace p3=1 if a3 > 1.25
su p3
local a=r(mean)
gen ss3="`a'"
gen p4=0
replace p4=1 if a4 > 1.33 
su p4
local a=r(mean)
gen ss4="`a'"


gen p5=0
replace p5=1 if b1 > 0.19
su p5
local a=r(mean)
gen pp1="`a'"
gen p6=0
replace p6=1 if b2 > 0.18
su p6
local a=r(mean)
gen pp2="`a'"
gen p7=0
replace p7=1 if b3 > 0.15
su p7
local a=r(mean)
gen pp3="`a'"
gen p8=0
replace p8=1 if b4 > 0.15
su p8
local a=r(mean)
gen pp4="`a'"
su p*

**imputing means (interaction coefficient and diffrence in AME's from models in table 2)
gen s1=1.003706
gen s2=.9821084 
gen s3=1.3244 
gen s4=1.217201 
gen z1=0.188
gen z2=0.181
gen z3=0.163
gen z4=0.147

sample 10
gen id=_n

reshape long a b s z pp ss, i(id) j(model)

*generating jitter variables for better visualization
gen model2=model+runiform()/4-0.125

*drawing graph
twoway scatter a model2 , msym(Oh) msize(small) mcol(black*0.2) || scatter s model if id==1,  saving(logit, replace) ///
 xlabel(1 "Model 1" 2 "Model 2"  3 "Model 3" 4 "Model 4" , labsize(vlarge)) ///
 scheme(plotplain) mcol(black) msym(O) msize(large)  mlabsize(vlarge) mlab(ss) xtitle(" ") mlabp(12)  ylab(, labsize(vlarge)) legend(off) title("Interaction coefficient", size(vlarge))
twoway scatter b model2 ,  msym(Oh) msize(small) mcol(black*0.2) || scatter z model if id==1, saving(ame, replace) ///
 xlabel(1 "Model 1" 2 "Model 2"  3 "Model 3" 4 "Model 4", labsize(vlarge) ) ///
 scheme(plotplain) mcol(black) msym(O) msize(large) mlabsize(vlarge)  xtitle(" ") mlab(pp) mlabp(12) ylab(, labsize(vlarge))  legend(off) title(Difference in AME, size(vlarge))
graph combine logit.gph ame.gph, scheme(s1mono) xsize(9)

*exporting graph
graph export appendixRI.eps, replace


*DiD analysis (S6)*

*NB. No new analyses, see file "dofile fig 3" for the analysis.

*Analyzing additional policy outcomes(S7)*

*opening municipal election data
use "09rep", clear

*creating temporary file to store estimates
tempfile het
postfile results var gr1 gr2 se p using `het', replace

*producing and saving estimates from different policy outcomes.
foreach i in 4 5 7 10 11 12 13 14 15 16 17  {
quietly{
eststo a: logit borg_vote (c.A`i')##(treat) c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb, vce(cluster muni)
margins, dydx(A`i') at(treat=(0 1)) level(68) post
local se=sqrt(_se[2._at]^2+_se[1bn._at]^2)
test _b[2._at]=_b[1bn._at]
local test=r(p)
post results (`i') (_b[2._at]) (_b[1bn._at]) (`se') (`test')
}
}
postclose results

*opening file with stored etimates
use `het', clear
label var gr1 "Treatment"
label var gr2 "Control"
label var se "SE of difference"
label var p "p-value of difference"

*writing table (edited manually for style in manuscript)
label define perf 4 "Unemployment performance"  5 "Housing"  7 "Daycare" 10 "Recreation" 11 "Schools" 12 "Library" 13 "Culture" 14 "Business" 15 "General services" 16 "Elderly Services" 17 "Health Services", replace
label val var perf
latabstat gr1 gr2 se p, stats(mean) by(var)   format(%9.2f) ///
tf(otheroutcomes) replace  ///
caption(Differences across treatment and control for other policy outcomes) ///
clabel(tab:placebo) 
 
*Increased motivated reasinging, reversed causality (S8)*
use 09rep.dta, clear

*estimating models with lagged mayoral support as the dependent variable, and storing estimates from these models.
eststo a: logit lv (c.unemp)##treat c.admin c.elderly c.housing, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore a
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

eststo b: logit lv (c.unemp)##treat c.admin c.housing c.elderly i.localmed i.educ i.employment c.age, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore b
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace


eststo c: logit lv (c.unemp)##treat  c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore c
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

eststo d: logit lv (c.unemp)##treat  c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore d
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace


*compiling and exporting table
la var lv "%borg"
esttab a b c d using lagtabmodels.tex, replace se  label nomtitles b(%9.2f) title(Logistic regression of voting for the mayoral party at the \emph{last} election} \footnotesize \label{table:lagmodels) ///
keep(unemp_perf 1.treatment 1.treatment#c.unemp_perf elderly housing administration) indicate("\hline Sociodemographic controls=age" "Political controls=ideology" "Municipal level variables=govsupport",labels("$\checkmark$" " ") ) ///
varlabel(unemp_perf "Unemployment performance" 1.treatment "Treatment" 1.treatment#c.unemp_perf "Treatment * Unemployment performance" elderly "Elderly performance" housing "Housing performance" administration "Administration controls municipality") ///
stats(t t_se c c_se dif p r2_p  ll N, layout (@ (@) @ (@) @ @ @ @ @) labels("AME (Control)" " " "AME (Treatment)" " " "Difference (T-C)" "\hspace{0.1in} \textit{p-value of difference}" "\hline Pseudo R$^2$" "Log likelihood " "Observations" ) fmt(%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f  %8.0f %8.0f)) ///
addnotes("Robust standard errors clustered on municipality in parentheses." "\sym{+} \(p<0.10\), \sym{*} \(p<0.05\)") star(+  0.1 * 0.05) nonotes 


