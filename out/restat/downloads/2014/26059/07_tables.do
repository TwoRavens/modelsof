
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: TABLES
********************************************************************************



clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."



use "$datapath\final\WWII_final.dta", clear



********************************************************************************
*** Table 1: Variable definition
********************************************************************************

* background information
tab male if nativeborn == 1 & country != 15
sum male if nativeborn == 1 & country != 15
sum yrbirth3 if nativeborn == 1 & country != 15
sum ses if nativeborn == 1 & country != 15


* outcome measures
sum child_imm    if nativeborn == 1 & country != 15
sum depress      if nativeborn == 1 & country != 15 

sum adult_diabet if nativeborn == 1 & country != 15
sum ever_marr    if nativeborn == 1 & country != 15
sum adult_heart  if nativeborn == 1 & country != 15
sum height 		 if nativeborn == 1 & country != 15
sum life_sat 	 if nativeborn == 1 & country != 15
sum l_hhnetworth if nativeborn == 1 & country != 15
sum health 		 if nativeborn == 1 & country != 15
sum iscedy_r 	 if nativeborn == 1 & country != 15
sum schooling 	 if nativeborn == 1 & country != 15
sum school_diff  if nativeborn == 1 & country != 15


* channels
sum father_absent if nativeborn == 1 & country != 15
sum dispos if nativeborn == 1 & country != 15
sum hunger if nativeborn == 1 & country != 15
sum persec if nativeborn == 1 & country != 15


* war variables
sum war war_combat_0_2 combat_3_10




********************************************************************************
*** Table 2: GDP per Head
********************************************************************************

* see Harrison(1998): table 1-10





********************************************************************************
*** Table 3: Percentage of SHARELIFE respondents with channels, by time period
********************************************************************************

*** % father absent by country
table country if nativeborn == 1 & yrbirth3 < 1929 & country != 15, c(mean father_absent) 
table country if nativeborn == 1 & yrbirth3 >= 1929 & yrbirth3 <= 1935 & country != 15, c(mean father_absent) 
table country if nativeborn == 1 & yrbirth3 > 1935 & yrbirth3 <= 1939 & country != 15, c(mean father_absent) 
table country if nativeborn == 1 & yrbirth3 > 1939 & yrbirth3 <= 1945 & country != 15, c(mean father_absent)
table country if nativeborn == 1 & yrbirth3 > 1945 & country != 15, c(mean father_absent) 


*** % hunger by country
table country if nativeborn == 1 & yrbirth3 < 1939 & country ~= 15, c(mean hunger_bef39) 
table country if nativeborn == 1 & yrbirth3 < 1946 & country ~= 15, c(mean hunger_39_45) 
table country if nativeborn == 1 & yrbirth3 < 1950 & country ~= 15, c(mean hunger_46_49) 
table country if nativeborn == 1 & yrbirth3 < 1955 & country ~= 15, c(mean hunger_50_54) 
table country if nativeborn == 1 & country ~= 15 , c(mean hunger_after54) 
    

*** % dispossession by country
table country if nativeborn == 1 & yrbirth3 < 1939 & country ~= 15, c(mean disp_bef39) 
table country if nativeborn == 1 & yrbirth3 < 1946 & country ~= 15, c(mean disp_3945) 
table country if nativeborn == 1 & yrbirth3 < 1950 & country ~= 15, c(mean disp_4649) 
table country if nativeborn == 1 & yrbirth3 < 1955 & country ~= 15, c(mean disp_5054) 
table country if nativeborn == 1  & country ~= 15, c(mean disp_aft54) 

table country if nativeborn == 1 & country ~= 15, c(mean dispos)




********************************************************************************
*** Table 4: Number of observations available in SHARELIFE by country
********************************************************************************

tab country war if nativeborn == 1 & country != 15








********************************************************************************
*** Table 5: Adult health outcomes associated with WWII
********************************************************************************


*** specifications

global noses4_yeardum  "war male yrbirth_d1-yrbirth_d47"
global noses5c_yeardum "war_combat_0_2 combat_3_10 male yrbirth_d1-yrbirth_d47"
global noses5_yeardum  "war war_male male yrbirth_d1-yrbirth_d47"
global noses4f_yeardum "war_combat_0_2 combat_3_10 combat_3_10_male war_combat_0_2_male male yrbirth_d1-yrbirth_d47" 




* A. war variable

reg adult_diabet $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
		
reg adult_heart $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15 , cluster(index)
                
reg height $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg depress $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
               
reg health $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
				
				
* B. Combat variable
						
reg adult_diabet $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg adult_heart $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15 , cluster(index)

reg height $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg depress $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg health $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
				
				
				

********************************************************************************
*** Table 6: Adult economic outcomes associated with WWII
********************************************************************************


* A. war variable

reg schooling $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                
reg school_diff $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                
reg l_hhnetworth curr_marr $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg ever_marr $noses5_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg life_sat $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)



* B. combat variable
							
reg schooling $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)

reg school_diff $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
			
reg l_hhnetworth curr_marr $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)

reg ever_marr $noses4f_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
	            
reg life_sat $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)

			  
			  
		

********************************************************************************
*** Table 7: Mean number of children per woman
********************************************************************************



*** median split SES
set more off
gen ses_d = 0
replace ses_d = . if ses == .
forvalues i = 11/29 {
sum ses if country == `i', d
replace ses_d = 1 if country == `i' & ses > r(p50)
}
tab country ses_d



*** children born during war, 1939-1945
forvalues i = 1/16 {
gen child_3945_`i' = 0
replace child_3945_`i' = 1 if chyrb_`i' >= 1939 & chyrb_`i' <= 1945 & chyrb_`i' ~= . & ch002 == 1
}

gen born_3945 = 0
forvalues i = 1/16 {
replace born_3945 = 1 if child_3945_`i' == 1
}

egen nr_children_3945 = rsum(child_3945_1-child_3945_16), m



*** children born before war, before 1939
forvalues i = 1/16 {
gen child_bef39_`i' = 0
replace child_bef39_`i' = 1 if chyrb_`i' < 1939 & ch002 == 1
}

gen born_bef_39 = 0
forvalues i = 1/16 {
replace born_bef_39 = 1 if child_bef39_`i' == 1
}
egen nr_children_bef39 = rsum(child_bef39_1-child_bef39_16), m



*** children born after war, after 1946
forvalues i = 1/16 {
gen child_aft46_`i' = 0
replace child_aft46_`i' = 1 if chyrb_`i' >= 1946 & chyrb_`i' ~= . & ch002 == 1
}

gen born_aft46 = 0
forvalues i = 1/16 {
replace born_aft46 = 1 if child_aft46_`i' == 1
}

egen nr_children_aft46 = rsum(child_aft46_1-child_aft46_16), m



*** TABLE
tabstat nr_children_bef39 if nr_children_bef39 ~= 0 & war_countries == 1 & ch002 == 1 & male == 0  & nativeborn == 1, by(ses_d) s(mean median N)

tabstat nr_children_3945 if nr_children_3945 ~= 0 & war_countries == 1 & ch002 == 1 & male == 0  & nativeborn == 1, by(ses_d) s(mean median N)

tabstat nr_children_aft46 if nr_children_aft46 ~= 0 & war_countries == 1 & ch002 == 1 & male == 0  & nativeborn == 1, by(ses_d) s(mean median N)






********************************************************************************
*** Table 8: Age of death of fathers
********************************************************************************


tabstat dn027_2 if nativeborn == 1 & ses_d == 0 & yrbirth3 < 1946, by(war_countries) s(mean N)
tabstat dn027_2 if nativeborn == 1 & ses_d == 0 & yrbirth3 >= 1946, by(war_countries) s(mean N)

tabstat dn027_2 if nativeborn == 1 & ses_d == 1 & yrbirth3 < 1946, by(war_countries) s(mean N)
tabstat dn027_2 if nativeborn == 1 & ses_d == 1 & yrbirth3 >= 1946, by(war_countries) s(mean N)





		
		
		
		
		
		
		
		
		

********************************************************************************
*** Table 9: Channels of war associated with WWII
********************************************************************************


global noses4_yeardum  "war male yrbirth_d1-yrbirth_d47"
global noses5c_yeardum "war_combat_0_2 combat_3_10 male yrbirth_d1-yrbirth_d47"



* A. war variable

reg hunger $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg dispos $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15 , cluster(index)
                			
reg persec $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                	
reg father_absent $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                
reg child_imm $noses4_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)

				
				

* B. combat variable

reg hunger $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg dispos $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15 , cluster(index)				
                
reg persec $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                	
reg father_absent $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
 				
reg child_imm $noses5c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
             			  
			  
			  
			  
			  
			  
			  
			  
			  
			  
********************************************************************************
*** Table 10: War interaction with childhood SES models
********************************************************************************

global ses4b_yeardum   "war ses_low ses_med war_ses_low war_ses_med male yrbirth_d1-yrbirth_d47"
global ses4c_yeardum   "war ses_low ses_med war_ses_low war_ses_med war_male male yrbirth_d1-yrbirth_d47"
global ses4d_yeardum   "war ses_low ses_med war_ses_low war_ses_med war_male war_ses_low_male war_ses_med_male male ses_low_male ses_med_male yrbirth_d1-yrbirth_d47"



* A. Health outcomes

reg adult_diabet $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg adult_heart $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15 , cluster(index)
                
reg height $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg depress $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15 , cluster(index)
                
reg health $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				

	
				

* B. SES outcomes

reg schooling $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                
reg school_diff $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
                
reg l_hhnetworth curr_marr $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg ever_marr $ses4c_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg ever_marr $ses4d_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				
reg life_sat $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)




* C. Channels

reg hunger $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
				 
reg dispos $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
								
reg persec $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)
								
reg father_absent $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)

reg child_imm $ses4b_yeardum Dcountry* if nativeborn == 1 & country != 15, cluster(index)

				
				
				
				
				
				
				
