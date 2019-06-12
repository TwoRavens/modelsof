use petitionsdataset_byarrivalyr, clear

collapse arrivalyr, by(country issueyear state)
gen yrsUS=issueyear-arrivalyr
gen postwar=(issueyear>=1917)
gen german=(country=="Germany")
gen postgerman=postwar*german
gen dummy1918=(issueyear==1918)

* regressions
estimates clear
xi: reg yrsUS german postwar dummy1918 postgerman, cl(country)
eststo m1
xi: reg yrsUS german postwar dummy1918 postgerman i.state, cl(country)
eststo m2
xi: reg yrsUS german i.state i.issueyear postgerman, cl(country)
eststo m3
xi: reg yrsUS i.country i.state i.issueyear postgerman, cl(country)
eststo m4
esttab m* using "TableE3.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) ///
stats(N r2) keep(german postwar postgerman) 
