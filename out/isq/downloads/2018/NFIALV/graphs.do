cd "C:\Users\Danny\Documents\ZIOP\substantive\merged"

use HillMooMuk06May11.dta, clear

gen logHROsec = log(1 + HROsec)

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

set more off
local beta WoverS lngdp lnpop allterror cat logHROsec
local gamma avmdia WoverS allterror aireportsl logHROsec

	ml model lf myoproba (beta: tort = `beta' `i') (cut2:) if avmdia!=.&aireportsl!=., cluster(COWccode)
	ml maximize, difficult
	matrix eb = e(b)
	gen insample = e(sample) == 1

	ml model lf ziopa (beta: tort = `beta' `i') (gamma: tort = `gamma' `i') (cut2:) if insample == 1, cluster(COWccode)
	ml init eb, skip
	qui ml maximize, difficult
	matrix eb = e(b)

	ml model lf ziopb (beta: tort = `beta' `i') (gamma: tort = `gamma' `i') (cut2:) (rho:) if insample == 1, cluster(COWccode) 
	ml init eb, skip
	ml maximize, difficult

preserve
drawnorm DH_b1-DH_b15, n(1000) means (e(b)) cov(e(V)) clear
save simulated_betas, replace
restore 
merge using simulated_betas
tab _merge
drop _merge
summarize DH*

scalar _WoverS = .69
scalar _allterror = 3
scalar _aireportsl = 3
scalar _logHROsec = .76

postutil clear
postfile media pr uci lci avmdia using media_gamma18May11.dta, replace
forvalues i = 0(.5)25 {
qui gen prg = normal(DH_b13+DH_b8*`i'+DH_b9*_WoverS+DH_b10*_allterror+DH_b11*_aireportsl+DH_b12*_HROsec)
sum prg, meanonly
scalar _pr = r(mean)
_pctile prg, percentiles(5 95)
scalar _uc = r(r2)
scalar _lc = r(r1)
post media (_pr) (_uc) (_lc) (`i')
drop prg
}
postclose media

scalar _avmdia = 0
scalar _allterror = 3
scalar _aireportsl = 3
scalar _HROsec = .76

postutil clear
postfile WS pr uci lci WoverS using WS_gamma18May11.dta, replace
forvalues i = 0(.01)1 {
qui gen prg = normal(DH_b13+DH_b8*_avmdia+DH_b9*`i'+DH_b10*_allterror+DH_b11*_aireportsl+DH_b12*_HROsec)
sum prg, meanonly
scalar _pr = r(mean)
_pctile prg, percentiles(5 95)
scalar _uc = r(r2)
scalar _lc = r(r1)
post WS (_pr) (_uc) (_lc) (`i')
drop prg
}
postclose WS

scalar _avmdia = 0
scalar _WoverS = .69
scalar _allterror = 3
scalar _aireportsl = 3

postutil clear
postfile HROs pr uci lci logHROsec using HROs_gamma18May11.dta, replace
forvalues i = 0(.01)4.27 {
qui gen prg = normal(DH_b13+DH_b8*_avmdia+DH_b9*_WoverS+DH_b10*_allterror+DH_b11*_aireportsl+DH_b12*`i')
sum prg, meanonly
scalar _pr = r(mean)
_pctile prg, percentiles(5 95)
scalar _uc = r(r2)
scalar _lc = r(r1)
post HROs (_pr) (_uc) (_lc) (`i')
drop prg
}
postclose HROs

use media_gamma18May11.dta, clear
twoway (line pr avmdia, lpattern(solid)) (line lci avmdia, lpattern(dash)) (line uci avmdia, lpattern(dash)), ytitle(Pr(No Exaggeration)) xtitle(Media Reports) xlabel(0[5]25) legend(off) sch(s2mono) 
graph save media_pr, replace
graph export media.png, replace

use WS_gamma18May11.dta, clear
twoway (line pr WoverS, lpattern(solid)) (line lci WoverS, lpattern(dash)) (line uci WoverS, lpattern(dash)), ytitle(Pr(No Exaggeration)) xtitle(W/S Ratio) xlabel(0[.1]1) legend(off) sch(s2mono)
graph save WS_pr, replace
graph export WS.png, replace

use HROs_gamma18May11.dta, clear
twoway (line pr logHROsec, lpattern(solid)) (line lci logHROsec, lpattern(dash)) (line uci logHROsec, lpattern(dash)), ytitle(Pr(No Exaggeration)) xtitle(ln(HR NGOs)) xlabel(0[.5]4.27) legend(off) sch(s2mono)
graph save HROs_pr, replace
graph export HROs.png, replace

graph combine media_pr.gph WS_pr.gph HROs_pr.gph, r(1) ycommon
