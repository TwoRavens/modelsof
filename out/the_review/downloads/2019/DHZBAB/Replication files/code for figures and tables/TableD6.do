use petitionsdataset, clear

gen postwar=(issueyear>=1917)
gen german=(country=="Germany")
foreach x in 1918 1919 1920 1921 1922 1923 1924 {
	gen postwar`x'=(issueyear>=`x')
	gen postgerman`x'=postwar`x'*german
}
gen postgerman1917=postwar*german
gen dummy1918=(issueyear==1918)
gen dummygerman=dummy1918*german

* deviation of index from state-specific pre-war trend
sum issueyear
local minyear=r(min)
local maxyear=r(max)-r(min)
gen t=issueyear-`minyear'+1
xi: reg petitions i.country|t i.state|t i.country*i.state if issueyear<1917
predict res, res

* regressions
estimates clear
xi: reg petitions i.country i.issueyear postgerman1917 dummygerman i.state, cl(country)
eststo m1
xi: reg petitions i.country i.issueyear postgerman1919 dummygerman i.state if issueyear>=1917, cl(country)
eststo m2
xi: reg petitions i.country i.issueyear postgerman1920 dummygerman i.state if issueyear>=1917, cl(country)
eststo m3
xi: reg petitions i.country i.issueyear postgerman1921 dummygerman i.state if issueyear>=1917, cl(country)
eststo m4
xi: reg petitions i.country i.issueyear postgerman1922 dummygerman i.state if issueyear>=1917, cl(country)
eststo m5
xi: reg petitions i.country i.issueyear postgerman1923 dummygerman i.state if issueyear>=1917, cl(country)
eststo m6
xi: reg petitions i.country i.issueyear postgerman1924 dummygerman i.state if issueyear>=1917, cl(country)
eststo m7

esttab m* using "TableD6.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(postgerman*) 
