#delimit ;
clear ;
set memory 100m ;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ; 

use "data_nis_census"; 
log using "log\comparative advantage table nis.log", replace;

generate c18_1occupation=1 if c18_1oc>=10 & c18_1oc<=430 ;
replace c18_1occupation=2 if c18_1oc>=500 & c18_1oc<=950;
replace c18_1occupation=3 if c18_1oc>=1000 & c18_1oc<=1240;
replace c18_1occupation=4 if c18_1oc>=1300 & c18_1oc<=1530;
replace c18_1occupation=5 if c18_1oc>=1540 & c18_1oc<=1560;
replace c18_1occupation=6 if c18_1oc>=1600 & c18_1oc<=1760;
replace c18_1occupation=7 if c18_1oc>=1800 & c18_1oc<=1860;
replace c18_1occupation=8 if c18_1oc>=1900 & c18_1oc<=1960;
replace c18_1occupation=9 if c18_1oc>=2000 & c18_1oc<=2060;
replace c18_1occupation=10 if c18_1oc>=2100 & c18_1oc<=2150;
replace c18_1occupation=11 if c18_1oc>=2200 & c18_1oc<=2340;
replace c18_1occupation=12 if c18_1oc>=2400 & c18_1oc<=2550;
replace c18_1occupation=13 if c18_1oc>=2600 & c18_1oc<=2760;
replace c18_1occupation=14 if c18_1oc>=2800 & c18_1oc<=2960;
replace c18_1occupation=15 if c18_1oc>=3000 & c18_1oc<=3260;
replace c18_1occupation=16 if c18_1oc>=3300 & c18_1oc<=3650;
replace c18_1occupation=17 if c18_1oc>=3700 & c18_1oc<=3950;
replace c18_1occupation=18 if c18_1oc>=4000 & c18_1oc<=4160;
replace c18_1occupation=19 if c18_1oc>=4200 & c18_1oc<=4250;
replace c18_1occupation=20 if c18_1oc>=4300 & c18_1oc<=4430;
replace c18_1occupation=21 if c18_1oc>=4500 & c18_1oc<=4650;
replace c18_1occupation=22 if c18_1oc>=4700 & c18_1oc<=4960;
replace c18_1occupation=23 if c18_1oc>=5000 & c18_1oc<=5930;
replace c18_1occupation=24 if c18_1oc>=6000 & c18_1oc<=6130;
replace c18_1occupation=25 if c18_1oc>=6200 & c18_1oc<=6940;
replace c18_1occupation=26 if c18_1oc>=7000 & c18_1oc<=7620;
replace c18_1occupation=27 if c18_1oc>=7700 & c18_1oc<=7750;
replace c18_1occupation=28 if c18_1oc>=7800 & c18_1oc<=7850;
replace c18_1occupation=29 if c18_1oc>=7900 & c18_1oc<=8960;
replace c18_1occupation=30 if c18_1oc>=9000 & c18_1oc<=9750;

generate b29occupation=1 if b29oc>=10 & b29oc<=430 ;
replace b29occupation=2 if b29oc>=500 & b29oc<=950;
replace b29occupation=3 if b29oc>=1000 & b29oc<=1240;
replace b29occupation=4 if b29oc>=1300 & b29oc<=1530;
replace b29occupation=5 if b29oc>=1540 & b29oc<=1560;
replace b29occupation=6 if b29oc>=1600 & b29oc<=1760;
replace b29occupation=7 if b29oc>=1800 & b29oc<=1860;
replace b29occupation=8 if b29oc>=1900 & b29oc<=1960;
replace b29occupation=9 if b29oc>=2000 & b29oc<=2060;
replace b29occupation=10 if b29oc>=2100 & b29oc<=2150;
replace b29occupation=11 if b29oc>=2200 & b29oc<=2340;
replace b29occupation=12 if b29oc>=2400 & b29oc<=2550;
replace b29occupation=13 if b29oc>=2600 & b29oc<=2760;
replace b29occupation=14 if b29oc>=2800 & b29oc<=2960;
replace b29occupation=15 if b29oc>=3000 & b29oc<=3260;
replace b29occupation=16 if b29oc>=3300 & b29oc<=3650;
replace b29occupation=17 if b29oc>=3700 & b29oc<=3950;
replace b29occupation=18 if b29oc>=4000 & b29oc<=4160;
replace b29occupation=19 if b29oc>=4200 & b29oc<=4250;
replace b29occupation=20 if b29oc>=4300 & b29oc<=4430;
replace b29occupation=21 if b29oc>=4500 & b29oc<=4650;
replace b29occupation=22 if b29oc>=4700 & b29oc<=4960;
replace b29occupation=23 if b29oc>=5000 & b29oc<=5930;
replace b29occupation=24 if b29oc>=6000 & b29oc<=6130;
replace b29occupation=25 if b29oc>=6200 & b29oc<=6940;
replace b29occupation=26 if b29oc>=7000 & b29oc<=7620;
replace b29occupation=27 if b29oc>=7700 & b29oc<=7750;
replace b29occupation=28 if b29oc>=7800 & b29oc<=7850;
replace b29occupation=29 if b29oc>=7900 & b29oc<=8960;
replace b29occupation=30 if b29oc>=9000 & b29oc<=9750;

generate b54occupation=1 if b54oc>=10 & b54oc<=430 ;
replace b54occupation=2 if b54oc>=500 & b54oc<=950;
replace b54occupation=3 if b54oc>=1000 & b54oc<=1240;
replace b54occupation=4 if b54oc>=1300 & b54oc<=1530;
replace b54occupation=5 if b54oc>=1540 & b54oc<=1560;
replace b54occupation=6 if b54oc>=1600 & b54oc<=1760;
replace b54occupation=7 if b54oc>=1800 & b54oc<=1860;
replace b54occupation=8 if b54oc>=1900 & b54oc<=1960;
replace b54occupation=9 if b54oc>=2000 & b54oc<=2060;
replace b54occupation=10 if b54oc>=2100 & b54oc<=2150;
replace b54occupation=11 if b54oc>=2200 & b54oc<=2340;
replace b54occupation=12 if b54oc>=2400 & b54oc<=2550;
replace b54occupation=13 if b54oc>=2600 & b54oc<=2760;
replace b54occupation=14 if b54oc>=2800 & b54oc<=2960;
replace b54occupation=15 if b54oc>=3000 & b54oc<=3260;
replace b54occupation=16 if b54oc>=3300 & b54oc<=3650;
replace b54occupation=17 if b54oc>=3700 & b54oc<=3950;
replace b54occupation=18 if b54oc>=4000 & b54oc<=4160;
replace b54occupation=19 if b54oc>=4200 & b54oc<=4250;
replace b54occupation=20 if b54oc>=4300 & b54oc<=4430;
replace b54occupation=21 if b54oc>=4500 & b54oc<=4650;
replace b54occupation=22 if b54oc>=4700 & b54oc<=4960;
replace b54occupation=23 if b54oc>=5000 & b54oc<=5930;
replace b54occupation=24 if b54oc>=6000 & b54oc<=6130;
replace b54occupation=25 if b54oc>=6200 & b54oc<=6940;
replace b54occupation=26 if b54oc>=7000 & b54oc<=7620;
replace b54occupation=27 if b54oc>=7700 & b54oc<=7750;
replace b54occupation=28 if b54oc>=7800 & b54oc<=7850;
replace b54occupation=29 if b54oc>=7900 & b54oc<=8960;
replace b54occupation=30 if b54oc>=9000 & b54oc<=9750;

generate b78occupation=1 if b78oc>=10 & b78oc<=430 ;
replace b78occupation=2 if b78oc>=500 & b78oc<=950;
replace b78occupation=3 if b78oc>=1000 & b78oc<=1240;
replace b78occupation=4 if b78oc>=1300 & b78oc<=1530;
replace b78occupation=5 if b78oc>=1540 & b78oc<=1560;
replace b78occupation=6 if b78oc>=1600 & b78oc<=1760;
replace b78occupation=7 if b78oc>=1800 & b78oc<=1860;
replace b78occupation=8 if b78oc>=1900 & b78oc<=1960;
replace b78occupation=9 if b78oc>=2000 & b78oc<=2060;
replace b78occupation=10 if b78oc>=2100 & b78oc<=2150;
replace b78occupation=11 if b78oc>=2200 & b78oc<=2340;
replace b78occupation=12 if b78oc>=2400 & b78oc<=2550;
replace b78occupation=13 if b78oc>=2600 & b78oc<=2760;
replace b78occupation=14 if b78oc>=2800 & b78oc<=2960;
replace b78occupation=15 if b78oc>=3000 & b78oc<=3260;
replace b78occupation=16 if b78oc>=3300 & b78oc<=3650;
replace b78occupation=17 if b78oc>=3700 & b78oc<=3950;
replace b78occupation=18 if b78oc>=4000 & b78oc<=4160;
replace b78occupation=19 if b78oc>=4200 & b78oc<=4250;
replace b78occupation=20 if b78oc>=4300 & b78oc<=4430;
replace b78occupation=21 if b78oc>=4500 & b78oc<=4650;
replace b78occupation=22 if b78oc>=4700 & b78oc<=4960;
replace b78occupation=23 if b78oc>=5000 & b78oc<=5930;
replace b78occupation=24 if b78oc>=6000 & b78oc<=6130;
replace b78occupation=25 if b78oc>=6200 & b78oc<=6940;
replace b78occupation=26 if b78oc>=7000 & b78oc<=7620;
replace b78occupation=27 if b78oc>=7700 & b78oc<=7750;
replace b78occupation=28 if b78oc>=7800 & b78oc<=7850;
replace b78occupation=29 if b78oc>=7900 & b78oc<=8960;
replace b78occupation=30 if b78oc>=9000 & b78oc<=9750;

label define occupation      
1 "Executive, Administrative and Managerial"
2 "Management Related"
3 "Mathematical and Computer Scientists"
4 "Engineers, Architects, and Surveyors"
5 "Engineering and Related Technicians"
6 "Life and Physical Scientists"
7 "Social Scientists and Related Workers"
8 "Life, Physical, and Social Science Technicians"
9 "Councelors, Social, and Religious Workers"
10 "Lawyers, Judges, and Legal Support Workers"
11 "Teachers"
12 "Education, Training, and Library Workers"
13 "Entertainers, etc"
14 "Media and Communication"
15 "Heath Diagnosis and Treating"
16 "Healthcare Tech and Support"
17 "Protective Services"
18 "Food Preparation and Serving"
19 "Cleaning and Building Service"
20 "Entertainment Attendants, etc"
21 "Personal Care and Service"
22 "Sales and Related"
23 "Office and Admin Support"
24 "Farming and Fishing"
25 "Construction, Trade, Extraction"
26 "Installation, Maintenance, Repair"
27 "Production and Operation Workers"
28 "Food Preparation"
29 "Setter, Operators and Tenders"
30 "Transportation and Material Moving";


label values c18_1occupation occupation;
label values b29occupation occupation;
label values b54occupation occupation;
label values b78occupation occupation;

generate occ_change1=1 if  b78oc!= b54oc & b78oc<1000000  & b54oc<1000000;
replace occ_change1=0 if  b78oc == b54oc & b78oc<1000000  & b54oc<1000000;
table occ_change1 , row col;
table occ_change1 schl_bf_occ, row col;

generate occ_change2=1 if  c18_1oc!= b54oc & c18_1oc<1000000  & b54oc<1000000;
replace occ_change2=0 if  c18_1oc == b54oc & c18_1oc<1000000  & b54oc<1000000;
table occ_change2 , row col;
table occ_change2 schl_bf_occ, row col;

generate occupation_change1=1 if  b78occupation!= b54occupation & b78occupation<1000000  & b54occupation<1000000;
replace occupation_change1=0 if  b78occupation == b54occupation & b78occupation<1000000  & b54occupation<1000000;
table occupation_change1 , row col;
table occupation_change1 schl_bf_occ, row col;

generate occupation_change2=1 if  c18_1occupation!= b54occupation & c18_1occupation<1000000  & b54occupation<1000000;
replace occupation_change2=0 if  c18_1occupation == b54occupation & c18_1occupation<1000000  & b54occupation<1000000;
table occupation_change2 , row col;
table occupation_change2 schl_bf_occ, row col;


/*** weighted tables ***/
table occ_change1 [pweight = niswgtsamp1], row col;
table occ_change1 schl_bf_occ [pweight = niswgtsamp1], row col;
table occ_change2 [pweight = niswgtsamp1], row col;
table occ_change2 schl_bf_occ [pweight = niswgtsamp1], row col;
table occupation_change1 [pweight = niswgtsamp1], row col;
table occupation_change1 schl_bf_occ [pweight = niswgtsamp1], row col;
table occupation_change2 [pweight = niswgtsamp1], row col;
table occupation_change2 schl_bf_occ [pweight = niswgtsamp1], row col;


log close;
