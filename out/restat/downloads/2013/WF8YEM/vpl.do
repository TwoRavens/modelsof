clear
set memory 7g
cd "\\Mfso01\MyDocs\liner\My Documents\Filer\"
use "monstring7282.dta", clear

keep bidnr bari stpi sipe pprf inst lngd pkat
destring lngd, gen(l_ngdcm)
gen d7282=1

destring pkat, replace

gen year_enlistment=substr(inst,1,2)
destring year_enlistment, replace

gen befl=substr(pprf,1,1)
gen pf=substr(pprf,3,1)
gen pg=substr(pprf,4,1)

destring befl, replace
destring pf, replace
destring pg, replace
destring inst, replace

replace befl=. if befl==0
replace pf=. if pf==0
replace pg=. if pg==0

gen sipes=substr(sipe,1,1)
gen sipei=substr(sipe,2,1)
gen sipep=substr(sipe,3,1)
gen sipee=substr(sipe,4,1)

destring sipes, replace
destring sipei, replace
destring sipep, replace
destring sipee, replace

gen pfsum=sipes+sipei+sipep+sipee

replace pfsum=. if (sipes==0 | sipei==0 | sipep==0 | sipee==0)
replace pfsum=. if (sipes==. | sipei==. | sipep==. | sipee==.)

gen logic_st=substr(stpi,1,1)
gen verbal_st=substr(stpi,2,1)
gen spatial_st=substr(stpi,3,1)
gen tech_st=substr(stpi,4,1)

destring logic_st, replace
destring verbal_st, replace
destring spatial_st, replace
destring tech_st, replace

destring bari, replace
destring stpi, replace
destring sipe, replace

gen pgsum=logic_st + verbal_st + spatial_st + tech_st
replace pgsum=. if (logic_st==0 | verbal_st==0 | spatial_st==0 | tech_st==0)
replace pgsum=. if (logic_st==. | verbal_st==. | spatial_st==. | tech_st==.)

sort bidnr

gen bari_2 = bari

save monstring7282_select_vars.dta, replace


save "vpl7282.dta", replace

use "vpl8397l.dta", clear

keep bidnr bari stpi sipes sipei sipep sipee pg pf befl inst l_ngdcm pkat
gen d8397=1

gen year_enlistment=floor(inst/10000)
replace year_enlistment=. if year_enlistment>=98

gen bari_2 = bari
replace bari_2 = year_enlistment if bari ==.

destring pkat, replace

destring inst, replace

replace befl=. if befl==0
replace pf=. if pf==0
replace pg=. if pg==0

gen pfsum = sipes + sipei + sipep + sipee
replace pfsum =. if (sipes == 0|sipei==0|sipep==0|sipee==0|sipes == .|sipei==.|sipep==.|sipee==.)

gen logic_st=floor(stpi/1000)
gen verbal_st=floor((stpi-logic_st*1000)/100)
gen spatial_st=floor((stpi-logic_st*1000-verbal_st*100)/10)
gen tech_st=stpi-logic_st*1000-verbal_st*100-spatial_st*10

gen pgsum=logic_st + verbal_st + spatial_st + tech_st
replace pgsum=. if (logic_st==0 | verbal_st==0 | spatial_st==0 | tech_st==0)
replace pgsum=. if (logic_st==. | verbal_st==. | spatial_st==. | tech_st==.)

drop if bari_2>= 95

sort bidnr

save "vpl8394.dta", replace

use "vpl7282.dta", clear
append using "vpl8394.dta"

	foreach x in pgsum {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==72
	egen temp2=mean(temp1) if `x'!=. & bari_2==72, by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==72
	gen `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==72
	drop temp*
	}

foreach i of num 73/94 {
	foreach x in pgsum {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==`i'
	egen temp2=mean(temp1) if `x'!=. & bari_2==`i', by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==`i'
	replace `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==`i'
	drop temp*
	}
}

gen pctc = pgsum_rank/100
bysort bari: gen c = invnorm(pctc)



	foreach x in pfsum {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==72
	egen temp2=mean(temp1) if `x'!=. & bari_2==72, by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==72
	gen `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==72
	drop temp*
	}

foreach i of num 73/94 {
	foreach x in pfsum {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==`i'
	egen temp2=mean(temp1) if `x'!=. & bari_2==`i', by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==`i'
	replace `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==`i'
	drop temp*
	}
}

gen pctn = pfsum_rank/100
bysort bari: gen n = invnorm(pctn)


*** Normalized test scores based on 1-9

	foreach x in pg {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==72
	egen temp2=mean(temp1) if `x'!=. & bari_2==72, by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==72
	gen `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==72
	drop temp*
	}

foreach i of num 73/94 {
	foreach x in pg {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==`i'
	egen temp2=mean(temp1) if `x'!=. & bari_2==`i', by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==`i'
	replace `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==`i'
	drop temp*
	}
}

gen pctc2 = pg_rank/100
bysort bari: gen c2 = invnorm(pctc2)



	foreach x in pf {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==72
	egen temp2=mean(temp1) if `x'!=. & bari_2==72, by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==72
	gen `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==72
	drop temp*
	}

foreach i of num 73/94 {
	foreach x in pf {
		sort `x'
	egen temp1=seq() if `x'!=. & bari_2==`i'
	egen temp2=mean(temp1) if `x'!=. & bari_2==`i', by(`x')
	egen temp3=count(bidnr) if `x'!=. & bari_2==`i'
	replace `x'_rank=((temp2-0.5)/temp3)*100 if bari_2 ==`i'
	drop temp*
	}
}

gen pctn2 = pf_rank/100
bysort bari: gen n2 = invnorm(pctn2)


save "vpl.dta", replace
