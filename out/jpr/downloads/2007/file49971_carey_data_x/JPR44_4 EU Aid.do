* JPR 44(4), July 2007
* European Aid: Human Rights versus Bureaucratic Inertia?
* by Sabine C. Carey
* Stata 9 do-file to create the Tables presented in the above article
* Comments and questions, please email sabine.carey@nottingham.ac.uk

use JPR44_4_SCC, clear

* Table I. Determinants of European Aid - Gatekeeping Stage

logit recaid lrecaid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 acp lgdppcl lpop, robust
estat class
logit rgeaid lrgeaid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 acp lgeweaponl1	///
lgeexportl1 lgdppcl lpop, robust
estat class
logit rfraid lrfraid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 flcolfra lfrweaponl1	///
lfrexportl1 lgdppcl lpop, robust
estat class
logit rukaid lrukaid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 flcolbrit	///
lukexportl1 lgdppcl lpop, robust
estat class

* Table II. Determinants of European Aid - Onset of Aid

logit ecaidon ecyears lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 acp lgdppcl lpop, robust
estat class
logit geaidon geyears lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 acp lgeweaponl1	///
lgeexportl1 lgdppcl lpop, robust
estat class
logit fraidon fryears lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 flcolfra lfrweaponl1	///
lfrexportl1 lgdppcl lpop, robust
estat class
logit ukaidon ukyears lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 flcolbrit ///
lukexportl1 lgdppcl lpop, robust
estat class

* Table III. Determinants of European Aid - Amount Stage

xtpcse lnecaid llnecaid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 acp  ///
lgdppcl lpop if recaid==1, pairwise
xtpcse lngeaid llngeaid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 acp  ///
lgeweaponl1 lgeexportl1 lgdppcl lpop if rgeaid==1, pairwise
xtpcse lnfraid llnfraid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 flcolfra     ///
lfrweaponl1 lfrexportl1 lgdppcl lpop if rfraid==1, pairwise
xtpcse lnukaid llnukaid lpts2 lpts3 lpts4 lpts5 aichange23l aichangen23l lpolity2 flcolbrit    ///
lukexportl1 lgdppcl lpop if rukaid==1, pairwise


