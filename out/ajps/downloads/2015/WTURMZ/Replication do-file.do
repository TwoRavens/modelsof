*Stata code for replicating analyses by Garand, Xu, and Davis using data from the Cumulative American National Election Study (CANES)

*This statement is used to install the fitstat command 

ssc install fitstat

*These are the statements used to generate new versions of the original raw variables
gen year = VCF0004
drop if year < 1992
gen sticpsr = VCF0901
gen weight = vcf0011z
gen welfare = VCF0220
gen swelfare = VCF0894
gen illegals = VCF0233
gen immig3 = VCF0879a
gen blacks = VCF0206
gen poor = VCF0223
gen partyid = VCF0301
gen libcon = VCF0803
gen gender = VCF0104
gen race = VCF0106a
gen black2012 = dem_racecps_black
gen hispanic2012 = dem_hisp
gen age = VCF0101
gen educ = VCF0140a
gen fincome5 = VCF0114
gen chattend = VCF0130a
gen pbornusa = VCF0143

*These statements are used to recode the variables for analysis
recode welfare 97 = 100 98 = . 99 = .
recode swelfare 1 = 1 2 = 0 3 = -1 8 = . 9 = .
recode illegals 97 = 100 98 = . 99 = .
recode immig3 1 = 1 3 = 0 5 = -1 8 = . 9 = .
recode blacks 97 = 100 98 = . 99 = .
recode poor 97 = 100 98 = . 99 = .
recode partyid 0 = .
replace partyid = partyid-1
recode libcon 0 = . 9 = .
replace libcon = libcon-1
replace gender = gender-1
gen white = 0
gen white2012 = dem_racecps_white
recode white 0 = 1 if race == 1
recode white 0 = 1 if dem_racecps_white == 1 & year == 2012
gen black = 0
recode black 0 = 1 if VCF0106a == 2
recode black 0 = 1 if year == 2012 & black2012 == 1
gen hispanic = 0
recode hispanic  0 = 1 if VCF0106a == 5
recode hispanic 0 = 1 if year == 2012 * hispanic2012 == 1
gen asian = 0
recode asian 0 = 1 if VCF0106a == 3
recode age 0 = .
gen age2 = age^2
recode educ 1 = 0 2 = 1 3 = 2 4 = 2 5 = 3 6 = 4 7 = 5 8 = . 9 = .
recode fincome5 0 = .
replace fincome5 = fincome5-1
recode chattend 8 = . 9 = . 5 = 0 4 = 1 3 = 2 2 = 3 1 = 4 0 = 4
recode pbornusa 1 = 1 5 = 0 8 = . 9 = .

*These statements create dichotomous variables for each year and each state
gen year92 = 0
gen year94 = 0
gen year96 = 0
gen year98 = 0
gen year00 = 0
gen year02 = 0
gen year04 = 0
gen year08 = 0
gen year12 = 0
recode year92 0 = 1 if year == 1992
recode year94 0 = 1 if year == 1994
recode year96 0 = 1 if year == 1996
recode year98 0 = 1 if year == 1998
recode year00 0 = 1 if year == 2000
recode year02 0 = 1 if year == 2002
recode year04 0 = 1 if year == 2004
recode year08 0 = 1 if year == 2008
recode year12 0 = 1 if year == 2012

gen alabama = 0
gen alaska = 0
gen arizona = 0
gen arkansas = 0
gen california = 0
gen colorado = 0
gen connecticut = 0
gen delaware = 0
gen florida = 0
gen georgia = 0
gen hawaii = 0
gen idaho = 0
gen illinois = 0
gen indiana = 0
gen iowa = 0
gen kansas = 0
gen kentucky = 0
gen louisiana = 0
gen maine = 0
gen maryland = 0
gen massachusetts = 0
gen michigan = 0
gen minnesota = 0
gen mississippi = 0
gen missouri = 0
gen montana = 0
gen nebraska = 0
gen nevada = 0
gen newhampshire = 0
gen newjersey = 0
gen newmexico = 0
gen newyork = 0
gen northcarolina = 0
gen northdakota = 0
gen ohio = 0
gen oklahoma = 0
gen oregon = 0
gen pennsylvania = 0
gen rhodeisland = 0
gen southcarolina = 0
gen southdakota = 0
gen tennessee = 0
gen texas = 0
gen utah = 0
gen vermont = 0
gen virginia = 0
gen washington = 0
gen westvirginia = 0
gen wisconsin = 0
gen wyoming = 0
gen dc = 0

recode alabama 0 = 1 if sticpsr == 41
recode alaska 0 = 1 if sticpsr == 81
recode arizona 0 = 1 if sticpsr == 61
recode arkansas 0 = 1 if sticpsr == 42
recode california 0 = 1 if sticpsr == 71
recode colorado 0 = 1 if sticpsr == 62
recode connecticut 0 = 1 if sticpsr == 1
recode delaware 0 = 1 if sticpsr == 11
recode florida 0 = 1 if sticpsr == 43
recode georgia 0 = 1 if sticpsr == 44
recode hawaii 0 = 1 if sticpsr == 82
recode idaho 0 = 1 if sticpsr == 63
recode illinois 0 = 1 if sticpsr == 21
recode indiana 0 = 1 if sticpsr == 22
recode iowa 0 = 1 if sticpsr == 31
recode kansas 0 = 1 if sticpsr == 32
recode kentucky 0 = 1 if sticpsr == 51
recode louisiana 0 = 1 if sticpsr == 45
recode maine 0 = 1 if sticpsr == 2
recode maryland 0 = 1 if sticpsr == 52
recode massachusetts 0 = 1 if sticpsr == 3
recode michigan 0 = 1 if sticpsr == 23
recode minnesota 0 = 1 if sticpsr == 33
recode mississippi 0 = 1 if sticpsr == 46
recode missouri 0 = 1 if sticpsr == 34
recode montana 0 = 1 if sticpsr == 64
recode nebraska 0 = 1 if sticpsr == 35
recode nevada 0 = 1 if sticpsr == 65
recode newhampshire 0 = 1 if sticpsr == 4
recode newjersey 0 = 1 if sticpsr == 12
recode newmexico 0 = 1 if sticpsr == 66
recode newyork 0 = 1 if sticpsr == 13
recode northcarolina 0 = 1 if sticpsr == 47
recode northdakota 0 = 1 if sticpsr == 36
recode ohio 0 = 1 if sticpsr == 24
recode oklahoma 0 = 1 if sticpsr == 53
recode oregon 0 = 1 if sticpsr == 72
recode pennsylvania 0 = 1 if sticpsr == 14
recode rhodeisland 0 = 1 if sticpsr == 5
recode southcarolina 0 = 1 if sticpsr == 48
recode southdakota 0 = 1 if sticpsr == 37
recode tennessee 0 = 1 if sticpsr == 54
recode texas 0 = 1 if sticpsr == 49
recode utah 0 = 1 if sticpsr == 67
recode vermont 0 = 1 if sticpsr == 6
recode virginia 0 = 1 if sticpsr == 40
recode washington 0 = 1 if sticpsr == 73
recode westvirginia 0 = 1 if sticpsr == 56
recode wisconsin 0 = 1 if sticpsr == 25
recode wyoming 0 = 1 if sticpsr == 68
recode dc 0 = 1 if sticpsr == 55  

*These statements are used to create the fimmigration factor score 

factor illegals immig3, pcf

predict fimmigration

 
*These statements are used to estimate regression results reported in Table 2. The second of each pair of regressions does not include the "cluster" command and hence reports the 
*F statistics and probability of F that are reported for each regression in Table 2.

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight]

fitstat

regress welfare illegals immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

regress welfare illegals immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight]

fitstat

regress welfare immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year96 year00 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

regress welfare immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year96 year00 year04 year08 year12 alaska-dc [aweight = weight]

fitstat



*These statements are used to estimate regression results reported in Table 3

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

fitstat

ologit swelfare illegals immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

fitstat

ologit swelfare immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year96 year00 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

fitstat



*These statements are used to generate predicted probabilities for Figure 2

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

prgen fimmigration, gen(fimmig) ncases(50)

twoway (scatter fimmip_1 fimmix, connect(l)) (scatter fimmip0 fimmix, connect(l)) (scatter fimmip1 fimmix, connect(l))


 
*These statements are used to generate predicted probabilities for Figure 3

ologit swelfare illegals immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

prgen illegals, gen(illeg) ncases(100)

twoway (scatter illegp_1 illegx, connect(l)) (scatter illegp0 illegx, connect(l)) (scatter illegp1 illegx, connect(l))



*These statements are used to generate predicted probabilities for Figure 4

ologit swelfare illegals immig3 blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

prgen immig3, gen(immig) ncases(3)

twoway (scatter immigp_1 immigx, connect(l)) (scatter immigp0 immigx, connect(l)) (scatter immigp1 immigx, connect(l))



*These statements are used to generate predicted probabilities for Figure 5

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

prgen blacks, gen(blacks) ncases(101)

twoway (scatter blacksp_1 blacksx, connect(l)) (scatter blacksp0 blacksx, connect(l)) (scatter blacksp1 blacksx, connect(l))



*These statements are used to generate predicted probabilities for Figure 6

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc [aweight = weight], cluster(sticpsr)

prgen poor, gen(poor) ncases(101)

twoway (scatter poorp_1 poorx, connect(l)) (scatter poorp0 poorx, connect(l)) (scatter poorp1 poorx, connect(l))


 
*These statements are used to estimate regression and ordered logit models reported in Appendix *Table 2.3. The second regression does not include the "cluster" command and 
*hence reports the F statistics and probability of F that are reported for the regression model in Table 2.3.

regress welfare fimmigration blacks poor partyid libcon gender age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if white == 1 [aweight = weight], cluster(sticpsr)

regress welfare fimmigration blacks poor partyid libcon gender age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if white == 1 [aweight = weight]

fitstat

ologit swelfare fimmigration blacks poor partyid libcon gender age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if white == 1 [aweight = weight], cluster(sticpsr)

fitstat



*These statements are used to estimate regression and ordered logit models reported in Appendix *Table 2.6. The second of each pair of regressions does not include 
*the "cluster" command and hence reports the *F statistics and probability of F that are reported for each regression in Table 2.6.

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if pbornusa == 1 [aweight = weight], cluster(sticpsr)

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if pbornusa == 1 [aweight = weight]

fitstat

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if pbornusa == 0 [aweight = weight], cluster(sticpsr)

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if pbornusa == 0 [aweight = weight]

fitstat



*These statements are used to estimate regression and ordered logit models reported in Appendix *Table 2.7

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if pbornusa == 1 [aweight = weight], cluster(sticpsr)

fitstat

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if pbornusa == 0 [aweight = weight], cluster(sticpsr)

fitstat



*These statements are used to estimate regression and ordered logit models reported in Appendix *Table 2.8. The second of each pair of regressions does not include 
*the "cluster" command and hence reports the *F statistics and probability of F that are reported for each regression in Table 2.6.

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if year < 1997 [aweight = weight], cluster(sticpsr)

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if year < 1997 [aweight = weight]

fitstat

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if year > 1997 [aweight = weight], cluster(sticpsr)

regress welfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if year > 1997 [aweight = weight]

fitstat


*These statements are used to estimate regression and ordered logit models reported in Appendix *Table 2.9

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if year < 1997 [iweight = weight], cluster(sticpsr)

fitstat

ologit swelfare fimmigration blacks poor partyid libcon gender black hispanic asian age age2 educ fincome chattend year94 year04 year08 year12 alaska-dc if year > 1997 [iweight = weight], cluster(sticpsr)

fitstat




*Stata code for creating Figure 1 in analyses by Garand, Xu, and Davis using data labelled “Trend in U.S. Foreign-Born Population, 1850-2010”

twoway (connected pforeign year, mlabel(pforeign) lwidth(thick)), ytitle(Percent foreign born) yscale(range(0 20)) xtitle(Year)

 

**Stata code for replicating supplemental analyses by Garand, Xu, and Davis using data from the 2012 American National Election Study (ANES)
*These are the statements used to generate new versions of the original raw variables
gen weight = weight_full
gen welfare = ftgr_welfare
gen swelfare = fedspend_welfare
gen illegals = ftcasi_illegal
gen immlevel = immigpo_level
gen blacks = ftcasi_black
gen poor = ftgr_poor
gen partyid = pid_x
gen libcon = libcpre_self
gen gender = gender_respondent
gen educ = dem_edugroup
gen fincome = incgroup_prepost
gen age = dem_agegrp_iwdate
gen chattend1 = relig_church 
gen chattend2 = relig_churchoft

*These statements are used to recode the variables for analysis
replace welfare = . if welfare < 0
recode swelfare -9 = . -8 = . 1 = 1 2 = -1 3 = 0
replace illegals = . if illegals < 0
replace immlevel = . if immlevel < 0
replace immlevel = abs(immlevel-5)
replace blacks = . if blacks < 0
replace poor = . if poor < 0
recode partyid -2 = .
replace partyid = partyid-1
replace libcon = . if libcon < 0
replace libcon = libcon-1
recode gender 1 = 0 2 = 1
replace educ = . if educ < 0
replace educ = educ-1
replace fincome = . if fincome < 0
replace fincome = fincome-1
replace age = . if age < 0
gen age2 = age^2
gen chattend = chattend2
replace chattend = . if chattend < 0
replace chattend = abs(chattend-5)
recode chattend . = 0 if chattend1 == 2

factor illegals immlevel
predict immig
gen immtakejobs=immigpo_jobs
recode immtakejobs (4=0) (3=1) (1=3) (-9 -8 -7 -6=.)
label var immtakejobs "recode of immigpo_jobs(0=not at all;3=extremely)"
gen importlimit=0
replace importlimit=-1 if imports_limit==2
replace importlimit=1 if imports_limit==1
label var importlimit "recode of imports_limit (1=favor, -1=oppose)"
gen wiretaps=wiretap_warrant
recode wiretaps (3=0) (2=-1) (-9 -8 -7 -6=.)
label var wiretaps "recode of wiretap_warrant (-1=oppose;1=favor)"
gen white = dem_racecps_white

* 2SLS-IV for everyone

ivreg2 welfare blacks poor partyid libcon gender educ fincome age age2 chattend (immig  = wiretaps importlimit immtakejobs )  [aweight = weight], first
**Note: Output shows that Cragg-Donald Wald F-statistic is 427.56; Sargan statistic is 0.879
* In the first stage model, the results show that Centered R2=0.3825 and (at the end of the first-stage model and right before summary results of first-stage regressions) Partial R-square=0.2195. 
ivreg2 swelfare blacks poor partyid libcon gender educ fincome age age2 chattend (immig  = wiretaps importlimit immtakejobs )  [aweight = weight], first
**Note: Output shows that Cragg-Donald Wald F-statistic is 431.87; Sargan statistic is 0.130
* In the first stage model, the results show that Centered R2=0.3838 and (at the end of the first-stage model and right before summary results of first-stage regressions) Partial R-square=0.2214. 

* 2SLS-IV for whites only

ivreg2 welfare blacks poor partyid libcon gender educ fincome age age2 chattend (immig  = wiretaps importlimit immtakejobs )  [aweight = weight] if white==1, first
* In the first stage model, the results show that Centered R2=0.3980 and (at the end of the first-stage model and right before summary results of first-stage regressions) Partial R-square=0.2343. 

ivreg2 swelfare blacks poor partyid libcon gender educ fincome age age2 chattend (immig  = wiretaps importlimit immtakejobs )  [aweight = weight] if white==1, first
* In the first stage model, the results show that Centered R2=0.3972 and (at the end of the first-stage model and right before summary results of first-stage regressions) Partial R-square=0.2331. 
