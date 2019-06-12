clear 
set mem 600m
use "CKKM ISQ Replication.dta"


*model 1
probit atopally0 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)

*model 2
probit atopally0 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if year < 1914, cl(dirdyadID)

*model 3
probit atopally0 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if year > 1913 & year < 1946, cl(dirdyadID)

*model 4
probit atopally0 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if year > 1945, cl(dirdyadID)

*model 5
probit atopally0bilat arep_BallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)

*model 6
probit atopally0def arep_MBdefSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
