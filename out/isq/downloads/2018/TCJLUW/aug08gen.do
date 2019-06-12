cd "C:\"
clear
set memory 32000
use "C:\ISQPaper\BritishAcademy\AugustData\aug08mis.dta", clear
 
#delimit ;

gen pkeep=q2001;
recode pkeep (5=1) (4=2) (3=3) (2=4) (1=5) (6=.);

gen euro=q27;
recode euro(3=1) (2=3) (1=5);

gen milspnd=q202;
recode milspnd (5=1) (4=2) (3=3) (2=4) (1=5) (6=.);

gen unapp=q203;
recode unapp (1=1) (2=2) (3=3) (4=4) (5=5) (6=.);

gen fterror=q205;
recode fterror (1=1) (2=2) (3=3) (4=4) (5=5) (6=.);

gen mbases=q206;
recode mbases (5=1) (4=2) (3=3) (2=4) (1=5) (6=.);

gen immig=q164;
recode immig (5=1) (4=2) (3=3) (2=4) (1=5) (6=.);

gen asylum=q214;
recode asylum (1=1) (2=2) (3=3) (4=4) (5=5) (6=.);

gen highed=0;
recode highed 0=1 if q112>3;

keep w8nonpol w8 pkeep euro milspnd unapp fterror mbases immig asylum highed;


