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

cd "C:\Users\Danny\Documents\ZIOP\substantive\merged"

local data = "predicted19may.dta" //
use `data', clear

set seed 666
set more off
local beta WoverS lngdp lnpop allterror cat logHROsec
local gamma avmdia WoverS allterror aireportsl logHROsec

	ml model lf myoproba (beta: tort = `beta') (cut2:), cluster(COWccode)
	qui ml maximize, difficult
	matrix eb = e(b)

	ml model lf ziopa (beta: tort = `beta') (gamma: tort = `gamma') (cut2:), cluster(COWccode)
	ml init eb, skip
	qui ml maximize, difficult
	matrix eb = e(b)

	ml model lf ziopb (beta: tort = `beta') (gamma: tort = `gamma') (cut2:) (rho:), cluster(COWccode) 
	ml init eb, skip
	ml maximize, difficult

drawnorm _b1-_b15, n(1000) means(e(b)) cov(e(V)) clear //
tempfile sim_betas
save `sim_betas'
sum _b*

tempname memhold
tempfile results

postfile `memhold' n pr_out0 lci_out0 uci_out0 pr_out1 lci_out1 uci_out1 pr_out2 lci_out2 uci_out2 pr_inf lci_inf uci_inf using `results'

	local N = _N
	forvalues n = 1(1)`N' {
		use `data', clear

		** (C) Pull x values from observation i.
			scalar _WS = WoverS[`n'] //
			scalar _lngdp = lngdp[`n'] //
			scalar _lnpop = lnpop[`n'] //
			scalar _allterror = allterror[`n']
			scalar _cat = cat_rat[`n']
			scalar _logHROsec = logHROsec[`n']
			scalar _avmdia = avmdia[`n']
			scalar _aireportsl = aireportsl[`n']

			use `sim_betas', clear

		** (C) Calculate predicted probabilities.
			qui gen xb = _b1*_WS+_b2*_lngdp+_b3*_lnpop+_b4*_allterror+_b5*_cat+_b6*_logHROsec+_b7
			qui gen zg = _b8*_avmdia+_b9*_WS+_b10*_allterror+_b11*_aireportsl+_b12*_logHROsec+_b13
			qui gen pr_out0 = normal(-xb) 
			qui gen pr_out1 = normal(_b14-xb)-normal(-xb)
			qui gen pr_out2 = 1-normal(_b14-xb)			
			qui gen pr_inf = normal(zg) //
	
		** Get mean predicted probability and confidence intervals
		** for observation i.
			qui sum pr_out0, meanonly
			scalar pr_out0 = r(mean)
			_pctile pr_out0, p(5 95)
			scalar lci_out0 = r(r1)
			scalar uci_out0 = r(r2)

			qui sum pr_out1, meanonly
			scalar pr_out1 = r(mean)
			_pctile pr_out1, p(5 95)
			scalar lci_out1 = r(r1)
			scalar uci_out1 = r(r2)

			qui sum pr_out2, meanonly
			scalar pr_out2 = r(mean)
			_pctile pr_out2, p(5 95)
			scalar lci_out2 = r(r1)
			scalar uci_out2 = r(r2)

			qui sum pr_inf, meanonly
			scalar pr_inf = r(mean)
			_pctile pr_inf, p(5 95)
			scalar lci_inf = r(r1)
			scalar uci_inf = r(r2)

		drop pr_out0 pr_out1 pr_out2 pr_inf
		post `memhold' (`n') ///
			(scalar(pr_out0)) (scalar(lci_out0)) (scalar(uci_out0)) ///
			(scalar(pr_out1)) (scalar(lci_out1)) (scalar(uci_out1)) ///
			(scalar(pr_out2)) (scalar(lci_out2)) (scalar(uci_out2)) ///
			(scalar(pr_inf)) (scalar(lci_inf)) (scalar(uci_inf))
		}

	postclose `memhold'

** Merge the results back into the (master) data.
	use `data', clear
	gen n = _n
	merge n using `results', uniq sort
	drop n
	drop if _m == 2

log using predictions19may.log, replace
	
	sum pr_inf
	sum pr_out0
	sum pr_out1
	sum pr_out2

	gen r1 = pr_inf >= .5 
	tab r1	

	gen out0 = pr_out0 > pr_out1 & pr_out0 > pr_out2 
	gen out1 = pr_out1 > pr_out0 & pr_out1 > pr_out2 
	gen out2 = pr_out2 > pr_out0 & pr_out2 > pr_out1 
	gen out = out1 == 1 
	replace out = 2 if out2 == 1 	
	tab out r1

	gen r1l = lci_inf >= .5 
	tab r1l	

	gen l0 = lci_out0 > lci_out1 & lci_out0 > lci_out2 
	gen l1 = lci_out1 > lci_out0 & lci_out1 > lci_out2 
	gen l2 = lci_out2 > lci_out0 & lci_out2 > lci_out1 
	gen lout = l1 == 1 
	replace lout = 2 if l2 == 1 	

	gen r1u = uci_inf >= .5 
	tab r1u	

	gen u0 = uci_out0 > uci_out1 & uci_out0 > uci_out2 
	gen u1 = uci_out1 > uci_out0 & uci_out1 > uci_out2 
	gen u2 = uci_out2 > uci_out0 & uci_out2 > uci_out1 
	gen uout = u1 == 1 
	replace uout = 2 if u2 == 1 	

	tab out r1, r
	tab lout r1l, r
	tab uout r1u, r

log close
