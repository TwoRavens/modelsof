**SORT DATA BY DYAD YEAR**sort dyadid yeartsset dyadid year

***TABLE 2***

btscs signatory year dyadid, g(years) nspline(3)
logit signatory norgconA incomp conflictduration war2 democracy years _spline1 _spline2 _spline3, cluster(conid)
outreg2 using dyadcivsoc1, se dec(3) replace 

drop years _spline1 _spline2 _spline3

btscs civ year dyadid, g(years) nspline(3)
logit civ norgconA incomp conflictduration war2 democracy years _spline1 _spline2 _spline3, cluster(conid)
outreg2 using dyadcivsoc1, se dec(3) append 
