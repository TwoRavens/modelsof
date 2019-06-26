


* 				REPLICATION DATA: THE SPOILS OF NATURE (P. LUJALA)

*****************************************************

* This is the do-file to replicate Tables I and II, and Appendix 1 for the empirical analysis in the article: 
* 'The Spoils of Nature: Armed Civil Conflict and Rebel Access to Natural Resources' by Päivi Lujala, 
* Journal of Peace Research (2010)

*****************************************************

* DO-FILES
* File 'Lujala Spoils of Nature dofile DURATION' replicates the duration analysis (Table I, Table II, and Appendix 1)
* File 'Lujala Spoils of Nature dofile ONSET' replicates the onset analysis (Table III and Appendix 2)

* DATA-FILES
* File 'Lujala Spoils of Nature data DURATION' is the replication data for the duration analysis (Table I, Table II, and Appendix 1)
* File 'Lujala Spoils of Nature dofile ONSET' is the replication data for the onset analysis (Table III and Appendix 2)

*****************************************************



*				TABLE I: BIVARIATE

*OIL RESERVES
streg oild_C, dist(w) nolog cluster(ccode) tr

*OIL PRODUCTION
streg oilp_C, dist(w) nolog cluster(ccode) tr

*GAS RESERVES
streg gasd_C, dist(w) nolog cluster(ccode) tr

*GAS PRODUCTION 
streg gasp_C, dist(w) nolog cluster(ccode) tr

*HYDROCARBON RESERVES
streg hydrod_C, dist(w) nolog cluster(ccode) tr

*HYDROCARBON PRODUCTION
streg hydrop_C, dist(w) nolog cluster(ccode) tr

* SECONDARY DIAMOND PRODUCTION
streg SDIAP_C, dist(w) nolog cluster(ccode) tr

*GEMSTONE PRODUCTION 
streg GEMP_C, dist(w) nolog cluster(ccode) tr

*PRIMARY DIAMOND PRODUCTIO
streg PDIAP_C, dist(w) nolog cluster(ccode) tr

*ALL GEMSTONES
streg ALLGEMP_C, dist(w) nolog cluster(ccode) tr




*				TABLE II: MULTIVARIATE

* MODEL 1
streg uneplnC frst12lnC rainseasonC ALLGEMP_C hydrod_C , ///
dist(w) nolog cluster(ccode) tr

* M 2
streg uneplnC frst12lnC rainseasonC terr int1600 ALLGEMP_C hydrod_C , ///
dist(w) nolog cluster(ccode) tr 

* M 3
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, ///
dist(w) nolog cluster(ccode) tr

* M 4
streg uneplnC frst12lnC rainseasonC terr int1600  polity2l SDIAP_C hydrod_C , ///
dist(w) nolog cluster(ccode) tr

* M 5
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrop_C, ///
dist(w) nolog cluster(ccode) tr

* M 6 
streg uneplnC frst12lnC rainseasonC  terr int1600 polity2l ALLGEMP_C oild_C, ///
dist(w) nolog cluster(ccode) tr

* M 7
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C oilp_C, ///
dist(w) nolog cluster(ccode) tr

* M 8
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP hydrop, ///
dist(w) nolog cluster(ccode) tr




*				APPENDIX 1 

*base model (Model 3 in Table II)
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, ///
dist(w) nolog cluster(ccode) tr

*Additional controls
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C  gdpll  popull  internatz  ALlangLN,dist(w) nolog cluster(ccode) tr noshow

*Drug cultivation
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C  hydrod_C  DRUGS_C ,dist(w) nolog cluster(ccode) tr noshow

*Dummy for the years between the discovery and the start of oil production in the conflict zone
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C  hydrod_C_DISCyears,dist(w) nolog cluster(ccode) tr noshow

*3 outliers removed
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C if outlier==0, dist(w) nolog cluster(ccode) tr

*colony and continent dummies
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C ///
nafrme asia ssafrica lamerica eeurop colony, dist(w) nolog cluster(ccode) tr

*Cluster (conflict)
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, dist(w) nolog cluster(id) tr

*Shared frailty (country)
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, dist(w) nolog shared(ccode) tr

*Shared frailty (conflict)
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, dist(w) nolog shared(id) tr

*Distribution: Log-normal
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, dist(lognormal) nolog cluster(ccode) tr

*Distribution: Log-logistic
streg uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C, dist(loglog) nolog cluster(ccode) tr

*Distribution: Weibull (Coefficient)
streg  uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C,  nolog cluster(ccode)  dist(w) nohr

*Distribution: cox (Coefficient)
stcox uneplnC frst12lnC rainseasonC terr int1600 polity2l ALLGEMP_C hydrod_C,  nolog cluster(ccode) nohr




