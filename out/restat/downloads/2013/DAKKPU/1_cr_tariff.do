set more off
pause off

*delete all files tar_`xx'_`y'.dta BEFORE RUNNING THIS


cd "C:\RESTAT\"
local ctrycode "Code_Pays"


capture program drop cr_tariffs
program cr_tariffs
preserve
local k = gg + 1 in 1
********************************************* loop reporter
local g = 1 
        while `g' < `k' {
        	restore
		preserve
		keep if lg==`g'
		replace ccode="ZAF" if ccode=="SAF"
		replace ccode="SER" if ccode=="SRB"
		replace pcode="ZAF" if pcode=="SAF"
		replace pcode="SER" if pcode=="SRB"
		local xx = ccode
		local y = year
		drop lg gg 
		save "tar_`xx'_`y'.dta",replace
		display "*****************************************************************country `xx' year `y' saved"
		local g = `g' + 1
		}
end	

*****************************************************************************************************


#delimit ;
global ppp "
1
2
3
4
5
6
7
8
9
10
2009_1
2009_2
2009_3
2009_4 
2009_5
2009_6 
2009_7   
";
#delimit cr
foreach p of global ppp {
insheet using "pre_wb_`p'.txt", clear
display "*******************************************file pre_wb_`p'***********************"
sum
tab reporter
rename reporter ic
sort ic
merge ic using `ctrycode'
tab _m
drop if _m==2
tab ic if _m==1
replace iso3="EUN" if ic==918
drop _m
rename ic reporter
rename iso3 ccode
tab ccode
rename partner ic
sort ic
merge ic using `ctrycode'
tab _m
drop if _m==2
tab ic if _m==1
drop _m
rename ic partner
rename iso3 pcode
egen lg=group(reporter)
egen gg=max(lg)
gen a=hs6+1000000
gen b=string(a)
gen c=substr(b,2,6)
drop a b hs6
rename c hs6
cr_tariffs
}


program drop cr_tariffs


