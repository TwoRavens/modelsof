version 10
clear
capture program drop _all
set memory 350m
capture log close
set more off
log using ${empdecomp}productivity_measures_update, text replace

***27.04.2008**RBal***********************************
* Generate productivity measures, 
* Save new panel: empdecomppanel1_update 
******************************************************

	use ${industri}entrycheck_update.dta, clear
	drop if aar<1990
#delimit ;
	drop btype tilstand psektor kommune offent v16 v17 v18 v19 v20 v21 v22
 v23 v24 v25 v26 v27 v28 v31 v33 v35 v36 v37 v41 v43 v44 v45 v48 v49 v58 v59
 v72 v73 v74 v75 v76 v77 v78 v79 v80 v81 v82 v83 v84 v85 v86 v87 v88 v89 
v90 v91 v92 v93 v94 v95 v96 v97 v98 v99 v100 v101 v102 v103 v110 v113 v112 v120 
 nace sifonorgnr orgnrbed orgnrkon ftype cap cap_inv mentry1 mexit1 kpi;
#delimit cr

	quietly gen isic3=int(naering/100)

* Information on the 3 different capital measures
	des k1 k2 k3
	pwcorr k1 k2 k3, star(1)
	* Mean of different cap measures by year
	table aar, c(m k1 m k2 m k3)
	* Median of different cap measures by year
	table aar, c(med k1 med k2 med k3)
	* # of obs of different cap measures by year
	table aar, c(n k1 n k2 n k3)


* One problem is that the new capital measures based on investment have 
* some negative obs, k2 and k3 have less negative obs, since these have 
* a capital stock value from the NA in their first year
	foreach t in 1 2 3 {
	gen x`t'=1 if k`t'<=0
	replace x`t'=0 if x`t'==.
	bys bnr: egen negk`t'=sum(x`t')
	count if x`t'==1
	}
	egen totneg=rsum(x1 x2 x3)
	count if totneg==3
	tab negk1 negk2 if n==N
	* Drop plants with 5 or more negative k1 obs
	drop if negk1>=4
	tab negk1 negk2 if n==N
* Replace remaining negative k* values to 1
	foreach t in 1 2 3 {
	replace k`t'=1 if k`t'<=0
	}
	drop x1 x2 x3 negk* n N totneg

* Generate other variables for later use
* Total output per year
	quietly bys aar: egen Qtot=sum(Qi)
	label var Qtot "Total manufacturing output per year"
* Total output per sector
	quietly bys aar isic3: egen Q3=sum(Qi)
	label var Q3 "Total 3 digit sector output"
* Sectoral market share
	gen ms3=Q3/Qtot
	label var ms3 "Share of total manuf. output produced in 3 digit sector"
* Plant level industry market share
	gen ms=Qi/Q3
	label var ms "Market share for plant in its 3 digit sector"
	quietly bys aar naering: egen Q5=sum(Qi)
	gen ms5=Qi/Q5
	drop Q5
	label var ms5 "Market share for plant in its 5 digit sector"

* Labour productivity
	gen LP=log(Qidef/Li_h)
	label var LP " log labour productivity"


* Generate factor elasticities=average cost shares per sector 
	foreach t in Li Mi {
		quietly gen s`t'=`t'/Qi
		quietly bys aar isic3: egen x`t'=mean(s`t') if s`t'>0.01 & s`t'<0.95
		quietly bys aar isic3: egen ms`t'=mean(x`t')
		drop x`t'
		sort bnr aar
	}
* Cost share for the k_inv* measures has to be defined with deflated vars.
	foreach t in k1 k2 k3 {
		quietly gen s`t'=`t'/Qidef
		quietly bys aar isic3: egen x`t'=mean(s`t') if s`t'>0.01 & s`t'<0.95
		quietly bys aar isic3: egen ms`t'=mean(x`t')
		drop x`t'
		sort bnr aar
	}


* All the following TFP indices use as capital measures k1 k2 k3
* and the corresponding tfp measures are called tfp1 tfp2 tfp3

* TFP index + CRS-index
	foreach t in 1 2 3 {
		quietly gen tfp`t'=ln(Qidef)-msk`t'*ln(k`t')-msMi*ln(Midef)-msLi*ln(Li_h)
		label var tfp`t' "tfp-index with 3-d m.& tr. cost shares , cap var k`t'"
		* Impose CRS
		quietly gen tfp`t'crs=ln(Qidef)-(1-msMi-msLi)*ln(k`t')-msMi*ln(Midef)-msLi*ln(Li_h)
		label var tfp`t'crs " Same as tfp`t', but imposing CRS"
	}
* TFP index + CRS-index based on employees instead of hours
		replace v13=1 if v13<1 & v13>0
		quietly gen tfp3_emp=ln(Qidef)-msk3*ln(k3)-msMi*ln(Midef)-msLi*ln(v13)
		label var tfp3_emp "tfp-index with 3-d m.& tr. cost shares, k3 and v13"
		* Impose CRS
		quietly gen tfp3crs_emp=ln(Qidef)-(1-msMi-msLi)*ln(k3)-msMi*ln(Midef)-msLi*ln(v13)
		label var tfp3crs_emp " Same as tfp3_emp, but imposing CRS"
	


* Translog multilateral TFP index based on Caves et al 1982
* TFP deviation from geometric mean, with cost shares being
* mean of plant and industry cost share

* Generate average of industry and plant level costshares
	foreach t in sk1 sk2 sk3 sLi sMi {
		quietly egen av`t'=rmean(`t' m`t')
	}
	
* Gen geometric mean of K L M and Q per sector
	quietly bys aar isic3: egen lnQdef=mean(ln(Qidef))
	foreach t in k1 k2 k3 Li_h Midef {
		quietly bys aar isic3: egen ln`t'=mean(ln(`t'))
	}
* Gen median of K L M and Q per sector
	quietly bys aar isic3: egen Qmed=median(ln(Qidef))
	foreach t in k1 k2 k3 Li_h Midef {
		quietly bys aar isic3: egen `t'med=median(ln(`t'))
	}


*Construct tfp index with geometric mean and median as reference point. 
	foreach t in 1 2 3 {
		* mean as ref point
		quietly gen tfp`t'_rel=ln(Qidef)-lnQdef-avsk`t'*(ln(k`t')-lnk`t')-avsLi*(ln(Li_h)-lnLi_h)-avsMi*(ln(Midef)-lnMidef)	
		label var tfp`t'_rel "tfp ind. geom mean as ref point, k`t'" 
		* median as ref point
		quietly gen tfp`t'_rel50=ln(Qidef)-Qmed-avsk`t'*(ln(k`t')-k`t'med)-avsLi*(ln(Li_h)-Li_hmed)-avsMi*(ln(Midef)-Midefmed)	
		label var tfp`t'_rel50 "tfp ind. median as ref point, k`t'" 
		* mean as ref point, impose CRS
		quietly gen tfp`t'_relcrs=ln(Qidef)-lnQdef-(1-avsLi-avsMi)*(ln(k`t')-lnk`t')-avsLi*(ln(Li_h)-lnLi_h)-avsMi*(ln(Midef)-lnMidef)	
		label var tfp`t'_relcrs "CRS-tfp ind. geom mean as ref point, k`t'" 
	}
	quietly drop lnQdef lnk* lnLi_h lnMidef *med
	sort bnr aar

*********
* one plant observed all years
drop if naering==35300

* TFP measures based on harrigan smoothing procedure CRS
* Used in paper by Redding and Simpson and ?

* Harrigan smoothing procedure for cost shares
* Factor use relative to capital use, note should use deflated values
	foreach t in k1 k2 k3 {
		quietly gen m`t'=ln(Midef/`t')
		quietly gen w`t'=ln(Li/`t')
	}
* Factor cost shares
	quietly gen alpha_m=Mi/Qi
	quietly gen alpha_w=Li/Qi
	sort bnr aar
	save ${prosjekt}temp1.dta, replace

program define harrigan
* Estimate the smoothed value of the share of 
* factor z in output (Assumes translog, CRS and market clearing
* ie no markup/no imperfect comp)at 3 digit level 
	use using ${prosjekt}temp1.dta if isic3==311, clear
	quietly xtreg alpha_m m`1' w`1', fe
	quietly predict m311, xb
	quietly xtreg alpha_w m`1' w`1', fe
	quietly predict w311, xb
	keep bnr aar isic3 m311 w311
	quietly save ${prosjekt}temp3.dta, replace
	#delimit ;
	foreach t in 312 313 314 321 322 323 324 331 332 
	341 342 351 352 354 355 356 361 362 369 371 372 
	381 382 383 384 385 390 {;
			use using ${prosjekt}temp1.dta if isic3==`t', clear;
			quietly xtreg alpha_m m`1' w`1', fe;
			quietly predict m`t', xb;
			quietly xtreg alpha_w m`1' w`1', fe;
			quietly predict w`t', xb;
			keep bnr aar isic3 m`t' w`t';
			quietly append using ${prosjekt}temp3.dta;
			quietly save ${prosjekt}temp3, replace;
	};
	use ${prosjekt}temp3.dta, clear;
	quietly gen alpha_mhat=m311;
	quietly gen alpha_what=w311;
	foreach t in 312 313 314 321 322 323 324 331 332
	 341 342 351 352 354 355 356 361 362 369 371 372
	 381 382 383 384 385 390 {;
		quietly replace alpha_mhat=m`t' if isic3==`t';
		quietly replace alpha_what=w`t' if isic3==`t';
	};
	sort bnr aar; 
	keep bnr aar isic3 alpha_mhat alpha_what;
	sort bnr aar;
	#delimit cr
* Generate 3 digit mean of estimated factor shares in output
	quietly bys aar isic3: egen mhat=mean(alpha_mhat)
	quietly bys aar isic3: egen what=mean(alpha_what)
	keep bnr aar isic3 mhat what
	rename mhat mhat`1'
	rename what what`1'
	label var mhat`1' "3 digit mean of estimated material sh in output, Harrig. proc, `1'"
	label var what`1' "3 digit mean of estimated labour sh in output, Harrig. proc, `1'"
	sort bnr aar
	quietly save ${prosjekt}temp3, replace

* Merge the costshares back to the rest of data
	use ${prosjekt}temp1.dta, clear
	merge bnr aar using ${prosjekt}temp3.dta
	assert _merge==3
	quietly drop _merge
	sort bnr aar
* Generate an index for TFP, imposing CRS
	quietly gen tfp_harr`1'=ln(Qidef)-(1-mhat`1'-what`1')*ln(`1')-what`1'*ln(Li_h)-mhat`1'*ln(Midef)
	label var tfp_harr`1' "CRS TFP with 3-d mean of estimated smoothed cost shares, `1'"
	quietly gen tfp_harr`1'_emp=ln(Qidef)-(1-mhat`1'-what`1')*ln(`1')-what`1'*ln(v13)-mhat`1'*ln(Midef)
	label var tfp_harr`1'_emp "CRS TFP with 3-d mean of estimated smoothed cost shares, `1' v13"

	quietly save ${prosjekt}temp1.dta, replace
end

* Run programme
	harrigan k1
	harrigan k2
	harrigan k3

* Save new panel with productivity measures
	drop avs* mk* wk* alpha* mhat* what*  
	compress
drop sLi msLi sMi msMi sk1 msk1 sk2 msk2 sk3 msk3  	
sort bnr aar

	save ${industri}empdecomppanel1_update.dta, replace
	erase ${prosjekt}temp3.dta
	erase ${prosjekt}temp1.dta


capture log close
exit
