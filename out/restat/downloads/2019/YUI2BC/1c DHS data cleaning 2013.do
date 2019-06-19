***Last Updated: 12/14/2018 Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Data cleaning of the Turkish National Survey on Domestic Violence against Women (TNSDVW) 2014

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

To run the do file all you need to do is to change the path of the working directory in line 34.

The dataset used in this do file is provided by the Hacettepe University Institute of Population Studies. 
Their data availability policy prohibits the distribution of data to non-registered users. Researchers 
have to sign up and complete a form on http://www.hips.hacettepe.edu.tr/tnsa/download.php 
Upon receipt of this form, the Hacettepe University sends 
the datasets electronically. 

Please save this dataset in Stata format as "Domestic Violence/originals/individual2013_TNSA.dta" 
before you run this do file.

*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";


use "originals/individual2013_TNSA.dta", clear

*******************************************
***Age, Marriage, and Children Variables***
*******************************************
 
 **Age**
 gen age=V012 
 label var age "Age"
 
 **Month of Birth**
 gen month=V009
 label var month "Month of birth"

 **Year of Birth**
 gen year=V010
 label var year "Year of birth"

 **Have children?
 gen has_children=.
 replace has_children=0 if V218==0
 replace has_children=1 if V218>0 &V218!=.
 label var has_children "Dummy:1 if she has children"
 
 *************************
 ***Religiosity Variables***
 *************************
 
 **Wears Headscarf**
 gen headscarf=.  
 replace headscarf=1 if S793I==1|S793I==2
 replace headscarf=0 if S793I==0
 label var headscarf "Dummy:1 if she wears headscarf"
 
 **Attended Quran Course**
 gen religious_course=.
 replace religious_course=1 if S115BB==1
 replace religious_course=0 if S115BB==0 
 label var religious_course "Dummy:1 if she attended Quran course"
 
 **Prays**
 gen namaz=.  
 replace namaz=1 if S793F==1|S793F==2
 replace namaz=0 if S793F==0
 label var namaz "Dummy:1 if she prays"
 
 **Fasts**
 gen fast=.  
 replace fast=1 if S793G==1|S793G==2
 replace fast=0 if S793G==0
 label var fast "Dummy:1 if she fasts"

 **Religiosity Index**
 foreach var in headscarf fast namaz{
 egen z_`var'=std(`var')
 }
 egen z_religious=rowmean(z_headscarf z_fast z_namaz)
 drop z_headscarf z_fast z_namaz

 label variable z_religious "Z-score proxy for the religiosity of woman"
 
 *************************
 ***Schooling Variables*** 
 *************************
 
 **Years of School**
 gen schooling=V133
 replace schooling=. if schooling==.a
 replace schooling=. if schooling==98
 label var schooling "Years of schooling"
 
 **Mother Tongue**
 gen noturkish2=.
 replace noturkish2=0 if S116==1
 replace noturkish2=1 if S116==2| S116==3| S116==7
 label var noturkish2 "Dummy:1 if is her mother tongue is not Turkish"
 
 ************************
 ***Location Variables***
 ************************
 
 **Rural**
 
 gen rural=.
 replace rural=1 if V102==2
 replace rural=0 if V102==1 
 label var rural "Dummy:1 if her current location is rural"
 
 **Creating Sampling Weight for Regression
 gen weight=V005/1000000
 label var weight "Sampling weight"
 
 **Dummy variables for Month-of-birth fixed effects**
 quietly tab month, gen(month_)
 foreach num of numlist 1(1)12{
 label variable month_`num' "Birth month dummies"
 }
 
 *Childhood residence
 gen rural_pre12=.
 replace rural_pre12=1 if S130C==3 | S130C==2
 replace rural_pre12=0 if S130C==1
 label variable rural_pre12 "Dummy:1 if childhood region is rural"
 
 gen province_pre12=.
 replace province_pre12=S130D if S130D<=81
 label var province_pre12 "Province lived before age 12"

gen region_pre12=.
replace region_pre12=1 if province_pre12==34
replace region_pre12=2 if province_pre12==10 |province_pre12==17 |province_pre12==22 |province_pre12==39 |province_pre12==59
replace region_pre12=3 if province_pre12==20 |province_pre12==35 |province_pre12==43 |province_pre12==45 |province_pre12==48| province_pre12==3 |province_pre12==9 |province_pre12==64
replace region_pre12=4 if province_pre12==14 |province_pre12==16 |province_pre12==26 |province_pre12==41 |province_pre12==81| province_pre12==81 |province_pre12==11|province_pre12==54|province_pre12==77
replace region_pre12=5 if province_pre12==6 |province_pre12==42 |province_pre12==70 
replace region_pre12=6 if province_pre12==1 |province_pre12==7 |province_pre12==15|province_pre12==31 |province_pre12==32|province_pre12==33 |province_pre12==46|province_pre12==80
replace region_pre12=7 if province_pre12==38 |province_pre12==40 |province_pre12==51 |province_pre12==66 |province_pre12==71|province_pre12==68 |province_pre12==50|province_pre12==58
replace region_pre12=8 if province_pre12==19 |province_pre12==37 |province_pre12==55 |province_pre12==60 |province_pre12==67|province_pre12==78|province_pre12==74|province_pre12==18|province_pre12==57|province_pre12==5
replace region_pre12=9 if province_pre12==61 |province_pre12==52 |province_pre12==28 |province_pre12==53|province_pre12==8|province_pre12==29
replace region_pre12=10 if province_pre12==4 |province_pre12==24 |province_pre12==25 |province_pre12==36 |province_pre12==76|province_pre12==69|province_pre12==75
replace region_pre12=11 if province_pre12==12 |province_pre12==23 |province_pre12==44 |province_pre12==65|province_pre12==62|province_pre12==30|province_pre12==49|province_pre12==13
replace region_pre12=12 if province_pre12==21 |province_pre12==27 |province_pre12==47 |province_pre12==63 |province_pre12==73|province_pre12==2|province_pre12==79|province_pre12==72|province_pre12==56

label variable region_pre12 "Region lived before age 12"

tab region_pre12, gen(region_pre12_)
 foreach num of numlist 1(1)12{
 label variable region_pre12_`num' "Childhood region dummies"
 }

gen region_pre12i1=region_pre12_1*rural_pre12
gen region_pre12i2=region_pre12_2*rural_pre12
gen region_pre12i3=region_pre12_3*rural_pre12
gen region_pre12i4=region_pre12_4*rural_pre12
gen region_pre12i5=region_pre12_5*rural_pre12
gen region_pre12i6=region_pre12_6*rural_pre12
gen region_pre12i7=region_pre12_7*rural_pre12
gen region_pre12i8=region_pre12_8*rural_pre12
gen region_pre12i9=region_pre12_9*rural_pre12
gen region_pre12i10=region_pre12_10*rural_pre12
gen region_pre12i11=region_pre12_11*rural_pre12
gen region_pre12i12=region_pre12_12*rural_pre12

foreach num of numlist 1(1)12{
label variable region_pre12i`num' "Childhood region dummies interacted with rural childhood region dummy"
}
 
 **GENERATE DIF VARIABLES FOR RD**
 gen dif=.
 replace dif = (-1)*[(12*(1987-year-1))+(12-month)+1] if year<1987
 replace dif = [(12*(year-1987-1))+month+11] if year>1987
 replace dif = (-1)*[1-month] if year==1987&month<1
 replace dif = month - 1 if year==1987&month>=1

 gen di1=dif
 gen di1_i=dif
 replace di1_i=0 if dif<0
 gen di2=dif^2
 gen di2_i=dif^2
 replace di2_i=0 if dif<0
 
label var dif "Difference between birth month and January 1987 (in months)"
label var di1 "Difference between birth month and January 1987 (in months)"
label var di1_i "Difference between birth month and January 1987 interacted with treatment (in months)"
label var di2 "Difference squarred between birth month and January 1987 (in months)"
label var di2_i "Difference squarred between birth month and January 1987 interacted with treatment (in months)"

 gen after1986=0
 replace after1986=1 if dif>=0
 
 label variable after1986 "Dummy:1 if born after January 1987"
 
 gen modate = ym(year, month)
 format modate %tm

 label variable modate "Birth month and year variables"
 
 drop V000-S736BC_8
 sort CASEID
 save "created/TNSA2013_Analysis.dta", replace

 
 
