*Replication do files for Bader and Daxecker, A Chinese resource curse? The human rights effects of oil export dependence on China versus the United States, JPR forthcoming*
**TABLE 1**

tsset ccode year

*Model 1, main model with oil export values adjusted by exporter country population size* 
xi: ologit  physint physintlag   lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod1

*Model 2, main model with  oil export values adjusted by exporter country GDP*
xi: ologit   physint physintlag  lnChoil_constgdplag lnUSoil_constgdplag demodummylag  lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod2

*Model 3, Add discovery variable and interaction to show that long-term effect*
xi: ologit  physint physintlag  c.lnChoil_constcaplag##c.l.lnnewdiscovery c.lnUSoil_constcaplag##c.l.lnnewdiscovery demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod3

*Model 4, Use first differences of oil rents and phsyical integrity to see whether short-term changes are associated with HR violations*
xi: ologit  d.physint physintlag   d.lnChoil_constcaplag d.lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod4

*Model 5, relaxing parallel regression assumption with generalized ordinal logit for some IVs*
xi: gologit2  physint physintlag  lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)  pl(physintlag   lnChoil_constcaplag lnUSoil_constcaplag demodummylag) 
est store mod5

*Model 6, excluding non-oil producers*
xi: ologit  physint physintlag  lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991&oil!=0, cluster(ccode)
est store mod6

outreg2 [mod1 mod2 mod3 mod4 mod5 mod6] using jbud_reptable1, word drop(_Iyear*) replace dec(3) 10pct 

