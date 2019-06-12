**********************************************
*Replication code for                        *
*The Effect of Fact-checking on Elites:      *
*A field experiment on U.S. state legislators*
*Brendan Nyhan and Jason Reifler             *
*Forthcoming, AJPS                           *
**********************************************

/*put your working directory here*/
cd "/Users/bnyhan/Documents/Dropbox/Field experiment/Nyhan Reifler field experiment replication"

/*open data*/
use "nyhan-reifler-fe.dta", clear

/*Main text*/

/*Table 1*/
preserve

gen senate=(chamber=="Senate")
collapse (mean) gop senate anycheck fundraising vote partyleader commleader [aweight=aw], by(treatment)
foreach var of varlist gop senate anycheck commleader {
format `var' %9.2f
}

format partyleader %9.2f

foreach var of varlist fundraising vote {
format `var' %9.1f
}
list
restore

/*Figure 1*/
twoway (kdensity voteshare if treatment==1 [aweight=aw]) (kdensity voteshare if treatment==0 [aweight=aw],xtitle("Vote share") ytitle("Kernel density") scheme(s2mono) legend(rows(1) label(1 "Treatment") label(2 "Control") size(*.8)) saving(balance1,replace) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

twoway (kdensity fundraising if treatment==1 [aweight=aw]) (kdensity fundraising if treatment==0 [aweight=aw],xtitle("Fundraising (log)") ytitle("Kernel density") scheme(s2mono) legend(rows(1) label(1 "Treatment") label(2 "Control") size(*.8)) saving(balance2,replace) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

grc1leg balance1.gph balance2.gph, title("",size(*.8)) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) scheme(s2mono) 
rm balance1.gph 
rm balance2.gph

/*Undeliverable letters*/ 
tab anyundeliv if control==0
tab totalundeliv if control==0

/*Legislators in treatment and placebo conditions*/
count if (treatment==1 | placebo==1)
count if missingdistrict==1 /*7 for whom no district mailings could be sent*/

/*Percentage of letters that were undeliverable*/
display 100*(1-(((769*6)+(7*5)+(2*2))-18)/((769*6)+(7*5)+(2*2))) 
/*calculation accounts for seven legislators with no district addresses and two who were removed from mailings after first wave due to complaints (see SM)*/

/*Postcard return difference*/
ttest anypostcard if control==0,by(treatment) unequal

/*Marginals*/
bys treatment: sum falsebinary 
tab falsebinary treatment,column
bys treatment: sum binarychecked 
tab binarychecked treatment,column
bys treatment: sum combined
tab combined treatment,column exact

/*Results for Table 2*/
bys treatment: sum falsebinary [aweight=aw]
bys treatment: sum binarychecked [aweight=aw]
bys treatment: sum combined [aweight=aw]

reg falsebinary treatment [aweight=aw],robust

/*effect sizes as percentages*/
display _b[treatment]*100
display (_b[treatment]/_b[_cons])*100

/*one-sided p-value*/
quietly test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg binarychecked treatment [aweight=aw],robust

/*effect sizes as percentages*/
display _b[treatment]*100
display (_b[treatment]/_b[_cons])*100

/*one-sided p-value*/
quietly test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg combined treatment [aweight=aw],robust

/*effect sizes as percentages*/
display _b[treatment]*100
display (_b[treatment]/_b[_cons])*100

/*one-sided p-value*/
quietly test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

/*Figure 2*/
gen composite=combined*100
graph bar (mean) composite [aweight=aw],over(treatment,label(labsize(*1.4))) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) scheme(s2mono) ylabel(0 "0%" 1 "1%" 2 "2%" 3 "3%",angle(0) labsize(*1.4) nogrid) ymtick(.5 1.5 2.5) ytitle("") legend(rows(1)) text(1.3 77.5 "*",size(*3))

/*Table 3*/
reg ratedbypf treatment  [aweight=aw], robust
reg totalarticles treatment  [aweight=aw], robust
reg html treatment  [aweight=aw], robust

/*Figure 3*/
gen scaledeffect=.0156884/((_n+20)/100) if _n<81 
gen compliance=(_n+20)/100 if _n<81

gen resplabel=""
replace resplabel="Postcard return rate: Treatment condition" if compliance>.209 & compliance<.211
replace resplabel="Postcard return rate: Placebo condition" if compliance>.339 & compliance<.341
replace resplabel="Non-returned mail" if compliance==1 /*rounded - goes .99->1 and nonreturned mail = .996*/

gen resp=scaledeffect if resplabel!=""

twoway (line scaledeffect compliance, graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) scheme(s2mono) ylabel(0 "0%" .02 "-2%" .04 "-4%" .06 "-6%" .08 "-8%", labsize(*.8) nogrid) ymtick(.01(.02).07) ytitle("Effect of reading letter (combined DV)",size(*.8)) xtitle("Percentage of legislators who read treatment letter (unknown)",size(*.8)) xmtick(.1(.2).9) xlabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%",labsize(*.8))) (scatter resp compliance,mlabel(resplabel) legend(off) msymbol(circle) mcolor(black) xscale(r(0 1.2)) mlabsize(*.9))


/*Supporting Materials*/

/*Table S1*/
tab state

/*Missing addresses*/
tab missingcapitol if control==0
tab missingdistrict treatment if control==0

/*Texas rating dates*/
preserve
keep if state=="Texas"
keep name rating1date rating2date rating3date rating4date rating5date 
rename rating1date rating1
rename rating2date rating2
rename rating3date rating3
rename rating4date rating4
rename rating5date rating5
gen i=_n

reshape long rating,i(i) j(ratingnum)
keep if rating!=.
sort rating
format rating %td
sort rating
list if rating>=td(18oct2012) & rating<=td(06nov2012)
restore

/*conditions of Texas legislators rated during that period*/
list state falsebinary treatment placebo control if name=="Kirk Watson"
list state falsebinary treatment placebo control if name=="Jason Isaac"

/*Table S2*/
reg falsebinary placebo [aweight=aw] if treatment==0,robust
reg binarychecked placebo [aweight=aw] if treatment==0,robust
reg combined placebo [aweight=aw] if treatment==0,robust

/*Table S3*/
bys treatment: sum falsebinary2 [aweight=aw]
bys treatment: sum binarychecked [aweight=aw]
bys treatment: sum combined2 [aweight=aw]

reg falsebinary2 treatment [aweight=aw],robust

/*effect sizes as percentages*/
display _b[treatment]*100
display (_b[treatment]/_b[_cons])*100

/*one-sided p-value*/
quietly test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg binarychecked treatment [aweight=aw],robust

/*effect sizes as percentages*/
display _b[treatment]*100
display (_b[treatment]/_b[_cons])*100

/*one-sided p-value*/
quietly test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg combined2 treatment [aweight=aw],robust

/*effect sizes as percentages*/
display _b[treatment]*100
display (_b[treatment]/_b[_cons])*100

/*one-sided p-value*/
quietly test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

/*Table S4*/
reg falsebinary treatment [aweight=aw] if control==0,robust

test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg binarychecked treatment [aweight=aw] if control==0,robust

test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg combined treatment [aweight=aw] if control==0,robust

test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

/*Table S5*/
logit falsebinary treatment,robust
test treatment
local sign_treatment = sign(_b[treatment])
display "H_0: coef<=0  p-value = " normal(`sign_treatment'*sqrt(r(chi2)))
mfx

logit binarychecked treatment,robust
test treatment
local sign_treatment = sign(_b[treatment])
display "H_0: coef<=0  p-value = " normal(`sign_treatment'*sqrt(r(chi2)))
mfx

logit combined treatment,robust
test treatment
local sign_treatment = sign(_b[treatment])
display "H_0: coef<=0  p-value = " normal(`sign_treatment'*sqrt(r(chi2)))
mfx

/*Table S6*/
reg falsebinary treatment i.blockdummy [aweight=aw],robust 
test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg binarychecked treatment i.blockdummy [aweight=aw],robust 
test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg combined treatment i.blockdummy [aweight=aw],robust 
test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

/*Table S7*/
reg falsebinary treatment [aweight=aw],robust cluster(blockdummy)
test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg binarychecked treatment [aweight=aw],robust cluster(blockdummy)
test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))

reg combined treatment [aweight=aw],robust cluster(blockdummy)
test _b[treatment]=0
local sign_treatment = sign(_b[treatment])  
display "Ho: coef >= 0  p-value = " 1-ttail(r(df_r),`sign_treatment'*sqrt(r(F)))
