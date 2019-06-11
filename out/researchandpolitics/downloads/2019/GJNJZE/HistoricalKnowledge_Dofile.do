clear

use MainStudyData.dta


***prepare dataset***

***rename, recode, and generate individual characteristics variables***

gen Male =a2003
recode Male (1=1)(2=0)
gen Age=2016-a2005
drop if Age<18
gen Education = a2012
gen lnincome=ln(income)
gen income2=income+206460+1
gen Income_log=ln(income2)
gen CCPmember =a2015
recode CCPmember (1=1)(2=0)
gen Overseas_visit = p005
recode Overseas_visit (1=1)(2=0)


***recode history questions***
gen fivethousand =p001
recode fivethousand (2=0) (1=1)
gen gdp =p002
recode gdp (1=0) (2=-1)
gen imperialexam=p003
recode imperialexam (1=0)(2=-1)
gen greatwall =p004
recode greatwall (2=0)(1=1)

***generate History score***
gen History_score=fivethousand+gdp+imperialexam+greatwall


***generate and recode variables: correction, overestimate, overestimate2, underestimate, underestimate2***
 
gen correction =sample_group2
recode correction (1=1)(2=0)
gen overestimate = History_score
recode overestimate (-2=0)(-1=0)(0=0)(1=1)(2=1)
gen overestimate2 = History_score
recode overestimate2 (-2=0)(-1=0)(0=0)(1=0)(2=1)
gen underestimate = History_score
recode underestimate (-2=1)(-1=1)(0=0)(1=0)(2=0)
gen underestimate2 = History_score
recode underestimate2 (-2=1)(-1=0)(0=0)(1=0)(2=0)

***generate interaction terms****

gen over_correct = overestimate*correction
gen under_correct = underestimate*correction

gen over2_correct = overestimate2*correction
gen under2_correct = underestimate2*correction

***generate national identity items and conduct factor analysis***
gen better=p006
gen proud=p007
gen culture=p008
gen citizenship=p009

factor better culture proud citizenship [aweight = aw], pcf
screeplot

***generate national identity index and check alpha score***

gen National_Identity=better+proud+culture+citizenship
alpha better proud culture citizenship 


***Conduct Analysis***


***graph History_score distribution, Figure 1***

hist History_score, discrete percent addlabel addlabopts(yvarformat(%9.1fc)) width(0.51) xlabel (-2 -1 0 1 2) xtitle ("")

graph save Figure_1, replace

***Regression Table***

reg National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1.doc, replace dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

reg National_Identity overestimate underestimate correction over_correct under_correct Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

reg National_Identity overestimate2 underestimate2 correction over2_correct under2_correct Overseas_visit  Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) 


***Summary Statistics****

sum National_Identity History_score correction overestimate underestimate overestimate2 underestimate2 over_correct under_correct over2_correct under2_correct Male Age Education Income_log CCPmember Overseas_visit


*****County-Fixed Effect
areg National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmember, absorb (county_no)
outreg2 using Study1T1FE.doc, replace addtext (County FE, Yes) dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   
areg National_Identity overestimate underestimate correction over_correct under_correct Overseas_visit Male Age Education Income_log CCPmember, absorb (county_no)
outreg2 using Study1T1FE.doc, append addtext (County FE, Yes) dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   
areg National_Identity overestimate2 underestimate2 correction over2_correct under2_correct Overseas_visit  Male Age Education Income_log CCPmember, absorb (county_no)
outreg2 using Study1T1FE.doc, append addtext (County FE, Yes) dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   

***recode those who only overestimate/underestimate one question*********
gen onlyfivethousand = fivethousand if  gdp == 0 & imperialexam == 0 & greatwall == 0
tab onlyfivethousand
gen onlygreatwall = greatwall if  gdp == 0 & imperialexam == 0 & fivethousand == 0
tab onlygreatwall
gen onlygdp = gdp if fivethousand  == 0 & imperialexam == 0 & greatwall == 0
tab onlygdp
gen onlyimperialexam = imperialexam if fivethousand == 0 &  gdp == 0 & greatwall == 0
tab onlyimperialexam 
reg National_Identity onlyfivethousand correction Male Age Education Income_log CCPmember Overseas_visit, vce(robust)
outreg2 using Study1T1_breakdown.doc, replace dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   
reg National_Identity onlygreatwall correction Male Age Education Income_log CCPmember  Overseas_visit, vce(robust)
outreg2 using Study1T1_breakdown.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   
reg National_Identity onlygdp correction Male Age Education Income_log CCPmember  Overseas_visit, vce(robust)
outreg2 using Study1T1_breakdown.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   
reg National_Identity onlyimperialexam correction Male Age Education Income_log CCPmember Overseas_visit, vce(robust)
outreg2 using Study1T1_breakdown.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)   

***Estimate without those who chose the highest scale (10) for all questions in the national identity index
drop if National_Identity==40
reg National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1S.doc, replace dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)
reg National_Identity overestimate underestimate correction over_correct under_correct Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1S.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)
reg National_Identity overestimate2 underestimate2 correction over2_correct under2_correct Overseas_visit  Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1S.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

***Robustness of the findings to missing data

mi set mlong
mi extract 0,clear
mi set mlong
*mi describe
*mi misstable summarize National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmembe
*mi misstable patterns  National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmembe
mi register imputed History_score overestimate underestimate over_correct under_correct overestimate2 underestimate2 over2_correct under2_correct
mi register regular correction Overseas_visit Male Age Education Income_log CCPmembe
mi impute mvn  History_score =  correction Overseas_visit Male Age Education Income_log CCPmember, add(20) rseed (53421) force
mi estimate: reg National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
mi estimate, dots post: reg National_Identity History_score correction Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1IM.doc, replace dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)
mi extract 0,clear
mi set mlong
mi register imputed  overestimate underestimate over_correct under_correct
mi register regular correction Overseas_visit Male Age Education Income_log CCPmembe
mi impute mvn overestimate underestimate over_correct under_correct=  correction Overseas_visit Male Age Education Income_log CCPmember, add(20) rseed (53421) force
mi estimate, dots post: reg National_Identity overestimate underestimate correction over_correct under_correct Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1IM.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)
mi extract 0,clear
mi set mlong
mi register imputed  overestimate2 underestimate2 over2_correct under2_correct
mi register regular correction Overseas_visit Male Age Education Income_log CCPmembe
mi impute mvn  overestimate2 underestimate2 over2_correct under2_correct=  correction Overseas_visit Male Age Education Income_log CCPmember, add(20) rseed (53421) force
mi estimate, dots post: reg National_Identity overestimate2 underestimate2 correction over2_correct under2_correct Overseas_visit  Male Age Education Income_log CCPmember, vce(robust)
outreg2 using Study1T1IM.doc, append dec (3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)


****** Power Analysis ********

*obtain the valid regression sample and error variance
reg National_Identity overestimate underestimate correction over_correct under_correct Overseas_visit Male Age Education Income_log CCPmember, vce(robust)
predict resid, residuals
sum resid
display 7.109612^2
tab underestimate correction if resid !=.
tab overestimate correction if resid !=.

*two sample means test
tab correction if resid !=.
sum National_Identity if resid !=.
by correction, sort: sum National_Identity if resid !=.
power twomeans 32.14951 31.92424  , graph n(100(200)1500) sd1( 7.880869 ) sd2( 7.138906)
*n1(528) n2(515)
*power oneway 32.14951 31.92424, varerror(50.546583) 


*twoway ANOVA
tab  correction overestimate if resid !=.
by  correction overestimate, sort: sum National_Identity if  resid !=.
power twoway  30.29474  32.84024 \ 31.01163  32.72012 ,varerror(50.546583) factor(rowcol) cellweights( 190 338 \ 172 343) 
power twoway  30.29474  32.84024 \ 31.01163  32.72012 ,varerror(50.546583) factor(rowcol) cellweights( 190 338 \ 172 343) graph(graphregion(fcolor(white)) scheme(s2mono))  n(1000(2000)20000) 


by  correction underestimate, sort: sum National_Identity if  resid !=.
power twoway   32.4482  27.41818  \  32.53879     28.60784 ,varerror(50.546583) factor(rowcol) cellweights( 473    55 \  464   51 )
power twoway   32.4482  27.41818  \  32.53879     28.60784 ,varerror(50.546583) factor(rowcol) cellweights( 473    55 \  464   51 ) graph( graphregion(fcolor(white)) scheme(s2mono))   n(1000(2000)20000) 




*Required effect size for detecting differences given the existing sample
*anova National_Identity correction##overestimate 
*estat esize
*anova National_Identity correction##underestimate 
*estat esize

power twoway  ,varerror(50.546583) factor(rowcol) cellweights( 190 338 \ 172 343) graph(ydimension(delta) graphregion(fcolor(white)) scheme(s2mono) ylabel(0(0.01)0.1))   n(100(200)3000) power(0.8)


power twoway    ,varerror(50.546583) factor(rowcol) cellweights( 473    55 \  464   51 ) graph(ydimension(delta) graphregion(fcolor(white)) scheme(s2mono) ylabel(0(0.01)0.1))   n(100(200)3000) power(0.8)


clear
