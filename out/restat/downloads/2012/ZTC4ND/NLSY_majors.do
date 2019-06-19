*generating majors in the NLSY

gen major_business=0
replace major_business=1 if major>0499 & major<0600
replace major_business=1 if major>0599 & major<0700

gen major_engine=0 
replace major_engine=1 if major>0899 & major<1000
replace major_engine=1 if major==4904
replace major_engine=1 if major==0202
*architecture

gen major_techvoc=0
replace major_techvoc=1 if major>0699 & major<0800
*add computer science
replace major_techvoc=1 if major>0 & major<0200
*all the agriculture majors
replace major_techvoc=1 if major>2099 & major<2200
*public affairs and service (social work/law enforcement/public admin)
replace major_techvoc=1 if major>1599 & major<1700
*library sciences
replace major_techvoc=1 if major==0201
replace major_techvoc=1 if major>0202 & major<0300 
replace major_techvoc=1 if major>1300 & major<1400
replace major_techvoc=1 if major>1800 & major<1900
replace major_techvoc=1 if major==9994
replace major_techvoc=1 if major==9995

gen major_biology=0
replace major_biology=1 if major>0399 & major<0500
replace major_biology=1 if major==4902

gen major_phy_sci=0
replace major_phy_sci=1 if major>1899 & major<2000
replace major_phy_sci=1 if major>1699 & major<1800
*all the math/stat majors

gen major_ed=0
replace major_ed=1 if major>0799 & major<0900

gen major_letters=0
replace major_letters=1 if major>0299 & major<0400
replace major_letters=1 if major>0999 & major<1200
replace major_letters=1 if major>1499 & major<1600
replace major_letters=1 if major>2299 & major<2400
replace major_letters=1 if major==4901

gen major_socsci=0
replace major_socsci=1 if major>2199 & major<2300
replace major_socsci=1 if major>1999 & major<2100
*psy 
replace major_socsci=1 if major>1399 & major<1500
*pre-law
replace major_socsci=1 if major==4903

gen major_health=0
replace major_health=1 if major>1199 & major<1300
*health professionals

gen major_mis=1 if major<1
replace major_mis=1 if major==9996
*other
replace major_mis=0 if major_mis==.

gen majorgroup=1 if major_business==1
replace majorgroup=2 if major_ed==1
replace majorgroup=3 if major_engine==1
replace majorgroup=4 if major_bio==1
replace majorgroup=5 if major_phy_sci==1
replace majorgroup=6 if major_letters==1
replace majorgroup=7 if major_socsci==1
replace majorgroup=8 if major_health==1
replace majorgroup=9 if major_tech==1
replace majorgroup=10 if major_mis==1

*bysort majorgroup: egen major_standard16=mean(study16)
*bysort majorgroup: egen major_standard20=mean(study20)
