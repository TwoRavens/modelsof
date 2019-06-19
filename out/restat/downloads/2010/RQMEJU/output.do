*** This file creates summary statistics for datachecks.xls *****
clear all
mac drop _all
set mem 600m
set matsize 5000
set linesize 255
set more off

/*cd C:\research\mp_india_restat\replication\*/

** the code needs the following Stata function ***
cap ssc install egenmore

cap log close
log using restat.log,replace



***** NOTE: FIRM ENTRY/EXIT YEARS NEEDED FOR DECOMPOSITION AND ACTIVITY TABLES ********
	**** Firm entry/exit years **** 
		qui forval i=0/4 {
		use restat_sumstats,clear
			collapse (mean) s190 (sum) sv, by(year fid)
						#d ;
							if `i'==0 {;keep if year>1;};
							if `i'==1 {;keep if year==1989 | year==1992 | year==1995 | year==1998 | year==2001 | year==2003;};
							if `i'==2 {;keep if year==1989 | year==1994 | year==1999 | year==2003;};
							if `i'==3 {;keep if year==1989 | year==2003;};
							if `i'==4 {;keep if year==1989 | year==1990 | year==2001;};
						#d cr
				tab year
				egen year2=group(year)
				drop s190
				tsset fid year2
				sort fid year2
					g tmp1=l.year2
					g entry = tmp1==.
				g entry_yr = entry*year
					drop if entry_yr==0
					keep fid entry_yr
					bys fid : g c=_n
					reshape wide entry_yr, i(fid) j(c)
					sort fid
				saveold fentry_tmp`i',replace
		use restat_sumstats,clear
			collapse (mean) s190 (sum) sv, by(year fid)
						#d ;
							if `i'==0 {;keep if year>1;};
							if `i'==1 {;keep if year==1989 | year==1992 | year==1995 | year==1998 | year==2001 | year==2003;};
							if `i'==2 {;keep if year==1989 | year==1994 | year==1999 | year==2003;};
							if `i'==3 {;keep if year==1989 | year==2003;};
							if `i'==4 {;keep if year==1989 | year==1990 | year==2001;};
						#d cr
				egen year2=group(year)
				drop s190
				tsset fid year2
				sort fid year2
					g tmp1=f.year2
					g exit = tmp1==.
				g exit_yr = exit*year
					drop if exit_yr==0
					keep fid exit_yr
					bys fid: g c=_n
					reshape wide exit_yr, i(fid) j(c)
					sort fid
				saveold fexit_tmp`i',replace
				sort fid
				merge fid using fentry_tmp`i'
					drop _m
				sort fid
				saveold fid_tmp`i',replace
					erase fentry_tmp`i'.dta
					erase fexit_tmp`i'.dta
			}

****************** TABLE 1 ****************** 
noisily dis ["*** TABLE 1 (PREVALENCE OF SINGLE- AND MULTIPLE-PRODUCT FIRMS)"]
	use restat_sumstats,clear
			bys fid year: egen n_yr = nvals(pcode3)
			egen npnic2_yr = nvals(pnic2), by(fid year)
			egen npnic4_yr = nvals(pnic4), by(fid year)
				bys pnic2: egen noprod = nvals(pcode3)
			collapse (mean) nic2 nic4 s190 s191 n_yr npnic*_yr (sum) sv, by(fid year) fast
			noisily dis ["******* TABLE 1 *************"]
				g mpf = n_yr~=1
				g mpf_n2 = npnic2_yr~=1
				g mpf_n4 = npnic4_yr~=1

				noisily dis ["*** MPFs/MIFs/MSFs ***"]
				noisily tabstat mpf mpf_n4 mpf_n2 
				noisily dis ["*** average products ***"]
				noisily sum n_yr
				noisily dis ["*** average products per MPFs***"]
				noisily sum n_yr if mpf==1
				noisily dis ["*** total output ***"]
				noisily tabstat s190, s(sum)
				noisily dis ["*** total output of MPFs***"]
				noisily tabstat s190 if mpf==1, s(sum)
				noisily dis ["*** total output of multiple-industry firms***"]
				noisily tabstat s190 if mpf_n4==1, s(sum)
				noisily dis ["*** total output of multiple-sector firms***"]
				noisily tabstat s190 if mpf_n2==1, s(sum)
				noisily dis ["*** average industries per multiple-industry firm***"]
				noisily sum npnic4_yr if mpf==1
				noisily dis ["*** average sectors per multiple-sector firm***"]
				noisily sum npnic2_yr if mpf==1

****************** TABLE 2 ****************** 
noisily dis ["*** TABLE 2 CHARACTERISTICS OF MP FIRMS *****"]
use restat_sumstats,clear
	bys fid year: egen n_yr = nvals(pcode3)
	bys fid year: egen n2_yr = nvals(pnic2)
	bys fid year: egen n4_yr = nvals(pnic4)
					foreach v of var * {
						local l`v' : variable label `v'
							if `"`l`v''"' == "" {
							local l`v' "`v'"
							}
					}
	collapse (mean) tfp1000 n2_yr n4_yr s190 s173 nic4 n_yr (sum) sv, by(fid year)
					foreach v of var * {
						label var `v' "`l`v''"
						}
				g export = s173 > 0
					replace export = . if s173 == .
				foreach v of varlist s190 {
					replace `v' = log(`v')
					}
		g mpf = n_yr~=1
		g mpf_nic2 = n2_yr~=1
		g mpf_nic4 = n4_yr~=1
		egen nic4_yr = group(nic4 year)

		foreach j of varlist mpf mpf_nic4 mpf_nic2 {
			qui foreach v of varlist s190 export tfp100  {
				areg `v' `j' if year==2000, a(nic4) cluster(fid)
					est store xs_`v'
				}
			noisily estout xs_*, cells(b(fmt(%9.3f)) se(fmt(%9.3f))) style(fixed) stats(N, fmt(%15.3f)) keep(`j')
			est clear
		}

****************** TABLE 3 ****************** 
noisily dis ["*** TABLE 3: DISTRIBUTION OF PRODUCTS WITHIN THE FIRM ***"]
	use restat_sumstats,clear
	foreach v of varlist pcode3 {
	use restat_sumstats,clear
			collapse (sum) sv, by(fid pcode3) fast
			drop if sv==0
			drop if pcode3==.
			bys fid: egen totsv = sum(sv)
				g shv = sv/totsv
					drop sv totsv
				gsort fid - shv
			by fid: g n = _n
			replace n = 10 if n>=10
			collapse (sum) shv, by(fid n)
			by fid: g N = _N
			collapse (mean) shv, by(N n) fast
				replace shv = shv*100
			reshape wide shv, i(N) j(n)
			xpose, clear
				foreach j of varlist _all {
					format `j' %9.0f
					}
				drop in 1
	}
	noisily list

****************** TABLE 4 ****************** 
noisily dis ["*** TABLE 4 FIRM ACTIVITY  *****"]
		forval i=3(-1)0 {
			qui {
				use restat_sumstats,clear
					sort fid 
					local k = "pcode3"
					bys fid year: egen n_yr = nvals(`k')
					collapse (sum) sv (mean) nic4 n_yr , by(year fid `k')
					drop if `k'==.
					egen id = group(fid `k')
							#d ;
								if `i'==0 {;local r="ANNUAL";keep if year>1;};
								if `i'==1 {;local r="3-YEAR";keep if year==1989 | year==1992 | year==1995 | year==1998 | year==2001 | year==2003;};
								if `i'==2 {;local r="5-YEAR";keep if year==1989 | year==1994 | year==1999 | year==2003;};
								if `i'==3 {;local r="OVERALL";keep if year==1989 | year==2003;};
							#d cr
						egen year2=group(year)
							tsset id year2
							sort id year2
								g tmp = l.year2
							g add = tmp==.
								g tmp2 = f.year2
							g drop = tmp2==.
								drop tmp tmp2
						*** Make add/drop missing if years of firm entry/exit ***
						sort fid
						merge fid using fid_tmp`i'
							keep if _m==3
							drop _m
								foreach v of varlist entry_* {
									g t0`v' = year==`v'
									}
								foreach v of varlist exit_* {
									g t1`v' = year==`v'
									}
									egen f_entry= rsum(t0*)
									egen f_exit= rsum(t1*)
								drop t0* t1*
								drop entry_* exit_*
							replace add = . if f_entry==1
								replace drop = . if f_exit==1
								drop f_entry f_exit
						** collect share of added/dropped output **
							bys fid year: egen sv_add=sum(sv) if add==1
							bys fid year: egen sv_drop=sum(sv) if drop==1
								foreach j of var * {
									local l`j' : variable label `j'
										if `"`l`j''"' == "" {
										local l`j' "`j'"
										}
									}
							collapse (max) add drop (mean) n_yr (sum) sv (mean) sv_add sv_drop, by(fid year year2)
										foreach j of var * {
											label var `j' "`l`j''"
											}
								sort fid year2
								tsset fid year2
								g l_nyr=l.n_yr
								g drop2 = l.drop
							replace sv_add = sv_add/sv
							replace sv_drop = sv_drop/sv
							g type = .
								replace type = 1 if add==0 & drop==0
								replace type = 2 if add==1 & drop==0
								replace type = 3 if add==0 & drop==1
								replace type = 4 if add==1 & drop==1
							g type2 = .
								replace type2 = 1 if add==0 & drop2==0
								replace type2 = 2 if add==1 & drop2==0
								replace type2 = 3 if add==0 & drop2==1
								replace type2 = 4 if add==1 & drop2==1
				}
					noisily dis ["************ `r' ********* "]
					** note: type2 defines add/drop as BRS (2006a) **
						noisily tab type2
						noisily tab type2 if l_nyr==1
						noisily tab type2 if l_nyr~=1
						noisily dis ["**** "]
						noisily tab type2 [aw=sv]
						noisily tab type2 [aw=sv] if l_nyr==1
						noisily tab type2 [aw=sv] if l_nyr~=1
			}

****************** TABLE 5 ****************** 
noisily dis ["*** TABLE 5 -- DECOMPOSITION TABLE ***"]
noisily dis ["NOTE: BECAUSE PROWESS IS NOT APPROPRIATE FOR A STUDY OF FIRM EXIT AND ENTRY, WE REPORT THE DECOMPOSITION FOR CONTINUING FIRMS, AND THEREFORE DO NOT REPORT FIRM EXTENSIVE MARGINS: fnet, fp_1, fp_2. Reported gross sales in Table 5 are the sum of pnet and inet"]
	forval u=0/4 {
		* aggregate changes *
	qui {
		use restat_sumstats,clear
			if `u'>0 & `u'<4 {
					local j1 = 1989+5*(`u'-1)
					local j2 = `j1'+4
					keep if year==`j1'|year==`j2'
				}						
			if `u'==4 {
				keep if year==1989|year==2003
				}
			dis `d'
			egen year2 = group(year)
				drop year
				rename year2 year
			collapse (sum) sv (mean) s190, by(fid pcode3 year)
			sort fid 
			collapse (mean) s190 (sum) sv, by(fid year) fast
			collapse (sum) s190 sv, by(year) fast
				sort year
				saveold decomp_tmp0,replace
		* firm entry/exit *
		use restat_sumstats,clear
			if `u'>0 & `u'<4 {
					local j1 = 1989+5*(`u'-1)
					local j2 = `j1'+4
					keep if year==`j1'|year==`j2'
					}
			if `u'==4 {
				keep if year==1989|year==2003
				}
			egen year2 = group(year)
				drop year
				rename year2 year
			collapse (sum) sv, by(fid pcode3 year)
			sort fid 
			collapse (sum) sv, by(fid year)
			fillin fid year
			tsset fid year
				replace sv = 0 if _fillin==1
			sort fid year
			g dy = d.sv
			bys fid: egen minyr_tmp = min(year) if _fillin==0
			bys fid: egen minyr = max(minyr)
			bys fid: egen maxyr_tmp = max(year) if _fillin==0
				replace maxyr_tmp = maxyr_tmp + 1
				bys fid: egen maxyr = max(maxyr_tmp)
				g firmtype=.
				qui replace firmtype = 1 if dy>0 & sv[_n-1]==0 & dy~=.
				qui replace firmtype = 2 if dy<0 & sv==0 & _fillin==1
				qui replace firmtype = 3 if year>minyr & year < maxyr & firmtype==.
				qui replace firmtype = 1 if dy==. & year==minyr
				qui replace dy = sv if dy==.
				drop if firmtype==.
			collapse (sum) sv dy, by(firmtype year)
				qui reshape wide sv dy, i(year) j(firmty)
				keep year dy*
				forval i=1/3 {
					cap rename dy`i' f`i'
					}
				sort year
				saveold decomp_tmp1,replace
		* extensive/intensive margin *
		use restat_sumstats,clear
			if `u'>0 & `u'<4 {
					local j1 = 1989+5*(`u'-1)
					local j2 = `j1'+4
					keep if year==`j1'|year==`j2'
					}
			if `u'==4 {
				keep if year==1989|year==2003
				}
			egen year2 = group(year)
				drop year
				rename year2 year
			collapse (sum) sv, by(fid pcode3 year)
			sort fid 
			qui collapse (sum) sv, by(year fid pcode3)
			egen id = group(fid pcode3)
				keep pcode3 id year sv
				qui fillin id year
			qui tsset id year
				replace sv = 0 if _fillin==1
			g dy = d.sv
			bys id: egen minyr_tmp = min(year) if _fillin==0
			bys id: egen minyr = max(minyr)
			bys id: egen maxyr_tmp = max(year) if _fillin==0
				replace maxyr_tmp = maxyr_tmp + 1
				bys id: egen maxyr = max(maxyr_tmp)
				g ptype=.
				replace ptype = 1 if dy>=0 & sv[_n-1]==0 & dy~=. & _fillin==0
					by id: g tmp=d.pty
					replace ptype=. if tmp==0
				replace ptype = 2 if dy<0 & sv==0 & _fillin==1
				replace ptype = 3 if year>minyr & year < maxyr & ptype==.
				replace ptype = 1 if dy==. & year==minyr
				replace dy = sv if dy==.
				replace ptype = 1 if year==minyr & ptype==.
				drop if ptype ==.
			*** extensive margin changes ***
			preserve
				collapse (sum) sv dy, by(ptype year)
					qui reshape wide sv dy, i(year) j(ptype)
					order year sv* dy*
					keep year dy*
					qui forval i=1/3 {
						cap rename dy`i' p`i'
						}
					sort year
					saveold decomp_tmp2,replace
			restore
			*** intensive margin (shrinking/growing) ***
				g intensive = dy>0
					qui collapse (sum) dy sv, by(intensive year)
					qui reshape wide dy sv, i(year) j(intensive)
					order year sv* dy*
					keep year dy*
					rename dy1 i1
					rename dy0 i0
					order year i1 i0
					sort year
					qui saveold decomp_tmp3,replace
			*** assemble and printout decomp table ***
			use decomp_tmp0,clear
				erase decomp_tmp0.dta
				qui forval i=1/3 {
					sort year
					merge year using decomp_tmp`i'
						drop _m
						erase decomp_tmp`i'.dta
					}
				tsset year
				sort year
				cap g f2=0
				cap g p2=0
				replace f1 = 0 if f1==.
				replace f3 = 0 if f3==.
				qui forval i=1/3 {
					g fp_`i' = f`i'/l.sv
					g pp_`i' = (p`i'-f`i')/l.sv
					}
					replace pp_3 = p3/l.sv
					g ip_0 = (i0-p2)/l.sv
					g ip_1 = (i1-p1)/l.sv
					g pout = d.sv/l.sv
					local vlist = "f1 f2 f3 p1 p2 p3 i0 i1 i10 i11 i00 i01 s191 sv sv00 sv10 sv01 sv11 fp_3"
					foreach v of local vlist {
						cap drop `v'
						}
					g fnet = fp_1+fp_2
					g pnet = pp_1+pp_2
					g inet = ip_0+ip_1
						drop pp_3
					foreach v of varlist pout fnet fp_1 fp_2 pnet pp_1 pp_2 inet ip_0 ip_1 {
						replace `v' = `v' * 100
						}
					order year pout fnet fp_1 fp_2 pnet pp_1 pp_2 inet ip_1 ip_0  
		}
					noisily dis ["***** Decomposition: `u' *****"]
					noisily tabstat pout fnet fp_1 fp_2 pnet pp_1 pp_2 inet ip_1 ip_0, by(year) f(%9.2f) labelwidth(8) varwidth(8) not nosep
					noisily dis ["**********************************"]
				}


****************** TABLE 6 ****************** 
	*** TABLE 6 REGRESSIONS ***
	use restat_regressions,clear
		qui {
				xi: areg n_yr f_ltf i.year if y97==1, a(fid) cluster(nic4)
					est store f_ltf
				xi: areg n_yr f_ltf i.nic2yr if y97==1, a(fid) cluster(nic4)
					est store f_ltf_n2
				xi: areg n_yr i.post91*i.avg_tf if y97==1, a(fid) cluster(nic4)
					est store dif
				xi: areg add f_ltf i.year if y97==1, a(fid) cluster(nic4)
					est store add
				xi: areg drop2 f_ltf i.year if y97==1, a(fid) cluster(nic4)
					est store drop
				xi: areg n_yr p_wgh_ltf i.year if y97==1, a(fid) cluster(nic4)
					est store firm_tf
				xi: areg drop2 f_low_ltf i.year if y97==1, a(fid) cluster(nic4)
					est store small
				xi: areg n_yr f_ltf ldli_a i.year if y97==1, a(fid) cluster(nic4)
					est store deli
				xi: areg n_yr i.dli_a88*f_ltf i.year if y97==1, a(fid) cluster(nic4)
					est store deli88
				}
		*** Test of NTBS (COLUMN 3 OF RESTAT TABLE 6)****
		use restat_regressions,clear
			g f_tf97_tmp = f_tf if year==1997
				bys nic4: egen f_tf97 = max(f_tf97_tmp)
			keep if year==1990|year==2001
				replace f_ltf = .
					replace f_ltf=f_tf if year==1990
					replace f_ltf=f_tf97 if year==2001
			egen nic4_yr = group(nic4 year)
			qui xi: areg n_yr f_ltf i.year, a(fid) cluster(nic4_yr)
				est store n_yrNTB

		noisily dis ["**** OUTPUT TABLE 6 *****"]
				noisily estout f_ltf f_ltf_n2 n_yrNTB dif, cells(b(fmt(%9.3f)) se(fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0g)) drop(_Iy* _Ipost91_1 _Iav* _In* _cons) style(tab) append varwidth(8) modelwidth(8) 
				noisily estout add drop firm_tf small deli deli88, cells(b(fmt(%9.3f)) se(fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0g)) drop(_Iy* _Idli_a8* _cons) style(tab) append varwidth(8) modelwidth(8) 
				est clear
cap log close

	*** erase tmp files ***
	local flist = "fid_tmp0 fid_tmp1 fid_tmp2 fid_tmp3 fid_tmp4"
	foreach f of local flist {
		cap erase `f'.dta
		}

