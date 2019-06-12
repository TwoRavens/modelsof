

/*******************************************************************
IPUMS_subset_00016.do

Selects a subset of variables from IPUMS_10_7_2014.dta that is more managable
but contains many of the variables we are interested in.  Saves it as 
IPUMS_sub_1.dta.

Paul Eliason, 10/7/2014
paul.elaison@duke.edu

Want to keep

place of birth
current place of residence
employment status
labor force status
earnings
educational attainment
living quarters stuff (institutionalized?)
race

******************************************************************/
clear all
set more off
capture log close
set mem 12000m
cd F:\RA\RA_Inequality\summer

use IPUMS_00016.dta, clear

/*keeping relevant variables*/
keep year datanum serial perwt region statefip metarea gq gqtype gqtyped ///
     age sex marst bpl birthyr citizen hispan school ///
     educ educd empstat labforce inctot incwage incbus00 ///
     incother race ind1990 ind1950 metro 
     
    
     
sort year 

drop if year==1910
drop if year==1920
drop if year==1930

tab sex, gen(dum)
rename dum1 male
drop dum2

 /*Keeping only men*/
 keep if male==1
 
 /*keeping ages 19 to 54*/
 keep if age>18 & age<65
 gen agesq = age*age
 
 /*Age bands for 25 to 54*/
 gen age1 = (age>24)*(age<30)
 gen age2 = (age>29)*(age<35)
 gen age3 = (age>34)*(age<40)
 gen age4 = (age>39)*(age<45)
 gen age5 = (age>44)*(age<50)
 gen age6 = (age>49)*(age<55)

tab race, gen(dum) 

gen white = (race==1)*(hispan==0)
gen black = (race==2)
gen other = (white == 0 & black == 0)
 


/*Other Category to add to Controls*/


 /*dummies for non-hispanic white and black*/
 gen nhwhite = (race==1)*(hispan==0)

 
 gen bw = 1
 replace bw = 0 if black==1
 replace bw = . if black==0 & nhwhite==0

/*Separate Controls for Native-Born and Foreign-Born*/
tab bpl, gen(dum)
 gen native=dum1+dum2+dum3+dum4+dum5+dum6+dum7+dum8+dum9+dum10 ///
	   +dum11+dum12+dum13+dum14+dum15+dum16+dum17+dum18+dum19+dum20 ///
           +dum21+dum22+dum23+dum24+dum25+dum26+dum27+dum28+dum29+dum30 ///
	   +dum31+dum32+dum33+dum34+dum35+dum36+dum37+dum38+dum39+dum40 ///
 	   +dum41+dum42+dum43+dum44+dum45+dum46+dum47+dum48+dum49+dum50 ///

 gen foreign= native==0
 gen blacknative= black==1 & native==1
 gen blackforeign= black==1 & foreign==1
 gen whitenative= white==1 & native==1
 gen whiteforeign= white==1 & foreign==1 
 gen othernative= other==1 & native==1
 gen otherforeign= other==1 & foreign==1

 drop dum1-dum126

 /*******Institutionalized?***********/  
 /*This includes people in corrections facilities, mental institutions 
 and nursing homes.  Neal argues that as long as we are excluding the elderly population this
 is a pretty good proxy for incarceration (see Neal and Rick 2014, page 2)*/
 
 gen institution=.
 replace institution = (gqtype==1) if year>1980
 replace institution = 1 if (gqtype==2 | gqtype==3 | gqtype==4) & year<=1980
 replace institution = 0 if (gqtype==0 | gqtype==5 | gqtype==6 | gqtype==7 | gqtype==8 | gqtype==9)
 
 
 /***Years of Education***/
 gen yreduc = .
replace yreduc = 0 if educd == 000 | educd == 001 | educd == 002 | educd == 011 | educd == 012
replace yreduc = 1 if educd == 014
replace yreduc = 2 if educd == 015
replace yreduc = 2 if educd == 010
replace yreduc = 3 if educd == 016
replace yreduc = 4 if educd == 017
replace yreduc = 3 if educd==013
replace yreduc = 7 if educd==020
replace yreduc = 6 if educd==021
replace yreduc = 5 if educd == 022
replace yreduc = 6 if educd == 023
replace yreduc = 8 if educd==024
replace yreduc = 7 if educd == 025
replace yreduc = 8 if educd == 026
replace yreduc = 9 if educd == 030
replace yreduc = 10 if educd == 040
replace yreduc = 11 if educd == 050 | educd == 061
replace yreduc = 12 if educd == 060 | educd == 062 | educd == 063 | educd == 064 | educd == 065
replace yreduc = 13 if educd == 070
replace yreduc = 14 if educd == 071 | educd == 080 | educd == 081 | educd == 082 | educd == 083
replace yreduc = 15 if educd == 090
replace yreduc = 16 if educd == 100 | educd == 101
replace yreduc = 17 if educd >101 & educd~=999
 
 
 /*Education--I am going to use all of the education levels available*/
 gen edlevel = .
 
 /*1910*/
 
 /*****************************************
 replace edlevel = 1 if lit==1 & year==1910
 replace edlevel = 2 if lit==2 & year==1910
 replace edlevel = 3 if lit==3 & year==1910
 replace edlevel = 4 if lit==4 & year==1910
 *****************************************/
 
 /*1940-2010*/
 replace edlevel = educ
 
 /*Rural and metro*/
 gen rm = .
 replace rm = 0 if metro==1
 replace rm = 1 if metro==2 | metro==3 | metro==4
  
 
 /*Removing N/A observations from incwage*/
drop if incwage==999999
 
 
 
 /***Percentile Ranks***/
 /*Everyone*/
 sort year incwage
 by year: egen N = count(incwage)
 by year: egen i = rank(incwage)
 gen pct = i/N*100
 
 drop N i
 

 /*Non-zero wages*/
 sort year incwage
 by year: egen N = count(incwage) if incwage>0
 by year: egen i = rank(incwage) if incwage>0
 gen pctNZ = i/N*100
 
 save "completedata_1964.dta",replace

