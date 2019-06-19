set memory 100m
tab ccode, gen(Iccode)
tab year, gen(time)

*Table 1

sum polity2 exconst2 exrec2 polcomp2 if petro_nx_3year!=. &D.exconst2!=.&growth!=., 
sum polity2 trans_democ trans_autoc regtrans_d if petro_nx_3year!=. &growth!=. &D.polity2!=., 


*Table 2. Oil Price Shocks and Democracy

xtreg D.polity2 L(0/2).petro_nx_index_growth  time* if D.exconst2!=. &growth!=., fe  cluster(ccode)
xtreg D.exconst2  L(0/2).petro_nx_index_growth time* if growth!=.  ,fe cluster(ccode)
xtreg D.exrec2  L(0/2).petro_nx_index_growth  time* if growth!=. , fe cluster(ccode)
xtreg D.polcomp2  L(0/2).petro_nx_index_growth time* if growth!=., fe  cluster(ccode)

xtreg D.polity2  petro_nx_3year time* if D.exconst2!=. &growth!=. ,fe  cluster(ccode)
xtreg D.exconst2 petro_nx_3year time* if growth!=.,   fe  cluster(ccode)
xtreg D.exrec2  petro_nx_3year time* if growth!=.,   fe  cluster(ccode)
xtreg D.polcomp2  petro_nx_3year time* if growth!=.,  fe  cluster(ccode)

*Table 3. Oil Price Shocks, Democracy, and Polity Convergence

xtreg D.polity2 L.polity2 petro_nx_3year time* if D.exconst2!=. &growth!=.,      fe  cluster(ccode)
xtreg D.exconst2 L.exconst2 petro_nx_3year time* if growth!=., fe  cluster(ccode)
xtreg D.exrec2 L.exrec2 petro_nx_3year time* if growth!=.,  fe  cluster(ccode)
xtreg D.polcomp2 L.polcomp2 petro_nx_3year time* if growth!=.,  fe  cluster(ccode)

xtabond2 D.polity2 L.polity2 petro_nx_3year time* Iccode* if D.exconst2!=. &growth!=., gmm( petro_nx_3year , lag (1 1)) gmm(L.polity2, lag (1 1)) cluster(ccode) iv ( time* Iccode*) 
xtabond2 D.exconst2 L.exconst2 petro_nx_3year time* Iccode* if D.exconst2!=. &growth!=.,  gmm( petro_nx_3year , lag (1 1))   gmm(L.exconst2, lag (1 1)) cluster(ccode)  iv (time* Iccode*) 
xtabond2 D.exrec2 L.exrec2 petro_nx_3year time* Iccode* if D.exrec2!=. &growth!=.,  gmm( petro_nx_3year , lag (1 1))   gmm(L.exrec2, lag (1 1)) cluster(ccode)  iv (time* Iccode*) 
xtabond2 D.polcomp2 L.polcomp2 petro_nx_3year time* Iccode* if D.polcomp2!=. &growth!=.,  gmm( petro_nx_3year , lag (1 1))   gmm(L.polcomp2, lag (1 1)) cluster(ccode)  iv (time* Iccode*) 


*Table 4. Persistent Effects of Oil Price Shocks on the Level of Per Capita GDP

xtreg growth (petro_nx_index_growth ) L.lcgdp time* if D.exconst2!=. &petro_nx_3year!=. ,fe cluster(ccode) 
xtreg growth_3year L(3).(petro_nx_index_growth ) L4.lcgdp time*  if D.exconst2!=.  &petro_nx_3year!=. ,fe cluster(ccode) 
xtreg growth_5year L(5).(petro_nx_index_growth ) L6.lcgdp time*  if D.exconst2!=. &petro_nx_3year!=. ,fe cluster(ccode) 
xtreg growth_10year L(10).(petro_nx_index_growth ) L11.lcgdp time*  if D.exconst2!=. &petro_nx_3year!=. ,fe cluster(ccode) 

xtabond2 growth(petro_nx_index_growth ) L.lcgdp time* Iccode* if D.exconst2!=. &petro_nx_3year!=.,cluster(ccode) gmm(L.lcgdp , lag ( 1 3))gmm(petro_nx_index_growth , lag ( 1 3)) iv(time* Iccode*  ) 
xtabond2 growth_3year L(3).(petro_nx_index_growth ) L4.lcgdp time* Iccode*  if D.exconst2!=. &petro_nx_3year!=.  , cluster(ccode) gmm(L4.lcgdp L3.petro_nx_index_growth , lag ( 1 3)) iv(time* Iccode*  ) 
xtabond2 growth_5year L(5).(petro_nx_index_growth ) L6.lcgdp time* Iccode*  if D.exconst2!=. &petro_nx_3year!=. ,cluster(ccode) gmm(L6.lcgdp L5.petro_nx_index_growth , lag ( 1 3)) iv(time* Iccode*  ) 
xtabond2 growth_10year L(10).(petro_nx_index_growth ) L11.lcgdp time* Iccode*  if D.exconst2!=. &petro_nx_3year!=. ,  cluster(ccode) gmm(L11.lcgdp L10.petro_nx_index_growth, lag ( 1 3)) iv(time* Iccode*  ) 

*Table 5. Persistent Effects of Oil Price Shocks on the Level of Democracy

xtreg D.polity2 (petro_nx_index_growth ) L.polity2 time* if D.exconst2!=. &growth!=. &petro_nx_3year!=.,fe cluster(ccode) 
xtreg polity_3year L(3).(petro_nx_index_growth ) L4.polity2 time*  if D.exconst2!=. &growth!=. &petro_nx_3year!=. ,fe cluster(ccode) 
xtreg polity_5year L(5).(petro_nx_index_growth ) L6.polity2 time*  if D.exconst2!=. &growth!=. &petro_nx_3year!=.,fe cluster(ccode) 
xtreg polity_10year L(10).(petro_nx_index_growth ) L11.polity2 time*  if D.exconst2!=. &growth!=. &petro_nx_3year!=.,fe cluster(ccode) 

xtabond2 D.polity2 (petro_nx_index_growth ) L.polity2 time* Iccode* if D.exconst2!=. &growth!=. &petro_nx_3year!=.,cluster(ccode) gmm(L.polity2 petro_nx_index_growth , lag ( 1 3)) iv(time* Iccode*  ) 
xtabond2 polity_3year L(3).(petro_nx_index_growth ) L4.polity2 time* Iccode*  if D.exconst2!=. &growth!=. &petro_nx_3year!=. , cluster(ccode) gmm(L4.polity2 L3.petro_nx_index_growth , lag ( 1 3)) iv(time* Iccode*  ) 
xtabond2 polity_5year L(5).(petro_nx_index_growth ) L6.polity2 time* Iccode*  if D.exconst2!=. &growth!=. &petro_nx_3year!=.,cluster(ccode) gmm(L6.polity2 L5.petro_nx_index_growth , lag ( 1 3)) iv(time* Iccode*  ) 
xtabond2 polity_10year L(10).(petro_nx_index_growth ) L11.polity2 time* Iccode*  if D.exconst2!=. &growth!=. &petro_nx_3year!=.,  cluster(ccode) gmm(L11.polity2 L10.petro_nx_index_growth,lag ( 1 3)) iv(time* Iccode*  ) 


***Table 6. Oil price shocks, income and democracy
xtreg D.polity2 L.polity2 growth time* if D.exconst2!=. &petro_nx_3year!=., fe    cluster(ccode)
xtreg D.exconst2 L.exconst2 growth time* if D.exconst2!=. &petro_nx_3year!=., fe    cluster(ccode)
xtreg D.exrec2 L.exrec2 growth time* if D.exconst2!=. &petro_nx_3year!=., fe    cluster(ccode)
xtreg D.polcomp2 L.polcomp2 growth time* if D.exconst2!=. &petro_nx_3year!=., fe    cluster(ccode)

xtivreg2 D.polity2 L.polity2 time* (growth= petro_nx_3year) if D.exconst2!=.  , fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exconst2 L.exconst2 time* (growth=petro_nx_3year) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exrec2 L.exrec2 time* (growth=petro_nx_3year) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.polcomp2 L.polcomp2 time* (growth=petro_nx_3year) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst 

*Table 7. Table 7. Oil Price Shocks, Income, and Democracy (Test of Exclusion Restriction)
*lagged income
xtivreg2 D.polity2 L.polity2  petro_nx_3year  time* (growth=  L2.lcgdp  ) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.exconst2 L.exconst2 petro_nx_3year  time* (growth=  L2.lcgdp  ) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.exrec2 L.exrec2 petro_nx_3year  time* (growth=  L(2).lcgdp  ) if D.exconst2!=., fe  cluster(ccode) fwl(time*)  ffirst 
xtivreg2 D.polcomp2 L.polcomp2 petro_nx_3year  time* (growth=  L(2).lcgdp  ) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst  

xtivreg2 D.polity2 L.polity2  time* (growth=  L2.lcgdp petro_nx_3year   ) if D.exconst2!=., fe cluster(ccode) fwl(time*) 
xtivreg2 D.exconst2 L.exconst2 time* (growth=  L2.lcgdp petro_nx_3year   ) if D.exconst2!=., fe cluster(ccode) fwl(time*) 
xtivreg2 D.exrec2 L.exrec2 time* (growth=  L(2).lcgdp petro_nx_3year   ) if D.exconst2!=., fe  cluster(ccode) fwl(time*)   
xtivreg2 D.polcomp2 L.polcomp2 time* (growth=  L(2).lcgdp petro_nx_3year   ) if D.exconst2!=., fe  cluster(ccode) fwl(time*)   

*Table 8. Oil Price Shocks, Income, and Democracy (Test of Exclusion Restriction)
*lagged saving rate

xtivreg2 D.polity2 L.polity2  time* (growth=  DL2.saving petro_nx_3year) if D.exconst2!=., fe cluster(ccode) fwl(time*) 
xtivreg2 D.exconst2 L.exconst2 time* (growth=  DL2.saving petro_nx_3year) if D.exconst2!=., fe cluster(ccode) fwl(time*) 
xtivreg2 D.exrec2 L.exrec2 time* (growth=  DL(2).saving petro_nx_3year) if D.exconst2!=., fe  cluster(ccode) fwl(time*)   
xtivreg2 D.polcomp2 L.polcomp2 time* (growth=  DL(2).saving petro_nx_3year) if D.exconst2!=., fe  cluster(ccode) fwl(time*)   

xtivreg2 D.polity2 L.polity2  petro_nx_3year  time* (growth=  DL2.saving) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.exconst2 L.exconst2 petro_nx_3year  time* (growth=  DL2.saving) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.exrec2 L.exrec2 petro_nx_3year  time* (growth=  DL(2).saving) if D.exconst2!=., fe  cluster(ccode) fwl(time*)  ffirst 
xtivreg2 D.polcomp2 L.polcomp2 petro_nx_3year  time* (growth=  DL(2).saving) if D.exconst2!=., fe cluster(ccode) fwl(time*)   ffirst

*Table 9. Robustness I: Excluding Major Oil Producers and Oil Consumers

xtivreg2 D.polity2 L.polity2 time* (growth=petro_nx_3year) if D.exconst2!=. &petroleum_worldshare<0.01, fe cluster(ccode) fwl(time*)   ffirst
xtivreg2 D.exconst2 L.exconst2 time* (growth=petro_nx_3year) if D.exconst2!=. &petroleum_worldshare<0.01, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exrec2 L.exrec2 time* (growth=petro_nx_3year) if D.exconst2!=.&petroleum_worldshare<0.01, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.polcomp2 L.polcomp2 time* (growth=petro_nx_3year) if D.exconst2!=.&petroleum_worldshare<0.01, fe cluster(ccode) fwl(time*) ffirst 

*Table 10. Robustness II: Oil Exporters Only
xtivreg2 D.polity2 L.polity2 time* (growth=petro_nx_3year) if D.exconst2!=. &exporter_d==1 , fe cluster(ccode) fwl(time*)   ffirst
xtivreg2 D.exconst2 L.exconst2 time* (growth=petro_nx_3year) if D.exconst2!=. &exporter_d==1, fe cluster(ccode) fwl(time*)  ffirst 
xtivreg2 D.exrec2 L.exrec2 time* (growth=petro_nx_3year) if D.exconst2!=.&exporter_d==1, fe cluster(ccode) fwl(time*)   ffirst
xtivreg2 D.polcomp2 L.polcomp2 time* (growth=petro_nx_3year) if D.exconst2!=.&exporter_d==1, fe cluster(ccode) fwl(time*) ffirst  

*Table 11. Robustness III: Is the Relationship Different for OPEC? 
xtivreg2 D.polity2 L.polity2 time* (growth growth_opec=petro_nx_3year petro_nx_3year_opec2) if D.exconst2!=. , fe cluster(ccode) fwl(time*) ffirst 
lincom growth +growth_opec 
xtivreg2 D.exconst2 L.exconst2 time* (growth growth_opec=petro_nx_3year petro_nx_3year_opec2) if D.exconst2!=. , fe cluster(ccode) fwl(time*) ffirst
lincom growth +growth_opec
xtivreg2 D.exrec2 L.exrec2 time* (growth growth_opec=petro_nx_3year petro_nx_3year_opec2) if D.exconst2!=. , fe cluster(ccode) fwl(time*) ffirst 
lincom growth +growth_opec
xtivreg2 D.polcomp2 L.polcomp2 time* (growth growth_opec=petro_nx_3year petro_nx_3year_opec2) if D.exconst2!=., fe cluster(ccode) fwl(time*) ffirst 
lincom growth +growth_opec

*Table 12. Robustness IV: Time Period Sample Split 
xtivreg2 D.polity2  time* (growth=petro_nx_3year) if D.exconst2!=.&year<=1987, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exconst2 time* (growth=petro_nx_3year) if D.exconst2!=.&year<1988, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exrec2  time* (growth=petro_nx_3year) if D.exconst2!=.&year<1988, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.polcomp2  time* (growth=petro_nx_3year) if D.exconst2!=.&year<1988, fe cluster(ccode) fwl(time*) ffirst 

xtivreg2 D.polity2  time* (growth=petro_nx_3year) if D.exconst2!=. &year>1987, fe cluster(ccode) fwl(time*) first 
xtivreg2 D.exconst2  time* (growth=petro_nx_3year) if D.exconst2!=. &year>1987, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exrec2  time* (growth=petro_nx_3year) if D.exconst2!=. &year>1987, fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.polcomp2  time* (growth=petro_nx_3year) if D.exconst2!=. &year>1987, fe cluster(ccode) fwl(time*) ffirs

*Table 13. Robustness V: Using Net-Export Shares in 1970 and Restricting the Sample to Post-1970

xtivreg2 D.polity2 L.polity2 time* (growth=petro_nx_3year_70) if D.exconst2!=. &year>1970 , fe cluster(ccode) fwl(time*) first 
xtivreg2 D.exconst2 L.exconst2 time* (growth=petro_nx_3year_70) if D.exconst2!=.  &year>1970 , fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.exrec2 L.exrec2 time* (growth=petro_nx_3year_70) if D.exconst2!=.  &year>1970 , fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 D.polcomp2 L.polcomp2 time* (growth=petro_nx_3year_70) if D.exconst2!=.  &year>1970 , fe cluster(ccode) fwl(time*) ffirst

*Table 14. Robustness VI: Including Interregnum Periods and Using Transition Indicators
xtivreg2 D.polity2 L.polity2 time* (growth=petro_nx_3year)  , fe cluster(ccode) fwl(time*) ffirst
xtivreg2 trans_democ time* (growth=petro_nx_3year) if D.polity2!=. , fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 trans_autoc time* (growth=petro_nx_3year) if D.polity2!=. ,fe cluster(ccode) fwl(time*) ffirst 
xtivreg2 regtrans_ch time* (growth = petro_nx_3year) if D.polity2!=., cluster(ccode) fe ffirst

*Table 15. Robustness VII: Alternative Democracy Indicators (Note: polright, fh_ind, and reg are inverse indicators of democracy)
xtivreg2 D.polright L.polright time* (growth=petro_nx_3year)  , fe cluster(ccode) fwl(time*) 
xtivreg2 D.fh_ind L.fh_ind time* (growth=petro_nx_3year)  , fe cluster(ccode) fwl(time*) 
xtivreg2 D.reg L.reg time* (growth=petro_nx_3year)  , fe cluster(ccode) fwl(time*) 
xtivreg2 D.ev_ps1 L.ev_ps1 time* (growth=petro_nx_3year)  , fe cluster(ccode) fwl(time*) 

*Table 16. Robustness VIII: World Bank GDP Data (Note: polright, fh_ind, and reg are inverse indicators of democracy)

xtivreg2 D.polity2 L.polity2 time* (growth_wdi=petro_nx_3year) if abs(D.lgdp_wdi)<0.3 , fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.polright L.polright time* (growth_wdi=petro_nx_3year) if abs(D.lgdp_wdi)<0.3 , fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.fh_ind L.fh_ind time* (growth_wdi=petro_nx_3year) if abs(D.lgdp_wdi)<0.3  , fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.reg L.reg  time* (growth_wdi=petro_nx_3year) if abs(D.lgdp_wdi)<0.3  , fe cluster(ccode) fwl(time*) ffirst
xtivreg2 D.ev_ps1 L.ev_ps1 time* (growth_wdi=petro_nx_3year) if abs(D.lgdp_wdi)<0.3  , fe cluster(ccode) fwl(time*) ffirst

