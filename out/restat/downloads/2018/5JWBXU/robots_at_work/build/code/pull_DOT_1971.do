* pulling DOT 1971 micro data - for female, weights, and to create cross-walk to DOT 1991 
	
u "..\input\DOT_1971\07845-0001-Data.dta", clear
	
	gen wt = int(V029*100) // original var should contain only two decimal places
	gen female = ( V023==2 )
	ren V018 occ70
	
		// DOT occupation code, 3-digit 
	tostring V001, gen(helper)
	
	replace helper = "0" + "0" + helper if length(helper)==7
	replace helper = "0" + helper if length(helper)==8
	
	assert length(helper)==9
	
	gen occ_dot_3dig = substr(helper,1,3)		
			
		// census 1990 (David Dorn) comparable occupation codes
	gen occ = occ70
	
	merge m:1 occ using "..\input\Autor-Dorn\occ1970_occ1990dd.dta"
		drop if _merg==2
			drop _mer
	replace occ1990dd = 479 if occ70==823
	
	do xwalk_occ1990dd-occ1990ddgg 
	
	local vars occ* female wt
	keep `vars' 
	order `vars' 
	
	compress
	
sa "..\temp\DOT_1971.dta", replace
