/* this file produces the splits defined in Section 2.2 of Bitler, Gelbach, and 
Hoynes (2016) "Can Variation in Subgroups' Average Treatment Effects Explain 
Treatment Effect Heterogeneity? Evidence from a Social Experiment" and presented in
in Section 2.3 */

use data-final.dta, clear

********************************************************************************
************************ Numbers in Section 2.3 ********************************
********************************************************************************
/* Split the sample into 3 groups by earnings history*/
*** 67.4 % of control group women no eanrings 7q pre-RA
su vernpq70 if e==0 & quarter==1
*** cut for low/hi, median is 1600 overall and C, 1700 for T
su ernpq7 if e==0 & quarter==1 & ernpq7>0, d
su ernpq7 if e==1 & quarter==1 & ernpq7>0, d
su ernpq7 if quarter==1 & ernpq7>0, d

********************************************************************************
********************************************************************************
********************************************************************************
