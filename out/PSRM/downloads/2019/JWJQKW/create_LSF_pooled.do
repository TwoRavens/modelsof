**********************************************************************************************************
**********************************************************************************************************
* Replication Code
* Labor market insecurity within the middle class - A new divide
* Hanna Schwander
* Political Science Research and Methods
**********************************************************************************************************
* This datafiles describes the generation of the relevant variables

* confidentiality undertaking prohibits granting access to these data
* apply for microdata: http://ec.europa.eu/eurostat/documents/203647/771732/How_to_apply_for_microdata_access.pdf
* and then merge the country files to yearly files and then the yearly files to a pooled data set
log using "Log_Createfile_Schwander_PSRM.smcl", replace

use "LSF_1992-2015.dta", clear

 
***************************************
** label important variables
***************************************
label var wstator "labor status during ref week"

#delimit;
label define wstator
1 "did work during the reference week"
2 "Was not working but had a job or business from which he/she was absent during the reference week"
3 "Was not working because on lay-off"
4 "Was a conscript on compulsory military or community service"
5 "Other who neither worked nor had a job or business during the reference week"
9 "Not applicable (child less than 15 years old)", modify;
label values wstator wstator;
#delimit cr



label define ilostat 1 "Employed" 2 "Unemployed" 3 "Inactive" 4 "Compulsory military service" 9 "Persons less than 15 years old", modify
label values ilostat ilostat


***************************************
*** create the socio-structural variables
***************************************
recode sex (1=0 "male") (2=1 "female"), gen(gender)
la var gender "gender"

gen workage =.
replace workage =1 if age >=17 & age <=67


drop if workage !=1

gen young =.
replace young =1 if age == 17
replace young =1 if age == 22
replace young =1 if age == 27
replace young =1 if age == 32
replace young =0 if age >= 37
la var young "young (17-36y)"


*education: HATLEV1D
gen education= .
replace education = 1 if hatlev1d == "L"
replace education = 2 if hatlev1d == "M"
replace education = 3 if hatlev1d == "H"

label define education 1 "Low-skilled: Lower secondary" 2 "Skilled: Upper secondary" 3 "High-skilled: Third level"
la val education education




gen hswomen =.
replace hswomen = 1 if gender == 1 & education ==3
replace hswomen = 0 if gender == 0
replace hswomen = 0 if gender == 1 & education <3

gen hsyoung = .
replace hsyoung = 1 if young == 1 & education ==3
replace hsyoung = 0 if young == 0
replace hsyoung = 0 if young == 1 & education <3


** labor market variables

gen involpt=.
replace involpt = 1 if ftptreas == 5
replace involpt = 1 if ftptreas == 6
replace involpt = 0 if ftptreas == 9
replace involpt = 0 if ftptreas < 5

tab involpt


gen partinv =.
replace partinv = 1 if ftpt == 2 & involpt ==1 
replace partinv = 0 if ftpt == 1 
replace partinv = 0 if ftpt == 2 & ftptreas ==0
la var partinv "Inv. part-time"

recode ftpt (1=0 "not parttime") (2=1 "parttime") (9=.), gen(parttime)
la var parttime "parttime"



gen tempinv = .
replace tempinv = 1 if temp ==2 & tempreas !=1
replace tempinv = 0 if temp ==1
replace tempinv = 0 if temp ==2 & tempreas ==1
la var tempinv "Inv. temporary"


recode ilostat (1 3 4 =0 "not unemployed") (2 = 1 "unemployed") , gen(unempl)
la var unempl "Unemployed"

save "LSF_1992-2015_rec.dta", replace

log close 
