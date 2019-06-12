
cd "c:\users\\`c(username)'\dropbox\TingleyCostaRica\ISQ\data\supplement"
insheet using CR_sitc3.csv , comma clear

replace commoditycode = subinstr(commoditycode,"S3-","",.)
rename commoditycode sitc
rename period year
preserve
keep if sitc=="TOTAL"
drop commoditydesc netweightkg-flag

reshape wide tradevalue , i(year partner sitc) j(tradeflow) str
renvars trade*, presub("tradevalue" "")

reshape wide Export Import, i(year sitc) j(partner) str
renvars Export* Import* , prefix("Tot_")
drop sitc reporter
tempfile totcr

sort year 
save `totcr' , replace

restore 
keep if length(sitc)==4

drop commoditydesc netweightkg-flag
reshape wide tradevalue , i(year partner sitc) j(tradeflow) str
renvars trade*, presub("tradevalue" "")

reshape wide Export Import, i(year sitc) j(partner) str


local names primary natres labor tech humcap nec

local primary1 0 1 2 3 4 
local primary2 94
local primary4 5977 

local natres2 61 68 69
local natres3 525 633 635 661 662 663 667 671 811
local natres4 6341 6342 6343 6344 6349 8519

local labor2 65 82 83 84
local labor3 664 665 666 793 812 813 873 874 881 882 883 884 894 895
local labor4 8510 8511 8512 8513 8514 8515 8517 8724 8913

local tech2 51 54 56 57 58 71 72 73 75 77
local tech3 522 523 524 591 592 593 598 741 742 743 744 745 746 747 749 764 792 871 893 
local tech4 0253 5972 5973 7481 7482 7484 7485 7486 7489 8721 8722 8723 8911 8912 8919

local humcap2 53 55 62 64 78 95
local humcap3 53 672 673 674 675 676 677 678 679 761 762 763 791 885 892 896 897 898 899 
local humcap4 6345 7483

local nec2 91 93 96 97

gen fact_intens = .

local count : word count `names'

qui forval i = 1/`count' {
local type: word `i' of `names'
forval j = 1/4 {
foreach var of local `type'`j' {
replace fact_intens = `i' if substr(sitc,1,`j')=="`var'"
}
}

label define intens `i' "`type'" , modify
}


collapse (sum) ExportUSA ImportUSA ExportWorld ImportWorld , by(year fact_intens)

sort year
merge year using `totcr' , uniqusing

drop _merge

foreach var of varlist ExportUSA-ImportWorld {
gen pct_`var' = `var'/Tot_`var'
}
label var year "Year"

preserve
keep year fact_intens pct*
*renvars pct* , presub("pct_" "")
*renvars Export* Import* , postfix(pct)
reshape long pct_, i(year fact_intens) j(type) str

reshape wide pct_ , i(year type) j(fact_intens)

label var pct_1 "Primary"
label var pct_2 "Natural Resource"
label var pct_4 "Technology"
label var pct_5 "Human Capital"
label var pct_3 "Labor"
label var pct_6 "NEC"


line pct_1  pct_4 pct_3   year  if type=="ExportUSA", xlab(1994(2)2006 , angle(45)) title("Changing Costa Rican Exports to US") ysca(range(0 1)) ylab(0(.2)1) ytitle("Proportion of CR exports") saving(app_fig1.gph , replace)
