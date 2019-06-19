***Last Updated: 12/14/2018 Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Data cleaning of the Turkish National Survey on Domestic Violence against Women (TNSDVW) 2008

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

To run the do file all you need to do is to change the path of the working directory in line 34.

The dataset used in this do file is provided by the Turkish Statistical Institute (TSI). Their data availability policy 
prohibits the distribution of data to non-registered users. Researchers have to complete a form 
(http://www.turkstat.gov.tr/UstMenu/body/bilgitalep/MVKullaniciTalepFormu_ENG.pdf), and send it 
to bilgi@tuik.gov.tr by e-mail. Upon receipt of this form, the TSI sends 
the datasets through an ftp server electronically. 

The name of the dataset sent by the TSI will be as follows: TKAA2008KADINDATA????????.sav. Please convert this data in spss
format into Stata format, and save it as "Domestic Violence/originals/women_from_spss.dta" before you run this
do file.

*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";

use "originals/women_from_spss.dta", clear;

*Create unique household ID;
gen HHID = qcluster*1000+qnumber;
sort HHID;
order HHID;

label variable HHID "Unique household ID";

*SCHOOLING VARIABLE;
gen schooling = .;
replace schooling=. if q105a == 98|q105b == 98;
replace q105b = 0 if q105b == 66;
*Take care of coding errors;
replace q105a = 13 if q105a==11&q105b>5;
replace q105a = 13 if q105a==12&q105b>3;
replace q105b=4 if q105a==15&q105b>4;
replace schooling=. if q105a == 14&q105b>4;
replace schooling=. if q105a == 11&q105b==0&q105c==1;

replace schooling = q105b if q105a==11;
replace schooling = 5+q105b if q105a==12;
replace schooling = q105b if q105a==13;
replace schooling = 8+q105b if q105a==14;
replace schooling = 11+q105b if q105a==15;
replace schooling = 15+q105b if q105a==16;

label variable schooling "Years of schooling";

gen jhighschool = 0;
replace jhighschool = 1 if q105a==12 & q105c==1;
replace jhighschool = 1 if q105a==13 & q105c==1;
replace jhighschool = 1 if q105a==14 | q105a==15 | q105a==16;
replace jhighschool =. if q105a==98;
replace jhighschool =. if q105a==.;

*AGE VARIABLE AND DIFFERENCES;
drop if q101m==.a;
drop if q101m==98;
rename q101m month;
drop if q101y==9998;
rename q101y year;

label variable month "Month of birth";
label variable year "Year of birth";

gen dif=.;
replace dif = (-1)*[(12*(1987-year-1))+(12-month)+1] if year<1987;
replace dif = [(12*(year-1987-1))+month+11] if year>1987;
replace dif = (-1)*[1-month] if year==1987&month<1;
replace dif = month - 1 if year==1987&month>=1;

label variable dif "Born after January 1987 (in months)";

gen di1=dif;
gen di1_i=dif;
replace di1_i=0 if dif<0;
gen di2=dif^2;
gen di2_i=dif^2;
replace di2_i=0 if dif<0;
gen di3=dif^3;
gen di3_i=dif^3;
replace di3_i=0 if dif<0;

gen after1986=0;
replace after1986=1 if dif>=0;

label variable after1986 "Dummy:1 if born after January 1987";

gen modate = ym(year, month);
format modate %tm;

label variable modate "Birth month and year variables";

save "created/women_data_for_analysis_2008_Restat_figure2.dta", replace;
