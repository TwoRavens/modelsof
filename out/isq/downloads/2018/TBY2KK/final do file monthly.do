*ecograteL1 ecorate2L1 tradeL1


set more off
clear
cd "C:\Documents and Settings\Benjamin\My Documents\Natsuko\Natsukof"


use may7_finalv5

*no time
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL , robust b(2) sims(10000) genname(a)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*no time plus ecograteL1 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL ecograteL1 , robust b(2) sims(10000) genname(b)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecograteL1  mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*no time plus ecorate2
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL ecorate2L1 , robust b(2) sims(10000) genname(c)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecorate2L1  mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*no time plus trade
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL tradeL1, robust b(2) sims(10000) genname(d)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 tradeL1 mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

clear

use may7_finalv5

*counter
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL peaceyrs, robust b(2) sims(10000) genname(a)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 peaceyrs mean 
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*counter ecograteL1 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs ecograteL1 , robust b(2) sims(10000) genname(b)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecograteL1 mean peaceyrs  mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*counter ecorate2L1 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs ecorate2L1 , robust b(2) sims(10000) genname(c)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecorate2L1  mean peaceyrs  mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*counter tradeL1
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs tradeL1, robust b(2) sims(10000) genname(d)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 tradeL1 mean peaceyrs  mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)


clear
use may7_finalv5

*cubic polynomial 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs peaceyrs2 peaceyrs3 , robust b(2) sims(10000) genname(a)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 peaceyrs mean peaceyrs2 169 peaceyrs3 2200
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*cubic polynomial ecograteL1 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs peaceyrs2 peaceyrs3 ecograteL1 , robust b(2) sims(10000) genname(b)


setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecograteL1 mean peaceyrs mean peaceyrs2 169 peaceyrs3 2200
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*cubic polynomial ecorate2L1  
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs peaceyrs2 peaceyrs3 ecorate2L1  , robust b(2) sims(10000) genname(c)


setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecorate2L1  mean peaceyrs mean peaceyrs2 169 peaceyrs3 2200
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*cubic polynomial ecorate2L1  
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  peaceyrs peaceyrs2 peaceyrs3 tradeL1, robust b(2) sims(10000) genname(d)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 tradeL1 mean peaceyrs mean peaceyrs2 169 peaceyrs3 2200
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

clear

use may7_finalv5 

*splines 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL   _spline1 _spline2 _spline3 , robust b(2) sims(10000) genname(a)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 _spline1 mean _spline2 mean _spline3 mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*splines plus ecograteL1 
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL   _spline1 _spline2 _spline3 ecograteL1 , robust b(2) sims(10000) genname(b)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecograteL1 mean _spline1 mean _spline2 mean _spline3 mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*splines plus ecorate2L1  
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL   _spline1 _spline2 _spline3 ecorate2L1  , robust b(2) sims(10000) genname(c)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 ecorate2L1  mean _spline1 mean _spline2 mean _spline3 mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*splines plus tradeL1  
estsimp mlogit DVm any_reject in_demand cell3  jcothermid cjothermid cally lncmilbal cnegL cthreatL  _spline1 _spline2 _spline3 tradeL1 , robust b(2) sims(10000) genname(d)

setx any_reject 0 in_demand 1 cell3 0 jcothermid 0 cjothermid 0 cally 0 lncmilbal mean cnegL 0 cthreatL 0 tradeL1 mean _spline1 mean _spline2 mean _spline3 mean
simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)
simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)


clear