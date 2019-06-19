clear
set more 1
set mem 40m

* This program reads in segregation data from different sources
* See "From Brown to Busing," Cascio, Gordon, Lewis, and Reber (CGLR), Journal of Urban Economics 2008 for details on these data.

* Segregation data for 1960-66 come from SERS. These data were hand-entered from the paper.
* sers`yr'-la.txt

* Segregation data for 1967 are from the Department of Health Education and Welfare. These data were in paper only and were hand-entered for CGLR.
* OCR67-LA.txt

* OCR data for 1968-1976 are from the Department of Health Education and Welfare. These data were electronic. An extract of the data for LA is provided in the raw data folder.
* ocr_rectype2_68_72_LA.dta
* ocr_rectype2_73_74_LA.dta
* ocr_rectype2_76_LA.dta

*read in SERS data
forvalues yr=60/66 {
	clear
	insheet using ${RAW}/sers`yr'-la.txt
	cap drop year
	gen year=19`yr'
	tempfile tmp`yr'
	save `tmp`yr''
	}
forvalues yr=60/65 {
	append using `tmp`yr''
	}

*1965 doesn't have much data, so drop it
drop if year==1965

gen ncesid=2200000+oedist
replace fipscnty=22000+fipscnty
keep ncesid fipscnty desegenrblack year

*sum by county
*first drop Bogalusa City because it's partner (Washington Parish) is not present
*Calcasieu (2200330,2200330.1) and Lake Charles (2202011) -- fipscnty 22019
*Bogalusa City (2200240) and Washington Parish (2201860) -- fipscnty 22117
*Monroe City (2201080) and OUACHITA Parish (2201200) -- fipscnty 22073

drop if ncesid==2200240 & year==1966
recode desegenrblack .=0
egen x=sum(desegenrblack), by(fipscnty year)
replace desegenrblack=x
drop x

*merge on county crosswalk
cap drop fipscnty
sort ncesid
merge ncesid using ${RAW}/LAnames
tab _merge
drop if _merge==2
drop _merge
sort fipscnty year

save ${DTA}/LA-sers, replace

*read in 1967 data
clear
insheet using ${RAW}/OCR67-LA.txt

recode enrother .=0
replace enrwhite=enrwhite+enrother

keep ncesid distname fipscnty enrblack enrwhite totenr

rename enrblack bl
rename enrwhite wh
recode wh .=0
recode bl .=0
rename totenr to
gen year=1967
tempfile ocr67
save `ocr67'

*get OCR data for 1968-1976, LA only

use ${RAW}/ocr_rectype2_68_72_LA
rename sch_enr_oth sch_enr_wh
rename sch_teach_oth sch_teach_wh

tempfile ocr1
save `ocr1'

use ${RAW}/ocr_rectype2_73_74_LA
rename sch_enr_oth sch_enr_wh
tempfile ocr2
save `ocr2'

use ${RAW}/ocr_rectype2_76_LA
foreach race in ai as bl wh hi {
	recode sch_enr_`race'_ma .=0
	recode sch_enr_`race'_fe .=0
	gen sch_enr_`race'=sch_enr_`race'_ma+sch_enr_`race'_fe
	}
drop sch_enr*_fe sch_enr*_ma
	
append using `ocr1'
append using `ocr2'

gen ncesid=oe_code-600000
drop oe_code
foreach race in ai as bl wh hi {
	rename sch_enr_`race' `race'
	recode `race' .=0
	}
gen to=ai+as+bl+wh+hi

*now append 1967 data
append using `ocr67'

*Note: confirmed that all consolidation partners are available, so don't need to exclude any districts
* change ncesids for city districts so that they are consolidated with their respective counties in the calculations
*Calcasieu and Lake Charles
recode ncesid 2202011=2200330.1

*Bogalusa and Washington
recode ncesid 2200240=2201860

*Monroe and Oachita
recode ncesid 2201080=2201200

*create total teachers and district-level teacher and enrollment measures
gen sch_teach_to=0
foreach race in ai as bl wh hi {
	recode sch_teach_`race' .=0
	replace sch_teach_to=sch_teach_to+sch_teach_`race'
	egen teach`race'=sum(sch_teach_`race'), by(ncesid year)
	egen enr`race'=sum(`race'), by(ncesid year)
	}
	egen teachto=sum(sch_teach_to), by(ncesid year)
	egen enrto=sum(to), by(ncesid year)

*create student-teacher ratios by race
*overall student-teacher ratio
gen sch_strat=to/sch_teach_to
gen sch_tsrat=sch_teach_to/to
foreach race in bl wh {
	gen double x=sch_strat*`race'/enr`race'
	gen double y=sch_tsrat*`race'/enr`race'
	egen strat`race'_ocr=sum(x), by(ncesid year)
	egen tsrat`race'_ocr=sum(y), by(ncesid year)
	drop x y
	}

*generate segregation variables

*****************************************************
*calculate dissimilarity index (white-nonwhite)

capture program drop dissim
program define dissim
	local a="`1'"
	local b="`2'"

	gen schtot=`a'+`b'
	cap egen enr`a'=sum(`a'), by(ncesid year)
	cap egen enr`b'=sum(`b'), by(ncesid year)
	gen disttot=enr`a'+enr`b'
	gen distper`a'=enr`a'/disttot
	gen distper`b'=enr`b'/disttot
	gen sper`a'=`a'/schtot
	*numerator of dissimilarity index for school:
	gen d=schtot*(abs(sper`a'-distper`a'))
	*sum across schools:
	egen e=sum(d), by(ncesid year)
	*denominator
	gen f=2*disttot*distper`a'*(1-distper`a')
	*calculate dissimilarity index
	gen d`a'_`b'=e/f
	replace d`a'_`b'=. if enr`a'==0|enr`b'==0
	drop d e disttot distper`a' distper`b' sper`a' schtot f

end

*calculate exposure index at school level for blacks
*generate bwgt = the fraction of blacks in a district for each school

capture program drop expose
program define expose
	local a="`1'"
	local b="`2'"

	gen `a'wgt=`a'/enr`a'
	gen `b'wgt=`b'/enr`b'

	*exposure of a to b
	gen sex`a'`b'=(`b'/to)*`a'wgt
	egen exp`a'_`b'=sum(sex`a'`b'), by(ncesid year)
	replace exp`a'_`b'=exp`a'_`b'
	drop `a'wgt `b'wgt sex`a'`b'
	replace exp`a'_`b'=. if enr`a'==0|enr`b'==0
	
end

**********************************************************************
*Now calculate segregation measures

dissim bl wh
expose bl wh
expose wh bl

*percent of blacks in school with any whites
gen x=(wh>0)
gen y=x*bl/enrbl
egen perblanywh=sum(y), by(ncesid year)
drop x y

cap drop tag
egen tag=tag(ncesid year)
keep if tag==1
keep ncesid sys_name ncesid year dbl_wh expbl_wh expwh_bl stratbl_ocr stratwh_ocr tsratbl_ocr tsratwh_ocr perblanywh

*merge on county crosswalk
cap drop fipscnty
sort ncesid
merge ncesid using ${RAW}/LAnames
tab _merge
drop if _merge==2
drop _merge
sort fipscnty year

save ${DTA}\LAOCR, replace

