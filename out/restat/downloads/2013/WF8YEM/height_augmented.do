**** USE AUGMENTED SAMPLE ****

** Use data set created by height_variables

/* FIGURE 2: The effect of height by age */

xi: reg chef i.age*l_ngdm i.year i.cohort if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)
xi: reg chef i.age*l_ngdm i.year i.cohort c2 n2  if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)

xi: reg chef i.age*l_ngdm i.year i.cohort*l_ngdm if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)
xi: reg chef i.age*l_ngdm i.year i.cohort*l_ngdm c2 n2 if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)


/* FIGURE 3: The effect of height by age - CEO's */

xi: reg ceo i.age*l_ngdm i.year i.cohort if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)
xi: reg ceo i.age*l_ngdm i.year i.cohort c2 n2  if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)

xi: reg ceo i.age*l_ngdm i.year i.cohort*l_ngdm if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)
xi: reg ceo i.age*l_ngdm i.year i.cohort*l_ngdm c2 n2 if cohort>= 1954 & cohort<= 1974 & year>= 2001 & year<= 2006 & age >=30 & age <=49, cluster(bidnr)


*** Controlling for the interaction between height and cohort ****


xi: reg chef i.age*l_ngdm i.cohort*l_ngdm if cohort>= 1954 & cohort<= 1974, cluster(bidnr) 
xi: reg chef i.age*l_ngdm i.cohort*l_ngdm c2 n2 if cohort>= 1954 & cohort<= 1974, cluster(bidnr) 


/* TABLE X: Restricting the sample to men with observed occupation in all years*/

* Create one variable observed in all years equal to one if chef is observed in all years

gen obs=1 if chef~=.
gen obs_06 = obs if year == 2006

sort bidnr year
gen obs_05 = obs[_n-1] if year == 2006 & bidnr == bidnr[_n-1] & year[_n-1] == 2005
gen obs_04 = obs[_n-2] if year == 2006 & bidnr == bidnr[_n-2] & year[_n-2] == 2004
gen obs_03 = obs[_n-3] if year == 2006 & bidnr == bidnr[_n-3] & year[_n-3] == 2003
gen obs_02 = obs[_n-4] if year == 2006 & bidnr == bidnr[_n-4] & year[_n-4] == 2002
gen obs_01 = obs[_n-5] if year == 2006 & bidnr == bidnr[_n-5] & year[_n-5] == 2001

gen obs_all = 1 if obs_06 == 1 & obs_05 == 1 & obs_04 == 1 & obs_03 == 1 & obs_02 == 1 & obs_01 == 1 & year == 2006

replace obs_all = obs_all[_n+1] if year == 2005 & bidnr == bidnr[_n+1] & year[_n+1] == 2006
replace obs_all = obs_all[_n+2] if year == 2004 & bidnr == bidnr[_n+2] & year[_n+2] == 2006
replace obs_all = obs_all[_n+3] if year == 2003 & bidnr == bidnr[_n+3] & year[_n+3] == 2006
replace obs_all = obs_all[_n+4] if year == 2002 & bidnr == bidnr[_n+4] & year[_n+4] == 2006
replace obs_all = obs_all[_n+5] if year == 2001 & bidnr == bidnr[_n+5] & year[_n+5] == 2006

xi: reg chef i.age*l_ngdm if obs_all == 1, cluster(bidnr)
xi: reg chef i.age*l_ngdm i.cohort*l_ngdm if obs_all == 1, cluster(bidnr)
xi: reg chef i.age*l_ngdm i.cohort*l_ngdm c2 n2 if obs_all == 1, cluster(bidnr)

