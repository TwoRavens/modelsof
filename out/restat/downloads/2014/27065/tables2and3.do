clear all

use firm-level.dta

drop if year<1982 | year>2006
drop if firm=="OTHER"

*Table 2
gen gtotal82 = 37337000 // global sales in 1982
gen gtotal06 = 69438000 // global sales in 2006

by year, sort: egen sample_sales_by_year = sum(sales)

gen ms82 = 100*sales/gtotal82 // correct only if year==1982

list firm sales ms82 if year==1982

gen sample_share = 100*sample_sales_by_year/gtotal82 // correct only if year==1982
sum sample_share if year==1982 // correct only if year==1982

gen ms06 = 100*sales/gtotal06 // correct only if year==2006

list firm sales ms06 if year==2006

gen sample_share2 = 100*sample_sales_by_year/gtotal06 // correct only if year==2006
sum sample_share2 if year==2006 // correct only if year==2006

*Table 3
sum pat_app sales price year
centile pat_app sales price, centile(10 90)
