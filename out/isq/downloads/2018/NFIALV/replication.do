cd "C:\Users\Danny\Documents\ZIOP\substantive\HilMooMuk_isq"

use HilMooMuk_replication.dta, clear
sort COWccode year
tsset COWccode year

gen logingo = log(1 + ingo)
gen logHROsec = log(1 + HROsecr)
gen logHROsecl = L.logHROsec

*/ define routines for OP, ZiOP, ZiOPC

capture program drop myoproba 
program myoproba
    version 10.0
    args lnf xb cut2
    tempvar p q  
    qui {
        gen double `p' = normal(-`xb')
        gen double `q' = normal(`cut2'-`xb')
        replace `lnf' = ///
            ln(`p') if $ML_y1==0
        replace `lnf' = ///
            ln((`q')-(`p')) if $ML_y1==1
	  replace `lnf' = ///
            ln(1-`q') if $ML_y1==2    
}
end

capture program drop ziopa
program ziopa 
	version 10.0
	args lnf xb zg cut2	
      tempvar p q r 
      qui {
        gen double `p' = normal(-`xb')
        gen double `q' = normal(`cut2'-`xb')
        gen double `r' = normal(`zg')
        replace `lnf' = ///
            ln((1-`r')+(`r'*`p')) if $ML_y1==0
        replace `lnf' = ///
            ln((`r'*`q')-(`r'*`p')) if $ML_y1==1
	  replace `lnf' = ///
            ln(`r'*(1-`q')) if $ML_y1==2    
}
end

capture program drop ziopb
program ziopb 
	version 10.0
	args lnf xb zg cut2 rho	
      qui {
	  replace `lnf' = ///
            ln((1-normal(`zg'))+binormal(`zg',-`xb',-`rho')) if $ML_y1==0
        replace `lnf' = ///
            ln(binormal(`zg',`cut2'-`xb',-`rho')-binormal(`zg',-`xb',-`rho')) if $ML_y1==1
        replace `lnf' = ///
            ln(binormal(`zg',`xb'-`cut2',`rho')) if $ML_y1==2    
}
end

*/ Models w/ all CIRI variables, logged INGO offices

set more off
local beta WoverS lngdp lnpop allterror cat logHROsec
local gamma avmdia WoverS allterror aireportsl logHROsec 
local dv tort polpris kill disap

log using results.log, replace

foreach i of local dv {

	ml model lf myoproba (beta: `i' = `beta') (cut2:) if avmdia!=.&aireportsl!=., cluster(COWccode)
	ml maximize, difficult
	estimates stats
	matrix eb = e(b)
	gen insample = e(sample) == 1

	ml model lf ziopa (beta: `i' = `beta') (gamma: `i' = `gamma') (cut2:) if insample == 1, cluster(COWccode)
	ml init eb, skip
	qui ml maximize, difficult
	matrix eb = e(b)

	ml model lf ziopb (beta: `i' = `beta') (gamma: `i' = `gamma') (cut2:) (rho:) if insample == 1, cluster(COWccode) 
	ml init eb, skip
	ml maximize, difficult
	estimates stats
	drop insample
}

*/ Models w/ CIRI torture, alternate INGO measures (Wiik count, logged Wiik count, INGO offices count)

local beta WoverS lngdp lnpop allterror cat 
local gamma avmdia WoverS allterror aireportsl 
local ngos ingo logingo HROsec 

foreach j of local ngos {

	ml model lf myoproba (beta: tort = `beta' `j') (cut2:) if avmdia!=.&aireportsl!=., cluster(COWccode)
	ml maximize, difficult
	matrix eb = e(b)
	gen insample = e(sample) == 1

	ml model lf ziopa (beta: tort = `beta' `j') (gamma: tort = `gamma' `j') (cut2:) if insample == 1, cluster(COWccode)
	ml init eb, skip
	qui ml maximize, difficult
	matrix eb = e(b)

	ml model lf ziopb (beta: tort = `beta' `j') (gamma: tort = `gamma' `j') (cut2:) (rho:) if insample == 1, cluster(COWccode) 
	ml init eb, skip
	ml maximize, difficult
	drop insample
}
log close

