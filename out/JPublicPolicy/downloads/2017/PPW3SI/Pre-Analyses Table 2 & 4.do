
cd "~//Replication Archive"
use "Dataset_final.dta"

******************************************************************************
*                                                                            *
*                          Table 2: Summary Statistics                       *
*                                                                            *
******************************************************************************

tabstat TotQuota sh_Own sh_GreenParties sh_ConstrBus spExpend_pKc sh_seFinance /*
*/ tax_r popDensity_ob av_dPop5 ConstrSur_uz , s(count mean median sd min max skew k) /*
*/ columns(s) total

******************************************************************************
*                                                                            *
*                         Table 4: Moran’s I & LM Tests                      *
*                                                                            *
******************************************************************************

* Average all variables over all cross-sections 
clear
use "Dataset_final.dta" 

sort bfs_nr year
by bfs_nr: egen av_TotQuota=mean(TotQuota) if inrange(year,1991,2010)
by bfs_nr: egen av_log_TotQuota=mean(log_TotQuota) if inrange(year,1991,2010)
by bfs_nr: egen av_Llog_TotQuota=mean(Llog_TotQuota) if inrange(year,1991,2010)
by bfs_nr: egen av_sh_Own=mean(sh_Own) if inrange(year,1991,2010)
by bfs_nr: egen av_sh_GreenParties=mean(sh_GreenParties) if inrange(year,1991,2010)
by bfs_nr: egen av_sh_ConstrBus=mean(sh_ConstrBus) if inrange(year,1991,2010)
by bfs_nr: egen av_sqrt_spExpend_pKc=mean(sqrt_spExpend_pKc) if inrange(year,1991,2010)
by bfs_nr: egen av_sh_seFinance=mean(sh_seFinance) if inrange(year,1991,2010)
by bfs_nr: egen av_tax_r=mean(tax_r) if inrange(year,1991,2010)
by bfs_nr: egen av_log_popDensity_ob=mean(log_popDensity_ob) if inrange(year,1991,2010)
by bfs_nr: egen av2_dPop5=mean(av_dPop5) if inrange(year,1991,2010)
by bfs_nr: egen av_sqrt_ConstrSur_uz=mean(sqrt_ConstrSur_uz) if inrange(year,1991,2010)
by bfs_nr: egen av_ConstrSur_ub=mean(ConstrSur_ub) if inrange(year,1991,2010)

drop if year!=1996
keep bfs_nr av* planReg* 

save "Dataset_averaged.dta" , replace

******************************************************************************
* Structural Equivalence

spatwmat using  "SEQ1980_shortMat.dta", /*
*/ name(W) 
spatgsa av_log_TotQuota, w(W) moran geary two

reg av_log_TotQuota           /*
*/      av_sh_Own              /*
*/      av_sh_GreenParties     /*
*/      av_sh_ConstrBus        /*
*/      av_sqrt_spExpend_pKc    /*
*/      av_sh_seFinance 		 /*
*/	    av_tax_r				/*
*/      av_log_popDensity_ob   /*
*/      av2_dPop5              /*
*/      av_sqrt_ConstrSur_uz, robust
spatdiag, weights(W)

******************************************************************************
* Planning Regions

spatwmat using "PlanRegions_shortMat.dta", /*
*/ name(W) 
spatgsa av_log_TotQuota, w(W) moran geary two

reg av_log_TotQuota           /*
*/      av_sh_Own              /*
*/      av_sh_GreenParties     /*
*/      av_sh_ConstrBus        /*
*/      av_sqrt_spExpend_pKc    /*
*/      av_sh_seFinance 		 /*
*/	    av_tax_r				/*
*/      av_log_popDensity_ob   /*
*/      av2_dPop5              /*
*/      av_sqrt_ConstrSur_uz, robust
spatdiag, weights(W)

******************************************************************************
* Neighbourhood

spatwmat using "Neighbours_shortMat.dta", /*
*/ name(W) 
spatgsa av_log_TotQuot, w(W) moran geary two

reg av_log_TotQuota           /*
*/      av_sh_Own              /*
*/      av_sh_GreenParties     /*
*/      av_sh_ConstrBus        /*
*/      av_sqrt_spExpend_pKc    /*
*/      av_sh_seFinance 		 /*
*/	    av_tax_r				/*
*/      av_log_popDensity_ob   /*
*/      av2_dPop5              /*
*/      av_sqrt_ConstrSur_uz, robust
spatdiag, weights(W)

