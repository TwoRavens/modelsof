

use "ESS1-7e01.dta" 


*Generation of year variables* 
generate year=.
replace year=2002 if essround==1
replace year=2004 if essround==2
replace year=2006 if essround==3
replace year=2008 if essround==4
replace year=2010 if essround==5
replace year=2012 if essround==6
replace year=2014 if essround==7


*Merging the country level dataset with the ESS data*

merge m:m cntry year using "World1980-2014.dta"


*Generation of countrynumerical* 
encode cntry, gen (ncountry)


*Coding of individual level information* 

*Voted in last election*
generate votedlast= 0
replace votedlast=1 if vote==1
replace votedlast=. if vote==. 


*Married*
generate married=0
replace married=1 if marital==1
replace married=1 if maritala==1
replace married=1 if maritalb==1


*Unemployed*
generate unemployed=0
replace unemployed=1 if uempla==1|uempli==1

*Age squared*

generate squared= age^2


*Income deciles* 

generate hinctnt10point= hinctnt/12*10

generate incomedecile=.
replace incomedecile= hinctnta if hinctnt==.
replace incomedecile= hinctnt10point if hinctnta==. 



*Coding of country level information* 


*Generation of number of parties*

*Existence of 2. government party*
generate egovparty2=0
replace egovparty2=1 if gov2seat !=.

*Existence of 3. government party*
generate egovparty3=0
replace egovparty3=1 if gov3seat !=.


*Existence of 1. opposition party*
generate eoppparty1=0
replace eoppparty1=1 if opp1seat !=.

*Existence of 2. opposition party*
generate eoppparty2=0
replace eoppparty2=1 if opp2seat !=.

*Existence of 1. opposition party*
generate eoppparty3=0
replace eoppparty3=1 if opp3seat !=.



*Total number of parties (treats independent legislators as parties)*
generate totalnumberofparties= 1+egovparty2 + egovparty3 + eoppparty1 + eoppparty2 + eoppparty3 + govoth + oppoth + ulprty



*Generation of chiefexecutiveelection dummy*
generate chiefexecutiveelection=0
replace chiefexecutiveelection=1 if presidentialsystem==0 & legelec==1
replace chiefexecutiveelection=1 if presidentialsystem==1 & exelec==1
replace chiefexecutiveelection=. if legelec==. | exelec==. 

*Generation of dummy for expenditure rule with statuary or constitutional basis*
generate statconER=0
replace statconER=1 if er== 1 & legal_n_er==3 |er== 1 & legal_n_er==5
replace statconER=. if er==.

*Generation of dummy for revenue rule with statuary or constitutional basis*
generate statconRR=0
replace statconRR=1 if rr== 1 & legal_n_rr==3 |rr== 1 & legal_n_rr==5
replace statconRR=. if rr==.

*Generation of dummy for balanced budget rule with statuary or constitutional basis*
generate statconBBR=0
replace statconBBR=1 if bbr== 1 & legal_n_bbr==3 |bbr== 1 & legal_n_bbr==5
replace statconBBR=. if bbr==.



*Generation of dummy for debt rule with statuary or constitutional basis*
generate statconDR=0
replace statconDR=1 if dr== 1 & legal_n_dr==3 |dr== 1 & legal_n_dr==5
replace statconDR=. if dr==.


*Generation of IMF national expenditure rules index* 
*Rescale cover of expenditure rule*
generate cover_n_er2= cover_n_er/2

*Rescale legal scope of expenditure rule*
generate legal_n_er2= legal_n_er/5

*generation of Expenditure rules strenght index* 
generate ER_n_strengh = cover_n_er2 + legal_n_er2 + enforce_n_er + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n


*Rescale cover of revenue rule*
generate cover_n_rr2= cover_n_rr/2

*Rescale legal scope of revenue rule*
generate legal_n_rr2= legal_n_rr/5

*generation of revenue rules strenght index*
generate RR_n_strengh= cover_n_rr2 + legal_n_rr2 + enforce_n_rr + frl + suport_budg_n + suport_impl_n

*Rescale cover of balanced budget rule*
generate cover_n_bbr2=cover_n_bbr/2

*Rescale legal scope of balanced budget rule*
generate legal_n_bbr2= legal_n_bbr/5

*generation of balanced budget rules strenght index*
generate BBR_n_strengh= cover_n_bbr2 + legal_n_bbr2 + enforce_n_bbr + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n

*Rescale cover of debt rule*
generate cover_n_dr2= cover_n_dr/2

*Rescale legal scope of debt rule*
generate legal_n_dr2= legal_n_dr/5

*generation of debt rule strenght index*
generate DR_n_strengh= cover_n_dr2 + legal_n_dr2 + enforce_n_dr + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n


*Generation of overal fiscal rules index*
generate nationalfiscalrulesindex=((DR_n_strengh*5/7) + (BBR_n_strengh*5/7) + (RR_n_strengh*5/6) + (ER_n_strengh*5/7))/4


*Generation of majority government dummy*
generate majoritygov=0
replace majoritygov=1 if maj>0.5
replace majoritygov=. if maj==.

*Generation of singlepartygovernment dummy*
generate singlepartygov=0
replace singlepartygov= 1 if herfgov==1
replace singlepartygov=. if herfgov==.

*generation of "strong government" dummy*
generate stronggov=0
replace stronggov= 1 if singlepartygov==1 & majoritygov==1
replace stronggov=. if singlepartygov==. | majoritygov==. 

*Generation of national fiscal rules in place*
generate nationaler=0
replace nationaler=1 if er==1 & er_supra!=2
replace nationaler=. if er==. 

generate nationalrr=0
replace nationalrr=1 if rr==1 & rr_supra!=2
replace nationalrr=. if rr==. 

generate nationalbbr=0
replace nationalbbr=1 if bbr==1 & bbr_supra!=2
replace nationalbbr=. if bbr==. 

generate nationaldr=0
replace nationaldr=1 if dr==1 & dr_supra!=2
replace nationaldr=. if dr==. 


generate nationalfiscalrule=0
replace nationalfiscalrule=1 if nationaler==1 | nationalrr==1 | nationalbbr==1 | nationaldr==1
replace nationalfiscalrule=. if year<1985



* Linear probability model* 


* Table 2: Interaction with income level* 
reg votedlast c.statconER##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconER) at (incomedecile=(1 2 3 4 5 6 7 8 9 10 ))
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line) 

reg votedlast c.statconRR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconRR) at (incomedecile=( 1 2 3 4 5 6 7 8 9 10 )) 
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line)

reg votedlast c.statconBBR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconBBR) at (incomedecile=( 1 2 3 4 5 6 7 8 9 10 ))
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line)

reg votedlast c.statconDR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconDR) at (incomedecile=( 1 2 3 4 5 6 7 8 9 10 ))
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line) 






*Table F1: Use of strenght indexes*
reg votedlast c.ER_n_strengh##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast c.RR_n_strengh##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast c.BBR_n_strengh##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast c.DR_n_strengh##c.incomedecile married unemployed age squared i.eisced  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast c.nationalfiscalrulesindex##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 


*Foot note: Without country fixed effects*
reg votedlast c.statconER##c.incomedecile married unemployed age squared i.eisced i.essround , cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconER) at (incomedecile=(1 2 3 4 5 6 7 8 9 10 ))
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line) 

reg votedlast c.statconRR##c.incomedecile married unemployed age squared i.eisced i.essround , cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconRR) at (incomedecile=( 1 2 3 4 5 6 7 8 9 10 )) 
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line)

reg votedlast c.statconBBR##c.incomedecile married unemployed age squared i.eisced i.essround , cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconBBR) at (incomedecile=( 1 2 3 4 5 6 7 8 9 10 ))
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line)

reg votedlast c.statconDR##c.incomedecile married unemployed age squared i.eisced i.essround , cluster (ncountry), [iweight=pspwght] 
margins, dydx(statconDR) at (incomedecile=( 1 2 3 4 5 6 7 8 9 10 ))
marginsplot, level(90)   yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  scheme(s1mono)  recastci(rline) recast(line) 






*Foot note. Education instead of income*
generate ordinaleducationscale=eisced
replace ordinaleducationscale=. if eisced==0 | eisced==55 | eisced==77 | eisced==88 | eisced==99

reg votedlast c.statconER##c.ordinaleducationscale incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

reg votedlast c.statconRR##c.ordinaleducationscale incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

reg votedlast c.statconBBR##c.ordinaleducationscale incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

reg votedlast c.statconDR##c.ordinaleducationscale incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 


generate tertiaryeduc=0
replace tertiaryeduc=1 if eisced==6 | eisced==7
replace tertiaryeduc=. if eisced==.

reg votedlast c.statconER##c.tertiaryeduc incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

reg votedlast c.statconRR##c.tertiaryeduc incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

reg votedlast c.statconBBR##c.tertiaryeduc incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

reg votedlast c.statconDR##c.tertiaryeduc incomedecile married unemployed age squared  i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 


*Excluding 2014*
reg votedlast c.statconER##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] if  essround==7
reg votedlast c.statconRR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] if  essround==7
reg votedlast c.statconBBR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] if  essround==7
reg votedlast c.statconDR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] if  essround==7


* Rule dummies*
reg votedlast statconER  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght]
reg votedlast statconRR  incomedecile married unemployed age  squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast statconBBR  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast statconDR incomedecile married unemployed age squared i.essround i.eisced i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg  votedlast statconER statconRR statconBBR statconDR incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
 
 
 *Strenght of rules*
reg votedlast ER_n_strengh  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast RR_n_strengh  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast BBR_n_strengh incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast DR_n_strengh incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
reg votedlast nationalfiscalrulesindex incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 




*Logit analysis (intepretation hard)* 

* Rule dummies*
logit votedlast statconER  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast statconRR  incomedecile married unemployed age  squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast statconBBR  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast statconDR incomedecile married unemployed age squared i.essround i.eisced i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast statconER statconRR statconBBR statconDR incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
 
 
 *Strenght of rules*
logit votedlast ER_n_strengh  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast RR_n_strengh  incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast BBR_n_strengh incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast DR_n_strengh incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast nationalfiscalrulesindex incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 


*Interaction with income level* 
logit votedlast c.statconER##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast c.statconRR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght]  
logit votedlast c.statconBBR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght]  
logit votedlast c.statconDR##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght]  


logit votedlast c.ER_n_strengh##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast c.RR_n_strengh##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast c.BBR_n_strengh##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 
logit votedlast c.DR_n_strengh##c.incomedecile married unemployed age squared i.eisced  i.essround i.ncountry, cluster (ncountry) , [iweight=pspwght]
logit votedlast c.nationalfiscalrulesindex##c.incomedecile married unemployed age squared i.eisced i.essround i.ncountry, cluster (ncountry), [iweight=pspwght] 

