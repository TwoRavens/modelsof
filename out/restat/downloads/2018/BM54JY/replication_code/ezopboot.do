
global runname m
global resname m
global nquantiles 20

set more off
set seed 1
set matsize 5000

do ezopprogs
est drop _all
global bootfile results/eop_bootfile_${runname}
use 	* if wy0609 <= 5000000 ///
	using data/sample, clear /// NB: data not available. Please see README
	
cap log close
log using ${runname}, replace

gen s = !phasein
keep if s
gen fameduc = max(far_aarutd16,mor_aarutd16)
egen fameducmean = rowmean(far_aarutd16 mor_aarutd16)
tab fameduc
qui su fameduc, d
gen educh = (fameduc > r(p50)) if fameduc != .
xtile famgroup = faminc_bhmean, n(10)
egen ezop = group(famgroup educh)
gen pt = post*treat
gen educh_t = educh * treat
gen educh_p = educh * post
gen pt_educh = educh * pt
forval p = 1/4 {
    if `p' == 1 gen faminc`p' = faminc_bhmean
    else gen faminc`p' = faminc_bhmean*faminc`=`p'-1'
    gen faminc`p'_t = faminc`p' * treat
    gen faminc`p'_p = faminc`p' * post
    gen pt_faminc`p' = faminc`p' * pt
    gen faminc`p'_educh = faminc`p' * educh
    gen faminc`p'_t_educh = faminc`p'_t * educh
    gen faminc`p'_p_educh = faminc`p'_p * educh
    gen pt_faminc`p'_educh = pt_faminc`p' * educh
}
pctilebyvar wy0609 , n(${nquantiles}) by(ezop) addmean(faminc1 educh)
preserve
	pctile cdf_faminc = faminc1, n(100) genp(cdf_F)
	pctile cdf_faminc_p1t1 = faminc1 if pt ==1, n(100)
	pctile cdf_wy0609 = wy0609, n(100)
	pctile cdf_wy0609_p1t1 = wy0609 if pt ==1, n(100)
	keep if group != . | _n < 100
	keep ptile p group faminc1mean educhmean cdf_*
	save ${bootfile}_desc, replace
restore
replace ptile = floor(ptile)
replace ptile = 0 if ptile > 0 & ptile < 1
mkmat ptile p group faminc1mean educhmean , mat(steps) nomissing
keep wy0609 post treat pt *faminc? *educh educh_? faminc?_? faminc?_?_educh born1968 born1969 born1973-born1976 ezop* s ccov36
tempfile file
save `file'
mata: st_numscalar("_bw",_optbw("wy0609","s"))
forval k = 1/20 {
	gen ss = s & ezop == `k'
	mata: st_numscalar("_bw`k'",_optbw("wy0609","ss"))
	drop ss
}
qui forval bsrep = 0/`bsstop' {
	if `bsrep' > 0 noi mysimdots `bsrep' 50
	u `file', clear
	if `bsrep' > 0 bsample, 
	svmat steps, name(col)
	rename ptile steps
	kdensityfast wy0609 if s , at(steps) gen(${resname}pdf) bw(`=_bw') cdf
	forval k = 1/20 {
	    kdensityfast wy0609 if s & ezop == `k' , at(steps) gen(${resname}pdf`k') bw(`=_bw`k'') cdf
 	    pctile cdf_wy0609_g`k' = wy0609 if s & ezop == `k', n(${nquantiles})
	    pctile cdf_wy0609_p1t1_g`k' = wy0609 if s & ezop == `k' & pt ==1, n(${nquantiles})
	}
	invqtenew wy0609 pt pt_faminc1 pt_faminc2 pt_faminc3 pt_faminc4 pt_*educh if s, ///
		controls(treat educh* faminc1* faminc2* faminc3* faminc4* born*) /// 
		at(steps) name(${resname})
	// Save bootstrap estimates
	keep if steps != .
	gen repl = `bsrep'  // gen replication no.
	keep repl steps p group *${resname}* cdf_* faminc1mean educhmean	// keep estimates
	if `bsrep' > 0 append using ${bootfile}_rep
	save ${bootfile}_rep, replace	// save file of bootstrap estimates
}

log close
