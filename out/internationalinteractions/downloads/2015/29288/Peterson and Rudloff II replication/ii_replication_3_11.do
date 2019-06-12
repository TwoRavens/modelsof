*Replication do file for Peterson and Rudloff "Preferential Trade Agreements and Trade Expectations Theory"
**questions and comments can be forwarded to Timothy M. Peterson: timothy.peterson@sc.edu


gen dyadid=ccode1*1000+ccode2
xtset dyadid year

logit f.cwmid f.signed lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_mid##c.f.py_mid##c.f.py_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m1
logit f.cwmid f.signed_no f.entered_force lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_mid##c.f.py_mid##c.f.py_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m2
logit f.cwmid f.signed lowerlib lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_mid##c.f.py_mid##c.f.py_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m3
logit f.cwmid f.signed_no f.entered_force lowerlib lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_mid##c.f.py_mid##c.f.py_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m4

logit f.fatal_mid f.signed lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_fatal_mid##c.f.py_fatal_mid##c.f.py_fatal_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m5
logit f.fatal_mid f.signed_no f.entered_force lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_fatal_mid##c.f.py_fatal_mid##c.f.py_fatal_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m6
logit f.fatal_mid f.signed lowerlib lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_fatal_mid##c.f.py_fatal_mid##c.f.py_fatal_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m7
logit f.fatal_mid f.signed_no f.entered_force lowerlib lowerdep minchdep mingrowth f.contigdi f.lndist lowerpolity atopally caprat c.f.py_fatal_mid##c.f.py_fatal_mid##c.f.py_fatal_mid coldwar if f.cwongo==0  , cluster(dyadid)
est store m8
estout m1 m2 m3 m4 m5 m6 m7 m8  , cells(b(star fmt(3)) se(par fmt(3))) stats(N ll chi2) style(tex) starlevels( * 0.05 ** 0.01 *** 0.001 ) delimiter( & )
