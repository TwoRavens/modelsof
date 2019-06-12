cd C:\Users\jcgray\Dropbox\patronage\	
	

sort reo year	
use zombies_2017.dta, clear
keep  reo year lifespan  aut3 compdummy lngdpsum1 pr_integration  age s3un numb_mids_sum   Europe Asia Americas Africa  hardrel life dea zombie compdummy competition desec5f itrans mccall mccallsmith	 desec5f 





	mlogit lifespan  aut3 compdummy lngdpsum1 pr_integration  age s3un numb_mids_sum   Europe Asia Americas Africa, baseoutcome(3) robust cluster(reo)
	estimates store m1

	mlogit lifespan   hardrel compdummy lngdpsum1 pr_integration  age  s3un  numb_mids_sum Europe Asia Americas Africa, baseoutcome(3) robust cluster(reo)
	estimates store m1a
 	margins, at(hardrel=(0/15)) vsquish
	*marginsplot, x(hardrel) recast(line) recastci(rspike)  xtitle("Secretariat City")  ytitle("Vitality")  scheme(s1mono) plotd(,allsimp)
marginsplot, x(hardrel) recast(line) recastci(rspike)  xtitle("Secretariat City")  ytitle("Vitality")  scheme(s1mono) plotd(,label( "Dead" "Zombie" "Life"))
	
	mlogit lifespan  aut3 hardrel compdummy lngdpsum1 pr_integration  age  s3un  numb_mids_sum Europe Asia Americas Africa, baseoutcome(3) robust cluster(reo)
 estimates store m1a1
	
	logit life  aut3 compdummy pr_integration lngdpsum1  age  s3un  numb_mids_sum  Europe Asia Americas Africa, robust cluster(reo)
	estimates store m2
	logit life  hardrel compdummy  pr_integration lngdpsum1  age  s3un numb_mids_sum Europe Asia Americas Africa, robust cluster(reo)
	estimates store m2a	
	logit dea  aut3 compdummy  pr_integration  lngdpsum1 age  s3un numb_mids_sum  Europe Asia Americas Africa, robust cluster(reo)
    estimates store m3
	logit dea hardrel compdummy pr_integration  lngdpsum1 age  s3un  numb_mids_sum  Europe Asia Americas Africa, robust cluster(reo)
	estimates store m3a
	logit zombie  aut3 compdummy pr_integration lngdpsum1   age s3un numb_mids_sum   Europe Asia Americas Africa, robust cluster(reo)
	estimates store m4
	logit zombie  hardrel compdummy  pr_integration lngdpsum1   age s3un numb_mids_sum  Europe Asia Americas Africa, robust cluster(reo)
	estimates store m4a
 estout m1 m1a m1a1 m2 m2a m3 m3a m4 m4a using z_table1.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex) label replace
 

	
	mlogit lifespan  aut3 compdummy  lngdpsum1  pr_integration  age  s3un  numb_mids_sum , robust cluster(reo) baseoutcome(3)
		estimates store m1b
			mlogit lifespan  hardrel compdummy  lngdpsum1  pr_integration  age  s3un numb_mids_sum ,  robust cluster(reo) baseoutcome(3)
		estimates store m1c
	logit life  aut3 compdummy lngdpsum1  pr_integration  age  s3un numb_mids_sum , robust  cluster(reo)
	estimates store m2c
	logit life hardrel compdummy  lngdpsum1  pr_integration  age  s3un  numb_mids_sum ,  robust cluster(reo)
		estimates store m2d
	logit dea  aut3 compdummy  lngdpsum1  pr_integration  age  s3un numb_mids_sum ,  robust cluster(reo)
		estimates store m3c
	logit dea hardrel compdummy  lngdpsum1  pr_integration  age  s3un numb_mids_sum , robust  cluster(reo)
		estimates store m3d
	logit zombie  aut3 compdummy lngdpsum1  pr_integration age s3un numb_mids_sum ,  robust cluster(reo)	
		estimates store m4c
	logit zombie  hardrel compdummy lngdpsum1  pr_integration age s3un  numb_mids_sum , robust  cluster(reo)	
		estimates store m4d
estout m1b m1c m2c m3c m4c m2d m3d m4d using z_table1appendix.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex)  label replace


		*robustness- alternate operationaliz - legalization	
			mlogit lifespan  aut3 mccall compdummy lngdpsum1   age  s3un numb_mids_sum Europe Asia Americas Africa, robust cluster(reo) baseoutcome(3)
			estimates store m2a12
			mlogit lifespan hardrel mccall  compdummy lngdpsum1   age  s3un  numb_mids_sum Europe Asia Americas Africa, robust cluster(reo) baseoutcome(3)
	estimates store m2a11

		
	estout m2a11 m2a12 using z_table3appendix.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex)  label replace
	
	*robustness - interaction
			mlogit lifespan   c.aut3##c.compdummy  lngdpsum1 pr_integration  age  s3un  numb_mids_sum, robust cluster(reo) baseoutcome(3)
			estimates store m3a
			estout m3a using z_table4appendix.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex)  label replace
		mlogit lifespan   c.hardrel##c.compdummy  lngdpsum1 pr_integration  age  s3un  numb_mids_sum, robust cluster(reo) baseoutcome(3)
		estout m1 m2 using z_table4appendix.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex)  label replace



 *table 2 - controlling for other aspects of IOs		
	logit life  aut3 compdum  lngdpsum1  pr_integration  age  s3un   numb_mids_sum desec5f, robust cluster(reo)   
		estimates store m13
	logit life  hardrel compdummy lngdpsum1  pr_integration  age  s3un   numb_mids_sum desec5f, robust cluster(reo)   
		estimates store m13a
	logit dea  aut3 compdummy  lngdpsum1  pr_integration  age  s3un  numb_mids_sum desec5f, robust cluster(reo)   
		estimates store m14
		logit dea  hardrel  compdummy lngdpsum1  pr_integration  age  s3un   numb_mids_sum desec5f, robust cluster(reo)    
		estimates store m14a	
	logit zombie  aut3 compdummy lngdpsum1  pr_integration age s3un  numb_mids_sum desec5f, robust cluster(reo)   
		estimates store m15	
	logit zombie  compdummy hardrel lngdpsum1  pr_integration age s3un numb_mids_sum desec5f , robust cluster(reo)    	
		estimates store m15a		
		
estout  m13 m13a m14 m14a m15 m15a using z_table2.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex)	 label replace	





	logit life  aut3 compdum  lngdpsum1  pr_integration  age  s3un  numb_mids_sum   itrans 
		estimates store m16
	logit life  hardrel compdummy lngdpsum1  pr_integration  age  s3un numb_mids_sum   itrans 
		estimates store m16a
	logit dea  aut3 compdummy lngdpsum1  pr_integration  age  s3un  numb_mids_sum    itrans 
		estimates store m17
		logit dea  hardrel  compdummy lngdpsum1  pr_integration  age  s3un  numb_mids_sum    itrans 
		estimates store m17a	
	logit zombie  aut3 compdummy  lngdpsum1  pr_integration age s3un   numb_mids_sum    itrans 
		estimates store m18	
	logit zombie  compdummy hardrel lngdpsum1  pr_integration age s3un   numb_mids_sum    itrans  	
			estimates store m18a	
		estout  m16 m16a m17 m17a m18 m18a using z_table2.rtf, cells(b(star fmt(3)) se(par fmt(2))) stats (chi2 r2_p ll  N) style(tex)	 label replace
