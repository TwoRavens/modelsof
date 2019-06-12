xtset ccodesrc year

********
*H1a: As US mil aid increases, cooperative behavior increases
*H3b: As US mil aid increases, cooperative behavior decreases
*******
***Equation 1*******

xtivreg2  f.behavior (logmilitaryaid = usgdppc  militaryaid2nd) logeconomicaid behavior loggdp2000 demsrc logtrps s_un_glo , fe robust

adjust logmilitaryaid=0 
adjust logmilitaryaid=8.12 
adjust logmilitaryaid=3.49 
adjust logmilitaryaid=5.45 

adjust logtrps=0
adjust logtrps=12.33
adjust logtrps=7.34
adjust logtrps=9.23

adjust demsrc=0
adjust demsrc=1


********
*H1b: As dependence on US mil aid increases, cooperative behavior increases
*H2a: As dependence on US mil aid increases, cooperative behavior decreases
*******
*******
*** Equation 2*******

xtivreg2  f.behavior (milaiddep2 = milaiddep2nd milaiddep3rd  ) econaiddep2 behavior loggdp2000 demsrc logtrps s_un_glo, fe robust


************
********
*H1c: cooperative behavior will be rewarded with increases in aid, the US will decrease or eliminate military assistance to states that are not cooperative
*H3c: the US will not reduce aid when countries are uncooperative
*******
*******
*** Equation 3*******

xtivreg2 difmilaid (L.difbeh=l.difbeh2nd l.difbeh3rd) L.militaryaid  L.loggdp2000 L.demsrc L.logtrps L.s_un_glo, fe robust


*************************************
***************************************
********
*H3a: States that are perceived as important to US security will be more likely to receive aid, but aid will be less likely to increase their cooperation
*******
*******
*** Equation 4*******

heckman behavior l.allies l.logmilitaryaid l.allyaid2 l.behavior l.demsrc l.logtrps l.loggdp2000 l.logeconomicaid if CINC_score<.02 &  ccodesrc!=666, 
	select(milalloc= l.allies l.logmilitaryaid l.behavior l.demsrc l.logtrps l.loggdp2000 l.logeconomicaid ) robust cluster(ccodesrc)



************************
* Robustness check
************************

***Equation 1*******

xtivreg2  f.behavior (logmilitaryaid =sep11 usgdppc  militaryaid2nd) logeconomicaid loggdp2000 demsrc logtrps behavior s_un_glo, fe robust

xtivreg2  f.behavior (logmilitaryaid = usgdppc  militaryaid2nd) logeconomicaid loggdp2000 demsrc logtrps behavior s3un, fe robust

xtivreg2  f.behavior (logmilitaryaid = usgdppc  militaryaid2nd) logeconomicaid demsrc logtrps behavior s_un_glo milexp_2005, fe robust

xtivreg2  f.behavior (logmilitaryaid = usgdppc  militaryaid2nd) logeconomicaid loggdp2000 demsrc logtrps behavior s_un_glo physint, fe robust

xtivreg2  f.behavior (logmilitaryaid = usgdppc  militaryaid2nd) logeconomicaid loggdp2000 demsrc logtrps behavior s_un_glo usbehavior, fe robust

xtivreg2  f.behavior (logmilitaryaid = usgdppc  militaryaid2nd) logeconomicaid loggdp2000 demsrc logtrps behavior s_un_glo if milaiddep2>0, fe robust

***Equation 2*******

xtivreg2  f.behavior (milaiddep2 =sep11 milaiddep3rd  milaiddep2nd) econaiddep2 loggdp2000 demsrc logtrps behavior s_un_glo, fe robust

xtivreg2  f.behavior (milaiddep2 = milaiddep3rd  milaiddep2nd) econaiddep2 loggdp2000 demsrc logtrps behavior s3un, fe robust

xtivreg2  f.behavior (milaiddep2 = milaiddep3rd  milaiddep2nd) econaiddep2 demsrc logtrps behavior s_un_glo milexp_2005, fe robust

xtivreg2  f.behavior (milaiddep2 = milaiddep3rd  milaiddep2nd) econaiddep2 loggdp2000 demsrc logtrps behavior s_un_glo physint, fe robust

xtivreg2  f.behavior (milaiddep2 = milaiddep3rd  milaiddep2nd) econaiddep2 loggdp2000 demsrc logtrps behavior s_un_glo usbehavior, fe robust

xtivreg2  f.behavior (milaiddep2 = milaiddep3rd  milaiddep2nd) econaiddep2 loggdp2000 demsrc logtrps behavior s_un_glo if milaiddep2>0, fe robust


***Equation 3*******

xtivreg2 difmilaid (L.difbeh=l.sep11 l.difbeh2nd l.difbeh3rd) L.militaryaid  L.loggdp2000 L.demsrc L.logtrps L.s_un_glo, fe robust

xtivreg2 difmilaid (L.difbeh=l.difbeh2nd l.difbeh3rd) L.militaryaid  L.loggdp2000 L.demsrc L.logtrps L.s3un, fe 

xtivreg2 difmilaid (L.difbeh=l.difbeh2nd l.difbeh3rd) L.militaryaid  L.demsrc L.logtrps L.s_un_glo L.milexp_2005, fe 

xtivreg2 difmilaid (L.difbeh=l.difbeh2nd l.difbeh3rd) L.militaryaid  L.loggdp2000 L.demsrc L.logtrps L.s_un_glo L.physint, fe 

xtivreg2 difmilaid (L.difbeh=l.difbeh2nd l.difbeh3rd) L.militaryaid  L.loggdp2000 L.demsrc L.logtrps L.s_un_glo if milaiddep2>0, fe robust

***Equation 4*******

heckman F.behavior allies logmilitaryaid allyaid2 behavior demsrc logtrps logeconomicaid milexp_2005 if CINC_score<.02 & ccodesrc!=666, select(F.milalloc= allies logmilitaryaid behavior demsrc logtrps logeconomicaid milexp_2005) robust cluster(ccodesrc)
outreg using robust, se 3aster bfmt(f) coefastr replace

heckman F.behavior allies logmilitaryaid allyaid2 behavior demsrc logtrps loggdp2000 logeconomicaid if CINC_score<.02 & ccodesrc!=666, select(F.milalloc= allies logmilitaryaid behavior demsrc logtrps loggdp2000 logeconomicaid physint) robust cluster(ccodesrc)
outreg using robust, se 3aster bfmt(f) coefastr append

heckman F.behavior allies logmilitaryaid allyaid2 behavior demsrc logtrps loggdp2000 logeconomicaid usbehavior if CINC_score<.02 & ccodesrc!=666, select(F.milalloc= allies logmilitaryaid behavior demsrc logtrps loggdp2000 logeconomicaid physint) robust cluster(ccodesrc)
outreg using robust, se 3aster bfmt(f) coefastr append

