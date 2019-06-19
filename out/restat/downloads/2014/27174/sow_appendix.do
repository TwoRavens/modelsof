* Date: May21 2014
clear 
clear matrix
set mem 100m
set more 1
cap log close

log using sow_appendix_cluster.log,replace

use sow_data_2013oct
 
 

/*gen snow_groupd2=snow*groupd2
gen snow_groupd3=snow*groupd3*/
******************************************
 
*******Table A: Test for the Quality of Randomization for the Field Experiment.

* Linear Probability regression
reg groupd2 sow0 pig  no_xnh subsidy age_vil edu_vil male_vil pop_regist pop_migout surname_vil town_loc land, robust cluster(townid)
reg groupd3 sow0 pig  no_xnh subsidy age_vil edu_vil male_vil pop_regist pop_migout surname_vil town_loc land, robust cluster(townid)

*************************
* Multinominal Probit
mprobit group sow0 pig no_xnh subsidy age_vil edu_vil male_vil pop_regist pop_migout surname_vil town_loc land, base(1) robust cluster(townid)

****************
* Multinominal Logit
mlogit group sow0 pig no_xnh subsidy age_vil edu_vil male_vil pop_regist pop_migout surname_vil town_loc land, base(1) robust cluster(townid)

********************************************
** Table appendix C1 and C2 : examine the effect of sow deaths during the snow storm on subsequent production*

ge lnhouse=log(house_val)
sum house lnhouse
gen insured_house=insuredpig*lhouse_val
gen insured_edu=insuredpig*edu_vil
gen snow_house=snow*lhouse_val
gen snow_edu=snow*edu_vil

gen insured_house_snow=insured_house*snow
gen insured_edu_snow=insured_edu*snow
 
gen house_groupd2=lhouse_val*groupd2
gen house_groupd3=lhouse_val*groupd3

gen house_snow_gd2=snow_house*groupd2
gen house_snow_gd3=snow_house*groupd3

gen edu_groupd2=edu_vil*groupd2
gen edu_groupd3=edu_vil*groupd3

gen edu_snow_gd2=snow_edu*groupd2
gen edu_snow_gd3=snow_edu*groupd3

*****Table C1: IV Estimates of the Effect of Sow Deaths During the Snow Storm on Sow Production in March 2008.
 

ivreg sow3 snow sow0 (insuredpig=groupd2-groupd3) towndummy*,robust cluster(townid)

ivreg sow3 snow sow0 (insuredpig snow_insured =groupd2-groupd3 snow_groupd2 snow_groupd3)  towndummy*  ,robust cluster(townid)

 
ivreg sow3 snow sow0 (insuredpig snow_insured insured_house =groupd2-groupd3 snow_groupd2 snow_groupd3 house_groupd2 house_groupd3) lnhouse  snow_house towndummy*,robust cluster(townid) 

ivreg sow3 snow sow0 (insuredpig snow_insured insured_house insured_house_snow =groupd2-groupd3 snow_groupd2 snow_groupd3 house_groupd2 house_groupd3 house_snow_gd2 house_snow_gd3) lnhouse snow_house  towndummy*,robust cluster(townid)  

ivreg sow3 snow sow0 (insuredpig snow_insured insured_edu insured_edu_snow =groupd2-groupd3 snow_groupd2 snow_groupd3 edu_groupd2 edu_groupd3 edu_snow_gd2 edu_snow_gd3) edu_vil  snow_edu   towndummy*,robust cluster(townid) 

 


******Table C2: IV Estimates of the Effect of Sow Deaths During the Snow Storm on Sow Production in June 2008.

ivreg sow4 snow sow0 (insuredpig=groupd2-groupd3) towndummy*,robust cluster(townid) 

ivreg sow4 snow sow0 (insuredpig snow_insured =groupd2-groupd3 snow_groupd2 snow_groupd3)    towndummy*,robust cluster(townid)  

 
ivreg sow4 snow sow0 (insuredpig snow_insured insured_house =groupd2-groupd3 snow_groupd2 snow_groupd3 house_groupd2 house_groupd3) lnhouse  snow_house towndummy*,robust cluster(townid)

ivreg sow4 snow sow0 (insuredpig snow_insured insured_house insured_house_snow =groupd2-groupd3 snow_groupd2 snow_groupd3 house_groupd2 house_groupd3 house_snow_gd2 house_snow_gd3) lnhouse snow_house towndummy*,robust cluster(townid)  
ivreg sow4 snow sow0 (insuredpig snow_insured insured_edu insured_edu_snow =groupd2-groupd3 snow_groupd2 snow_groupd3 edu_groupd2 edu_groupd3 edu_snow_gd2 edu_snow_gd3) edu_vil  snow_edu towndummy*,robust cluster(townid)
***********************************************************************************************
***********************************************************************************************
***Table D: The Relationship Between the Number of Villagers Participating in the New Rural Health Coop (Columns 1-4)
*** and the Number of Households Receiving Government Subsidies (Columns 5-8) and the Purchase of the Sow Insurance:
*** Some Preliminary Evidence for the Role of Trust for Government. 
   
 *************Examining the Role of Trust *********
*****APPENDIX Table D : Coop and insured sows ************

reg insuredpig no_xnh sow0 , robust cluster(townid)


reg insuredpig no_xnh sow0 groupd2 groupd3,robust cluster(townid)   

reg insuredpig no_xnh sow0   towndummy*  ,robust cluster(townid)  

reg insuredpig no_xnh sow0 groupd2 groupd3 towndummy* ,robust cluster(townid) 

*****************
****APPENDIX Table D:  Subsidy from gov and insured sows *********

reg insuredpig subsidy sow0 , robust cluster(townid)

reg insuredpig subsidy sow0 groupd2 groupd3 , robust cluster(townid)

reg insuredpig subsidy sow0   towndummy*  ,robust cluster(townid)

reg insuredpig subsidy sow0 groupd2 groupd3   towndummy*  ,robust cluster(townid)
  
 ******************************************************end



*********Table B: Testing for the Parallel Trend in the Number of Sows Between the Treatment and Control Villages.

reshape long sow,i(villageid) j(year)
iis villageid 
tis year
 
tab year,ge(quarterd)
ge lig=0
replace lig=1 if groupd2==1
ge hig=0
replace hig=1 if groupd3==1

ge lig_q1=lig*quarterd1
ge lig_q2=lig*quarterd2
ge lig_q3=lig*quarterd3
ge lig_q4=lig*quarterd4
ge lig_q5=lig*quarterd5

ge hig_q1=hig*quarterd1
ge hig_q2=hig*quarterd2
ge hig_q3=hig*quarterd3
ge hig_q4=hig*quarterd4
ge hig_q5=hig*quarterd5

 
xtreg sow quarterd2-quarterd5 lig_q2-lig_q5 hig_q2-hig_q5,fe


sort group year
by group year:ameans sow
************************************************************************************************ 
 
 
log close
clear





