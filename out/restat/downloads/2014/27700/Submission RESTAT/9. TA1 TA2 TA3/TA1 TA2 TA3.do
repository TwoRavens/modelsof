clear
cd "H:\Superstars\Submission RESTAT\"


* APPENDIX A1 
use "9. TA1 TA2 TA3\input\comparisonWITS.dta", clear
keep if year>2003 & year<2011
rename ratio _
reshape wide _, i(country) j(year)
drop if country=="DJI" | country=="GHA" | country=="NGA"
save "9. TA1 TA2 TA3\TA1.dta", replace

* APPENDIX A2 
use "9. TA1 TA2 TA3\input\T2_paretoTOP1all.dta", clear
drop type 
order country number average max min median sd
save "9. TA1 TA2 TA3\TA2.dta", replace

* APPENDIX A3 
use "9. TA1 TA2 TA3\input\T3_paretoTOP5all.dta", clear
drop type 
order country number average max min median sd
save "9. TA1 TA2 TA3\TA3.dta", replace
	
