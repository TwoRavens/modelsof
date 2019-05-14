********************************************************************************************
***  Part 2 of 3: 
***  Ichino, Nahomi, and Noah L. Nathan.  2013.  "Crossing the Line: Local Ethnic
***  Geography and Voting in Ghana," American Political Science Review 107(2): 344-61.
***  http://dx.doi.org/10.1017/S0003055412000664
***
***  IchinoNathan_APSR_survey_analysis.do
***
***  Nahomi Ichino and Noah Nathan
***  Department of Government, Harvard University
***  February 2013
***  
***  Note: 
***  This reproduces Tables 3-5 of the published article.
***  This also reproduces Tables 4-13 of the Supplementary Materials 
***
**************
***  Calls: 
***  IchinoNathan_APSR_survey_data.csv
***
***  Survey data is from Rounds 3 and 4 of the Afrobarometer survey for Ghana
***  See afrobarometer.org for original survey data and information
***
***  Data available at:
***  http://dvn.iq.harvard.edu/dvn/dv/nichino
***  http://hdl.handle.net/1902.1/21461 
******************************************************************************************


clear
insheet using "IchinoNathan_APSR_survey_data.csv", comma

**** TABLE 3 *****
preserve
drop if const230_h=="KUMASI"


* NOTE: we used "latabstat" to produce our table for LaTeX; note that this rounds the mean on "unfair" differently at the second decimal place from using "tabstat" (0.56 versus 0.55).
* findit latabstat
* latabstat eth_akan eth_ewe eth_ga eth_dagomba vote_npp_pres vote_ndc_pres economy_oneyear unfair poverty urb trustother gov_sentus male central r4 akan_30km_l_p ewe_30km_l_p akan_5km_l_p ewe_5km_l_p popdens5x5 dev_factor2, cl(sumstat1) stat(mean sd min max n) col(statistics) format(%9.2f) tf(Table3) replace

tabstat eth_akan eth_ewe eth_ga eth_dagomba vote_npp_pres vote_ndc_pres economy_oneyear unfair poverty urb trustother gov_sentus male central r4 akan_30km_l_p ewe_30km_l_p akan_5km_l_p ewe_5km_l_p popdens5x5 dev_factor2, stat(mean sd min max n) col(statistics) format(%9.2f) 
restore


**** TABLE 4 *****
gen akan30_central=akan_30km_l_p*central
logit vote_npp_pres akan_30km_l_p akan30_central eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 if urb==0, robust cluster(fid0725) 
logit vote_ndc_pres akan_30km_l_p akan30_central eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 if urb==0, cluster(fid0725)
logit vote_npp_pres ewe_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 if urb==0, cluster(fid0725)
logit vote_ndc_pres ewe_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 if urb==0, cluster(fid0725)


**** TABLE 5 *****
preserve
drop if const230_h=="KUMASI"
*Kumasi is dropped because no local census data was available (noted in text)
*Panel A
logit vote_npp_pres akan_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, robust cluster(fid0725) 
logit vote_ndc_pres akan_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_npp_pres ewe_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_ndc_pres ewe_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
*Panel B
logit vote_npp_pres akan_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, robust cluster(fid0725) 
logit vote_ndc_pres akan_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_npp_pres ewe_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_ndc_pres ewe_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
restore





**********************************
***** SUPPLEMENTAL MATERIALS *****

**** TABLE 4 ****
preserve
drop if const230_h=="KUMASI"
logit vote_npp_pres akan_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, robust cluster(fid0725) 
logit vote_ndc_pres akan_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_npp_pres ewe_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_ndc_pres ewe_30km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
restore

**** TABLE 5 ****
preserve
drop if const230_h=="KUMASI"
logit vote_npp_pres akan_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, robust cluster(fid0725) 
logit vote_ndc_pres akan_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_npp_pres ewe_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
logit vote_ndc_pres ewe_5km_l_p eth_akan eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 r4 if urb==1, cluster(fid0725)
restore

**** TABLE 6 ****
xtile akan30_q5=akan_30km_l_p if urb==0, nquantiles(5)
tab akan30_q5 gov_sentus if urb==0, row

xtile ewe30_q5=ewe_30km_l_p if urb==0, nquantiles(5)
tab ewe30_q5 gov_sentus if urb==0, row

tab gov_sentus if eth_akan==1&urb==0
tab gov_sentus if eth_ewe==1&urb==0
tab gov_sentus if eth_dagomba==1&urb==0


**** TABLE 7 ****
gen int1 = gov_sentus*central
gen int2 = gov_sentus*akan_30km_l_p
gen int3 = central*akan_30km_l_p 
gen int4 = gov_sentus*int3

logit vote_npp_pres akan_30km_l_p central gov_sentus int1 int2 int3 int4 male economy_oneyear poverty dev_factor2 if eth_akan!=1&urb==0, robust cluster(fid0725)
logit vote_ndc_pres akan_30km_l_p central gov_sentus int1 int2 int3 int4 male economy_oneyear poverty dev_factor2 if eth_akan!=1&urb==0, robust cluster(fid0725)

**** TABLE 8 ****
drop int1 int2 int3 int4
gen int2 = trustother*akan_30km_l_p
preserve
keep if r4==0
eststo clear
logit vote_npp_pres akan_30km_l_p trustother int2 male economy_oneyear poverty dev_factor2 if eth_akan!=1&urb==0, robust cluster(fid0725)
logit vote_ndc_pres akan_30km_l_p trustother int2 male economy_oneyear poverty dev_factor2 if eth_akan!=1&urb==0, robust cluster(fid0725)
restore

**** TABLE 9 ****
drop akan30_q5
drop ewe30_q5

tab trustother if eth_akan==1
tab trustother if eth_ewe==1
tab trustother if eth_dagomba==1

preserve
keep if r4==0
keep if eth_akan==0
keep if urb==0
xtile akan30_q5=akan_30km_l_p, nquantiles(5)
tab akan30_q5 trustother, row
restore

preserve
keep if r4==0
keep if eth_ewe==0
keep if urb==0
xtile ewe30_q5=ewe_30km_l_p, nquantiles(5)
tab ewe30_q5 trustother, row
restore

**** TABLE 10 ****
logit trustother akan_30km_l_p central male poverty if urb==0, robust cluster(fid0725)
logit trustother akan_30km_l_p central male poverty if eth_akan==0&urb==0, robust cluster(fid0725)
logit trustother ewe_30km_l_p central male poverty if urb==0, robust cluster(fid0725)
logit trustother ewe_30km_l_p central male poverty if eth_ewe==0&urb==0, robust cluster(fid0725)


**** TABLE 11 ****
logit trustother trustown akan_30km_l_p central male poverty if urb==0, robust cluster(fid0725)
logit trustother trustown akan_30km_l_p central male poverty if eth_akan==0&urb==0, robust cluster(fid0725)
logit trustother trustown ewe_30km_l_p central male poverty if urb==0, robust cluster(fid0725)
logit trustother trustown ewe_30km_l_p central male poverty if eth_ewe==0&urb==0, robust cluster(fid0725)


**** TABLE 12 ****
gen ak30=akan_30km_l_p*eth_akan
gen ew30=akan_30km_l_p*eth_ewe
gen ga30=akan_30km_l_p*eth_ga
gen da30=akan_30km_l_p*eth_dagomba
gen ewresp=responsself*eth_ewe
logit responsself akan_30km_l_p akan30_central eth_ewe eth_dagomba ew30 da30 central if eth_akan==0& economy_oneyear!=., cluster(fid0725)
logit responsself akan_30km_l_p akan30_central eth_ewe eth_dagomba ew30 da30 central poverty if eth_akan==0& economy_oneyear!=., cluster(fid0725)
logit vote_npp_pres akan_30km_l_p akan30_central eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central if eth_akan==0&responsself!=., cluster(fid0725)
logit vote_npp_pres responsself akan_30km_l_p akan30_central eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central if eth_akan==0, cluster(fid0725)
logit vote_npp_pres responsself ewresp akan_30km_l_p eth_ewe eth_dagomba akan30_central male economy_oneyear poverty dev_factor2 central if eth_akan==0, cluster(fid0725)


**** TABLE 13 ****
gen seg_int_A = akan_30km_l_p*h_30rad_e
gen seg_int_E = ewe_30km_l_p*h_30rad_e

logit vote_npp_pres akan_30km_l_p akan30_central eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e if urb==0&eth_akan==0, robust cluster(fid0725) 
logit vote_ndc_pres akan_30km_l_p akan30_central eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e if urb==0&eth_akan==0, cluster(fid0725)
logit vote_npp_pres ewe_30km_l_p eth_akan eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e if urb==0&eth_ewe==0, cluster(fid0725)
logit vote_ndc_pres ewe_30km_l_p eth_akan eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e if urb==0&eth_ewe==0, cluster(fid0725)
logit vote_npp_pres akan_30km_l_p akan30_central eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e seg_int_A if urb==0&eth_akan==0, robust cluster(fid0725) 
logit vote_ndc_pres akan_30km_l_p akan30_central eth_ewe eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e seg_int_A if urb==0&eth_akan==0, cluster(fid0725)
logit vote_npp_pres ewe_30km_l_p eth_akan eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e seg_int_E if urb==0&eth_ewe==0, cluster(fid0725)
logit vote_ndc_pres ewe_30km_l_p eth_akan eth_dagomba male economy_oneyear poverty dev_factor2 central r4 h_30rad_e seg_int_E  if urb==0&eth_ewe==0, cluster(fid0725)






