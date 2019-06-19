*Creates more useful variables for analysis;

#delimit;
clear;
pause off;
set more off;
set mem 2500m;
capture log close;

************************;
* First we open the cleaned data;

use Cl_S_EOG_limitedA_rescale.dta, clear;

* This creates new variables that are specific to a particular subsample;
* Particularly, 1998-2003, we retain 1997 for lagged values;
drop if year<1997;

*drop if year>2003;

* Tests are unique to mastid year grade. ; 
* For duplicate scores by student-year;
**I keep the test scores from the highest grade as long as both math and read scores;
* are not missing. If they are both missing, I use the lower grade unless the lower;
* grade is also missing both scores, in which case I drop it and keep (the missing);
* higher grade scores. At the end, all scores are unique to student-year.;

gsort mastid year -grade;
quietly by mastid year: gen int Dum=_n;
quietly by mastid year: gen int Dum2=_N;
by mastid year: gen byte missingH = 1 
    if Dum2==2 & Dum==1 & newreadscal==. & newmathscal==.;
by mastid year: egen int missH=min(missingH);
by mastid year: gen byte missingL = 1 
    if Dum2==2 & Dum==2 & newreadscal==. & newmathscal==.;
by mastid year: egen int missL=min(missingL);
drop if Dum==2 & (missH!=1 | missL==1);
drop if Dum==1 & Dum2==2 & (missH==1 & missL!=1);
drop Dum Dum2 missingH missingL missH missL;
sort grade year;


* No longer need higher grades;
* drop if grade>5;


* Also can scale score to pre2003 - old or post2002 - new;
local scale "old";


* Want to rescale test variable so that deviation from ;
* achievement level 3, i.e. mathach or readach<3, and ;
* standardized for a given grade over the years. ;
* Originally tried using mathach and readach vars, but ;
* have 2 probs- (1) there are missing values for;
* these vars when mathscal non-missing and (2) taking ;
* the min score for mathscal given mathach==3 gives a ;
* math scale score that is sometimes lower than that ;
* which is reported in codebooks.  This could be due ;
* to retaking exam,but should have corrected this above.;
* to create more accurate measure, I take the average ;
* of the max for the level below and the min for level 3 ;
* to get my cutoff;

gen ach3=1 if mathach==3;
gen ach2=1 if mathach==2;
gen mathach2=`scale'mathscal*ach2;
gen mathach3=`scale'mathscal*ach3;
sort grade year;
by grade year: egen min=min(mathach3);
by grade year: egen max=max(mathach2);
gen cut=(max+min)/2;
gen dev3=`scale'mathscal-cut;
bysort grade: egen mean=mean(dev3) if year==1997;
*B/c above creates missing values for non-1997, the below generates value for all years;
bysort grade: egen mmean=min(mean);
bysort grade: egen sd=sd(dev3) if year==1997;
*B/c above creates missing values for non-1997, the below generates value for all years;
bysort grade: egen msd=min(sd);
gen math=(dev3-mmean)/msd;
drop dev3 min sd mean cut mathach2 mathach3 ach2 ach3 max mmean msd;

gen ach3=1 if readach==3;
gen ach2=1 if readach==2;
gen readach2=`scale'readscal*ach2;
gen readach3=`scale'readscal*ach3;
sort grade year;
by grade year: egen min=min(readach3);
by grade year: egen max=max(readach2);
gen cut=(max+min)/2;
gen dev3=`scale'readscal-cut;

bysort grade: egen mean=mean(dev3) if year==1997;
*B/c above creates missing values for non-1997, the below generates value for all years;
bysort grade: egen mmean=min(mean);
bysort grade: egen sd=sd(dev3) if year==1997;
*B/c above creates missing values for non-1997, the below generates value for all years;
bysort grade: egen msd=min(sd);
gen read=(dev3-mmean)/msd;
drop dev3 min sd mean cut readach2 readach3 ach2 ach3 max mmean msd;



sort mastid year;
tsset mastid year;
* Lagged and double Lagged Test scores;

    gen math_1=l.math;
    gen read_1=l.read;
    gen math_2=l2.math;
    gen read_2=l2.read;
    label variable math_1 "lagged math";
    label variable read_1 "lagged reading";
    label variable math_2 "twice lagged math";
    label variable read_2 "twice lagged reading";




sort mastid year;
gen rach1_1=l.readach==1;
gen rach2_1=l.readach==2;
gen rach3_1=l.readach==3;

gen mach1_1=l.mathach==1;
gen mach2_1=l.mathach==2;
gen mach3_1=l.mathach==3;

label variable rach1_1 "lagged reading achievement level 1";
label variable rach2_1 "lagged reading achievement level 2";
label variable rach3_1 "lagged reading achievement level 3";
label value rach1_1 rach2_1 rach3_1 dum;

label variable mach1_1 "lagged math achievement level 1";
label variable mach2_1 "lagged math achievement level 2";
label variable mach3_1 "lagged math achievement level 3";
label value mach1_1 mach2_1 mach3_1 dum;


* Student accountability captures a policy change;
* requiring retention for students whose EOG was;
* Achievement Level 1 or 2;
gen studacct=year>=2001 & grade==5;
replace studacct=1 if year>=2002 & (grade==3| grade==8);
label variable studacct "student accountability";
label value studacct dum;

* Student accountability interacted with lagged achievement level;

    gen sa_rach1=studacct*rach1_1;
    gen sa_rach2=studacct*rach2_1;
    gen sa_rach3=studacct*rach3_1;
    
    gen sa_mach1=studacct*mach1_1;
    gen sa_mach2=studacct*mach2_1;
    gen sa_mach3=studacct*mach3_1;
    

* Create identifier for peergroups;
egen peergroup=group(school grade year teachid);
label variable peergroup "same classroom";
egen schyr=group(school year);
label variable schyr "same school-year";

*Let's make parent's education time invariant;
* First we find avg parental edu for all student obs.;
gen x=pared;
drop pared;
egen y=mean(x), by(mastid);
    gen pared=1 if y<1.5;
replace pared=2 if y>=1.5&y<2.5;
replace pared=3 if y>=2.5;
replace pared=. if y==.;
drop x y;

* Create dummies for categories 2 and 3;
gen pared2=0 if pared~=.;
gen pared3=0 if pared~=.;
replace pared2=1 if pared==2;
replace pared3=1 if pared==3;
label variable pared "parental education";
label value pared edu;
label variable pared2 "parents edu HS+";
label variable pared3 "parents edu 4 yr+";
label value pared2 pared3 dum;

* drop observation if there is no reading score reported;
drop if readscal==.;


* Race definitions, include american indian as nonwhite;
* Modify this temporarily by removing amind;
gen n=( black==1 | hisp==1 | amind==1 );
label variable n "nonwhite (black, hispanic, or american indian)";
gen w=n==0;
label variable w "white (white, asian, multi, other)";
label value n w dum;

*Create dummy variable for NCLB;

gen nclb=year>=2003;

* NCLB interacted with lagged achievement level;

    gen nclb_rach1=nclb*rach1_1;
    gen nclb_rach2=nclb*rach2_1;
    gen nclb_rach3=nclb*rach3_1;
    
    gen nclb_mach1=nclb*mach1_1;
    gen nclb_mach2=nclb*mach2_1;
    gen nclb_mach3=nclb*mach3_1;

compress;
aorder;
order mastid year;
sort mastid year;
save Cr_eog.dta, replace;
log close;


