use petitionsdataset, clear

gen postwar=(issueyear>=1917)
gen german=(country=="Germany")
gen postgerman=postwar*german
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
xi: reg petitions german postwar dummy1918 dummygerman postgerman, cl(country)
eststo m1
xi: reg petitions german postwar dummy1918 dummygerman postgerman t, cl(country)
eststo m2
xi: reg petitions german dummygerman postgerman i.issueyear, cl(country)
eststo m3
xi: reg petitions i.country dummygerman postgerman i.issueyear, cl(country)
eststo m4
xi: reg petitions i.country dummygerman postgerman i.issueyear i.state, cl(country)
eststo m5
xi: reg res i.country i.issueyear postgerman dummygerman i.state, cl(country)
eststo m6

esttab m* using "Table3.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) ///
stats(N r2) keep(postwar german postgerman) 

