* Cl_S_EOG_limitedA.do is the file that cleans the student 
* End of Grade data file Co_S_EOG_limitedA. 
* Only a subset of all variables from the raw EOG data are present.
* This why it is limited. Variables are destringed or recoded. 
* Some particularly useful
* variables are created.


#delimit;
clear;
pause off;
set more off;
set mem 800m;
capture log close;


local outfile S_EOG_limitedA;


************************;
* First we open the compiled raw data;

use Co_`outfile', clear;

* Recode Charter school students so we can destring lea;
replace lea="0" if schlcode=="000";
destring lea, replace;
destring schlcode, replace;
* Generate a unique school variable, first three digits are;
* lea, last three are school within district;
* Charter schools are coded 0;
gen long school = lea*1000 + schlcode;
label variable school "unique school identifier";
label define chrtr 0 "Charter School";
label value school chrtr;
drop schlcode;

destring grade, replace;

destring administ, replace;

* Undocumented value assume * is missing;
replace title1="" if title1=="*";
destring title1, replace;

* Standardize makeup variable over years;
gen int mymakeup =0;
replace mymakeup=. if makeup=="" & year < 1999;
replace mymakeup=1 if year<1997 & makeup=="1";
replace mymakeup=1 if (year==1997 | year==1998) & makeup=="M";
replace mymakeup=1 if year>1998 & makeup=="9";
drop makeup;
rename mymakeup makeup;
label variable makeup "test was a makeup test";
label define dum 1 "Yes" 0 "No";
label value makeup dum;


* Standardize school lunch over years;
gen lunch = (schlunch =="1" | schlunch=="2") if year>1998 & year<2003;
* Removed schlunch=="4" after talking with Jane 4/15/08;
replace lunch =. if year>1998 & year<2003 & schlunch=="3" ;
replace lunch =0 if year > 1998 & year < 2006 & schlunch=="4";
replace lunch =1 if year > 2002 & year < 2006 & (schlunch=="2" | schlunch=="3");
* Specifically changed 4 to no free or reduced lunch from 98-02;
replace lunch =1 if year ==2006 & (frl=="F" | frl=="R" | frl=="T" );
replace lunch =0 if year ==2006 & frl=="N" ;
label variable lunch "free/reduced lunch";
label value lunch dum;
drop frl schlunch;

* Standardize limited english over years;
gen limitedeng=0;
replace limitedeng =1 if limeng =="1" & (year==1995 | (year>1996 & year<2003));
replace limitedeng =1 if limeng =="Y" & year==1996;
replace limitedeng=. if limeng=="";
replace limitedeng = 0 if year==2003;
replace limitedeng = 1 if year==2003 & (lep =="1" | lep=="2");
replace limitedeng = . if year==2003 & lep =="";
replace limitedeng = 0 if (year==2004 | year==2005);
replace limitedeng = 1 if (year==2004 | year==2005) & 
	(lepstat =="2" | lepstat=="3" | lepstat =="4" | lepstat=="5");
replace limitedeng = . if (year==2004 | year==2005) & lepstat =="";

replace limitedeng = 0 if year==2006;
replace limitedeng = 1 if year==2006 & lep_current=="1";
replace limitedeng = . if year==2006 & lep_current=="";
label variable limitedeng "limited english proficiency";
label value limitedeng dum;
drop limeng lep lepstat lep_current;

* Standardize disabled over years;
destring ldread, replace;
destring ldmath, replace;
destring ldwrite, replace;
destring ldoth, replace;
destring except, replace;
gen disable = except>2;
label variable disable "mentally or physically disabled";
label value disable dum;
replace disable =. if except==.;

replace ethnic="" if ethnic=="N"|ethnic=="R"|ethnic=="S";
sort mastid;
* Individuals with multiple modes for race are classified by ;
* W > O > M > I > H > B > A;
by mastid: egen racemode=mode(ethnic),maxmode;
gen byte black=racemode=="B";
gen byte hisp=racemode=="H";
gen byte white=racemode=="W";
gen byte amind=racemode=="I";
gen byte asian=racemode=="A";
gen byte multi=racemode=="M";
gen byte other=racemode=="O";
label variable black "student is black";
label variable hisp "student is hispanic";
label variable white "student is white";
label variable amind "student is american indian";
label variable asian "student is asian";
label variable multi "student is multi-ethnic";
label variable other "student is other";
label values black hisp white 
	amind asian multi other dum;
local race "black hisp white amind asian multi other";
foreach x of local race {;
	replace `x'=. if racemode=="";
	};
drop racemode;
encode ethnic, generate(ethnicity);
label define racelabels 1 "Asian" 2 "Black" 3 "Hispanic" 
				4 "American Indian" 5 "Multi-Ethnic"
				6 "Other" 7 "White";
label value ethnicity racelabels;
drop ethnic;

* one random miscode;
replace sex="" if sex=="W"; 
sort mastid;
* If individual has equal number of observations for male and female,;
* they are classified female, minmode -> F < M;
by mastid: egen sexmode=mode(sex),minmode;
gen byte male=sexmode=="M";
replace male=. if sexmode=="";
label variable male "student is male";
label values male dum;
drop sex sexmode;

destring pared, replace;
* Make pared consistent (has dif values in 2000 and 2003+ for some odd reason);
replace pared=2 if (year==2000|year>2002) & pared==3;
replace pared=3 if (year==2000|year>2002) & pared==4;
replace pared=4 if (year==2000|year>2002) & pared==5;
replace pared=5 if (year==2000|year>2002) & pared==6;
replace pared=6 if (year==2000|year>2002) & pared==7;
replace pared=. if pared==0 | pared==8;
replace pared=. if pared==9;

* Recreate parental education to 3 categories;
* 3 categories: 1=did not complete HS, ;
* 2=HS degree+ but not 4-yr, 3=4-yr degree or grad school;
recode pared 3/4=2 5/6=3;
label define edu 1 "Did not complete HS" 2 "HS degree+ but not 4-yr"
				3 "4-yr degree or grad school";
label value pared edu;

* Create an hours of TV var;
gen tvhr=0 if tv=="A";
replace tvhr=1 if tv=="B";
replace tvhr=2 if tv=="C";
replace tvhr=3 if tv=="D";
replace tvhr=4.5 if tv=="E";
replace tvhr=6 if tv=="F";
replace tvhr=. if tv =="";
label variable tvhr "hours of TV per day";
drop tv;

* Create hours of free reading variable;
gen freadhr=0 if freeread=="A";
replace freadhr=.5 if freeread=="B";
replace freadhr=1 if freeread=="C";
replace freadhr=1.5 if freeread=="D";
replace freadhr=2.5 if freeread=="E";
replace freadhr=. if freeread=="";
label variable freadhr "hours of free reading per day";
drop freeread;

destring mathach, replace;
destring readach, replace;

compress;
aorder;
order mastid year;
sort mastid year;
save Cl_`outfile'.dta, replace;
log close;




