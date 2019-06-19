* cpi.do
* Read in CPI data

clear
insheet using ${CSV}/cpi.csv

*use 2007 as base year
gen x=cpi if year==2007
egen y=max(x)
gen cpi_defl=cpi/y
label var cpi_defl "Deflate to 2007$"
drop x y series

sort year

save ${DTA}/cpi, replace
