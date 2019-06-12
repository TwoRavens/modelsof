
use publicdata, clear

global covariates "MBfemale Mreportedage MBvoted2004 MBvoted2002 MBvoted2001 MBconsumer MBgetsmag MBpreferrepub MBprefernoone Mwave2 MZBfemale MZreportedage MZBvoted2004 MZBvoted2002 MZBvoted2001 MZBconsumer MZBgetsmag MZBpreferrepub MZBprefernoone MZwave2"
*These global covariates include variables which are all 0 (missing indicators)
sum MBvoted2004 MBvoted2002 MBvoted2001 MBconsumer MBgetsmag MBpreferrepub MBprefernoone Mwave2 doperator89
drop MBvoted2004 MBvoted2002 MBvoted2001 MBconsumer MBgetsmag MBpreferrepub MBprefernoone Mwave2 doperator89
global covariates "MBfemale Mreportedage MZBfemale MZreportedage MZBvoted2004 MZBvoted2002 MZBvoted2001 MZBconsumer MZBgetsmag MZBpreferrepub MZBprefernoone MZwave2"
global priorvoting = "voted2004g voted2003g voted2002g voted2001g voted2000g"

*TABLE 2 - All okay
foreach X in getapaper getpost gettimes readfrqr readsome {
	areg `X' post times $covariates doperator*, absorb(cells)
	areg `X' paper $covariates doperator*, absorb(cells)
	}


*TABLE 3 - All okay
foreach X in factindex consindexpol consindexgen {
	areg `X' post times $covariates doperator*, absorb(cells)
	areg `X' paper $covariates doperator*, absorb(cells)
	}
	

*TABLE 4 - All okay
foreach X in voted voted2005g voted2006g voteddem voteddem_all {
	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		areg `X' post times $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		areg `X' post times $covariates doperator*, absorb(cells)
		}

	if ("`X'" == "voted2005g" | "`X'" == "voted2006g" ) {
		areg `X' paper $covariates $priorvoting if completematch=="yes", absorb(cells)
		}
	else {
		areg `X' paper $covariates doperator*, absorb(cells)
		}
	}


*APPENDIX TABLE 2 - One sign error on adjusted R2, another rounding error on adjusted R2, rounding error on a coefficient

foreach X in iraqdead libby miers mostimp_scandals iraq_post iraq leak alito repfavorable demunfavorable bushapproval conservative {
	areg `X' post times $covariates doperator*, absorb(cells)
	areg `X' paper $covariates doperator*, absorb(cells) 
	}


*Table 1C - comparison of means across columns - no statistical tests of differences in table

save DatGKB, replace


