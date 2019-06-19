/***********************************
* sample_selection_and_creation.do *
***********************************/

set more off

gen sample = 1

foreach var of var byp38 bysex byrace byfcomp bymothed byfathed byincome bytxmstd bytxrstd ///
f1rgp9 f3attainment byte22 bytm22 bytm20 byte20 byerace bymrace bytmhdeg bytehdeg byte29 bytm29 ///
byte26c bytm26c {
replace `var' = . if `var'<0
replace sample = 0 if `var'==.
}
replace sample = 0 if bysibstr==-4
replace bysibstr = . if bysibstr<0
replace bysibstr = 0 if bysibstr==. & sample==1

 
gen y = 1*(f3attainment==1)+2*(f3attainment==2) ///
	+3*(f3attainment>=3 & f3attainment<=5)+4*(f3attainment>=6)
gen t1 = 1*(byte20==1)+2*(byte20==2) ///
	+3*(byte20>=3 & byte20<=4)+4*(byte20>=5)
gen t2 = 1*(bytm20==1)+2*(bytm20==2) ///
	+3*(bytm20>=3 & bytm20<=4)+4*(bytm20>=5)
gen Y = y==4 if y>=1
gen T1 = t1==4 if t1>=1
gen T2 = t2==4 if t2>=1
replace Y = . if f3attainment<0 | f3attainment==.
replace T1 = . if byte20<0 | byte20==.
replace T2 = . if bytm20<0 | bytm20==.
label var T1 "ELA Teacher Exp."
label var T2 "Math Teacher Exp."


gen inc1 = byincome<=6
gen inc2 = byincome>=7 & byincome<=8
gen inc3 = byincome>=9 & byincome<=10
gen inc4 = byincome>=11
gen lowincome = byincome<=6
gen highincome = byincome>=12 & byincome~=.
gen gend = bysex==1 if bysex~=.


/***************************
* STUDENT CHARACTERISTICS **
***************************/

/* Race */

foreach var of varlist byrace byerace bymrace byparace {
replace `var'=4 if `var'==5
qui tab `var', gen(c`var')
}



/* Parents' Highest Degree 
<HS, ==HS, some col, more than col*/
foreach var of varlist byfathed bymothed {
gen ind_`var'=`var'>=0
gen `var'1=`var'==1 if `var'~=.
gen `var'2=`var'==2 if `var'~=.
gen `var'3=`var'>=3 & `var'<=5  if `var'~=.
gen `var'4=`var'>=6 if `var'~=.
}


foreach var of varlist bytxmstd bytxrstd {
replace `var' = . if `var'<0
}


gen noneng = byhomlng>=2 if byhomlng>=0 | sample==1
gen pnoneng = byparlng>=2 if byparlng>=0 | sample==1
gen cbynonusgmany = bynonusg>=2  if bynonusg>=0 | sample==1

foreach var of varlist byhomlng byparlng byplang bygnstat{
*replace `var'=`var'*ind_`var'
replace `var' = . if `var'<0
qui tab `var', gen(`var')
}


gen cbyplang = byplang <=3 & byplang~=.
gen cbyfcomp = byfcomp>=2 if byfcomp~=.







/***************************
* TEACHER CHARACTERISTCS  **
***************************/

/* Teacher's experience */
foreach var of varlist bytm26c byte26c byte27 bytm27 {
gen `var'_sq = `var'^2
}




/* Teacher Certification - regular vs not regular */
foreach var of varlist byte29 bytm29 {
gen c`var' = `var'>=2 if `var'~=.
}

/* Teacher Graduate Degree */
foreach var of varlist bytehdeg bytmhdeg {
gen c`var'=`var'>=5 if `var'~=.
}


/* Teacher Major in subject taught */
gen mmajor = bytm31a==3 if bytm31a>0
replace mmajor = bytm31b==3 if bytm31b>0 & mmajor==.
replace mmajor = bytm31b==3 if bytm31b==3 & mmajor~=1

gen emajor = byte31a==2 if byte31a>0
replace emajor = byte31b==2 if byte31b>0 & emajor==.
replace emajor = byte31b==2 if byte31b==2 & emajor~=1

foreach var of varlist mmajor emajor {
replace `var' = 0 if `var'==. & sample==1
} 



/***************************
* SCHOOL CHARACTERISTICS  **
***************************/

/* school var */
qui tab byregion, gen(region)
qui tab bysctrl, gen(schooltype)
qui tab byurban, gen(urban)
qui tab byregurb, gen(urbanregion)

gen ind_by10flp= by10flp>=0
qui tab by10flp, gen(c_by10flp)

gen ind_bys26=bys26>=0
gen hsprog1 = bys26==2
gen hsprog2 = bys26==3
gen egend = byte22==1 if byte22~=.
gen mgend = bytm22==1 if bytm22~=.

#delimit;
label var cbyerace1 "ELA Teacher is American Indian";
label var cbyerace2 "ELA Teacher is Asian";
label var cbyerace3 "ELA Teacher is Black";
label var cbyerace4 "ELA Teacher is Hispanic";
label var cbyerace5 "ELA Teacher is Multiple Race";
label var cbyerace6 "ELA Teacher is White";

label var cbymrace1 "Math Teacher is American Indian";
label var cbymrace2 "Math Teacher is Asian";
label var cbymrace3 "Math Teacher is Black";
label var cbymrace4 "Math Teacher is Hispanic";
label var cbymrace5 "Math Teacher is Multiple Race";
label var cbymrace6 "Math Teacher is White";

label var egend "ELA Teacher is Male";
label var mgend "Math Teacher is Male";

label var byte26c "ELA Teacher Experience";
label var bytm26c "Math Teacher Experience";

label var byte26c_sq "ELA Teacher Exp. Squared";
label var bytm26c_sq "Math Teacher Exp. Squared";

label var emajor "ELA Teacher major in English";
label var mmajor "Math Teacher major in Math";

label var cbytehdeg "ELA Teacher has graduate degree";
label var cbytmhdeg "Math Teacher has graduate degree";

label var cbyte29 "ELA Teacher has no regular certificate";
label var cbytm29 "Math Teacher has no regular certificate";



label var cbyrace1 "Student is American Indian";
label var cbyrace2 "Student is Asian";
label var cbyrace3 "Student is Black";
label var cbyrace4 "Student is Hispanic";
label var cbyrace5 "Student is Multiple Race";
label var cbyrace6 "Student is White";	  

label var gend "Student is Male";
label var noneng "Home language not English";
label var cbyplang "Parents English not fluent";

label var byfathed2 "Father has HS Diploma";
label var byfathed3 "Father has Some College";
label var byfathed4 "Father has a Bachelor's or More";

label var bymothed2 "Mother has HS Diploma";
label var bymothed3 "Mother has Some College";
label var bymothed4 "Mother has a Bachelor's or More";

*label var cbyfcomp "Not have both father and Mother";


/* income : <20 omi, 35 50 75 100 more*/
replace inc4 = byincome==11;

label var inc2 "HH income 20K - 35K";
label var inc3 "HH income 35K - 75K";
label var inc4 "HH income 75K - 100K";
label var highincome "HH income $>$ 100K";

gen cbyp38 = byp38;
label var cbyp38 "Parents ever held job in US";


foreach var of var sch_id bytm26c bymrace bytm22 bytmhdeg bytm31a byte26c byerace byte22 bytehdeg byte31a {;
replace `var' = . if `var'<0;
};
egen tidmth = group(sch_id bytm26c bymrace bytm22 bytmhdeg bytm31a);
egen tideng = group(sch_id byte26c byerace byte22 bytehdeg byte31a);

rename tidmth tidm; rename tideng tide;


gen Tm = T2; gen Te = T1;
replace tidm=. if bytm20<0;
replace tide=. if byte20<0;

foreach v in e m {;
by tid`v', sort: gen numberstudents_`v' = _N;
by tid`v', sort: egen numberstudents_col_`v' = sum(T`v');
sort stu_id;
gen numberstudents_b_`v' = (numberstudents_`v'-1);
gen numberstudents_col_b_`v' = (numberstudents_col_`v' - T`v');
gen tchavg_col_`v'b = (numberstudents_col_b_`v' / numberstudents_b_`v');
replace tchavg_col_`v'b = . if tid`v'==.;
};

gen tidmth=tidm;
gen tideng=tide;
gen T1diffrace = byerace~=byrace; label var T1diffrace "ELA T. Race Mismatch";
gen T2diffrace = bymrace~=byrace; label var T2diffrace "Math T. Race Mismatch";

save $data\allsample, replace;
