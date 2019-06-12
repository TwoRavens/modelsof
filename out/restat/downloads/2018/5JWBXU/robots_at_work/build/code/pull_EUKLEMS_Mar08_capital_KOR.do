*** EUKLEMS Mar 2008 release, capital file KOREA: load data into Stata
	
	foreach var in CAP_ICT CAP_NonICT CAP_GFCF {
		
import excel "..\input\EUKLEMS\korea_capital_input_08I.xls",  first sheet("`var'") clear
		
		ren _* `var'* 
		reshape long `var', i(code) j(year)
		
		if "`var'"!="CAP_ICT" {
	
merge 1:1 code year using "..\temp\EUKLEMS_Mar08_capital_KOR"	
			drop _mer
		}
	
sa "..\temp\EUKLEMS_Mar08_capital_KOR", replace	
	}
	
	
	gen CAPIT = CAP_ICT/CAP_GFCF
	gen CAPNIT = CAP_NonICT/CAP_GFCF 
	
	keep if CAPIT!=. 

	gen country = "KOR"
	
	order country code desc year CAPIT CAPNIT
	so code year
	
sa "..\temp\EUKLEMS_Mar08_capital_KOR", replace	
