*  Table 2--Binary Support--All Cases (Politically Relevant Dyads)
logit support L.joindem L.oreltrade1 L.religomem L.cultsim L.capratab   L.atopally  L.stratrivals L.satisfaca L.satisfacb volunsupyrs volunspline* if  contig1==1 & year>1945, robust
* Table 2--Binary Support--All Cases (Politically Relevant Dyads) voluntary support only
logit volunsupport L.joindem L.oreltrade1 L.religomem L.cultsim L.capratab   L.atopally  L.stratrivals L.satisfaca L.satisfacb volunsupyrs volunspline* if  contig1==1 & year>1945, robust
* Table 2--Binary Support--Strategic Rivals
logit volunsupport L.joindem L.oreltrade1 L.religomem L.cultsim L.capratab   L.atopally  L.rivalint L.rivalyrs  L.satisfaca L.satisfacb volunsupyrs volunspline* if  stratrivals==1 & year>1945, robust
* Table 2--Binary Support--Strategic Rivals--Game Type
logit volunsupport L.joindem L.oreltrade1 L.religomem L.cultsim  L.atopally  L.rivalint L.frustgame  L.opportgame volunsupyrs volunspline* if  stratrivals==1 & year>1945, robust
* Table 2--Support Level--Satisfaction and Capability
ologit supportlev  L.joindem L.oreltrade1 L.religomem L.cultsim L.capratab   L.atopally  L.rivalint L.rivalyrs  L.satisfaca L.satisfacb volunsupyrs volunspline* if  stratrivals==1 & year>1945, robust
* Table 2--Support Level--Game Type
ologit supportlev  L.joindem L.oreltrade1 L.religomem L.cultsim  L.atopally  L.rivalint   L.frustgame L.opportgame volunsupyrs volunspline* if  stratrivals==1 & year>1945, robust 
* Table 2--No. Groups
poisson  nogroups1 L.joindem L.oreltrade1 L.religomem L.cultsim L.capratab   L.atopally  L.rivalint L.rivalyrs  L.satisfaca L.satisfacb volun*yr* if  stratrivals==1 & year>1945, robust cl(dyad)

* Table 4--Target Initiation--Politically Relevant Dyads
logit dichtarga L.joindem L.oreltrade1 L.religomem L.cultsim L.atopally L.rivalint L.volunsupport notargyrs targspline* if contig1==1, robust
* Table 4--Target Initiation--Strategic Rivals
logit dichtarga L.joindem L.oreltrade1 L.religomem L.cultsim L.atopally L.rivalint L.volunsupport notargyrs  if stratrivals==1, robust
* Note: Cubic Spline prevent convergence here.
* Table 4--Target Hostility--Politically Relevant Dyads
poisson targethost  L.joindem L.oreltrade1 L.religomem L.cultsim L.atopally L.rivalint L.volunsupport notargyrs  if contig1==1, robust cl(dyad)
* Table 4--Target Hostility--Strategic rivals
poisson targethost  L.joindem L.oreltrade1 L.religomem L.cultsim L.atopally L.rivalint L.volunsupport notargyrs  if stratrivals==1, robust cl(dyad)
* Table S3--Instrumental Variables Probit--Politically Relevant Dyads
ivprobit dichtarga L.joindem L.oreltrade1 L.religomem L.atopally L.capratab L.rivalint L.rivalyrs (L.volunsupport = commonid L.frustgame L.opportgame L2.volunsupport) if contig1==1, first
* Table S3--Instrumental Variables Probit--Strategic Rivals
ivprobit dichtarga L.joindem L.oreltrade1 L.religomem L.atopally L.capratab L.rivalint L.rivalyrs (L.volunsupport = commonid L.frustgame L.opportgame L2.volunsupport) if stratrivals==1, first

