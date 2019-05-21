clear all 
clear matrix

set mem 600M
set matsize 2500
set maxvar 5000
use "U:/FEC/AJPS/Table6.dta"


merge m:1 zip using "U:\FEC\ZipWorkInState_forCarly", gen(MergeCommuting)
drop if _merge==2
gen CanCommute=1 if perout>5
replace CanCommute=0 if perout<=5

gen logCumAds=log(Cumulative+1)
drop if TotalPop==0

*Lets see which ones are all zeros:
bysort zip: egen ElectionConts=sum(TotConts)
gen ZeroConts=1 if ElectionConts==0
replace ZeroConts=0 if ElectionConts>0&ElectionConts!=.

gen logAmount=log(TotAmount+1)



gen PerCapitaDollars=TotAmount/TotalPop

gen Percent2=(JulyAmount-JuneAmount)/((JuneAmount+JulyAmount)/2) if month==7
replace Percent2=(AugAmount-JulyAmount)/((AugAmount+JulyAmount)/2) if month==8
replace Percent2=(SeptAmount-AugAmount)/((AugAmount+SeptAmount)/2) if month==9
replace Percent2=(OctAmount-SeptAmount)/((OctAmount+SeptAmount)/2) if month==10
replace Percent2=0 if Percent2==.&month!=6&ZeroConts!=1&AllAds>100 


gen logTotAds=log(TotAds+1)

g June=1 if month==6
replace June=0 if month!=6
g July=1 if month==7
replace July=0 if month!=7
g Aug=1 if month==8
replace Aug=0 if month!=8
g Sept=1 if month==9
replace Sept=0 if month!=9
g Oct=1 if month==10
replace Oct=0 if month!=10

gen SqrtAds=TotAds^(.5)
gen Treatment=1 if TotAds>100
replace Treatment=0 if TotAds<=100
 
*****VERY GOOD*****ONLY FOR THOSE WHO EVER GET ADS
destring zip, replace
xtset zip
xtreg TotAmount logTotAds July Aug Sept Oct if AllAds>100, fe robust cluster(StDMA)
eststo
xtreg TotAmount logTotAds July Aug Sept Oct if AllAds>100&CanCommute==0, fe robust cluster(StDMA)
eststo

xtreg logAmount logTotAds July Aug Sept Oct if AllAds>100, fe robust cluster(StDMA)
eststo
xtreg logAmount logTotAds July Aug Sept Oct if AllAds>100&CanCommute==0, fe robust cluster(StDMA)
eststo

xtreg TotAmount logCumAds July Aug Sept Oct if AllAds>100, fe robust cluster(StDMA)
eststo
xtreg TotAmount logCumAds July Aug Sept Oct if AllAds>100&CanCommute==0, fe robust cluster(StDMA)
eststo

xtreg logAmount logCumAds July Aug Sept Oct if AllAds>100, fe robust cluster(StDMA)
eststo
xtreg logAmount logCumAds July Aug Sept Oct if AllAds>100&CanCommute==0, fe robust cluster(StDMA)
eststo

/*
areg TotAmount Treatment Aug Sept Oct if AllAds>=100 & ElectionConts!=0, a(zip) robust cluster(StDMA)
eststo
areg logAmount Treatment Aug Sept Oct if AllAds>=100& ElectionConts!=0, a(zip) robust cluster(StDMA)
eststo
*/


esttab using "U:\FEC\SeptemberRevisionsFieldPaper\Table6.tex", se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear



