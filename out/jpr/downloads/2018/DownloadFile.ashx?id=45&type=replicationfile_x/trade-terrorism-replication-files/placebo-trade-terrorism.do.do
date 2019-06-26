
***This file contains replication commands (Stata 13 was used) for the paper, entiltled, "Trade and terrorism: A disaggregated approach" 
***by Subhayu Bandyopadhyay, Todd Sandler, and Javed Younas
***forthcoming in Journal of Peace Research 
***upload trade-terrorism.dta stata data set for running these regressions.
***See excel file for the description of variables. Refer to the paper for more information.   


*****PLACEBO TESTS******

***Before running these placebos regressions, first run the variables transformation commands in terrorism-trade.do file

/**TABLE IV**/
***PLACEBO TEST 1(a)
***Fixed EFFECT
***Total trade (exp+imp)
xi: xtreg ltrv1 domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4 domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14 domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp1 tratp1) 

***Total exp
xi: xtreg ltrv1_e domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_e domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_e domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp1 tratp1) 

***Total imp
xi: xtreg ltrv1_i domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_i domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_i domtp1 tratp1 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp1 tratp1)
 
***PLACEBO TEST 1(b)
***Fixed EFFECT
***Total trade (exp+imp)
xi: xtreg ltrv1 domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4 domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14 domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp3 tratp3 

***Total exp
xi: xtreg ltrv1_e domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_e domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_e domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp3 tratp3) 

***Total imp
xi: xtreg ltrv1_i domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_i domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_i domtp3 tratp3 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp3 tratp3)
 
 
*************//////////****************** 
  
*****SOME MORE PLACEBO TESTS, NOT REPORTED IN THE PAPER******* 
**Fixed EFFECT
***Total trade (exp+imp)
xi: xtreg ltrv1 domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4 domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14 domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp2 tratp2) 

***Total exp
xi: xtreg ltrv1_e domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_e domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
eststo m2

xi: xtreg ltrv14_e domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp2 tratp2)

***Total imp
xi: xtreg ltrv1_i domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_i domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_i domtp2 tratp2 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp2 tratp2) 

***Fixed EFFECT
***Total trade (exp+imp)
xi: xtreg ltrv1 domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4 domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14 domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp4 tratp4) 

***Total exp
xi: xtreg ltrv1_e domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_e domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_e domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp4 tratp4) 

***Total imp
xi: xtreg ltrv1_i domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m1

xi: xtreg ltrv4_i domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m2

xi: xtreg ltrv14_i domtp4 tratp4 lgdp lgdppc regional custrict11 i.year, fe cl(pairid)
est sto m3

esttab m1 m2 m3, b(%7.3f) se(%7.3f) star stats(N) title("Placebo Tests") keep(domtp4 tratp4)

log close 
 

