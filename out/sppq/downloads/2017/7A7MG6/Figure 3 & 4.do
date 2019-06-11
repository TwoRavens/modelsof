**below commands recreate Figures 3 and 4***

use "SPPQ Figure 3 & 4 PL Data.dta"
serrbar avgmeLAC selib retensys, scale (1.96) ytitle("Pr(Liberal Vote)")ylabel(-.2(.1).2) yline(0) xtitle("") xlabel(1 "Comp Elect" 2 "Reten Elect" 3 "Appointment") title("Liberal Amici in Products Liability Law")
gr save LACinPLacrossRetenSys.gph
serrbar avgmeCAC secon retensys, scale (1.96)ytitle("Pr(Liberal Vote)")ylabel(-.1(.05).15)yline(0) xtitle("")xlabel(1 "Comp Elect" 2 "Reten Elect" 3 "Appointment")title("Con Amici in Products Liability Law")
gr save CACinPLacrossRetenSys.gph
use "SPPQ Figure 3 & 4 EL Data.dta"
serrbar avgmeLAC selib retensys, scale (1.96)ytitle("Pr(Liberal Vote)") ylabel(-.2(.1).2) yline(0) xtitle("")xlabel(1 "Comp Elect" 2 "Reten Elect" 3 "Appointment") title("Liberal Amici in Environmental Law")
gr save LACinELacrossRetenSys.gph
serrbar avgmeCAC secon retensys, scale (1.96)ytitle("Pr(Liberal Vote)")ylabel(-.1(.05).15) yline(0) xtitle("")xlabel(1 "Comp Elect" 2 "Reten Elect" 3 "Appointment") title("Con Amici in Environmental Law")
gr save CACinELacrossRetenSys.gph 
use "SPPQ Figure 3 & 4 FS Data.dta"
serrbar avgmeLAC selib retensys, scale (1.96)ytitle("Pr(Liberal Vote)")ylabel(-.2(.1).2) yline(0) xtitle("")xlabel(1 "Comp Elect" 2 "Reten Elect" 3 "Appointment") title("Liberal Amici in Free Speech & Expression Law")
gr save LACinFSacrossRetenSys.gph
serrbar avgmeCAC secon retensys, scale (1.96)ytitle("Pr(Liberal Vote)")ylabel(-.1(.05).15) yline(0) xtitle("")xlabel(1 "Comp Elect" 2 "Reten Elect" 3 "Appointment") title("Con Amici in Free Speech & Expression Law")
gr save CACinFSacrossRetenSys.gph
**the following command creates the combined graphs in Figure 3**
gr combine LACinPLacrossRetenSys.gph LACinELacrossRetenSys.gph LACinFSacrossRetenSys.gph

**the following command creates the combined graphs in Figure 4**
gr combine CACinPLacrossRetenSys.gph CACinELacrossRetenSys.gph CACinFSacrossRetenSys.gph





