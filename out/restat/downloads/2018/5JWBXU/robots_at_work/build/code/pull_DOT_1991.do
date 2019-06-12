* pull 1991 DOT

	local path "..\input\DOT_1991\DS0013"
	
	local vars "str occ_dot_3dig 8-16"
	
	local vars "`vars' str phys_strngth 78-78"
	local vars "`vars' str phys_climbng 79-79"
	local vars "`vars' str phys_balncng 80-80"
	local vars "`vars' str phys_stoppng 81-81"
	local vars "`vars' str phys_kneelng 82-82"
	local vars "`vars' str phys_crouchg 83-83"
	local vars "`vars' str phys_crawlng 84-84"
	local vars "`vars' str phys_reachng 85-85"
	local vars "`vars' str phys_handlng 86-86"
	local vars "`vars' str phys_fingrng 87-87"
	local vars "`vars' str phys_feeling 88-88"
	local vars "`vars' str phys_talking 89-89"
	local vars "`vars' str phys_hearing 90-90"
	local vars "`vars' str phys_tstngsmllng 91-91"
	local vars "`vars' str phys_acuityn 92-92"
	local vars "`vars' str phys_acuityf 93-93"
	local vars "`vars' str phys_dpthprc 94-94"
	local vars "`vars' str phys_accmdtn 95-95"
	local vars "`vars' str phys_colrvsn 96-96"
	local vars "`vars' str phys_fldvisn 97-97"
	
	local vars "`vars' str occ_title 112-179"
	
infix `vars' using "`path'\06100-0013-Data.txt", clear
	
	compress
	
	replace occ_dot_3dig = substr(occ_dot_3dig,1,3)
	
	codebook occ_dot_3dig
		
sa "..\temp\dot_1991_phys", replace

	* collapse
	
		// N - not present, O - occasionally, F - frequently, C - constantly
	drop phys_strngth
	
	foreach varbl of var phys_* {
				
		gen _`varbl' = `varbl'!="N" if `varbl'!=""
	}
	
	foreach varbl of var phys_* {
				
		gen cnt_`varbl' = 0 if `varbl'=="N" 
			replace cnt_`varbl' = 1 if `varbl'=="O" 
			replace cnt_`varbl' = 2 if `varbl'=="F" 
			replace cnt_`varbl' = 3 if `varbl'=="C" 
	}
	
	drop phys_*
	ren _* *
	
	collapse phys* cnt*, by(occ_dot_3dig)
		
sa "..\temp\DOT_1991_phys_occ3", replace
