*Table 3

newey F.physint lnpop lngdp civilconflict   lnhrfilled2   humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1 | disastersample==1 ) , lag(4) force
*outreg2 using Table1 , replace word label bdec(5)
newey F.physint lnpop lngdp civilconflict   lnhrfilled2   humanitarian  NONhumanitarianIMI polity2 if ( disastersample==1 ) , lag(4) force
*outreg2 using Table1 , word label bdec(5)
newey F.physint lnpop lngdp civilconflict   lnhrfilled2   humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1 ) , lag(4) force
*outreg2 using Table1 , word label bdec(5)
newey F.physint lnpop lngdp civilconflict   lnhrfilled2   humanitarianlnhrfilled2 humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1 | disastersample==1 ) , lag(4) force
*outreg2 using Table1 , word label bdec(5)
newey F.physint lnpop lngdp civilconflict   lnhrfilled2   humanitarianlnhrfilled2  humanitarian  NONhumanitarianIMI polity2 if ( disastersample==1 ) , lag(4) force
*outreg2 using Table1 , word label bdec(5)
newey F.physint lnpop lngdp civilconflict   lnhrfilled2    humanitarianlnhrfilled2 humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1  ) , lag(4) force
*outreg2 using Table1 , word label bdec(5)

*Table 4

newey F.D.lngdp lngdp physint lnpop  civilconflict  lnsusdev  humanitarian NONhumanitarianIMI  polity2  if ( civilconflictsample==1 | disastersample==1 ) , lag(4) force
*outreg2 using Table3 , replace word label bdec(5)
newey F.D.lngdp lngdp physint lnpop  civilconflict  lnsusdev    humanitarian NONhumanitarianIMI  polity2  if ( disastersample==1 ) , lag(4) force
*outreg2 using Table3 , word label bdec(5)
newey F.D.lngdp lngdp physint lnpop  civilconflict lnsusdev   humanitarian NONhumanitarianIMI  polity2  if ( civilconflictsample==1 ) , lag(4) force
*outreg2 using Table3a , word label bdec(5)
newey F.D.lngdp  physint lnpop lngdp civilconflict   lnsusdev   humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1 | disastersample==1 ) , lag(4) force
*outreg2 using Table3 , word label bdec(5)
newey F.D.lngdp  physint lnpop lngdp civilconflict   lnsusdev   humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( disastersample==1 ) , lag(4) force
*outreg2 using Table3 , word label bdec(5)
newey F.D.lngdp  physint lnpop lngdp civilconflict   lnsusdev    humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1  ) , lag(4) force
*outreg2 using Table3  , word label bdec(5)
newey F.D.lngdp  physint lnpop lngdp civilconflict   lnsusdev   humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsamplelong==1 ) , lag(5) force
outreg2 using Table3a , word label bdec(5)
*Table 5

newey F.sh_imm_meas  lngdp physint lnpop  civilconflict  lnsusdev  humanitarian NONhumanitarianIMI  polity2  if ( civilconflictsample==1 | disastersample==1 ) , lag(4) force
outreg2 using Table5 , replace word label bdec(5)
newey F.sh_imm_meas  lngdp physint lnpop  civilconflict lnsusdev  humanitarian NONhumanitarianIMI  polity2  if ( disastersample==1 ) , lag(4) force
outreg2 using Table5 , word label bdec(5)
newey F.sh_imm_meas  lngdp physint lnpop  civilconflict lnsusdev  humanitarian NONhumanitarianIMI  polity2  if ( civilconflictsample==1 ) , lag(4) force
outreg2 using Table5 , word label bdec(5)
newey F.sh_imm_meas   physint lnpop lngdp civilconflict   lnsusdev   humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1 | disastersample==1 ) , lag(4) force
outreg2 using Table5 , word label bdec(5)
newey F.sh_imm_meas  physint lnpop lngdp civilconflict   lnsusdev   humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( disastersample==1 ) , lag(4) force
outreg2 using Table5 , word label bdec(5)
newey F.sh_imm_meas  physint lnpop lngdp civilconflict   lnsusdev    humanitariansusdev humanitarian  NONhumanitarianIMI polity2 if ( civilconflictsample==1  ) , lag(4) force
outreg2 using Table5, word label bdec(5)
