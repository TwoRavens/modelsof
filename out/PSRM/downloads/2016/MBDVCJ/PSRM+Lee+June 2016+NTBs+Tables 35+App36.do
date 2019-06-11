
clear

*use "PSRM+Lee+sic87+ntbs+1990s+sum.dta", clear

********************************************************************************************
*Table A1: Summary Statistics
********************************************************************************************
sum ncov3 nfq3 BRdisadv BRR indcon geocon size polcon1 grfd1con_ RDcon_ psg50dcon1_ h50con1_ safe4gcon ltfc_ 

********************************************************************************************
**TABLE 3: Partisan Dominance and the Marginal Effects of Comparative Disadvantage on NTBs
********************************************************************************************
*Interaction Terms
gen grfd1BR_=grfd1con_*BRdisadv

*DV: NTB Coverage Ratio
reg ncov3 BRdisadv grfd1con_ geocon indcon size ltfc_, vce (cluster sic)
estimates store m31
reg ncov3 BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_, vce (cluster sic)
estimates store m32
reg ncov3 BRdisadv grfd1con_ grfd1BR_ geocon indcon polcon1 size ltfc_, vce (cluster sic)
estimates store m33

*DV: NTB Frequency Ratio
reg nfq3 BRdisadv grfd1con_ geocon indcon size ltfc_, vce (cluster sic)
estimates store m34
reg nfq3 BRdisadv grfd1con_ grfd1BR_ geocon indcon size ltfc_, vce (cluster sic)
estimates store m35
reg nfq3 BRdisadv grfd1con_ grfd1BR_ geocon indcon polcon1 size ltfc_, vce (cluster sic)
estimates store m36

estout m31 m32 m33 m34 m35 m36, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N vce, fmt(3 0 0)) legend varlabels(_cons Constant)

*********************************************************************************************************
*TABLE 5: Alternatnive Estimations: Partisan Dominance and NTBs
*********************************************************************************************************
*Interaction Terms
gen RDconBR_=RDcon_*BRdisadv
gen psg501BR_=psg50dcon1_*BRdisadv
gen h501BR_=h50con1_*BRdisadv

*DV: NTB Coverage Ratio
reg ncov3 BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc, vce(cluster sic)
estimates store m51
reg ncov3 BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc, vce(cluster sic)
estimates store m52
reg ncov3 BRdisadv h50con1_ h501BR_ geocon indcon size ltfc, vce(cluster sic)
estimates store m53

*DV: NTB Frequency Ratio
reg nfq3 BRdisadv RDcon_ RDconBR_ geocon indcon size ltfc_, vce(cluster sic)
estimates store m54
reg nfq3 BRdisadv psg50dcon1_ psg501BR_ geocon indcon size ltfc_, vce(cluster sic)
estimates store m55
reg nfq3 BRdisadv h50con1_ h501BR_ geocon indcon size ltfc_, vce(cluster sic)
estimates store m56

estout m51 m52 m53 m54 m55 m56, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N vce, fmt(3 0 0)) legend varlabels(_cons Constant)

*********************************************************************************************************
*TABLE A3: Import Penetration Ratio, Partisan Dominance and Nontariff Protection
*********************************************************************************************************
*Interaction Terms
gen RDconBRR_=RDcon_*BRR
gen psg501BRR_=psg50dcon1_*BRR
gen h501BRR_=h50con1_*BRR

*DV: NTB Coverage Ratio
reg ncov3 BRR RDcon_ RDconBRR_ geocon indcon size ltfc, vce(cluster sic)
estimates store mA31
reg ncov3 BRR psg50dcon1_ psg501BRR_ geocon indcon size ltfc, vce(cluster sic)
estimates store mA32
reg ncov3 BRR h50con1_ h501BRR_ geocon indcon size ltfc, vce(cluster sic)
estimates store mA33

*DV: NTB Frequency Ratio
reg nfq3 BRR RDcon_ RDconBRR_ geocon indcon size ltfc_, vce(cluster sic)
estimates store mA34
reg nfq3 BRR psg50dcon1_ psg501BRR_ geocon indcon size ltfc_, vce(cluster sic)
estimates store mA35
reg nfq3 BRR h50con1_ h501BRR_ geocon indcon size ltfc_, vce(cluster sic)
estimates store mA36
estout mA31 mA32 mA33 mA34 mA35 mA36, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N vce, fmt(3 0 0)) legend varlabels(_cons Constant)

*********************************************************************************************************
*TABLE A6: Concentration in Safe Districts and Nontariff Protection
*********************************************************************************************************
gen safe4gconBR_=safe4gcon*BRdisadv

*DV: NTB Coverage Ratio
reg ncov3 BRdisadv safe4gcon geocon indcon size ltfc, vce(cluster sic)
estimates store mA61
reg ncov3 BRdisadv safe4gcon safe4gconBR_ geocon indcon size ltfc, vce(cluster sic)
estimates store mA62
reg ncov3 BRdisadv safe4gcon safe4gconBR_ geocon indcon size polcon1 ltfc, vce(cluster sic)
estimates store mA63

*DV: NTB Frequency Ratio
reg nfq3 BRdisadv safe4gcon geocon indcon size ltfc, vce(cluster sic)
estimates store mA64
reg nfq3 BRdisadv safe4gcon safe4gconBR_ geocon indcon size ltfc, vce(cluster sic)
estimates store mA65
reg nfq3 BRdisadv safe4gcon safe4gconBR_ geocon indcon size polcon1 ltfc, vce(cluster sic)
estimates store mA66

estout mA61 mA62 mA63 mA64 mA65 mA66, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(r2 N vce, fmt(3 0 0)) legend varlabels(_cons Constant)

*THE END
log close
