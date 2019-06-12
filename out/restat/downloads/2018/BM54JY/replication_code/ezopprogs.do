cap prog drop mysavedist
prog def mysavedist, byable(recall)
	syntax varlist [if] [in] , name(string) nq(real)
	marksample touse
	foreach v in `varlist' {
		pctile `name'`v' = `v' if s & `touse', nq(`nq')
		kdensfast `v' if s & `touse', at(`name'`v') gen(`name'`v'_pdf)
	}
end
cap prog drop pctilebyvar
prog def pctilebyvar
	syntax varname(numeric) [if] [in], Nquantiles(real) by(varlist) addmean(varlist)
	marksample touse
	tempvar group
	sort `by'
	egen `group' = group(`by')
	mata: x = . , . , .
	qui levelsof `group', local(gvals)
	foreach k of local gvals {
		pctile tmp = `varlist' if `touse' & `group' == `k', n(`nquantiles') genp(pvar)
		mata: st_view(xx=.,.,"tmp",0)
		mata: st_view(p=.,.,"pvar",0)
		mata: k = J(rows(xx),1,strtoreal(st_local("k")))
		mata: x = x \ xx , p , k
		drop tmp pvar
	}
	mata: st_store(1::rows(x),st_addvar("float",("ptile","p","group")),sort(x,(1,3,2)))
	qui foreach k of local gvals {
		foreach mvar in `addmean' {
		    cap gen `mvar'mean = .
		    su `mvar' if `touse' & `group' == `k', meanonly
		    replace `mvar'mean = r(mean) if group == `k'
		}
	}
end
cap prog drop invqtenew
prog def invqtenew, eclass byable(recall)
syntax varlist(min=2) [if] [in] , Controls(varlist fv) at(varname) [by(varname) name(string)]
marksample touse
if "`by'" != "" {
	qui levelsof `by' , local(byvals)
	cap confirm numeric var `by'
	if _rc loc string string
	foreach x of local byvals {
		if "`string'" != "" loc byx `by' == "`x'"
		else loc byx `by' == `x'
		invqtenew `varlist' if `touse' & `byx', c(`controls') at(`at') name(`name')
	}
}
else {
gettoken y varlist : varlist
local D `varlist'
local X `controls'
markout `touse' `y' `D' `X'
if "`name'" == "" loc name b
foreach d in `D' {
	gen double `name'_`d' = .
}
regress `y' `D' `X'  if `touse'
foreach d in `D' {
	gen double `name'_`d'_ols = _b[`d'] if `at' != .
}
loc i = 1
qui levelsof `at', local(stepvals)
tempvar Fi
foreach Ti of local stepvals {
	gen `Fi' = `y' >= `Ti' if `touse'
	regress `Fi' `D' `X'  if `touse'
	foreach d in `D' {
		replace `name'_`d' = _b[`d'] if `at' == `Ti'
		}
	drop `Fi'
	loc ++i
}
}
end
cap prog drop _regfast
prog def _regfast, eclass
	syntax varlist(numeric min=2) [if] [in]
	marksample touse
	gettoken y x : varlist
	mata : _ols("`y'","`x'", "`touse'")
	mat colnames b = `x'
mat list b
	ereturn post b
end
cap mata: mata drop _ols()
mata:
void _ols(string scalar y, string scalar x, string scalar sample)
{
	st_view(X, ., tokens(x), tokens(sample))
	st_view(Y, ., tokens(y), tokens(sample))
	xmean = mean(X, 1)
	ymean = mean(Y, 1)
	xx = crossdev(X, xmean, X, xmean)
	xy = crossdev(X, xmean, Y, ymean)
	b = cholsolve(xx, xy) 
	st_matrix("b", b')
}
end
cap prog drop kdensityfast
prog def kdensityfast, sortpreserve
	syntax varname [if] [in], at(varname) gen(name) [ by(varname) BWidth(real 0) cdf ]
	marksample touse
	if "`by'" != "" {
		qui levelsof `by' , local(byvals)
		cap confirm numeric var `by'
		if _rc loc string string
		foreach x of local byvals {
			if "`string'" != "" loc byx `by' == "`x'"
			else loc byx `by' == `x'
			kdensityfast `varlist' if `touse' & `byx', at(`at') gen(`gen'_`x') bw(`bwidth') `cdf'
		}
	}
	else {
		sort `at'
		if `bwidth' == 0 mata: _optbw("`varlist'","`touse'")
		else mata: h = strtoreal(st_local("bwidth"))
		mata: _kdensfast("`varlist'","`at'","`touse'","`gen'",h)
		if "`cdf'" != "" mata: _cdfby("`varlist'","`at'","`touse'","`gen'_F")
	}
end
cap mata: mata drop _optbw()
mata:
real scalar _optbw(string scalar X,string scalar sample)
{
	st_view(x, ., tokens(X), tokens(sample))
	m = min( (sqrt(variance(x)) , mm_iqrange(x)/1.349) )
	h = 0.9*m*rows(x)^(-1/5)
	return(h)
}
end
cap mata: mata drop _kdensfast()
mata: 
void _kdensfast(string scalar X,string scalar AT,string scalar sample,string scalar out , ///
				| real scalar h)
{
	st_view(x=., ., tokens(X), tokens(sample))
	st_view(at=., ., tokens(AT), 0)
	if (h==.) h = 0.9 * (min( (sqrt(variance(x)) , mm_iqrange(x)/1.349) )) * rows(x)^(-1/5)
	Xh = (J(1,rows(x),at) :- x')/h
	f = rowsum(mm_kern_epan2(Xh)) / (h*rows(x))
	newvar = st_addvar("double",tokens(out))
	st_store(1::rows(f),newvar,f)
}
end
cap mata: mata drop _cdfby()
mata: 
void _cdfby(string scalar X,string scalar AT,string scalar sample,string scalar out)
{
	st_view(x=., ., tokens(X), tokens(sample))
	st_view(at=., ., tokens(AT), 0)
	Fi = (J(1,rows(x),at) :- x') :>= 0
	F = rowsum(Fi) / rows(x)
	newvar = st_addvar("double",tokens(out))
	st_store(1::rows(F),newvar,F)
}
end


