
*for Tables 3 and A1
clear 
use "C:\....SPPQ170032ReplicationDataFinal.dta" 
drop if stateid_x==15 | stateid_x==21 | stateid_x==28 
drop if year<1997
drop if f.rpsy==0 & f.rpsx==0

*Table 3
probit dv govdistabs  nbors_y  deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id)
eststo rpsbase 
margins, dydx(govdistabs  nbors_y)
probit dv govdistabs  nbors_y  iiireason1 deregulatedx re_pot_1mill_x  CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) robust
eststo rps1
probit dv govdistabs  nbors_y  iiireason2 deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps2
margins, dydx(govdistabs  nbors_y iiireason2 )
probit dv govdistabs  nbors_y  iiireason3 deregulatedx re_pot_1mill_x  CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps3
margins, dydx(govdistabs  nbors_y iiireason3 )
probit dv govdistabs  nbors_y  iiireason4 deregulatedx re_pot_1mill_x  CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps4
margins, dydx(govdistabs  nbors_y iiireason4 )
probit dv govdistabs  nbors_y  iiireason5 deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps5
margins, dydx(govdistabs  nbors_y iiireason5 )
probit dv govdistabs  nbors_y iiireason6 deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps6
margins, dydx(govdistabs  nbors_y iiireason6 )
probit dv govdistabs  nbors_y  iiireason7 deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps7
margins, dydx(govdistabs  nbors_y iiireason7 )
probit dv govdistabs  nbors_y  iiireason8 deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps8
margins, dydx(govdistabs  nbors_y iiireason8 )
probit dv govdistabs  nbors_y  iiireason9 deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps9
margins, dydx(govdistabs  nbors_y iiireason9 )
probit dv govdistabs  nbors_y  allreason deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id) 
eststo rps10
margins, dydx(govdistabs  nbors_y allreason )
esttab rps*, se csv 

*Table A1
gen nborsy_traditional=nbors_y*iiireason5
probit dv govdistabs  nbors_y iiireason5 nborsy_traditional deregulatedx  re_pot_1mill_x CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 yearsline3, cluster(dyad_id)
eststo rpsinter
esttab rpsinter, se 

*for Table 4 
clear 
use "C:\....SPPQ170032ReplicationDataFinal.dta" 

drop if stateid_x==21 | stateid_x==39
drop if year<1998
drop if f.deregulatedy==0 & f.deregulatedx==0


probit dv2 govdistabs  nbors_y   re_pot_1mill_x  CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 , cluster(dyad_id) 
eststo deregbase
margins, dydx(govdistabs  nbors_y)
probit dv2 govdistabs  nbors_y  iiireason1  re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg1
margins, dydx(govdistabs  nbors_y iiireason1 )
probit dv2 govdistabs  nbors_y  iiireason2 re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 , cluster(dyad_id) 
eststo dereg2
margins, dydx(govdistabs  nbors_y iiireason2)
probit dv2 govdistabs  nbors_y  iiireason3 re_pot_1mill_x    CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg3
margins, dydx(govdistabs  nbors_y iiireason3 )
probit dv2 govdistabs  nbors_y  iiireason4  re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg4
margins, dydx(govdistabs  nbors_y iiireason4)
probit dv2 govdistabs  nbors_y  iiireason5  re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg5
margins, dydx(govdistabs  nbors_y iiireason5)
probit dv2 govdistabs  nbors_y  iiireason6  re_pot_1mill_x  CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2 , cluster(dyad_id) 
eststo dereg6
margins, dydx(govdistabs  nbors_y iiireason6 )
probit dv2 govdistabs  nbors_y  iiireason7  re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg7
margins, dydx(govdistabs  nbors_y iiireason7 )
probit dv2 govdistabs  nbors_y  iiireason8  re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg8
margins, dydx(govdistabs  nbors_y iiireason8 )
probit dv2 govdistabs  nbors_y  iiireason9  re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg9
margins, dydx(govdistabs  nbors_y iiireason9 )
probit dv2 govdistabs  nbors_y  allreason re_pot_1mill_x   CO2pc_x cit_ideox govt_ideox elec_pricex yearsline1 yearsline2, cluster(dyad_id) 
eststo dereg10
esttab dereg*, se 





