	* do Prepare_mata_ksDiD_manual.do

mata: mata clear
program drop _all

version 12

mata:
mata set matastrict on

void mata_ksDiD_manual(string scalar xvar, string scalar dvar, ///
	string scalar sel, string scalar xvarbase, ///
	string scalar dvarbase, string scalar selbase)

{
	real colvector x, d, x1, x0, cdf_x1, cdf_x0, xbase, dbase, ///
	x1base, x0base, cdf_x0base, cdf_x1base, xfull, selobs, selobsbase

	real scalar ks_abs, ks_plus, ks_minus, ks_did_abs, ks_did_plus, ///
	ks_did_minus, N0, N1, N0base, N1base, N, Nbase

	x=st_data(.,xvar,sel)
	d=st_data(.,dvar,sel)

	xbase=st_data(.,xvarbase,selbase)
	dbase=st_data(.,dvarbase,selbase)

	selobs=(x:!=.):*(d:!=.)
	x=select(x,selobs)
	d=select(d,selobs)
	selobsbase=(xbase:!=.):*(dbase:!=.)
	xbase=select(xbase,selobsbase)
	dbase=select(dbase,selobsbase)
	
	xfull=(x\xbase)
	x1=select(x,(d:==1))
	x0=select(x,(d:==0))
	
	x1base=select(xbase,(dbase:==1))
	x0base=select(xbase,(dbase:==0))
	
	cdf_x1=mm_relrank(x1,1,xfull)
	cdf_x0=mm_relrank(x0,1,xfull)
	
	cdf_x1base=mm_relrank(x1base,1,xfull)
	cdf_x0base=mm_relrank(x0base,1,xfull)
	
	ks_abs=max(abs(cdf_x0-cdf_x1))
	ks_plus=max(cdf_x0-cdf_x1)
	ks_minus=min(cdf_x0-cdf_x1)
	
	ks_did_abs=max(abs(cdf_x0-cdf_x1-(cdf_x0base-cdf_x1base)))
	ks_did_plus=max(cdf_x0-cdf_x1-(cdf_x0base-cdf_x1base))
	ks_did_minus=min(cdf_x0-cdf_x1-(cdf_x0base-cdf_x1base))
	
	N0=rows(x0)
	N1=rows(x1)
	N=rows(x)
	N0base=rows(x0base)
	N1base=rows(x1base)
	Nbase=rows(xbase)
	
	st_numscalar("r(ks_abs)",ks_abs)
	st_numscalar("r(ks_0lt1)",ks_plus)
	st_numscalar("r(ks_1lt0)",ks_minus)
	st_numscalar("r(ks_DiD_abs)",ks_did_abs)
	st_numscalar("r(ks_DiD_0lt1)",ks_did_plus)
	st_numscalar("r(ks_DiD_1lt0)",ks_did_minus)
	st_numscalar("r(N0)",N0)
	st_numscalar("r(N1)",N1)
	st_numscalar("r(N)",N)
	st_numscalar("r(N0base)",N0base)
	st_numscalar("r(Nbase)",Nbase)
	st_numscalar("r(N1base)",N1base)

}

mata mosave mata_ksDiD_manual(), dir("${ado}/") replace

end

	*
