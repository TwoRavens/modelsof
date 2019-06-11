


*use "PSRM+Lee+sic87+tariffs+1989-1998+sum.dta", clear

d dy2 dy1 year
sum dy2 dy1 year
sum tfc_ tfd_ if dy1==1988

********************************************************************************
*Table A1: Summary Statistics
********************************************************************************
sum dy1 year if data1ylag==1
sum tfc_ tfd_ BRdisadv BRR indcon geocon size polcon1 grfd1con_ RDcon_ psg50dcon1_ h50con1_ pivotalcon safecon safe4con safe4gcon if data1ylag==1

xtset sic dy1

********************************************************************************
*TABLE 1: Partisan Dominance and Tariffs 
********************************************************************************
*DV: Tariffs on Total Imports
xtregar tfc_ BRdisadv grfd1con_ geocon size ltfc_, fe
 estimates store m11
xtregar tfc_ BRdisadv grfd1con_ geocon size ltfc_, re
 estimates store m12
xtabond tfc_ BRdisadv grfd1con_ geocon size, lags(2) vce(r)
 estimates store m13
xtgls tfc_ BRdisadv grfd1con_ indcon geocon size ltfc_ polcon1, panels(h) corr(psar1) force
 estimates store m14
xtpcse tfc_ BRdisadv grfd1con_ indcon geocon size ltfc_ polcon1, pairwise corr(psar1) 
 estimates store m15

*DV: Tariffs on Dutiable Imports
xtregar tfd_ BRdisadv grfd1con_ geocon size ltfd_, fe
 estimates store m16
xtregar tfd_ BRdisadv grfd1con_ geocon size ltfd_, re
 estimates store m17
xtabond tfd_ BRdisadv grfd1con_ geocon size, lags(2) vce(r)
 estimates store m18
xtgls tfd_ BRdisadv grfd1con_ indcon geocon size ltfd_ polcon1, panels(h) corr(psar1) force
 estimates store m19
xtpcse tfd_ BRdisadv grfd1con_ indcon geocon size ltfd_ polcon1, pairwise corr(psar1) 
 estimates store m20

*TABLE 1
estout m11 m12 m13 m14 m15, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2_o r2_w r2_b r2 N N_g vce, fmt(3 3 3 3 0 0)) legend varlabels(_cons Constant)
estout m16 m17 m18 m19 m20, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2_o r2_w r2_b r2 N N_g vce, fmt(3 3 3 3 0 0)) legend varlabels(_cons Constant)

********************************************************************************
/*TABLE 2: Partisan Dominance and the Marginal Effects of Comparative 
           Disadvantage on Tariffs*/
********************************************************************************
*Interaction Terms
gen grfd1BR_=grfd1con_*BRdisadv

*DV: Tariffs on Total Imports
xtgls tfc_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_ i.dy1, panels(h) corr(psar1) force
 estimates store m21
xtgls tfc_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_ polcon1 i.dy1, panels(h) corr(psar1) force
 estimates store m22
xtpcse tfc_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store m23
xtpcse tfc_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_ polcon1 i.dy1, pairwise corr(psar1) 
 estimates store m24

 *DV: Tariffs on Dutiable Imports
xtgls tfd_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfd_ i.dy1, panels(h) corr(psar1) force
 estimates store m25
xtgls tfd_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfd_ polcon1 i.dy1, panels(h) corr(psar1) force
 estimates store m26
xtpcse tfd_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store m27
xtpcse tfd_ BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfd_ polcon1 i.dy1, pairwise corr(psar1) 
 estimates store m28

estout m21 m22 m23 m24 m25 m26 m27 m28, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2_o r2_w r2_b r2 N N_g vce, fmt(3 3 3 3 0 0)) legend varlabels(_cons Constant)

********************************************************************************
*TABLE 4: Alternative Estimations: Partisan Dominance and Tariffs
********************************************************************************
*Interaction Terms
gen RDconBR_=RDcon_*BRdisadv
gen psg501BR_=psg50dcon1_*BRdisadv
gen h501BR_=h50con1_*BRdisadv

*DV: Tariffs on Total Imports
xtpcse tfc_ BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store m41
xtpcse tfc_ BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store m42
xtpcse tfc_ BRdisadv h50con1_ h501BR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store m43
 
*DV: Tariffs on Dutiable Imports
xtpcse tfd_ BRdisadv RDcon_ RDconBR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store m44
xtpcse tfd_ BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store m45
xtpcse tfd_ BRdisadv h50con1_ h501BR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store m46

estout m41 m42 m43 m44 m45 m46, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N N_g vce, fmt(3 0 0)) legend varlabels(_cons Constant)


********************************************************************************
**TABLE A2: Import Penetration Ratio, Partisan Dominance and Tariff Protection
********************************************************************************
*Interaction Terms
gen RDconBRR_=RDcon_*BRR
gen psg501BRR_=psg50dcon1_*BRR
gen h501BRR_=h50con1_*BRR

*DV: Tariffs on Total Imports
xtpcse tfc_ BRR RDcon_ RDconBRR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA21
xtpcse tfc_ BRR RDcon_ RDconBRR_ geocon indcon size ltfc_ polcon1 i.dy1, pairwise corr(psar1) 
 estimates store mA22
xtpcse tfc_ BRR psg50dcon1_ psg501BRR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA23
*DV: Tariffs on Dutiable Imports
xtpcse tfc_ BRR psg50dcon1_ psg501BRR_ geocon indcon size ltfc_ polcon1 i.dy1, pairwise corr(psar1) 
 estimates store mA24
xtpcse tfc_ BRR h50con1_ h501BRR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA25
xtpcse tfc_ BRR h50con1_ h501BRR_ geocon indcon size ltfc_ polcon1 i.dy1, pairwise corr(psar1) 
 estimates store mA26

estout mA21 mA22 mA23 mA24 mA25 mA26, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N N_g vce, fmt(3 0 0)) legend varlabels(_cons Constant)

********************************************************************************
**TABLES A4: Concentration in Marginal Districts and Tariff Protection
********************************************************************************
d pivotalcon 
*Interaction Terms
gen pivotalconBR_=pivotalcon*BRdisadv
gen pivotalconBRR_=pivotalcon*BRR

xtpcse tfc_ BRdisadv pivotalcon geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA41	
xtpcse tfc_ BRdisadv pivotalcon pivotalconBR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA42	
xtpcse tfc_ BRR pivotalcon geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA43	
xtpcse tfc_ BRR pivotalcon pivotalconBRR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA44
xtpcse tfd_ BRdisadv pivotalcon geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA45
xtpcse tfd_ BRdisadv pivotalcon pivotalconBR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA46
xtpcse tfd_ BRR pivotalcon geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA47		
xtpcse tfd_ BRR pivotalcon pivotalconBRR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA48	
estout mA41 mA42 mA43 mA44 mA45 mA46 mA47 mA48, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N N_g, fmt(3 0 0)) legend varlabels(_cons Constant)

********************************************************************************
*Table A5: Concentration in Safe Districts and Tariff Protection
********************************************************************************
d safecon safe4gcon safe4con
*Interaction Terms
gen safeconBR_=safecon*BRdisadv
gen safe4gconBR_=safe4gcon*BRdisadv
gen safe4conBR_=safe4con*BRdisadv

xtpcse tfc_ BRdisadv safecon safeconBR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA51
xtpcse tfc_ BRdisadv safe4con safe4conBR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA52
xtpcse tfc_ BRdisadv safe4gcon safe4gconBR_ geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA53
xtpcse tfc_ BRdisadv safe4gcon geocon indcon size ltfc_ i.dy1, pairwise corr(psar1) 
 estimates store mA54
xtpcse tfd_ BRdisadv safecon safeconBR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA55	
xtpcse tfd_ BRdisadv safe4con safe4conBR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA56
xtpcse tfd_ BRdisadv safe4gcon safe4gconBR_ geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA57
xtpcse tfd_ BRdisadv safe4gcon geocon indcon size ltfd_ i.dy1, pairwise corr(psar1) 
 estimates store mA58
estout mA51 mA52 mA53 mA54 mA55 mA56 mA57 mA58, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N N_g, fmt(3 0 0)) legend varlabels(_cons Constant)

********************************************************************************
**TABLE A7: Alternative Estimations with Independent Variables Lagged Two Years
********************************************************************************

xtpcse tfc2 BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_ i.dy2, pairwise corr(psar1) 
 estimates store mA71
xtpcse tfc2 BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc_ i.dy2, pairwise corr(psar1) 
 estimates store mA72
xtpcse tfc2 BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc_ i.dy2, pairwise corr(psar1) 
 estimates store mA73
xtpcse tfc2 BRdisadv h50con1_ h501BR_ geocon indcon size ltfc_ i.dy2, pairwise corr(psar1) 
 estimates store mA74
 
xtpcse tfd2 BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfd_ i.dy2, pairwise corr(psar1) 
 estimates store mA75
xtpcse tfd2 BRdisadv RDcon_ RDconBR_ geocon indcon size ltfd_ i.dy2, pairwise corr(psar1) 
 estimates store mA76
xtpcse tfd2 BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfd_ i.dy2, pairwise corr(psar1) 
 estimates store mA77
xtpcse tfd2 BRdisadv h50con1_ h501BR_ geocon indcon size ltfd_ i.dy2, pairwise corr(psar1) 
 estimates store mA78
 
estout mA71 mA72 mA73 mA74 mA75 mA76 mA77 mA78, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N N_g vce, fmt(3 0 0)) legend varlabels(_cons Constant)


**THE END
