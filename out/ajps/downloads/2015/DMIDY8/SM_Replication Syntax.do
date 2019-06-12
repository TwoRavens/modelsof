//Final Do File to Accompany Self Monitoring Paper//




clearset mem 1Gcd "/Users/chrisweber/Desktop/SMRevisions/Self Monitoring/Replication Folder/"use "replication data.dta", clear
//keep hispanic black asian white workbla violbla /*
*/eqright eqchanc eqpeopl blame hardwrk poverty /*
*/strongr closer strongd /*
*/conserv moderat liberal /*
*/i_expec i_amnot i_nojoy i_deciv /* */welfarb wealthb workwhi violwhi /*
*/yearbrn educ gender /*
*/irish tryhard deserve slavery discrim noeduc /*
*/homeown integr locgov spended affact1 affact2 /*
*/profil1 profil2 profil3 deathpe favord /*
*/suspend nylaw innocen helpblc /*
*/profil2 profil3 deathpe favord suspend nylaw innocen /*
*/pct_aa nxtdoor localtv area areacode zip
//Generate a pseudo zip
//egen cluster=group(zip)
//replace zip=cluster
//The original data file was merged with census data based on respondent zipcode//
//To preserve participant anonymity, the replication data includes the contextual data we use
//the survey variables we rely on, but excludes identifying information, including zipcodes//Only white respondents are included.  
  
//The above syntax explains how the data for replication were generated. Run everything below
  
  
//Various Measures of Context//
************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************//Heterogeneity Measure that is in the Paper//gen p1=(hispanic)+(black)+(asian)+(white)gen sum1=(hispanic^2)+(black^2)+(asian^2)+(white^2)gen het=p1-sum1
set scheme s2monograph twoway histogram het || kdensity het, bwidth(0.05) ytitle("density") xtitle("Heterogeneity, All Groups") legend(label(1 "Histogram") label(2 "Kernel Density") )
//A zero to 1 scale//replace het=(het-0.0178418)/.6732611 
 ////////////////
//Black v. White Heterogeneity//
//This is the measure in the paper, the rest are for the appendix//gen p2=(black)+(white)gen sum2=(black^2)+(white^2)
gen het2=p2-sum2
graph twoway histogram het2 || kdensity het2, bwidth(0.05) ytitle("density") xtitle("Heterogeneity, Blacks/Whites") legend(label(1 "Histogram") label(2 "Kernel Density") )

//Just percentage black//
graph twoway histogram black || kdensity black, bwidth(0.05) ytitle("density") xtitle("Percent Black") legend(label(1 "Histogram") label(2 "Kernel Density") )

//Black:White//gen dif=(black)-(white)graph twoway histogram dif || kdensity dif, bwidth(0.05) ytitle("density") xtitle("Heterogeneity, Blacks-Whites") legend(label(1 "Histogram") label(2 "Smoothed Density") )
*replace this to vary from 0 to 1
sum dif
replace dif=(dif+ .9870968 )/1.712533
gen lndif=ln(dif+.01)  
  ///Generate Don't Now and Midpoint responses for dissembling analysis////gen mid1=1 if workbla==5replace mid1=2 if workbla>5 & workbla<11replace mid1=3 if workbla<5replace mid1=4 if workbla>10gen mid2=1 if violbla==5replace mid2=2 if violbla>5 & violbla<11replace mid2=3 if violbla<5replace mid2=4 if violbla>10**Labels high scores are reject for the working stereotype, but endorse blacks as violent for the violent stereotype** label define mid1 1 "midpoint" 2 "reject" 3 "endorse" 4 "opt out"label values mid1 mid1label define mid2 1 "midpoint" 2 "endorse" 3 "reject" 4 "opt out"label values mid2 mid2
**Recode so that dissembling is reject, midpoint, or opt out.
recode mid1 (1 2 4=1) (3=0), gen(dissemble1)
recode mid2 (1 3 4=1) (2=0), gen(dissemble2)

************************************************************************************************************************************************************************************

//Independent variables//
************************************************************************************************************************************************************************************
//egalitarianism scale//
recode eqright (5 6=.), gen(eqright_r)
recode eqchanc (1=4) (2=3) (3=2) (4=1)  (5 6=.), gen(eqchanc_r)
recode eqpeopl (5 6=.), gen(eqpeopl_r)
replace eqright_r=(eqright_r-1)/3
replace eqchanc_r=(eqchanc_r-1)/3
replace eqpeopl_r=(eqpeopl_r-1)/3
egen egalitarianism=rmean(eqright_r eqpeopl_r)label variable eqright_r "eqright reversed 0-1"label variable eqpeopl_r "eqpeopl reversed 0-1"label variable eqchanc_r "eqchanc 0-1"
//individualism scale//
recode blame (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(blame_r)
recode hardwrk  (5 6=.), gen(hardwrk_r)
recode poverty (1=3) (2=1) (3=2) (4=2) (5 6=.), gen(poverty_r)
replace blame_r=(blame_r-1)/3
replace hardwrk_r=(hardwrk_r-1)/3
replace poverty_r=(poverty_r-1)/3
alpha blame_r poverty_r
egen individualism=rmean(blame_r poverty_r)label variable blame_r "blame reversed, 0-1"label variable hardwrk_r "hardwrk 0-1"label variable poverty_r "poverty reversed, 0-1"//PID and Ideology//
**High scores are republicans and conservatives**gen pid=.replace pid=1 if strongr==1replace pid=.83 if strongr==2 | strongr==3replace pid=.67 if closer==1replace pid=.5 if closer==3 | closer==4replace pid=.33 if closer==2replace pid=.17 if strongd==2 | strongd==3replace pid=0 if strongd==1gen libcon=.replace libcon=1 if conserv==1replace libcon=.83 if conserv==2 | conserv==3replace libcon=.67 if moderat==2replace libcon=.5 if moderat==3 | moderat==4 | moderat==5 | moderat==6replace libcon=.33 if moderat==1replace libcon=.17 if liberal==2 | liberal==3replace libcon=0 if liberal== 1//self monitoring scale//recode i_expec (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_expec_r)
recode i_amnot (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_amnot_r )
recode i_nojoy (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_nojoy_r)
recode i_deciv (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_deciv_r )
replace i_expec_r=(i_expec_r-1)/3
replace i_amnot_r=(i_amnot_r-1)/3
replace i_nojoy_r=(i_nojoy_r-1)/3
replace i_deciv_r=(i_deciv_r-1)/3
alpha i_expec_r i_amnot_r i_nojoy_r i_deciv_r
egen smonitor=rmean(i_expec_r i_amnot_r i_nojoy_r i_deciv_r)label variable i_expec_r "i_expec reverse 0-1"label variable i_amnot_r "i_amnot reverse 0-1"label variable i_nojoy_r "i_nojoy reverse 0-1"label variable i_deciv_r "i_deciv reverse 0-1"//stereotypes towards blacks//replace workbla=. if workbla>10replace violbla=. if violbla>10gen workbla0=((11-workbla)-1)/9gen violbla0=(violbla-1)/9//welfare and poverty stereotypes for  blacks
gen welfbla0=welfarb
replace welfbla0=. if welfbla0>10
replace welfbla0=(welfbla0-1)/9
replace wealthb=. if wealthb>10
gen poorbla0=((11-wealthb)-1)/9
//stereotypes towards whites
replace workwhi=. if workwhi>10replace violwhi=. if violwhi>10gen workwhi0=((11-workwhi)-1)/9gen violwhi0=(violwhi-1)/9


//Generate several "difference" measures//
gen d1_violent=violbla0-violwhi0
gen d1_work=workbla0-workwhi0
reg violbla0 violwhi0predict d2_violent, residuals
reg workbla0 workwhi0predict d2_work, residuals



//Age//
replace yearbrn=. if yearbrn>1983
gen age=2001-yearbrn
gen agemiss=age==.




//Other Demographic Variables
*Education is 1 if some college or greaterrecode educ 1 2 3 4 5 6 7 = 0 8=0 9 10=0 11=1 12 13 14=1 15 16=.*1 is femalerecode gender 2=0 3=.//racial resentmentgen irish_r=irishgen tryhard_r =tryhardgen deserve_r=deservegen slavery_r=slaveryrecode irish_r 1=1 2=.75 5 6=.5 3=.25 4=0recode tryhard_r 1=1 2=.75 5 6=.5 3=.25 4=0recode deserve_r 1=0 2=.25 5 6=.5 3=.75 4=1recode slavery_r 1=0 2=.25 5 6=.5 3=.75 4=1gen discrim_r=discrimgen noeduc_r=noeducreplace discrim_r=1-discrim_rreplace noeduc_r=1-noeduc_regen resent4= rmean (irish_r tryhard_r deserve_r slavery_r)label variable resent4 "K & S 4-item resetnment scale" ************************************************************************************************************************************************************************************

//Dependent variables//
************************************************************************************************************************************************************************************//Affirmative Actionrecode homeown 3 4=.recode integr 5 6=.recode locgov 5 6=.recode spended 5 6=.recode affact1 3 4=.recode affact2 3 4=.gen affact1_01=affact1recode affact1_01 1=0 2=1gen affact2_01=affact2recode affact2_01 1=0 2=1egen affact=rmean(affact1_01 affact2_01)label variable affact "affact1 afact2 0-1: 1=oppose aff action"
// Housing integrationrecode profil1 5 6=.recode profil2 5 6=.recode profil3 5 6=.recode deathpe 5 6=.recode favordp 3 4=.recode suspend 4 5=.recode nylaw 3 4=.recode innocen 3 4=. recode helpblc 3 4=.gen homeown01=homeownrecode homeown01 1=0 2=1label variable homeown0 "0-1 homeown, 1=up to homeowner"gen integr01=integrrecode integr01 1=0 2=.33 3=.67 4=1label variable integr01 "integr recoded to 0-1, 1=st. oppose"gen locgov01=locgovrecode locgov01 1=0 2=.33 3=.67 4=1label variable locgov01 "locgov: recoded to 0-1, 1=st oppose"egen housintegr=rmean (integr01 locgov01 homeown01)egen housintegr2=rmean(integr01 locgov01)label variable housintegr2 "housing integration -integr01 locgov01"//Aid to blacksgen helpblk01=helpblcrecode helpblk01 1=0 2=1gen spended01=spendedrecode spended01 1=0 2=.33 3=.67 4=1egen aidblk=rmean(helpblk01 spended01)//Racial Profilinggen profil2_01=profil2gen profil3_01=profil3recode profil2_01 1=0 2=.33 3=.67 4=1recode profil3_01 1=0 2=.33 3=.67 4=1egen rac_profil=rmean(profil2_01 profil3_01)label variable rac_profil "oppose action against officers: profiling" //Death Penalty Attitudesrecode deathpe 4=0 3=.33 2=.67 1=1 5=. 6=.recode favordp 2=0 1=1 3=. 4=.recode suspend 1=0 2=1 3=. 4=. 5=.recode nylaw 2=0 1=1 3=. 4=.recode innocen 2=0 1=1 3=. 4=.egen death_penalty=rmean(deathpe suspend nylaw innocen)label variable death_penalty "death penalty: deathpe suspend nylaw innoc"alpha integr01 locgov01 helpblk01 spended01 affact1_01 affact2_01, std gen(dv1)egen dv_1=rmean(integr01 locgov01 helpblk01 spended01 affact1_01 affact2_01)//Subjective Diversity
gen pcent=pct_aa
replace pcent=0 if nxtdoor==2
recode pcent (999 998 111=.)

//Media consumption
gen local=localtv
replace local=. if local==8

//Wave variable
gen wave_r=0 if area<.
replace wave_r=1 if areacode<.
//Primary Model includes %B-%W//Do not select below for figure. Scroll to **end**//******BEGIN*************First, Mean Center Everything*****
egen EGALITARIANISM=mean(egalitarianism) egen INDIVIDUALISM=mean(individualism) egen PID=mean(pid)egen LIBCON=mean(libcon) egen WORKBLA0=mean(workbla0) egen VIOLBLA0=mean(violbla0) egen SMONITOR=mean(smonitor) egen DIF=mean(dif)egen LNDIF=mean(lndif)egen HET=mean(het)
egen LOCAL=mean(local)
replace egalitarianism=egalitarianism-EGALITARIANISM replace individualism=individualism-INDIVIDUALISM replace pid=pid-PID replace libcon=libcon-LIBCON replace workbla0=workbla0-WORKBLA0 replace violbla0=violbla0-VIOLBLA0 replace smonitor=smonitor-SMONITOR replace dif=dif-DIFreplace lndif=lndif-LNDIF
replace het=het-HET
replace local=local-LOCAL//Correlation of stereotypes across levels of self monitoring
//Weak evidence that SM correlation varies across smonitoring.
corr workbla0 violbla0 if smonitor> .1246931  & smonitor<.
corr workbla0 violbla0 if  smonitor<-.1253069 
corr workbla0 violbla0 if smonitor>-.1252  & smonitor<.125  
//summary measuresalpha integr01 locgov01 helpblk01 spended01 affact1_01 affact2_01
alpha deathpe suspend nylaw innocenalpha irish_r tryhard_r deserve_r slavery_rcorr blame_r poverty_rcorr eqright_r eqpeopl_r 
 /*** creating interactions with self monitoring and neighborhood composition**/
//model with difference black-white//
local h="dif"gen ZIPbXsm=`h'*smonitorgen workblaXsm=workbla0*smonitorgen violblaXsm=violbla0*smonitorgen workblaXZIPb=workbla0*`h'gen violblaXZIPb=violbla0*`h'gen workXsmXZIP=workbla0*`h'*smonitorgen vioXsmXZIP=violbla0*`h'*smonitor

//Impute Age. Linear projection of covariates. Things do not substantively change when interactions and dvs are included
mi query
mi set mlong
mi register imputed age 
mi register regular egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif 
mi impute mvn age  =  egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif , add(1) rseed(546) force 

//Mean center after imputation
egen AGE=mean(age)
replace age=age-AGE//Page 16 of Supplementary Materialsum dif, detailgen hiD=1 if dif>=.2360098   & dif<.
replace hiD=0 if dif<=-.1350976  

sum smonitor, detail
gen hiS=1 if smonitor>=.2913598      & smonitor<.
replace hiS=0 if smonitor<= -0.2919736

by hiD, sort: sum  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif

//Also for supplement
by zip, sort: gen count=_n
drop if count!=1
drop if hiD==.
sort hiD zip
keep hiD zip

////////////////////////////////////////////////////////////////////////////////////////////////////////////

//These are the tables//
//Table 1, OLS results
//Table 2, Marginal effects
//Tables 3 and 4, Dissembling analysis

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
sum  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif
//First order effects (Reported in Table 1)
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age dif
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif
//Interactive Model with three ways (Reported in Table 1). Uncomment est store below for footnote X
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  
est store a1
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  
est store a2
suest a1 a2
test [a1_mean]_b[workXsmXZIP]-[a2_mean]_b[workXsmXZIP]=0
test [a1_mean]_b[vioXsmXZIP]-[a2_mean]_b[vioXsmXZIP]=0
//Dissembling Table Model (Reported in Tables 3 and 4)
reg workbla0 egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsmmlogit mid1  egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsm, base(3)reg violbla0 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsmmlogit mid2 egalitarianism individualism   pid libcon gender educ smonitor age  dif  ZIPbXsm, base(2)
//Alternative Specifications and Estimators (Reported in Supplementary Table A1)
//These are reported in supplementary appendix, table A1.
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP, cluster(zip)
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP, cluster(zip)
xtmixed dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP ||zip:
xtmixed death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP || zip:
//Heckman Model. This is included in a footnote.
heckman workbla0 egalitarianism individualism  pid libcon gender educ smonitor age agemiss dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)heckman violbla0 egalitarianism individualism  pid libcon gender educ smonitor age agemiss dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)
recode mid1 (1=1) (2=0) (3=0) (4=.), gen (mi1)
recode mid2 (1=1) (2=0) (3=0) (4=.), gen (mi2)
//Check this below
heckman mi1 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)
heckman mi2 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)

//Footnote XX
//These models are included in Footnote XX. They add survey wave and media consumption
//First order effects (Reported in Table 1)
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age dif local wave_r
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif local wave_r
//Interactive Model with three ways (Reported in Table 1). Uncomment est store below for footnote X
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  local wave_r
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  local wave_r
//Dissembling Table Model (Reported in Tables 3 and 4)
reg workbla0 egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsm local wave_rmlogit mid1  egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsm local wave_r, base(3)reg violbla0 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm local wave_rmlogit mid2 egalitarianism individualism   pid libcon gender educ smonitor age  dif  ZIPbXsm local wave_r, base(2)

//These models are included in Footnote XX. They rely on a censored version of diversity.
drop ZIPbXsm-vioXsmXZIP
gen censored_dif=black-white
replace censored_dif=0 if censored_dif>0 & censored_dif<.
local h="censored_dif"gen ZIPbXsm=`h'*smonitorgen workblaXsm=workbla0*smonitorgen violblaXsm=violbla0*smonitorgen workblaXZIPb=workbla0*`h'gen violblaXZIPb=violbla0*`h'gen workXsmXZIP=workbla0*`h'*smonitorgen vioXsmXZIP=violbla0*`h'*smonitor

reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age censored_dif 
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor censored_dif  
//Interactive Model with three ways (Reported in Table 1). Uncomment est store below for footnote X
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age censored_dif  workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age censored_dif  workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP 
//Dissembling Table Model (Reported in Tables 3 and 4)
reg workbla0 egalitarianism individualism pid libcon gender educ smonitor age censored_dif   ZIPbXsmmlogit mid1  egalitarianism individualism pid libcon gender educ smonitor age censored_dif   ZIPbXsm, base(3)reg violbla0 egalitarianism individualism  pid libcon gender educ smonitor age censored_dif   ZIPbXsm mlogit mid2 egalitarianism individualism   pid libcon gender educ smonitor age  censored_dif   ZIPbXsm,  base(2)



//Simple Slopes/Marginal Effects Analysis for the Text//
//This is table 2.
//Note: The fixed values are assuming nothing is mean centered. So do not mean center if this is run; otherwise,change 10, 25, 75, and 90 percentiles
//Racial Policy//
*p<0.10, 1.645
**p<0.05, 2.03
***p<0.01, 2.7
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
	  *10th percentile SM and 10th percentile DIF
	  local valsm = 0
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 			  
			  di dydx2 se2 
			  			  di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*10th percentile SM and 25th percentile DIF
	 local valsm = 0
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2
			    di dydx1/se1
						  di dydx2/se2 
			  drop dydx1 se1 dydx2 se2  			  
	*10th percentile SM and 75th percentile DIF
	 local valsm = 0
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  
	*10th percentile SM and 90th percentile DIF
	 local valsm = 0
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	
			  
			    
   *25th percentile SM and 10th percentile DIF
	  local valsm = 0.167
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*25th percentile SM and 25th percentile DIF
	 local valsm = 0.167
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  			  
	*25th percentile SM and 75th percentile DIF
	 local valsm = 0.167
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*25th percentile SM and 90th percentile DIF
	 local valsm = 0.167
	  local valblack=0.381
	    quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 10th percentile DIF
	  local valsm = 0.417
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 25th percentile DIF
	 local valsm = 0.417
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  			  
	*75th percentile SM and 75th percentile DIF
	 local valsm = 0.417
	  local valblack=0.172
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2 
	*75th percentile SM and 90th percentile DIF
	 local valsm = 0.417
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  
	  
	*90th percentile SM and 10th percentile DIF
	  local valsm = 0.58
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*90th percentile SM and 25th percentile DIF
	 local valsm = 0.58
	  local valblack=0.031
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  			  
	*90th percentile SM and 75th percentile DIF
	 local valsm = 0.58
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*90th percentile SM and 90th percentile DIF
	 local valsm = 0.58
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
			  			  		  
//Death Penalty Attitudes
//The fixed values are assuming nothing is mean centered. So do not mean center if this is run; otherwise,change 10, 25, 75, and 90 percentiles

reg death_penalty egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
	 	  *10th percentile SM and 10th percentile DIF
	  local valsm = 0
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 			  
			  di dydx2 se2 
			  			  di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*10th percentile SM and 25th percentile DIF
	 local valsm = 0
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2
			    di dydx1/se1
						  di dydx2/se2 
			  drop dydx1 se1 dydx2 se2  			  
	*10th percentile SM and 75th percentile DIF
	 local valsm = 0
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  
	*10th percentile SM and 90th percentile DIF
	 local valsm = 0
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	
			  
			    
   *25th percentile SM and 10th percentile DIF
	  local valsm = 0.167
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*25th percentile SM and 25th percentile DIF
	 local valsm = 0.167
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  			  
	*25th percentile SM and 75th percentile DIF
	 local valsm = 0.167
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*25th percentile SM and 90th percentile DIF
	 local valsm = 0.167
	  local valblack=0.381
	    quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 10th percentile DIF
	  local valsm = 0.417
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 25th percentile DIF
	 local valsm = 0.417
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  			  
	*75th percentile SM and 75th percentile DIF
	 local valsm = 0.417
	  local valblack=0.172
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2 
	*75th percentile SM and 90th percentile DIF
	 local valsm = 0.417
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  
	  
	*90th percentile SM and 10th percentile DIF
	  local valsm = 0.58
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*90th percentile SM and 25th percentile DIF
	 local valsm = 0.58
	  local valblack=0.031
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  			  
	*90th percentile SM and 75th percentile DIF
	 local valsm = 0.58
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*90th percentile SM and 90th percentile DIF
	 local valsm = 0.58
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
			  			  		  		
			  			  		  		
			  			  		  		


//Wireframe Plot to create figures A2 and A3****
//Again, not mean centered, so comment mean centering syntax above if used.
local h="dif"gen ZIPbXsm=`h'*smonitorgen workblaXsm=workbla0*smonitorgen violblaXsm=violbla0*smonitorgen workblaXZIPb=workbla0*`h'gen violblaXZIPb=violbla0*`h'gen workXsmXZIP=workbla0*`h'*smonitorgen vioXsmXZIP=violbla0*`h'*smonitor
set obs 101
gen n=_n
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
set more off
**Create a 100x100 matrix with SM on the row, Diversity on the column. Do not mean center**
forvalues j=1/59{
    gen t`j'=.
    }    
    set more off
*Loop around values of sm. Go from 0.10 to 90th percentile which is 0.to 0.58
  forvalues i=1/59{
	  local valsm = (`i'-1)/100
	  *Loop around values of value black, go from 10 to 90th 
              forvalues j=2/39{
              	local valblack=(`j'-1)/100
                  quietly predictnl dydx=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se)
                  quietly replace t`j'=dydx/se if n==`i'
               drop dydx se
               }
}
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
set more off
**Create two 100x100 matrix with SM on the row, Diversity on the column**
forvalues j=1/59{
    gen u`j'=.
    }    
    set more off
*Loop around values of sm. Go from 0.10 to 90th percentile which is 0 to 0.58
  forvalues i=1/59{
	  local valsm = (`i'-1)/100
	  *Loop around values of value black, go from 10 to 90th, which is 0.01 to 0.38
              forvalues j=2/39{
              	local valblack=(`j'-1)/100
                  quietly predictnl dydx=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se)
                  quietly replace u`j'=dydx/se if n==`i'
               drop dydx se
               }
}
**Output a file to create a wireframe plot in R**
outsheet t1-t59 u1-u59 in 1/101 using "wire.csv", comma  replace

	  			  
			  			  
//Table A2 and A3; this model excludes values
reg dv_1   pid libcon  workbla0 violbla0 gender educ smonitor dif age 
reg death_penalty  pid libcon  workbla0 violbla0 gender educ smonitor dif age
reg dv_1 pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg death_penalty  pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg workbla0   pid libcon gender educ smonitor age dif  ZIPbXsm  
reg violbla0   pid libcon gender educ smonitor age dif  ZIPbXsm   
mlogit mid1   pid libcon gender educ smonitor age dif  ZIPbXsm  , base(3) 
mlogit mid2   pid libcon gender educ smonitor age dif  ZIPbXsm  , base(2) 

//Imputation Models (Reported in Footnote)
*drop age
//Age//
replace yearbrn=. if yearbrn>1983
drop age
gen age=2001-yearbrn
mi query
mi set mlong
mi register imputed age 
mi register regular egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif 
//Multiple Imputations
mi impute mvn age  =  egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif , add(20) rseed(546) force 
mi estimate: reg dv_1  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  age 
mi estimate: reg death_penalty  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
mi estimate: reg workbla0  egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsmmi estimate: mlogit mid1 egalitarianism individualism pid libcon gender educ smonitor age  dif ZIPbXsm , base(3)mi estimate: reg violbla0 egalitarianism individualism   pid libcon gender educ smonitor age dif  ZIPbXsmmi estimate: mlogit mid2  egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm  , base(2) 


//Additional Robustness checks for supplementary material (Table A5, A6, and A7)
//Branton and Jones (2005) measure
drop ZIPbXsm-vioXsmXZIP
local h="het"gen ZIPbXsm=`h'*smonitorgen workblaXsm=workbla0*smonitorgen violblaXsm=violbla0*smonitorgen workblaXZIPb=workbla0*`h'gen violblaXZIPb=violbla0*`h'gen workXsmXZIP=workbla0*`h'*smonitorgen vioXsmXZIP=violbla0*`h'*smonitor
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor `h' age 
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor `h' age
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg death_penalty egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg workbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid1 egalitarianism individualism pid libcon gender educ smonitor age `h' ZIPbXsm , base(3)
reg violbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid2 egalitarianism individualism pid libcon gender educ smonitor age  `h' ZIPbXsm , base(2)



//Alternative specification using log transformed (Reported in Table A8, A9, and A10)
drop ZIPbXsm-vioXsmXZIP
local h="lndif"gen ZIPbXsm=`h'*smonitorgen workblaXsm=workbla0*smonitorgen violblaXsm=violbla0*smonitorgen workblaXZIPb=workbla0*`h'gen violblaXZIPb=violbla0*`h'gen workXsmXZIP=workbla0*`h'*smonitorgen vioXsmXZIP=violbla0*`h'*smonitor
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor `h' age 
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor `h' age
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg death_penalty egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg workbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid1 egalitarianism individualism pid libcon gender educ smonitor age  `h' ZIPbXsm , base(3)
reg violbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid2 egalitarianism individualism pid libcon gender educ smonitor age  `h' ZIPbXsm , base(2)


******END****************END****************END****************END****************END****************END****************END****************END****************END****************END**********//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//

*Syntax to Generate Figures 1 and 2. Generate figure at 10 and 90 percentiles for SM and Diversity
**Do not use mean centered variables***set more offlocal h="dif"gen ZIPbXsm=`h'*smonitorgen workblaXsm=workbla0*smonitorgen violblaXsm=violbla0*smonitorgen workblaXZIPb=workbla0*`h'gen violblaXZIPb=violbla0*`h'gen workXsmXZIP=workbla0*`h'*smonitorgen vioXsmXZIP=violbla0*`h'*smonitor//For combined scale***Min (10%) and Max (90%) SM and Diversity****gen smonitorlow=0gen smonitorhigh=0.58333gen blackhigh=0.3814314gen blacklow=0.0103239***Begin File****estsimp reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
generate plo1=.generate phi1=.generate pe1=.generate stereot=_n in 1/101replace stereot=stereot-1generate plo2=.generate phi2=.generate pe2=.generate plo3=.generate phi3=.generate pe3=.generate plo4=.generate phi4=.generate pe4=.*****************************no blacks, min sm*************************setx (egalitarianism individualism pid libcon  violbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorlow			gen blackhat=blacklow		      local C1=((`a')/100)*smhat /*workblaXsm*/     			local C2=((`a')/100)*smhat*blackhat /*workXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*workblaXZIPb*/  			sum violbla0			gen violhat=r(mean)		      local C5=violhat*smhat		/*SM x Violence*/			local C6=violhat*blackhat  /*violblaXZIPb*/			local C7=violhat*blackhat*smhat  /*vioXsmXZIP*/			local smonitor=smonitorlow						setx (smonitor) `smonitor' 			setx (violblaXsm)`C5'/*This will stay constant, it is SM x violence*/			setx (workblaXsm)`C1' /*This is the the SM x work interaction*/			setx(workbla0)((`a')/100) 			local black=blacklow			setx (dif) `black'   /*hetereogeneity*/	        	setx violblaXZIPb `C6'       			setx workblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx vioXsmXZIP `C7'     			setx workXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5) 		gen lo=r(r1)		gen up=r(r2)		replace plo1=lo if stereot==`a'		replace phi1=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe1=t if stereot==`a'drop pi up lo t violhat smhat blackhat local a=`a'+1}*****************************no blacks, max sm*************************setx (egalitarianism individualism pid libcon  violbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorhigh			gen blackhat=blacklow		      local C1=((`a')/100)*smhat /*workblaXsm*/     			local C2=((`a')/100)*smhat*blackhat /*workXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*workblaXZIPb*/  			sum violbla0			gen violhat=r(mean)		      local C5=violhat*smhat		/*SM x Violence*/			local C6=violhat*blackhat  /*violblaXZIPb*/			local C7=violhat*blackhat*smhat  /*vioXsmXZIP*/			local smonitor=smonitorhigh						setx (smonitor) `smonitor' 			setx (violblaXsm)`C5'/*This will stay constant, it is SM x violence*/			setx (workblaXsm)`C1' /*This is the the SM x work interaction*/			setx(workbla0)((`a')/100) 			local black=blacklow			setx (dif) `black'   /*hetereogeneity*/	        	setx violblaXZIPb `C6'       			setx workblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx vioXsmXZIP `C7'     			setx workXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo2=lo if stereot==`a'		replace phi2=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe2=t if stereot==`a'drop pi up lo t violhat smhat blackhat local a=`a'+1}*****************************max blacks, min sm*************************setx (egalitarianism individualism pid libcon  violbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorlow			gen blackhat=blackhigh		      local C1=((`a')/100)*smhat /*workblaXsm*/     			local C2=((`a')/100)*smhat*blackhat /*workXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*workblaXZIPb*/  			sum violbla0			gen violhat=r(mean)		      local C5=violhat*smhat		/*SM x Violence*/			local C6=violhat*blackhat  /*violblaXZIPb*/			local C7=violhat*blackhat*smhat  /*vioXsmXZIP*/			local smonitor=smonitorlow						setx (smonitor) `smonitor' 			setx (violblaXsm)`C5'/*This will stay constant, it is SM x violence*/			setx (workblaXsm)`C1' /*This is the the SM x work interaction*/			setx(workbla0)((`a')/100) 			local black=blackhigh			setx (dif) `black'   /*hetereogeneity*/	        	setx violblaXZIPb `C6'       			setx workblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx vioXsmXZIP `C7'     			setx workXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo3=lo if stereot==`a'		replace phi3=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe3=t if stereot==`a'drop pi up lo t violhat smhat blackhat local a=`a'+1}*****************************max blacks, max sm*************************setx (egalitarianism individualism pid libcon  violbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorhigh			gen blackhat=blackhigh		      local C1=((`a')/100)*smhat /*workblaXsm*/     			local C2=((`a')/100)*smhat*blackhat /*workXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*workblaXZIPb*/  			sum violbla0			gen violhat=r(mean)		      local C5=violhat*smhat		/*SM x Violence*/			local C6=violhat*blackhat  /*violblaXZIPb*/			local C7=violhat*blackhat*smhat  /*vioXsmXZIP*/			local smonitor=smonitorhigh						setx (smonitor) `smonitor' 			setx (violblaXsm)`C5'/*This will stay constant, it is SM x violence*/			setx (workblaXsm)`C1' /*This is the the SM x work interaction*/			setx(workbla0)((`a')/100) 			local black=blackhigh			setx (dif) `black'   /*hetereogeneity*/	        	setx violblaXZIPb `C6'       			setx workblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx vioXsmXZIP `C7'     			setx workXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo4=lo if stereot==`a'		replace phi4=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe4=t if stereot==`a'drop pi up lo t violhat smhat blackhat local a=`a'+1}gen v1=plo1 gen v2=phi1 gen v3=pe1 gen v4=stereot gen v5=plo2 gen v6=phi2 gen v7=pe2 gen v8=plo3 gen v9=phi3 gen v10=pe3 gen v12=plo4 gen v13=phi4 gen v14=pe4 drop plo1 phi1 pe1 stereot plo2 phi2 pe2 plo3 phi3 pe3 plo4 phi4 pe4drop b1-b19 b20//Death Penaltyestsimp reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
generate plo1=.generate phi1=.generate pe1=.generate stereot=_n in 1/101replace stereot=stereot-1generate plo2=.generate phi2=.generate pe2=.generate plo3=.generate phi3=.generate pe3=.generate plo4=.generate phi4=.generate pe4=.*****************************no blacks, min sm*************************setx (egalitarianism individualism pid libcon  workbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorlow			gen blackhat=blacklow		      local C1=((`a')/100)*smhat /*violXsm*/     			local C2=((`a')/100)*smhat*blackhat /*violXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*violXZIPb*/  			sum workbla0			gen workhat=r(mean)		      local C5=workhat*smhat		/*SM x Violence*/			local C6=workhat*blackhat  /*workblaXZIPb*/			local C7=workhat*blackhat*smhat  /*workXsmXZIP*/			local smonitor=smonitorlow						setx (smonitor) `smonitor' 			setx (workblaXsm)`C5'/*This will stay constant, it is SM x work*/			setx (violblaXsm)`C1' /*This is the the SM x work interaction*/			setx(violbla0)((`a')/100) 			local black=blacklow			setx (dif) `black'   /*hetereogeneity*/	        	setx workblaXZIPb `C6'       			setx violblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx workXsmXZIP `C7'     			setx vioXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo1=lo if stereot==`a'		replace phi1=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe1=t if stereot==`a'drop pi up lo t workhat smhat blackhat local a=`a'+1}*****************************no blacks, max sm*************************setx (egalitarianism individualism pid libcon  workbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorhigh			gen blackhat=blacklow		      local C1=((`a')/100)*smhat /*violXsm*/     			local C2=((`a')/100)*smhat*blackhat /*violXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*violXZIPb*/  			sum workbla0			gen workhat=r(mean)		      local C5=workhat*smhat		/*SM x Violence*/			local C6=workhat*blackhat  /*workblaXZIPb*/			local C7=workhat*blackhat*smhat  /*workXsmXZIP*/			local smonitor=smonitorhigh						setx (smonitor) `smonitor' 			setx (workblaXsm)`C5'/*This will stay constant, it is SM x work*/			setx (violblaXsm)`C1' /*This is the the SM x work interaction*/			setx(violbla0)((`a')/100) 			local black=blacklow			setx (dif) `black'   /*hetereogeneity*/	        	setx workblaXZIPb `C6'       			setx violblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx workXsmXZIP `C7'     			setx vioXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo2=lo if stereot==`a'		replace phi2=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe2=t if stereot==`a'drop pi up lo t workhat smhat blackhat local a=`a'+1}*****************************max blacks, min sm*************************setx (egalitarianism individualism pid libcon  workbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorlow			gen blackhat=blackhigh		      local C1=((`a')/100)*smhat /*violXsm*/     			local C2=((`a')/100)*smhat*blackhat /*violXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*violXZIPb*/  			sum workbla0			gen workhat=r(mean)		      local C5=workhat*smhat		/*SM x Violence*/			local C6=workhat*blackhat  /*workblaXZIPb*/			local C7=workhat*blackhat*smhat  /*workXsmXZIP*/			local smonitor=smonitorlow						setx (smonitor) `smonitor' 			setx (workblaXsm)`C5'/*This will stay constant, it is SM x work*/			setx (violblaXsm)`C1' /*This is the the SM x work interaction*/			setx(violbla0)((`a')/100) 			local black=blackhigh			setx (dif) `black'   /*hetereogeneity*/	        	setx workblaXZIPb `C6'       			setx violblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx workXsmXZIP `C7'     			setx vioXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo3=lo if stereot==`a'		replace phi3=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe3=t if stereot==`a'drop pi up lo t workhat smhat blackhat local a=`a'+1}*****************************max blacks, max sm*************************setx (egalitarianism individualism pid libcon  workbla0  age)mean (gender)1  (educ)0local a=0	while `a'<=100{            gen smhat=smonitorhigh			gen blackhat=blackhigh		      local C1=((`a')/100)*smhat /*violXsm*/     			local C2=((`a')/100)*smhat*blackhat /*violXsmXZIP*/        			local C3=smhat*blackhat /*ZIPbxSM*/	        			local C4=((`a')/100)*blackhat /*violXZIPb*/  			sum workbla0			gen workhat=r(mean)		      local C5=workhat*smhat		/*SM x Violence*/			local C6=workhat*blackhat  /*workblaXZIPb*/			local C7=workhat*blackhat*smhat  /*workXsmXZIP*/			local smonitor=smonitorhigh						setx (smonitor) `smonitor' 			setx (workblaXsm)`C5'/*This will stay constant, it is SM x work*/			setx (violblaXsm)`C1' /*This is the the SM x work interaction*/			setx(violbla0)((`a')/100) 			local black=blackhigh			setx (dif) `black'   /*hetereogeneity*/	        	setx workblaXZIPb `C6'       			setx violblaXZIPb `C4'      			setx ZIPbXsm `C3'      			setx workXsmXZIP `C7'     			setx vioXsmXZIP `C2'		simqi, ev genev(pi)		_pctile pi, p(2.5,97.5)		gen lo=r(r1)		gen up=r(r2)		replace plo4=lo if stereot==`a'		replace phi4=up if stereot==`a'		sum pi		gen t=r(mean)		replace pe4=t if stereot==`a'drop pi up lo t workhat smhat blackhat local a=`a'+1}gen x1=plo1 gen x2=phi1 gen x3=pe1 gen x4=stereot gen x5=plo2 gen x6=phi2 gen x7=pe2 gen x8=plo3 gen x9=phi3 gen x10=pe3 gen x12=plo4 gen x13=phi4 gen x14=pe4 drop plo1 phi1 pe1 stereot plo2 phi2 pe2 plo3 phi3 pe3 plo4 phi4 pe4drop b1-b19 b20gen stereot=v4/100set scheme s2monograph twoway (rarea v5 v6 stereot, color(gs11) sort  msize(medium) )|| (line v7 stereot, sort msymbol(Oh) clpattern(shortdash))|| (line v3 stereot, sort msymbol(Oh) clpattern(solid)) ,ylabel(0(0.2)1.0) ytitle("Policy Attitudes") xtitle("Lazy Stereotype") xlabel(0(.2)1) name(graph1, replace) legend(label(2 "High SM") label(3 "Low SM") label(1 "95% Confidence Interval") )  title("Race Policy") subtitle("Low Diversity")graph twoway (rarea v12 v13 stereot, color(gs11) sort  msize(medium) )|| (line v14 stereot, sort msymbol(Oh) clpattern(shortdash))|| (line v10 stereot, sort msymbol(Oh) clpattern(solid)) ,ylabel(0(0.2)1.0) ytitle("Policy Attitudes") xtitle("Lazy Stereotype") xlabel(0(.2)1) name(graph2, replace) legend(label(2 "High SM") label(3 "Low SM") label(1 "95% Confidence Interval") ) title("Race Policy") subtitle("High Diversity")graph twoway (rarea x5 x6 stereot, color(gs11) sort  msize(medium) )|| (line x7 stereot, sort msymbol(Oh) clpattern(shortdash))|| (line x3 stereot, sort msymbol(Oh) clpattern(solid)) ,ylabel(0(0.2)1.0) ytitle("Death Penalty") xtitle("Violent Stereotype") xlabel(0(.2)1) name(graph3, replace) legend(label(2 "High SM") label(3 "Low SM") label(1 "95% Confidence Interval") )  title("Support Death Penalty") subtitle("Low Diversity")graph twoway (rarea x12 x13 stereot, color(gs11) sort  msize(medium) )|| (line x14 stereot, sort msymbol(Oh) clpattern(shortdash))|| (line x10 stereot, sort msymbol(Oh) clpattern(solid)) ,ylabel(0(0.2)1.0) ytitle("Death Penalty") xtitle("Violent Stereotype") xlabel(0(.2)1) name(graph4, replace) legend(label(2 "High SM") label(3 "Low SM") label(1 "95% Confidence Interval") ) title("Support Death Penalty") subtitle("High Diversity")grc1leg  graph1  graph2 graph3 graph4, col(2) row(2) iscale(*0.8) imargin(medium) legendfrom(graph1) note("High=90th percentile; Low=10th percentile.")//Generate the multinomial logit figuresdrop v1-v14 
drop stereot
estsimp reg violbla0 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm

generate plo1=.generate phi1=.generate pe1=.generate stereot=_n in 1/101replace stereot=stereot-1generate plo2=.generate phi2=.generate pe2=.*****************************no blacks*************************setx (egalitarianism individualism pid libcon age)mean (gender)1  (educ)0local a=0	while `a'<=100{			gen blackhat=blacklow		    local C1=((`a')/100)*blackhat /*ZIPxSM*/			local C2=((`a')/100) /*SM*/
			local black=blackhat			setx (dif) `black' 			setx (smonitor) `C2'			setx (ZIPbXsm) `C1'			simqi, ev genev(pi)			_pctile pi, p(2.5,97.5) 			gen lo=r(r1)			gen up=r(r2)			replace plo1=lo if stereot==`a'			replace phi1=up if stereot==`a'			sum pi			gen t=r(mean)			replace pe1=t if stereot==`a'drop pi up lo t blackhat local a=`a'+1}*****************************max blacks*************************setx (egalitarianism individualism pid libcon age)mean (gender)1  (educ)0local a=0	while `a'<=100{			gen blackhat=blackhigh		    local C1=((`a')/100)*blackhat /*ZIPxSM*/			local C2=((`a')/100) /*SM*/
			local black=blackhat			setx (dif) `black' 			setx (smonitor) `C2'			setx (ZIPbXsm) `C1'			simqi, ev genev(pi)			_pctile pi, p(2.5,97.5) 			gen lo=r(r1)			gen up=r(r2)			replace plo2=lo if stereot==`a'			replace phi2=up if stereot==`a'			sum pi			gen t=r(mean)			replace pe2=t if stereot==`a'drop pi up lo t blackhat local a=`a'+1}gen v1=plo1 gen v2=phi1 gen v3=pe1 gen v4=stereot gen v5=plo2 gen v6=phi2 gen v7=pe2 drop plo1 phi1 pe1 stereot plo2 phi2 pe2 drop b1-b11 b12gen stereot=v4/100set scheme s2mono

gen vv1=v1
gen vv2=v2
gen vv3=v3
gen vv7=v7//Generate the dissembling models. Using SM as the x-axis
drop v1-v7
***Multinomial logit figures*********drop stereot
generate ploa1=.generate phia1=.generate pea1=.generate ploa2=.generate phia2=.generate pea2=.generate ploa3=.generate phia3=.generate pea3=.generate ploa4=.generate phia4=.generate pea4=.generate plob1=.generate phib1=.generate peb1=.generate plob2=.generate phib2=.generate peb2=.generate plob3=.generate phib3=.generate peb3=.generate plob4=.generate phib4=.generate peb4=.generate stereot=_n in 1/101replace stereot=stereot-1estsimp mlogit mid1 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm, base(3)setx (pid libcon individualism egalitarianism  gender age)mean (gender)1  (educ)0
***Low Diversity****local a=0	while `a'<=100{	        gen blackhat=blacklow		      local C1=((`a')/100)*blackhat /*sm x diversity*/		      local SM=((`a')/100)
		      local black=blackhat			   setx (dif) `black'  (smonitor) `SM' (ZIPbXsm)`C1'                   simqi, prval(1 2 3 4) genpr(v1 v2 v3 v4)		           _pctile v1, p(2.5,97.5)		gen loa1=r(r1)		gen upa1=r(r2)		replace ploa1=loa1 if stereot==`a'		replace phia1=upa1 if stereot==`a'		sum v1		gen ta1=r(mean)    	replace pea1=ta1 if stereot==`a'    _pctile v2, p(2.5,97.5)		gen loa2=r(r1)		gen upa2=r(r2)		replace ploa2=loa2 if stereot==`a'		replace phia2=upa2 if stereot==`a'		sum v2		gen ta2=r(mean)		replace pea2=ta2 if stereot==`a'    _pctile v3, p(2.5,97.5)		gen loa3=r(r1)		gen upa3=r(r2)		replace ploa3=loa3 if stereot==`a'		replace phia3=upa3 if stereot==`a'		sum v3		gen ta3=r(mean)		replace pea3=ta3 if stereot==`a'     _pctile v4, p(2.5,97.5)		gen loa4=r(r1)		gen upa4=r(r2)		replace ploa4=loa4 if stereot==`a'		replace phia4=upa4 if stereot==`a'		sum v4		gen ta4=r(mean)		replace pea4=ta4 if stereot==`a'drop v1 v2 v3 v4 upa1 loa1 upa2 loa2 upa3 loa3 upa4 loa4 ta1 ta2 ta3 ta4 blackhat local a=`a'+1}setx (pid libcon individualism egalitarianism  gender age)mean (gender)1  (educ)0
***High Diversity****local a=0	while `a'<=100{	        gen blackhat=blackhigh		      local C1=((`a')/100)*blackhat /*sm x diversity*/		      local SM=((`a')/100)
		      local black=blackhat			   setx (dif) `black'  (smonitor) `SM' (ZIPbXsm)`C1'                   simqi, prval(1 2 3 4) genpr(v1 v2 v3 v4)		           _pctile v1, p(2.5,97.5)		gen lob1=r(r1)		gen upb1=r(r2)		replace plob1=lob1 if stereot==`a'		replace phib1=upb1 if stereot==`a'		sum v1		gen tb1=r(mean)    	replace peb1=tb1 if stereot==`a'    _pctile v2, p(2.5,97.5)		gen lob2=r(r1)		gen upb2=r(r2)		replace plob2=lob2 if stereot==`a'		replace phib2=upb2 if stereot==`a'		sum v2		gen tb2=r(mean)		replace peb2=tb2 if stereot==`a'    _pctile v3, p(2.5,97.5)		gen lob3=r(r1)		gen upb3=r(r2)		replace plob3=lob3 if stereot==`a'		replace phib3=upb3 if stereot==`a'		sum v3		gen tb3=r(mean)		replace peb3=tb3 if stereot==`a'     _pctile v4, p(2.5,97.5)		gen lob4=r(r1)		gen upb4=r(r2)		replace plob4=lob4 if stereot==`a'		replace phib4=upb4 if stereot==`a'		sum v4		gen tb4=r(mean)		replace peb4=tb4 if stereot==`a'drop v1 v2 v3 v4 upb1 lob1 upb2 lob2 upb3 lob3 upb4 lob4 tb1 tb2 tb3 tb4 blackhat local a=`a'+1}gen y1=ploa1 gen y2=phia1gen y3=pea1gen y4=ploa2 gen y5=phia2gen y6=pea2gen y7=ploa3 gen y8=phia3gen y9=pea3gen y10=ploa4 gen y11=phia4gen y12=pea4gen y13=plob1 gen y14=phib1gen y15=peb1gen y16=plob2 gen y17=phib2gen y18=peb2gen y19=plob3 gen y20=phib3gen y21=peb3gen y22=plob4 gen y23=phib4gen y24=peb4gen y25=stereot drop stereot ploa1-peb4drop b1-b33//Violent stereotyperecode mid2 2=3 3=2label values mid2 mid1generate ploa1=.generate phia1=.generate pea1=.generate ploa2=.generate phia2=.generate pea2=.generate ploa3=.generate phia3=.generate pea3=.generate ploa4=.generate phia4=.generate pea4=.generate plob1=.generate phib1=.generate peb1=.generate plob2=.generate phib2=.generate peb2=.generate plob3=.generate phib3=.generate peb3=.generate plob4=.generate phib4=.generate peb4=.generate stereot=_n in 1/101replace stereot=stereot-1estsimp mlogit mid2 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm, base(3)setx (pid libcon individualism egalitarianism  gender age)mean (gender)1  (educ)0
***Low Diversity****local a=0	while `a'<=100{	        gen blackhat=blacklow		      local C1=((`a')/100)*blackhat /*sm x diversity*/		      local SM=((`a')/100)
		      local black=blackhat			   setx (dif) `black'  (smonitor) `SM' (ZIPbXsm)`C1'                   simqi, prval(1 2 3 4) genpr(v1 v2 v3 v4)		           _pctile v1, p(2.5,97.5)		gen loa1=r(r1)		gen upa1=r(r2)		replace ploa1=loa1 if stereot==`a'		replace phia1=upa1 if stereot==`a'		sum v1		gen ta1=r(mean)    	replace pea1=ta1 if stereot==`a'    _pctile v2, p(2.5,97.5)		gen loa2=r(r1)		gen upa2=r(r2)		replace ploa2=loa2 if stereot==`a'		replace phia2=upa2 if stereot==`a'		sum v2		gen ta2=r(mean)		replace pea2=ta2 if stereot==`a'    _pctile v3, p(2.5,97.5)		gen loa3=r(r1)		gen upa3=r(r2)		replace ploa3=loa3 if stereot==`a'		replace phia3=upa3 if stereot==`a'		sum v3		gen ta3=r(mean)		replace pea3=ta3 if stereot==`a'     _pctile v4, p(2.5,97.5)		gen loa4=r(r1)		gen upa4=r(r2)		replace ploa4=loa4 if stereot==`a'		replace phia4=upa4 if stereot==`a'		sum v4		gen ta4=r(mean)		replace pea4=ta4 if stereot==`a'drop v1 v2 v3 v4 upa1 loa1 upa2 loa2 upa3 loa3 upa4 loa4 ta1 ta2 ta3 ta4 blackhat local a=`a'+1}setx (pid libcon individualism egalitarianism  gender age)mean (gender)1  (educ)0

***High Diversity****local a=0	while `a'<=100{	        gen blackhat=blackhigh		      local C1=((`a')/100)*blackhat /*sm x diversity*/		      local SM=((`a')/100)
		      local black=blackhat			   setx (dif) `black'  (smonitor) `SM' (ZIPbXsm)`C1'                   simqi, prval(1 2 3 4) genpr(v1 v2 v3 v4)		           _pctile v1, p(2.5,97.5)		gen lob1=r(r1)		gen upb1=r(r2)		replace plob1=lob1 if stereot==`a'		replace phib1=upb1 if stereot==`a'		sum v1		gen tb1=r(mean)    	replace peb1=tb1 if stereot==`a'    _pctile v2, p(2.5,97.5)		gen lob2=r(r1)		gen upb2=r(r2)		replace plob2=lob2 if stereot==`a'		replace phib2=upb2 if stereot==`a'		sum v2		gen tb2=r(mean)		replace peb2=tb2 if stereot==`a'    _pctile v3, p(2.5,97.5)		gen lob3=r(r1)		gen upb3=r(r2)		replace plob3=lob3 if stereot==`a'		replace phib3=upb3 if stereot==`a'		sum v3		gen tb3=r(mean)		replace peb3=tb3 if stereot==`a'     _pctile v4, p(2.5,97.5)		gen lob4=r(r1)		gen upb4=r(r2)		replace plob4=lob4 if stereot==`a'		replace phib4=upb4 if stereot==`a'		sum v4		gen tb4=r(mean)		replace peb4=tb4 if stereot==`a'drop v1 v2 v3 v4 upb1 lob1 upb2 lob2 upb3 lob3 upb4 lob4 tb1 tb2 tb3 tb4 blackhat local a=`a'+1}gen z1=ploa1 gen z2=phia1gen z3=pea1 
*Midpointgen z4=ploa2 gen z5=phia2gen z6=pea2 
*Rejectgen z7=ploa3 gen z8=phia3gen z9=pea3 
*Endorsegen z10=ploa4 gen z11=phia4gen z12=pea4 
*Opt outgen z13=plob1 gen z14=phib1gen z15=peb1gen z16=plob2 gen z17=phib2gen z18=peb2gen z19=plob3 gen z20=phib3gen z21=peb3gen z22=plob4 gen z23=phib4gen z24=peb4gen z25=stereot drop stereot ploa1-peb4drop b1-b33gen stereot=y25/100graph twoway (rarea vv1 vv2 stereot, color(gs11) sort  msize(medium) )|| (line vv3 stereot, sort msymbol(Oh) clpattern(shortdash))|| (line vv7 stereot, sort msymbol(Oh) clpattern(solid)) ,ytitle("Endorse Violent Stereotype") xtitle("Self Monitoring") xlabel(0(.2)1) ylabel(0(0.1)0.8) name(g1, replace) legend(label(2 "Low Diversity") label(3 "High Diversity") label(1 "95% Confidence Interval") )  title("Self Monitoring") subtitle("At Low and High Levels of Diversity") graph combine g1, iscale(*0.9)graph twoway (rarea z7 z8 stereot, color(gs11) sort  msize(medium) )|| (line z3 stereot, sort msymbol(Oh) clpattern(dash)) ||(line z6 stereot, sort msymbol(Oh)) ||(line z9 stereot, sort msymbol(Oh) clpattern("1")) ||(line z12 stereot, sort msymbol(Oh)) ,ylabel(0(0.1)0.8) ytitle("Probability") xtitle("Self Monitoring") xlabel(0(.2)1) name(graph3, replace) legend(label(1 "95% Confidence Interval")label(2 "Mid-Point") label(3 "Reject") label(4 "Endorse") label(5 "Opt-out") ) title("Violent Stereotype")  subtitle("Low Diversity")graph twoway (rarea z19 z20 stereot, color(gs11) sort  msize(medium) )|| (line z15 stereot, sort msymbol(Oh) clpattern(dash)) ||(line z18 stereot, sort msymbol(Oh)) ||(line z21 stereot, sort msymbol(Oh) clpattern("1")) ||(line z24 stereot, sort msymbol(Oh)) ,ylabel(0(0.1)0.8) ytitle("Probability") xtitle("Self Monitoring") xlabel(0(.2)1) name(graph4, replace) legend(label(1 "95% Confidence Interval")label(2 "Mid-Point") label(3 "Reject") label(4 "Endorse") label(5 "Opt-out") ) title("Violent Stereotype") subtitle("High Diversity")graph combine  graph3  graph4, col(2) iscale(*0.9) imargin(small) note("High=90th percentile; Low=10th percentile.")graph combine g1  graph3  graph4, col(2) row(2) iscale(*0.8) imargin(small) holes(3) note("High=90th percentile; Low=10th percentile.")