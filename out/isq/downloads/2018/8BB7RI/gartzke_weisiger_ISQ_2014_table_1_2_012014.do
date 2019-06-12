
**  Analysis do file for Tables 1 and 2 from Gartzke, Erik and Alex Weisiger 2014 “Under Construction:  Development, Democracy, and Difference as Determinants of Systemic Liberal Peace,” International Studies Quarterly 58(2):130-145.

** Discrepancies:
** Minor differences appear in the printed table and these results.  The differences appear to be a result of transposing the table.  None of these discrepancies are substantive.  All appear in Table 2.
** Model 7: Ln(alpha) should be -16.62 (not -16.59)
** Model 8: Ln(alpha) should be -16.60 (not -18.37)
** also, chi^2 = 26.74 instead of 26.75
** Model 9: Ln(alpha) should be -39.93 (not -19.13)
** Model 11: Ln(alpha) should be -16.38 (not -17.43)
** Model 12: Ln(alpha) should be -16.44 (not -17.42)


log using gartzke_weisiger_ISQ_2014_table_1_2_data_012014.log, replace

set more off

use gartzke_weisiger_ISQ_2014_table_1_2_data_012014.dta, clear

** Replicating Table 1

nbreg fat1 polave, nolog robust

nbreg fat1 polave states year, nolog robust

nbreg fat1 polave diff1 states year, nolog robust

nbreg fat1 polave diff1 pcenerg states year, nolog robust

nbreg fat1 polave diff1 pcenerg sysdepstate states year, nolog robust

nbreg fat1 polave polave2 diff1 pcenerg states year, nolog robust


** Replicating Table 2

nbreg fat1 wgdppc3 states year, nolog robust

nbreg fat1 wgdppc3 polave states year, nolog robust

nbreg fat1 wgdppc3 polave diff1 states year, nolog robust

nbreg fat1 wgdppc3 polave diff1 sysdepstate states year, nolog robust

nbreg fat1 wgdppc3 propdem diff1 sysdepstate states year, nolog robust

nbreg fat1 wgdppc3 dempower diff1 sysdepstate states year, nolog robust



** Replication of Table 3 is done with a different dataset





