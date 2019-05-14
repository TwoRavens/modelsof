clear all
set maxvar 30000

estimates clear
local cc=0
foreach x in FNIdataset FNIdataset_for FNIdataset_forfath FNIdataset_coh20 FNIdataset_coh10 FNIdataset_soundex 	{
	use `x', clear

	drop if ethnicgroup==.

	gen postwar=(birthyear>=1917)   
	gen inter=postwar*german

	reg FNI i.birthyear i.ethnicgroup inter, cluster(ethnicgroup)
	eststo m`cc'
	local cc=`cc'+1
}

esttab m* using "TableD1.csv", star(* 0.1 ** 0.05 *** 0.01) replace ///
		cells(b(fmt(a3) star) se(par)) stats(N r2) keep(inter)
