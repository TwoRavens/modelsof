*Replication do files for Bader and Daxecker, A Chinese resource curse? The human rights effects of oil export dependence on China versus the United States, JPR forthcoming*
*Robustness Tests Table A1*

tsset ccode year


*Model 1, IV= oil flows*
xi: ologit  physint physintlag  lnChoil_constlag lnUSoil_constlag  demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store rob1 

*Model 2, Adjust oil export values by all exports to US and China (Oil exports to US and China divided by all exports to US and China, respectively)*
xi: ologit  physint physintlag  lnUSoil_allexplag lnChoil_allexplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store rob2

*Model 3, Control for arms exports to US and China*
xi: ologit  physint physintlag lnChoil_constcaplag lnUSoil_constcaplag demodummylag    USarms_gdplag Charms_gdplag   lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store rob3

*Model 4, add democracy interaction* 
xi: ologit  physint physintlag  c.lnChoil_constcaplag##i.demodummylag c.lnUSoil_constcapla##i.demodummylag     lngdplag lnpoplag incidencev412  i.year if year>1991, cluster(ccode)
est store rob4

*Model 5, Exclude potential outliers for US, Canada*
xi: ologit  physint physintlag   lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991&ccode!=20, cluster(ccode)
est store rob5

*Model 6, without lag of DV* 
xi: ologit  physint lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store rob6

outreg2 [rob1 rob2 rob3 rob4 rob5 rob6] using jbud_robusttableA1, word replace dec(3) 10pct drop(i.year)

*Figure A1: US Export Dependence*Democracy*
ologit  physint physintlag  c.lnChoil_constcaplag##i.demodummylag c.lnUSoil_constcapla##i.demodummylag     lngdplag lnpoplag incidencev412  i.year if year>1991, cluster(ccode)
margins demodummylag, at(lnUSoil_constcaplag=(0 (0.5) 8.5) )  atmeans pr(outcome(7)) 
marginsplot, x(lnUSoil_constcaplag ) xlab(0 (2) 8)   ciopts(lpattern(-)) recastci(rline) title("") saving(USdemfigureA1, replace)
