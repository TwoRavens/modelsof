/*Table 1 in Hegre, Oneal, and Russett, "Trade Does Promote Peace: New Simultaneous Estimates of the Reciprocal Effects 
of Trade and Conflict," Journal of Peace Research, 2010 47(6):763-774: Replication and reanalysis of Keshk, Pollins, and Reuveny, 
JOP, Nov 2004: 12-03-2010*/

set mem 200m

/*KPR's posted data "JOP_results.dta"*/
use c:\simul\jopdata\JOP_re~1.dta, replace

desc 
summ

#del ;

/*Table 1, columns 1 & 2*/
/*reproduce KPR's JOP results*/
cdsimeq (ttab ttab_lag largdp lbrgdp lapop lbpop logdstab ldemL allytyp3 )( ndis
ndis_lag  ddpndH growthL ldemL allytyp3 caprat contigkb lrgdpH), nof nos;

/*Table 1, column 3 & 4: add logdstab to conflict equation*/
/*add the ln of distance to the conflict eqn*/
cdsimeq (ttab ttab_lag largdp lbrgdp lapop lbpop logdstab ldemL allytyp3 )( ndis
ndis_lag  ddpndH growthL ldemL allytyp3 caprat contigkb logdstab lrgdpH), nof nos;

/*probit only*/
probit ndis ttab ndis_lag  ddpndH growthL ldemL allytyp3 caprat contigkb lrgdpH;
probit ndis ttab ndis_lag  ddpndH growthL ldemL allytyp3 caprat contigkb logdstab lrgdpH;

/*mentioned in text*/
/*and add contig to the trade eqn*/
cdsimeq (ttab ttab_lag largdp lbrgdp lapop lbpop logdstab contigkb ldemL allytyp3 )
( ndis ndis_lag  ddpndH growthL ldemL allytyp3 caprat contigkb logdstab lrgdpH),
nofirst nosecond;

exit;
