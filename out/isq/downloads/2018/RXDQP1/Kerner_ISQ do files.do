
*replication files for “Why Should I Believe You: The Sources of Credibility in Bilateral Investment Treaties and their Effects” International Studies Quarterly (forthcoming)*
*the author can be reached at akerner@emory.edu*

* model 1a*

xtivreg2  FDI2_2000_mil l.FDI2_2000_mil  bit  Other_BITs polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

* model 1b*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  bit  Other_BITs polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe


*model 2a*

xtivreg2  FDI2_2000_mil l.FDI2_2000_mil  (bit  Other_BITs=    instrument_1  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

* model 2b*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (bit  Other_BITs=   instrument_1  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

*model 3*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (bit  Other_BITs  polsxOther_BITs=  polsxinstrument_2   instrument_1  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

* model 4*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (bit  Other_BITs   year1997xOther_BITs=   year1997xinstrument_2   instrument_1  instrument_2  instrument_3) polity_s  year1997 l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

* model 5*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (bit  Other_BITs   lsavingsxOther_BITs =    lsavingsxinstrument_2   instrument_1  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe


*model 6*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (  BIT_pre_arbitration_clause  BIT_post_arbitration_clause  Other_BITs =  instrument_1_pre_arbitration instrument_1_post_arbitration instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

* model 7*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (  BIT_pta Other_BITs_pta=dyadic2   instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe

* model 8*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  ( Other_BITs_pta= instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1 &  BIT_pta ==0, robust fe

* model 9*

xtivreg2   lnFDI2_2000 l.lnFDI2_2000  ( Other_BITs_pta= instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1 &  BIT_pta ==1, robust fe

* model 10 *

xtivreg2    lnFDI2_2000_ipolatez l.lnFDI2_2000_ipolatez  (bit Other_BITs_pta=dyadic2  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1 & year>=1982 , robust fe

* model 11 * 
collapse lnFDI2_2000  bit  Other_BITsdyadic2  instrument_2  instrument_3 polity_s  savings  polconiii_2002 tradegdp  pta  lngdp lnsourcegdp  worldgrowth  CAOI  OECDfounding  hoststatenonOECD, by( twoyear group)
gen timetrend = twoyear
gen timetrend2 = timetrend*timetrend
tsset group twoyear
xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (bit  Other_BITs=   instrument_1  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe


* model 12*
collapse lnFDI2_2000  bit  Other_BITsdyadic2  instrument_2  instrument_3 polity_s  savings  polconiii_2002 tradegdp  pta  lngdp lnsourcegdp  worldgrowth  CAOI  OECDfounding  hoststatenonOECD, by( fiveyear group)
gen timetrend = fiveyear
tsset group fiveyear
xtivreg2   lnFDI2_2000 l.lnFDI2_2000  (bit  Other_BITs=   instrument_1  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1, robust fe


* model 13* 

xtivreg2       Stock_2000_mil l.Stock_2000_mil  (bit    Other_BITs=dyadic2  instrument_2  instrument_3) polity_s  l.savings  polconiii_2002 l.tradegdp  pta  l.lngdp l.lnsourcegdp  worldgrowth  l.CAOI  timetrend timetrend2 if  OECDfounding ==1 &  hoststatenonOECD==1 , robust fe
