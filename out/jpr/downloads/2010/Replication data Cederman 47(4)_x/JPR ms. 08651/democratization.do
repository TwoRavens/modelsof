* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Replication data                                                            *
* "DEMOCRATIZATION AND CIVIL WAR: EMPIRICAL EVIDENCE"                         *
* Lars-Erik Cederman, Simon Hug, Lutz F. Krebs                                *
* Journal of Peace Research                                                   *
* http://jpr.sagepub.com/                                                     *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


*== NOTE: Enter the path to the directory containg the data file here ==========
    cd "/Users/lfkrebs/Data/"
*===============================================================================


clear
set more off
set memory 16m
log using "democratization.log", replace

use "democratization.Stata10.dta", clear
tsset cowcode year


*~~ Core analysis ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*-- Table I: Main results ------------------------------------------------------

*.. Model 1.1: Base model ......................................................
logit acdonset2 cdem caut  lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 1.2: Base model excluding observations with missing Polity values ....
logit acdonset2 cdem caut  lpopl lgdpcapl year  acdpeaceyears acdspline* if polity != ., nolog cl(cowcode)
fitstat


*.. Model 1.3: Controlling for Anocracy ........................................
logit acdonset2 cdem caut anoc lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 1.4: Controlling for Polity and Polity squared ........................
logit acdonset2 cdem caut polity polity2 lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*-- Table II: Extending the period of regime change by 3 years -----------------

*.. Model 2.1: Base model ......................................................
logit acdonset2 cdem03 caut03  lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 2.2: Base model excluding observations with missing Polity values ....
logit acdonset2 cdem03 caut03  lpopl lgdpcapl year  acdpeaceyears acdspline* if polity != ., nolog cl(cowcode)
fitstat


*.. Model 2.3: Controlling for Anocracy ........................................
logit acdonset2 cdem03 caut03 anoc lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 2.4: Controlling for Polity and Polity squared ........................
logit acdonset2 cdem03 caut03 polity polity2 lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*-- Table III: Varying the DV --------------------------------------------------


*.. Models 3.1 & 3.2: Dividing onset by conflict type ..........................
mlogit acdonset3 cdem03 caut03  polity polity2 lpopl lgdpcapl year acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 3.3: Onset as defined in Fearon & Laitin (2003) .......................
logit onsetfl2 cdem03 caut03  polity polity2 lpopl lgdpcapl year fpeaceyears fspline*, nolog cl(cowcode)
fitstat


*~~ Additional Checks ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*-- Table I: Testing for the reduced set of observations of the 03 variables ---

*.. Model 1.1 ..................................................................
logit acdonset2 cdem caut  lpopl lgdpcapl year  acdpeaceyears acdspline* if cdem03 != . & caut03 != ., nolog cl(cowcode)
fitstat


*.. Model 1.2 ..................................................................
logit acdonset2 cdem caut  lpopl lgdpcapl year  acdpeaceyears acdspline* if cdem03 != . & caut03 != .& polity != ., nolog cl(cowcode)
fitstat


*.. Model 1.3 ..................................................................
logit acdonset2 cdem caut anoc lpopl lgdpcapl year  acdpeaceyears acdspline* if cdem03 != . & caut03 != ., nolog cl(cowcode)
fitstat


*.. Model 1.4 ..................................................................
logit acdonset2 cdem caut polity polity2 lpopl lgdpcapl year  acdpeaceyears acdspline* if cdem03 != . & caut03 != ., nolog cl(cowcode)
fitstat


*-- Table II: Comparing dem/aut with dem03/aut03 -------------------------------

*.. Model 2.1 ..................................................................
logit acdonset2 cdem03r cdem caut03r caut lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 2.2 ..................................................................
logit acdonset2 cdem03r cdem caut03r caut lpopl lgdpcapl year  acdpeaceyears acdspline* if polity != ., nolog cl(cowcode)
fitstat


*.. Model 2.3 ..................................................................
logit acdonset2 cdem03r cdem caut03r caut anoc lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


*.. Model 2.4 ..................................................................
logit acdonset2 cdem03r cdem caut03r caut polity polity2 lpopl lgdpcapl year  acdpeaceyears acdspline*, nolog cl(cowcode)
fitstat


log close
set more on

*===============================================================================
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*-------------------------------------------------------------------------------
*...............................................................................
