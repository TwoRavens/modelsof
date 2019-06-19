************************
**Construct Main Dataset
************************

**Load data
insheet using "./data/TSdata.txt", clear
ren v1 enum
ren v2 inum
ren v3 snum
ren v4 year
replace year=year+1969
ren v5 vaexports
ren v6 exports
ren v7 finalexports
ren v8 intermedexports
drop v9
merge 1:1 enum inum snum year using "./data/data_id.dta", nogenerate

**Clean up countries
drop if (ecode=="CZE" | icode=="CZE") & year<1993
drop if (ecode=="EST" | icode=="EST") & year<1993
drop if (ecode=="RUS" | icode=="RUS") & year<1990
drop if (ecode=="SVK" | icode=="SVK") & year<1993
drop if (ecode=="SVN" | icode=="SVN") & year<1993
replace ecode="ROM" if ecode=="ROU"
replace icode="ROM" if icode=="ROU"

**Replace with zeros when exports<1e-6
replace exports=0 if exports<1e-6
replace finalexports=0 if finalexports<1e-6
replace intermedexports=0 if intermedexports<1e-6

sort ecode icode year
save "./data/VAdataset", replace

