xtgee cwinit ngovtptys minority wkpty grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust

xtgee cwinit ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtgee cwinit ngovtptys ngovtptys_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
vce

xtgee cwinit minority minority_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =minority_grgdpch=0
vce

xtgee cwinit wkpty wkpty_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =wkpty_grgdpch=0
vce

**controlling for pres with dyadic data
xtgee cwinit ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch pres dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtgee cwinit ngovtptys ngovtptys_grgdpch grgdpch pres dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
vce

xtgee cwinit minority minority_grgdpch grgdpch pres dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =minority_grgdpch=0
vce

xtgee cwinit wkpty wkpty_grgdpch grgdpch pres dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust
test grgdpch =wkpty_grgdpch=0
vce

**excluding US
xtgee cwinit ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust, if ccode1 !=2
test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtgee cwinit ngovtptys ngovtptys_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust, if ccode1 !=2
test grgdpch =ngovtptys_grgdpch=0
vce

xtgee cwinit minority minority_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust, if ccode1 !=2
test grgdpch =minority_grgdpch=0
vce

xtgee cwinit wkpty wkpty_grgdpch grgdpch dem2 relcap tau_glob contig2, f(binomial) l(probit) i(dyadid) t(year) corr(ar1) force robust, if ccode1 !=2
test grgdpch =wkpty_grgdpch=0
vce

**Random effects

xtprobit cwinit ngovtptys minority wkpty grgdpch dem2 relcap tau_glob contig2 peaceyears _spline1 _spline2 _spline3, re i(dyadid) 

xtprobit cwinit ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch dem2 relcap tau_glob contig2 peaceyears _spline1 _spline2 _spline3, re i(dyadid) 

test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtprobit cwinit ngovtptys ngovtptys_grgdpch grgdpch dem2 relcap tau_glob contig2 peaceyears _spline1 _spline2 _spline3, re i(dyadid) 

test grgdpch =ngovtptys_grgdpch=0
vce

xtprobit cwinit minority minority_grgdpch grgdpch dem2 relcap tau_glob contig2 peaceyears _spline1 _spline2 _spline3, re i(dyadid) 

test grgdpch =minority_grgdpch=0
vce

xtprobit cwinit wkpty wkpty_grgdpch grgdpch dem2 relcap tau_glob contig2 peaceyears _spline1 _spline2 _spline3, re i(dyadid) 

test grgdpch =wkpty_grgdpch=0
vce


**Monadic runs
xtgee cwinit_count ngovtptys minority wkpty grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust

xtgee cwinit_count ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtgee cwinit_count ngovtptys ngovtptys_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
vce

xtgee cwinit_count minority minority_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =minority_grgdpch=0
vce

xtgee cwinit_count wkpty wkpty_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =wkpty_grgdpch=0
vce

**controlling for presidential systems
xtgee cwinit_count ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch pres, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtgee cwinit_count ngovtptys ngovtptys_grgdpch grgdpch pres, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =ngovtptys_grgdpch=0
vce

xtgee cwinit_count minority minority_grgdpch grgdpch pres, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =minority_grgdpch=0
vce

xtgee cwinit_count wkpty wkpty_grgdpch grgdpch pres, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust
test grgdpch =wkpty_grgdpch=0
vce

**excluding the US
xtgee cwinit_count ngovtptys minority wkpty ngovtptys_grgdpch minority_grgdpch wkpty_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust, if ccode1 !=2

test grgdpch =ngovtptys_grgdpch=0
test grgdpch =minority_grgdpch=0
test grgdpch =wkpty_grgdpch=0
vce

xtgee cwinit_count ngovtptys ngovtptys_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust, if ccode1 !=2

test grgdpch =ngovtptys_grgdpch=0
vce

xtgee cwinit_count minority minority_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust, if ccode1 !=2

test grgdpch =minority_grgdpch=0
vce

xtgee cwinit_count wkpty wkpty_grgdpch grgdpch, f(nbinomial) i(ccode1) t(year) corr(ar1) force robust, if ccode1 !=2

test grgdpch =wkpty_grgdpch=0
vce



