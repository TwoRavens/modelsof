
clear
cd ..\cps
set mem 300m
set more off

*smoking information of other household members
clear
foreach name in feb03 jun03 nov03 {
      use "D:\data\cps\data\raw\cps`name'.dta",clear
	keep if pea1==1 | pea1==2
	keep hrhhid pea3 prs64
	ren hrhhid hhid
	ren pea3 pes34 
	gen smoke=(pes34==1|pes34==2)
	*total numer of smoking person in the household
	by hhid, sort: egen tsm = total(smoke)
	*keep only self-respondent
	keep if prs64==1	
	keep hhid tsm
	sort hhid
	save t`name'c, replace
        }

clear
foreach name in feb03 jun03 nov03 {
      use "D:\data\cps\data\raw\cps`name'.dta",clear
	ren pec6e pec6d2
	keep peio1cow hrhhid huhhnum pulineno hrmis hrmonth hryear prtage hufaminc hrnumhou pemaritl peeduca ptdtrace prdthsp pea2 /*
*/ peb2 peb3 pec2 pec3 peda ped2 peg1 pemlr pea3 peb6a peb6b peb6c peb6d peb6d2 peb7 pec7d peb8 pec1 pec1a pec6a pec6b pec6c pec6d /*
*/ pec6d2 pec8 peh6 peb1 pesex gestfips pwsrwgt pea1 prs64 gecmsa gemsa peb5anum peb5aunt pec5anum pec5aunt peb5c* geco gemsast /* 
*/ gemsasz gereg prmjocc1 prmjind1
	keep if pea1==1 | pea1==2
	*keep only self-respondent
	keep if prs64==1	
	ren hrnumhou hhsize
	ren hrmonth month
	ren hryear year
	ren prtage age
	ren pesex sex
	ren ptdtrace race
	ren prdthsp origin
	ren peeduca edu
	ren gestfips state
	ren peb1 cigday
	ren pemaritl marstat
	ren hufaminc faminc
	ren pwsrwgt srwgt
	ren hrhhid hhid
	ren huhhnum hhnum
	ren pulineno lineno
	ren hrmis mis
	ren pea3 pes34 
	ren pea2 pes33
	ren peb8 pes61 
	replace pes61=pec8 if pes61<0 & pec8>0
	replace pes61=peh6 if pes61<0 & peh6>0
	keep peio1cow hhid hhnum lineno mis year month age sex faminc hhsize edu race origin marstat state cigday pes34 pes61 /*
*/ peb2 peb3 pec2 pec3 srwgt peda ped2 peg1 pes33 pemlr peb6a peb6b peb6c peb6d peb6d2 peb7 pec7d pec1 pec1a pec6a pec6b pec6c pec6d pec6d2 /*
*/ gecmsa gemsa peb5anum peb5aunt pec5anum pec5aunt peb5c* geco gemsast gemsasz gereg prmjocc1 prmjind1

	sort hhid
	merge hhid using t`name'c
	keep if _merge==3
	drop _merge
	save t`name', replace
        }


use tfeb03,clear 
foreach name in jun03 nov03 {
	append using t`name'
	}
sort state year month
merge state year month using cigtaxprice3
keep if _merge==3
drop _merge

save merge2003-4, replace

