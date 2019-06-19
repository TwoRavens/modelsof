clear all
set matsize 800

cap program drop expy
mata:
	void expy(string scalar dresp, scalar sy)
	{
		y = st_data(.,"dresp")
		y = y:+rnormal(rows(y),1000,0,sy)
		y = 1:/(1:+exp(-y))
		y = (mean(y'))'
		st_store(.,"dresp",y)
	}
end

cap program drop est_boot
program define est_boot
syntax[, NB(real 1) DZ(real 1) DY(real 1) MGEO(string) MNP(string) MP(string) NAME(string)]

	set obs 1
	gen NB = 0
	save data/boot_`name', replace
	step0, dz(`dz') dy(`dy') mgeo(`mgeo')
	compress
	save data/tableboot_`name', replace
	forv nn = 1/`nb'{
		use data/tableboot_`name', clear
		// the first iteration produces the actual estimates, bootstrap starts at nb=2
		if `nn'>1 bsample
		qui step1, mnp(`mnp') mp(`mp')
		if `nn'==1 qui tab EZ, matrow(MP)
		qui step2
		qui svmat DRF
		keep DRF*
		qui keep if DRF1 ~= .
		rename DRF1 P
		rename DRF2 EY1
		rename DRF3 EY0
		rename DRF4 POUT
		rename DRF5 Pmin
		rename DRF6 Pmax
		qui gen NB = `nn'
		qui append using data/boot_`name'
		sort P NB
		qui save data/boot_`name', replace
		di "iteration "`nn'
	}
end

cap program drop step0
program define step0
syntax[, DZ(real 1) DY(real 1) MGEO(string)]

	use data/inflow, clear

	// treatment status and outcome
	gen trained = (dtdebfor1 < datefin)
	label var trained "trained at least once during the unemp. spell"
	gen dZ = datedeb + `dz'
	gen dY = datedeb + `dy'
	format %d dZ dY
	gen Z = (dtdebfor1 <= dZ) * trained
	gen Y = (datefin < dY)
	
	// occupation dummies, taking executive as the reference
	drop if occup == "RIEN" | occup == "Z"
	qui tab occup, gen(occ_id)
	drop occ_id2
	
	// region dummies, taking Ile de France as the reference
	drop if regionU == "aquitaine" | regionU == "limousin"
	qui tab regionU, gen(reg_id)
	drop reg_id13
	
	// define geographical zone for markets
	sort dep occup y_id2004
	merge m:1 dep occup y_id2004 using data/uv
	keep if _merge==3
	drop _merge
	rename u_`mgeo' u
	rename v_`mgeo' v
	rename th_`mgeo' Eth
	gen mgeo = `mgeo'
	drop zone u_* v_* th_*
end

cap program drop step1
program define step1
syntax[, MNP(string) MP(string)]

	bys mgeo occup y_id*: gen pop = _N

	// drop markets with strictly less than two treated or two non treated individual
	bys mgeo occup y0 (Z): drop if Z[1]==Z[_N] | Z[1]~=Z[2] | Z[_N-1]~=Z[_N]
	
	// probability of being treated within each market
	bys mgeo occup y_id*: egen EZ = mean(Z)

	// average individual variables at the market level
	foreach vv of varlist X_* Xh_nus* Xh_duru* Xh_durZ*{
		bys mgeo occup y_id*: egen M`vv' = mean(`vv')
		label var M`vv' "average `vv' at the market level"
	}

	// compute propensity score
	gen pscore = 0
	egen gmnp = group(`mnp')
	su gmnp
	local max_gmnp = r(max)
	foreach mmm of numlist 1(1)`max_gmnp'{
		di `mmm'
		gen ZZ = Z if gmnp == `mmm'
		logit ZZ X* `mp'
		predict ps, p
		replace pscore = ps if gmnp == `mmm'
		drop ZZ ps
	}
	drop gmnp
	count if pscore == 0 | pscore == .

	// support condition
	bys mgeo occup y_id* Z (pscore): gen minps = pscore[1]
	bys mgeo occup y_id* Z (pscore): gen maxps = pscore[_N]
	gen out_supp = 0
	foreach ps of numlist 0 1{
		gen check_ps = (Z == `ps')
		bys mgeo occup y_id* (check_ps): replace out_supp = out_supp + (check_ps == 0) * ((pscore < minps[_N]) + (pscore > maxps[_N]))
		drop check_ps
	}
	tab out_supp Z
	bys Z: su pscore if out_supp == 1, det
	bys Z: tab mgeo occup if out_supp == 1
	drop if out_supp == 1
	drop minps maxps out_supp
	
	// drop markets with strictly less than two treated or two non treated individual (once again, because of supp cond)
	bys mgeo occup y0 (Z): drop if Z[1]==Z[_N] | Z[1]~=Z[2] | Z[_N-1]~=Z[_N]

	// computing the weighted regression estimates (still have to take average per market)
	gen EY1 = .
	gen EY0 = .
	gen wr = sqrt(Z / pscore + (1 - Z) / (1 - pscore))
	egen gm = group(mgeo occup y_id*)
	su gm
	local gm_max = r(max)
	qui foreach mmm of numlist 1(1)`gm_max'{
		noi di `mmm'
		gen ZZ`mmm' = Z if gm == `mmm'
		reg Y ZZ`mmm' X* [w = wr]
		predict pY, xb
		qui replace EY1 = pY + (1 - Z) * _b[ZZ`mmm'] if gm == `mmm'
		qui replace EY0 = pY - Z * _b[ZZ`mmm'] if gm == `mmm'
		drop ZZ`mmm' pY
	}
	drop gm wr datedeb datefin dtdebfor1 dtfinfor1 sortiemp y0 m0 trained dZ dY Z Y pscore
	
	foreach vv of varlist EY1 EY0{
		bys mgeo occup y_id*: egen m`vv' = mean(`vv')
		replace `vv' = m`vv'
		drop m`vv'
	}
	cap drop X*
	bys mgeo occup y_id*: keep if _n == 1
	compress
end

cap program drop step2
program define step2
	
	gen P = EZ
	replace P = . if P == 0
	gen trP = ln(P/(1-P))    // specify P = exp(xb+e)/(1+exp(xb+e)), so that P in [0,1]
	gen TH = Eth
	gen P2 = P^2
	gen TH2 = TH^2
	gen wpop = pop

	drop MX_m2-MX_m12 MX_age2

	gen qual = (occup=="C" | occup=="T")+2*(occup=="I" | occup=="O")
	tab qual, gen(qual_id)
	drop qual_id1

	egen mid = group(regionU qual)

	xtreg trP TH MX_*, i(mid) fe
	predict xb, xbu
	scalar sig = e(rmse)

	gen R = normalden((trP-xb)/sig)/sig
	gen R2 = R^2
	gen PR = P*R

	_pctile P, nq(3)
	local cut1 = r(r1)
	local cut2 = r(r2)

	gen Rq1 = normal((ln(`cut1'/(1-`cut1'))-xb)/sig)
	gen Rq2 = normal((ln(`cut2'/(1-`cut2'))-xb)/sig)-Rq1
	gen Rq3 = 1-normal((ln(`cut2'/(1-`cut2'))-xb)/sig)

	local thresh = .001
	gen ins = (min(Rq1,Rq2,Rq3)>=`thresh')
	qui su ins
	local pout = round(1-r(mean), .001)
	keep if ins==1
	
	su P               // store bounds of P for which support condition is verified 
	gen Pmin = r(min)
	gen Pmax = r(max)
	
	local nstep = rowsof(MP)
	matrix DRF = J(`nstep',3,0), J(`nstep',1,`pout'), J(`nstep',1,r(min)), J(`nstep',1,r(max))

	// predict EY for each observed value of P
	forv zz =0/1{
		gen trEY`zz' = ln(EY`zz'/(1-EY`zz'))
		reg trEY`zz' P P2 R R2 PR
		local sy`zz' = e(rmse)
		matrix eb`zz' = e(b)
	}
	qui forv rp = 1/`nstep'{
		matrix DRF[`rp',1] = MP[`rp',1]
		gen p = MP[`rp',1]
		gen trp = ln(p/(1-p))
		gen p2 = p^2
		gen r = normalden((trp-xb)/sig)/sig
		gen r2 = r^2
		gen pr = p * r
		gen dresp = eb1[1,1] * p + eb1[1,2] * p2 + eb1[1,3] * r + eb1[1,4] * r2 + eb1[1,5] * pr + eb1[1,6]
		mata: expy("dresp",`sy1')
		rename dresp dresp1
		gen dresp = eb0[1,1] * p + eb0[1,2] * p2 + eb0[1,3] * r + eb0[1,4] * r2 + eb0[1,5] * pr + eb0[1,6]
		mata: expy("dresp",`sy0')
		rename dresp dresp0
		su dresp1 [fw = wpop]
		matrix DRF[`rp',2] = r(mean)
		su dresp0 [fw = wpop]
		matrix DRF[`rp',3] = r(mean)
		drop p trp p2 r r2 pr dresp1 dresp0
	}
end

est_boot, nb(500) dz(183) dy(366) mgeo(regionU) mnp(mgeo) mp(occ_* y_*) name(fe)
 
