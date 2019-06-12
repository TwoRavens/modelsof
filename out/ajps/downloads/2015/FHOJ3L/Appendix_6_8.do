***REGRESSIONS, USING MATCHING SAMPLE
clear all
use "U:/FEC/Tables1_4.do"
set more off


*******************Treatment Effects*******************

g Treatment1= 1 if TotAds>=1000
	replace Treatment1=0 if TotAds<1000
	replace Treatment1=. if missing(TotAds)	



	
forvalues i==1(1)56{
g StFIPS`i'=.
replace StFIPS`i'=1 if StFIPS==`i'
replace StFIPS`i'=0 if StFIPS!=`i'
}	

drop if NonComp==0
drop if TotalPop==0
gen state=trim(State)
bysort DMAName: egen Overlap=nvals(StFIPS)

g PerCapitaGiving=amount/Pop
label variable PerCapitaGiving "Amount Given Per Person"

g PerCapitaGivingThous=amount/TotalPop
label variable PerCapitaGiving "Amount Given Per Thousand People"

g PercentVoted=(TotVote/1000)/TotalPop

gen lnperout=ln(perout+1)
gen CanCommute=1 if perout>5
replace CanCommute=0 if perout<=5
g logDollars=ln(Cont+.001)
gen stctyfips=StCtyFIPS
destring stctyfips, replace
merge m:1 stctyfips using "U:/FEC/turnout04", gen(mergeturnout)
drop if mergeturnout==2
drop mergeturnout
drop dup

xtset StFIPS
xtlogit Treatment1 Inc PercentHispanic PercentBlack density per_collegegrads, fe or
predict PropScore1, pu0  
*xtreg logDollars Treatment1 Inc PercentHispanic PercentBlack density per_collegegrads, fe robust

psmatch2 Treatment1, outcome(Cont) neighbor(1) cal(.0001)  pscore(PropScore1) common
g Difference=Cont-_Cont if Treatment==1
su Difference, det

/*
keep _n1 Treatment1
drop if _n1==.
save "U:/FEC/nn", replace
clear all
*/
rename _n1 _nnew
rename _id _n1
merge 1:m _n1 using "U:/FEC/nn", gen(mergeNN)
gen Keep=1 if mergeNN==3
replace Keep=1 if Treatment==1

replace _nnew= _n1 if mergeNN==3

*replace Keep=0 if mergeNN==1

gen logTotAds=log(Ads+1)
gen logCont=log(Cont*1000+1)
*replace Inc=ln(Inc)
*gen PercentVoted_04= Total04_sum/(Pop*1000)
*label variable PercentVoted_04 "Voter Turnout 2004"
replace Total04=ln(Total04_sum)
xtset _nnew
reg Cont Treatment i.StFIPS, robust cluster(StDMA) 
eststo
reg Cont Treatment i.StFIPS if CanCommute==0, robust cluster(StDMA) 
eststo
reg Cont Treatment Inc PercentHispanic PercentBlack turnout i.StFIPS , robust cluster(StDMA)
eststo
reg Cont Treatment Inc PercentHispanic PercentBlack turnout   i.StFIPS if CanCommute==0, robust cluster(StDMA)
eststo
reg Cont Treatment i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS.tex", keep(Treatment1) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear
reg Cont Treatment Inc PercentHispanic PercentBlack Pop turnout i.StFIPS , robust cluster(StDMA)
eststo
reg Cont Treatment Inc PercentHispanic PercentBlack Pop turnout   i.StFIPS if CanCommute==0, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS2.tex", se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


reg Cont Ads i.StFIPS, robust cluster(StDMA)
eststo
reg Cont Ads i.StFIPS if CanCommute==0, robust cluster(StDMA)
eststo
reg Cont Ads i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg Cont Ads i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS2.tex", keep(Ads) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


reg logCont logTotAds i.StFIPS, robust cluster(StDMA)
eststo
reg logCont logTotAds i.StFIPS if CanCommute==0, robust cluster(StDMA)
eststo
reg logCont logTotAds i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg logCont logTotAds i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS3.tex", keep(logTotAds) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

replace Cont=Cont*1000
reg Cont logTotAds i.StFIPS, robust cluster(StDMA)
eststo
reg Cont logTotAds i.StFIPS if CanCommute==0, robust cluster(StDMA)
eststo
reg Cont logTotAds i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg Cont logTotAds i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS4.tex", keep(logTotAds) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


reg logCont TotAds i.StFIPS, robust cluster(StDMA)
eststo
reg logCont TotAds i.StFIPS if CanCommute==0, robust cluster(StDMA)
eststo
reg logCont TotAds i.StFIPS if Keep==1, robust cluster(StDMA)
eststo
reg logCont TotAds i.StFIPS if CanCommute==0&Keep==1, robust cluster(StDMA)
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS5.tex", keep(TotAds) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


xtreg logCont logTotAds , robust fe
eststo
xtreg logCont logTotAds if CanCommute==0, robust  fe 
eststo
xtreg logCont logTotAds if Keep==1, robust fe 
eststo
xtreg logCont logTotAds  if CanCommute==0&Keep==1, robust fe 
eststo

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS3.tex", keep(logTotAds) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

reg Cont Treatment i.StFIPS CanCommute, robust cluster(StDMA) 
eststo
reg Cont Treatment Inc PercentHispanic PercentBlack turnout i.StFIPS CanCommute, robust cluster(StDMA)
eststo
reg Cont Treatment i.StFIPS CanCommute if Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS CanCommute if Keep==1, robust cluster(StDMA)
eststo
esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS4.tex", keep(Treatment1) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


xtset StFIPS
*drop PropScore1
xtlogit Treatment1 Inc PercentHispanic PercentBlack density per_collegegrads CanCommute, fe or
predict PropScore2, pu0 
*xtreg logDollars Treatment1 Inc PercentHispanic PercentBlack density per_collegegrads, fe robust

psmatch2 Treatment1, outcome(Cont) neighbor(1) cal(.0001)  pscore(PropScore2) common
g Difference2=Cont-_Cont if Treatment==1
su Difference2, det

/*
replace Cont=Cont/1000
keep _n1 Treatment1
drop if _n1==.
save "U:/FEC/nn2", replace
clear all
*/
replace Cont=Cont/1000
rename _n1 _n2
rename _id _n1
merge 1:m _n1 using "U:/FEC/nn2", gen(mergeNN2)
gen Keep2=1 if mergeNN2==3
replace Keep2=1 if Treatment==1

replace _n2= _n1 if mergeNN2==3

*replace Keep=0 if mergeNN==1

reg Cont Treatment i.StFIPS CanCommute, robust cluster(StDMA) 
eststo
reg Cont Treatment Inc PercentHispanic PercentBlack turnout i.StFIPS CanCommute, robust cluster(StDMA)
eststo
reg Cont Treatment i.StFIPS CanCommute if Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS CanCommute if Keep==1, robust cluster(StDMA)
eststo
reg Cont Treatment i.StFIPS CanCommute if Keep2==1, robust cluster(StDMA)
eststo
reg Cont Treatment turnout i.StFIPS CanCommute if Keep2==1, robust cluster(StDMA)
eststo
esttab using "U:\FEC\SeptemberRevisionsFieldPaper\AppendixOLS4.tex", keep(Treatment1 CanCommute) se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

