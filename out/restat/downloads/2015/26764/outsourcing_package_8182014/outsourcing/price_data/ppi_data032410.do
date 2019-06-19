*MAPPING TO PRODUCER PRICE INDEX FROM THE BLS
*Catie Almirall
*3/24/10

cd C:\Users\wb364506\Documents\for_avi

***INSHEETING ORIGINALS
foreach n of numlist 0/25{
 clear
 insheet using pd_originals\pd_data_`n'.txt
 drop if year<1982
 drop if year>2002
 gen survey=substr(series_id,1,2)
 gen season=substr(series_id,3,1)
 gen industry=substr(series_id,4,4)
 gen product=substr(series_id,9,8)
 save pd_data_`n'.dta
}
foreach n of numlist 29/31{
 clear
 insheet using pd_originals\pd_data_`n'.txt
 drop if year<1982
 drop if year>2002
 gen survey=substr(series_id,1,2)
 gen season=substr(series_id,3,1)
 gen industry=substr(series_id,4,4)
 gen product=substr(series_id,9,8)
 save pd_data_`n'.dta
}

***APPENDING ALL INDUSTRIES
use pd_data_1
foreach n of numlist 2/25{
 append using pd_data_`n'.dta
}
foreach n of numlist 29/31{
 append using pd_data_`n'.dta
}
save pd_data, replace

use pd_data
append using pd_data_0
duplicates drop

***RESHAPING WIDE, GETTING AVERAGES
drop footnote survey season
encode industry, gen (indcode)
drop if product!=""
gen mo=substr(period, 2,2)
destring mo, replace
gen year_mo=year*100+mo
drop year mo period product
reshape wide value, i(indcode) j(year_mo)

#delimit;
foreach year of numlist 1982/2002{;
 egen value`year'14=rowmean(value`year'01 value`year'02 value`year'03 value`year'04 value`year'05 value`year'06 value`year'07 value`year'08 
 value`year'09 value`year'10 value`year'11 value`year'12);
};

keep value*13 value*14 industry indcode series_id

foreach year of numlist 1982/2002{
 gen check`year'13=0
 replace check`year'13=1 if value`year'13==. & value`year'14!=.
 gen check`year'14=0
 replace check`year'14=1 if value`year'13!=. & value`year'14==.
}
sum check*13
sum check*14
drop check*
drop value*13

save pd_data_all, replace


***PASTED IN TWO EXTRA OBSERVATIONS, FOR AGRICULTURE AND FOR GENERAL
generate source="ppi"
save pd_data_all, replace


***ADDING CPI DATA WHERE DESIRABLE
cd C:\Users\wb364506\Documents\for_avi

***INSHEETING ORIGINALS
foreach n in 0_Current 1_Allitems 11 12 13 14 15 16 17 18 20{
 clear
 insheet using cu_originals\cu_data_`n'.txt
 drop if year<1982
 drop if year>2002
 gen survey=substr(series_id,1,2)
 gen season=substr(series_id,3,1)
 gen periodicity=substr(series_id,4,1)
 gen area=substr(series_id,5,4)
 gen product=substr(series_id,9,8)
 save cu_data_`n'.dta
}

***APPENDING ALL INDUSTRIES
use cu_data_0_Current
foreach n in 1_Allitems 11 12 13 14 15 16 17 18 20{
 append using cu_data_`n'.dta
}
save cu_data, replace

use cu_data
keep if area=="0000"
keep if season=="U"
duplicates drop

***RESHAPING WIDE, GETTING AVERAGES
drop footnote survey
encode product, gen (productcode)
gen mo=substr(period, 2,2)
destring mo, replace
gen year_mo=year*100+mo
drop year mo period product area
keep if periodicity=="R"
drop periodicity
reshape wide value, i(productcode) j(year_mo)

#delimit;
foreach year of numlist 1982/2002{;
 egen value`year'14=rowmean(value`year'01 value`year'02 value`year'03 value`year'04 value`year'05 value`year'06 value`year'07 value`year'08 
 value`year'09 value`year'10 value`year'11 value`year'12);
};

keep value*13 value*14 product productcode series_id

foreach year of numlist 1982/2002{
 gen check`year'13=0
 replace check`year'13=1 if value`year'13==. & value`year'14!=.
 gen check`year'14=0
 replace check`year'14=1 if value`year'13!=. & value`year'14==.
}
sum check*13
sum check*14
drop check*
drop value*13

save cu_data_all, replace

generate source="cpi"
rename productcode indcode
decode indcode, gen(industry)
drop indcode
save cu_data_all, replace

use pd_data_all
replace source = "agri" if industry=="agri"
drop indcode
save pd_data_all, replace

use pd_data_all
replace source = "agri" if industry=="agri"
append using cu_data_all
encode industry, gen(indcode)


***FINAL FORMAT
reshape long value, i(indcode) j(year)
replace year=floor(year/100)
reshape wide value, i(indcode) j(year)
save price_data_all, replace

use price_data_all
sort industry source
merge industry source using ind7090-price.dta, uniqmaster
drop if _merge==1
drop _merge


tab ind7090 if  value1985==.

*    ind7090 |      Freq.     Percent        Cum.
*------------+-----------------------------------
*         40 |          1        9.09        9.09
*         60 |          1        9.09       18.18
*        121 |          1        9.09       27.27
*        152 |          1        9.09       36.36
*        261 |          1        9.09       45.45
*        262 |          1        9.09       54.55
*        502 |          1        9.09       63.64
*        511 |          1        9.09       72.73
*        512 |          1        9.09       81.82
*        531 |          1        9.09       90.91
*        660 |          1        9.09      100.00

replace value1985=value1986 if value1985==.
replace value1984=value1985 if value1984==.
replace value1983=value1984 if value1983==.
replace value1982=value1983 if value1982==.

reshape long value, i(ind7090) j(year)
rename value price_index
compress
save price_data_all, replace

