
**REPLICATION
tsset ccode year

*Model 1, main model with oil export values adjusted by exporter country population size* 
xi: ologit  physint physintlag   lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod1
xi: ologit  physint physintlag   lnChoil_const2709caplag lnUSoil_const2709caplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod1a

*Model 2, main model with  oil export values adjusted by exporter country GDP*
xi: ologit   physint physintlag  lnChoil_constgdplag lnUSoil_constgdplag demodummylag  lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod2

xi: ologit   physint physintlag  lnChoil_constgdplag2709 lnUSoil_constgdplag2709 demodummylag  lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod2a


*Model 3, Add discovery variable and interaction to show that long-term effect*
xi: ologit  physint physintlag  c.lnChoil_constcaplag##c.l.lnnewdiscovery c.lnUSoil_constcaplag##c.l.lnnewdiscovery demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod3
xi: ologit  physint physintlag  c.lnChoil_const2709caplag##c.l.lnnewdiscovery c.lnUSoil_const2709caplag##c.l.lnnewdiscovery demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod3a


*Model 4, Use first differences of oil rents and phsyical integrity to see whether short-term changes are associated with HR violations*
xi: ologit  d.physint physintlag   d.lnChoil_constcaplag d.lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod4
xi: ologit  d.physint physintlag   d.lnChoil_const2709caplag d.lnUSoil_const2709caplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
est store mod4a

*Model 5, relaxing parallel regression assumption with generalized ordinal logit for some IVs*
xi: gologit2  physint physintlag  lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)  pl(physintlag   lnChoil_constcaplag lnUSoil_constcaplag demodummylag) 
est store mod5
xi: gologit2  physint physintlag  lnChoil_const2709caplag lnUSoil_const2709caplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)  pl(physintlag   lnChoil_const2709caplag lnUSoil_const2709caplag demodummylag) 
est store mod5a



*Model 6, excluding non-oil producers*
xi: ologit  physint physintlag  lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991&oil!=0, cluster(ccode)
est store mod6
xi: ologit  physint physintlag  lnChoil_const2709caplag lnUSoil_const2709caplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991&oil!=0, cluster(ccode)
est store mod6a


outreg2 [mod1 mod1a mod2 mod2a] using jbud_reptable1, word drop(_Iyear*) replace dec(3) 10pct 
outreg2 [mod3 mod3a mod4 mod4a] using jbud_reptable2, word drop(_Iyear*) replace dec(3) 10pct 
outreg2 [mod5 mod5a mod6 mod6a] using jbud_reptable3, word drop(_Iyear*) replace dec(3) 10pct 
 



