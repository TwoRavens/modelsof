*Replication von Soest and Wahman (2014) "Not all dictators are equal: Coups, fraudulent elections and the selective targeting of democratic sanctions" Journal of Peace Research


***Table I***

*Model 1

logit dmhr_sancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog) 

vif, uncentered

*Rare events model 1

relogit dmhr_sancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog) 


*Model 1 post-estimations

quietly logit dmhr_sancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog) 

prchange couprev,x (contelection==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000 ) rest (mean)level(90)

prvalue, x(couprev==1 contelection==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean) level(90)

prvalue, x(couprev==0 contelection==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean) level(90)

prchange contelection,x (couprev==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean)level(90)

prvalue, x ( contelection==1 couprev==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean)level(90)

prvalue ,x (contelection==0 couprev==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean)level(90)

prchange deltafhcl,x (couprev==0 contelection==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean)level(90)

prgen deltafhcl, from (0) to (+3) gen(prdeltacl) x (lnondmhrsancgoal==0 contelection==0 couprev==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean)

graph twoway connected prclp1 prclx


*Model 2

logit dmhrsancgoalBMR couprev ifhpol contelection deltafhcl lnondmhrsancgoal nodemsancBMRt1 nodemsancBMRt2 nodemsancBMRt3 if l.dmhrsancgoalBMR==0, cluster(ccode_qog) 

vif, uncentered

*Rare events model 2

relogit dmhrsancgoalBMR couprev ifhpol contelection deltafhcl lnondmhrsancgoal nodemsancBMRt1 nodemsancBMRt2 nodemsancBMRt3 if l.dmhrsancgoalBMR==0, cluster(ccode_qog) 

*Model 3

logit us_dmhrsancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal nousdemsanct1 nousdemsanct2 nousdemsanct3 if l.us_dmhrsancgoal==0, cluster(ccode_qog) 

*Rare events model 3

relogit us_dmhrsancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal nousdemsanct1 nousdemsanct2 nousdemsanct3 if l.us_dmhrsancgoal==0, cluster(ccode_qog) 

*Model 3 post estimations (Table II)

quietly logit us_dmhrsancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal nousdemsanct1 nousdemsanct2 nousdemsanct3 if l.us_dmhrsancgoal==0, cluster(ccode_qog) 

prchange couprev,x (contelection==0 lnondmhrsancgoal==0 nousdemsanct1==10 nousdemsanct2==100 nousdemsanct3==1000) rest (mean)level(90)

prvalue, x(couprev==1 contelection==0 lnondmhrsancgoal==0 nousdemsanct1==10 nousdemsanct2==100 nousdemsanct3==1000) rest (mean) level(90)

prvalue, x(couprev==0 contelection==0 lnondmhrsancgoal==0 nousdemsanct1==10 nousdemsanct2==100 nousdemsanct3==1000) rest (mean) level(90)


prchange contelection,x (couprev==0 lnondmhrsancgoal==0 nousdemsanct1==10 nousdemsanct2==100 nousdemsanct3==1000) rest (mean)level(90)

prvalue, x ( contelection==1 couprev==0 lnondmhrsancgoal==0 nousdemsanct1==10 nousdemsanct2==100 nousdemsanct3==1000) rest (mean)level(90)

prvalue ,x (contelection==0 couprev==0 lnondmhrsancgoal==0 nousdemsanct1==10 nousdemsanct2==100 nousdemsanct3==1000) rest (mean)level(90)

*Model 4

logit eu_dmhrsancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal noeudemsanct1 noeudemsanct2 noeudemsanct3 if l.eu_dmhrsancgoal==0, cluster(ccode_qog) 

*Rare events model 4

relogit eu_dmhrsancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal noeudemsanct1 noeudemsanct2 noeudemsanct3 if l.eu_dmhrsancgoal==0, cluster(ccode_qog) 

*Model 4 postestimations (Table II)

quietly logit eu_dmhrsancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal noeudemsanct1 noeudemsanct2 noeudemsanct3 if l.eu_dmhrsancgoal==0, cluster(ccode_qog) 

prvalue, x(couprev==1 contelection==0 lnondmhrsancgoal==0 noeudemsanct1==10 noeudemsanct2==100 noeudemsanct3==1000) rest (mean) level(90)

prvalue, x(couprev==0 contelection==0 lnondmhrsancgoal==0 noeudemsanct1==10 noeudemsanct2==100 noeudemsanct3==1000) rest (mean) level(90)

prchange contelection,x (couprev==0 lnondmhrsancgoal==0 noeudemsanct1==10 noeudemsanct2==100 noeudemsanct3==1000) rest (mean)level(90)

prvalue, x ( contelection==1 couprev==0 lnondmhrsancgoal==0 noeudemsanct1==10 noeudemsanct2==100 noeudemsanct3==1000) rest (mean)level(90)

prvalue ,x (contelection==0 couprev==0 lnondmhrsancgoal==0 noeudemsanct1==10 noeudemsanct2==100 noeudemsanct3==1000) rest (mean)level(90)



**Table III**


*Model 5

logit dmhr_sancgoal couprev contelection protest l.wdigdpgrocap l.wdiinflationgdpfrac l.gdpconstantcapita1000 l.westorgtie l.blackknight l.westtradelog l.wdi_fdi l.oilmil lnondmhrsancgoal l.agree2un_westimp2 t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog)

vif, uncentered

*Rare events model 5

relogit dmhr_sancgoal couprev contelection protest lwdigdpgrocap lwdiinflationgdpfrac lgdpconstantcapita1000 lwestorgtie lblackknight lwesttradelog lwdi_fdi loilmil lnondmhrsancgoal lagree2un_westimp2 t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog)

*Correcting for multicollinearity model 5

*Westtradelog- exclude lgdpconstantcapita1000 lwestorgtie loilmil l.agree2un_westimp2    
logit dmhr_sancgoal couprev contelection protest l.wdigdpgrocap l.wdiinflationgdp l.blackknight l.westtradelog l.wdi_fdi lnondmhrsancgoal t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog)

vif, uncentered

* agree2un_westimp2- excluding polynominals, blackknights & westorgtie

logit dmhr_sancgoal couprev contelection protest l.wdigdpgrocap l.wdiinflationgdpfrac l.gdpconstantcapita1000 l.westtradelog l.wdi_fdi l.oilmil lnondmhrsancgoal l.agree2un_westimp2 if l.dmhr_sancgoal==0, cluster(ccode_qog)

vif, uncentered

* westorgtie - excluding l.westtradelog l.oilmil

logit dmhr_sancgoal couprev contelection protest l.wdigdpgrocap l.wdiinflationgdpfrac l.gdpconstantcapita1000 l.westorgtie l.blackknight l.wdi_fdi lnondmhrsancgoal l.agree2un_westimp2 t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog)

vif, uncentered

*Model 6

logit dmhrsancgoalBMR couprev contelection protest l.wdigdpgrocap l.wdiinflationgdpfrac l.gdpconstantcapita1000 l.westorgtie l.blackknight l.westtradelog l.wdi_fdi l.oilmil lnondmhrsancgoal l.agree2un_westimp2 nodemsancBMRt1 nodemsancBMRt2 nodemsancBMRt3 if l.dmhrsancgoalBMR==0, cluster(ccode_qog) 

vif, uncetered

*Model 7 

logit dmhr_sancgoal couprev i.contelection##c.l.wdi_fdi l.gdpconstantcapita1000 protest l.wdiinflationgdpfrac l.wdigdpgrocap l.westorgtie l.blackknight l.westtradelog l.oilmil lnondmhrsancgoal l.agree2un_westimp2 t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog) 

*Figure 2

margins contelection, at(l.wdi_fdi=(0(2)20) couprev==0)

set scheme lean2

marginsplot, xdimension(l.wdi_fdi) yline(0) plot1opts(recast(line) lwidth(.8) lpattern(dash_dot) lcolor(gs10)) plot2opts(recast(line) lwidth(.8) lpattern(dash)) ci1opts(recast(rline) lcolor(gs10) lpattern(dash_dot)) ci2opts(recast(rline) lpattern(dash)) level (90)



**Online Appendix**

**Figure 3** 


logit dmhr_sancgoal couprev ifhpol contelection deltafhcl lnondmhrsancgoal t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog) 

prchange deltafhcl,x (couprev==0 contelection==0 lnondmhrsancgoal==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean)level(90)

prgen deltafhcl, from (0) to (+3) gen(prdeltacl) x (lnondmhrsancgoal==0 contelection==0 couprev==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000) rest (mean) ci delta level(90)


graph twoway connected prclp1 prdeltaclp1lb prdeltaclp1ub  prclx 



**Figure 4**

logit dmhr_sancgoal contelection ifhpol lnondmhrsancgoal c.deltaifhpol##i.couprev t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog) 

margins couprev, at(deltaifhpol=(-3(1)0)contelection==0 t1nodmhrsancgoal==10 t2nodmhrsancgoal==100 t3nodmhrsancgoal==1000)

set scheme lean2

marginsplot, xdimension(deltaifhpol) yline(0) plot1opts(recast(line) lwidth(.8) lpattern(dash_dot) lcolor(gs10)) plot2opts(recast(line) lwidth(.8) lpattern(dash)) ci1opts(recast(rline) lcolor(gs10) lpattern(dash_dot)) ci2opts(recast(rline) lpattern(dash)) level (90)

**Table IV** 

*Model 8
logit eu_dmhrsancgoal bruxdist couprev ifhpol contelection deltafhcl lnondmhrsancgoal noeudemsanct1 noeudemsanct2 noeudemsanct3 if l.eu_dmhrsancgoal==0, cluster(ccode_qog)

*Model 9
logit us_dmhrsancgoal washdist couprev ifhpol contelection deltafhcl lnondmhrsancgoal nousdemsanct1 nousdemsanct2 nousdemsanct3 if l.us_dmhrsancgoal==0, cluster(ccode_qog)


* Table V 

*Model 10
logit eu_dmhrsancgoal couprev ifhpol contelection deltafhcl Asia  Pacific la me postcommunist lnondmhrsancgoal noeudemsanct1 noeudemsanct2 noeudemsanct3 if l.eu_dmhrsancgoal==0, cluster(ccode_qog)

*Model 11
logit us_dmhrsancgoal couprev ifhpol contelection deltafhcl Asia  Pacific la me postcommunist lnondmhrsancgoal nousdemsanct1 nousdemsanct2 nousdemsanct3 if l.us_dmhrsancgoal==0, cluster(ccode_qog)


* Table VII 

quietly logit dmhr_sancgoal couprev contelection protest l.wdigdpgrocap l.wdiinflationgdp l.gdpconstantcapita1000 l.westorgtie l.blackknight l.westtradelog l.wdi_fdi l.oilmil lnondmhrsancgoal l.agree2un_westimp2 t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0, cluster(ccode_qog)

*Model 12

logit dmhr_sancgoal couprev contelection protest l.wdigdpgrocap l.wdiinflationgdp l.gdpconstantcapita1000 l.westorgtie l.blackknight l.westtradelog l.countbit l.oilmil lnondmhrsancgoal l.agree2un_westimp2 t1nodmhrsancgoal t2nodmhrsancgoal t3nodmhrsancgoal if l.dmhr_sancgoal==0 & e(sample), cluster(ccode_qog)




