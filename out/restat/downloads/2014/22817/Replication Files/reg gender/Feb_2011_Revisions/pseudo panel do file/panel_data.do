clear 
set memory 300m 
set more off
/* cd "E:\occdist\reg_gender"  */
cd "C:\Users\kp\Documents\thesis_topic occdist\reg_gender" 

foreach xobs in 100 200 500 {

foreach sx in M F {
clear
foreach yr in  00 90 {
clear
use `sx'_census`yr'_imm.dta 
keep if metpop_country>= `xobs'
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt  metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt 

generate cntry_met = metpop_country / metpop_total 

set matsize 500 



keep if imm_new5==1 
sort occ1990 pwmetro bpl 
merge occ1990 pwmetro bpl using `sx'_census`yr'_rank_edu.dta 
drop if _merge==2 
drop _merge 


generate occpop1=0 if rank_oldimm_occ<100000 
replace occpop1=1 if rank_oldimm_occ==1 
generate occpop2=0 if rank_oldimm_occ<100000 
replace occpop2=1 if rank_oldimm_occ==1|rank_oldimm_occ==2 
generate occpop3=0 if rank_oldimm_occ<100000 
replace occpop3=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3 
generate occpop4=0 if rank_oldimm_occ<100000 
replace occpop4=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4 
generate occpop5=0 if rank_oldimm_occ<100000 
replace occpop5=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5 

generate occpop1_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop1_wt=1 if rank_oldimm_occ_wt==1 
generate occpop2_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop2_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2 
generate occpop3_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop3_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3 
generate occpop4_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop4_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4
generate occpop5_wt=0 if rank_oldimm_occ_wt<100000
replace occpop5_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4|rank_oldimm_occ_wt==5


generate age2=age^2
generate english=1 if  speakeng==2|speakeng==3|speakeng==4|speakeng==5
replace english=0 if speakeng==1|speakeng==6
generate edu=1 if educ99>=0 & educ99<=9
replace edu=2 if educ99==10
replace edu=3 if educ99==11
replace edu=4 if educ99==12| educ99==13
replace edu=5 if educ99==14
replace edu=6 if educ99==15| educ99==16| educ99==17


label define edu 1 "no diploma" 2 "High School" 3 "Some College" 4 "Associates Degree" 5 "College" 6 "Graduate Degree"
label values edu edu


generate edu1=0  
replace edu1=1 if edu==1  
generate edu2=0  
replace edu2=1 if edu==2  
generate edu3=0  
replace edu3=1 if edu==3  
generate edu4=0  
replace edu4=1 if edu==4  
generate edu5=0  
replace edu5=1 if edu==5  
generate edu6=0  
replace edu6=1 if edu==6  

generate marst1=0  
replace marst1=1 if marst==1  
generate marst2=0  
replace marst2=1 if marst==2  
generate marst3=0  
replace marst3=1 if marst==3  
generate marst4=0  
replace marst4=1 if marst==4  
generate marst5=0  
replace marst5=1 if marst==5  
generate marst6=0  
replace marst6=1 if marst==6  
  

generate male=0 if sex==2
replace male=1 if sex==1

collapse (sum) pop (mean) occpop1 occpop2 occpop3 occpop4 occpop5 cntry_met p_occ_old_country1 p_occ_old_country2 p_occ_old_country3 p_occ_old_country4 p_occ_old_country5 p_native_occ1 p_native_occ2 p_native_occ3 p_native_occ4 p_native_occ5 p_occ_met1 p_occ_met2 p_occ_met3 p_occ_met4 p_occ_met5 age sex english age2 mean_occ_edu1 mean_occ_edu2 mean_occ_edu3 mean_occ_edu4 mean_occ_edu5 edu1 edu2 edu3 edu4 edu5 edu6 marst1 marst2 marst3 marst4 marst5 marst6, by (pwmetro bpl)   

rename pop pop_`yr'  
rename 	occpop1	 	occpop1_`yr'	  
rename 	occpop2	 	occpop2_`yr'	  
rename 	occpop3	 	occpop3_`yr'	  
rename 	occpop4	 	occpop4_`yr'	  
rename 	occpop5	 	occpop5_`yr'	  
rename cntry_met cntry_met_`yr'  
rename 	p_occ_old_country1	 	p_occ_old_country1_`yr'	  
rename 	p_occ_old_country2	 	p_occ_old_country2_`yr'	  
rename 	p_occ_old_country3	 	p_occ_old_country3_`yr'	  
rename 	p_occ_old_country4	 	p_occ_old_country4_`yr'	  
rename 	p_occ_old_country5	 	p_occ_old_country5_`yr'	  
rename 	p_native_occ1	 	p_native_occ1_`yr'	  
rename 	p_native_occ2	 	p_native_occ2_`yr'	  
rename 	p_native_occ3	 	p_native_occ3_`yr'	  
rename 	p_native_occ4	 	p_native_occ4_`yr'	  
rename 	p_native_occ5	 	p_native_occ5_`yr'	  
rename 	p_occ_met1	 	p_occ_met1_`yr'	  
rename 	p_occ_met2	 	p_occ_met2_`yr'	  
rename 	p_occ_met3	 	p_occ_met3_`yr'	  
rename 	p_occ_met4	 	p_occ_met4_`yr'	  
rename 	p_occ_met5	 	p_occ_met5_`yr'	  
rename 	age	 	age_`yr'	  
rename 	sex	 	sex_`yr'	  
rename 	english	 	english_`yr'	  
rename 	age2	 	age2_`yr'	  
rename 	mean_occ_edu1	 	mean_occ_edu1_`yr'	  
rename 	mean_occ_edu2	 	mean_occ_edu2_`yr'	  
rename 	mean_occ_edu3	 	mean_occ_edu3_`yr'	  
rename 	mean_occ_edu4	 	mean_occ_edu4_`yr'	  
rename 	mean_occ_edu5	 	mean_occ_edu5_`yr'	  
rename 	edu1	 	edu1_`yr'	  
rename 	edu2	 	edu2_`yr'	  
rename 	edu3	 	edu3_`yr'	  
rename 	edu4	 	edu4_`yr'	  
rename 	edu5	 	edu5_`yr'	  
rename 	edu6	 	edu6_`yr'	  
rename 	marst1	 	marst1_`yr'	  
rename 	marst2	 	marst2_`yr'	  
rename 	marst3	 	marst3_`yr'	  
rename 	marst4	 	marst4_`yr'	  
rename 	marst5	 	marst5_`yr'	  
rename 	marst6	 	marst6_`yr'	  

sort pwmetro bpl  
save `sx'_agg_data`yr'_x`xobs'.dta, replace  


} /* foreach yr */
} /* foreach sx */
} /* foreach xobs */



