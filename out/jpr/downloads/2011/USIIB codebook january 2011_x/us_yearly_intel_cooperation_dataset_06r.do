
capture log close
set more off
log using us_yearly_intel_cooperation_dataset_06r, replace
use "C:\us_yearly_intel_cooperation_dataset_05.dta", clear


countfit USIC I_TER_FAT D_TER_FAT US_JNT_OPR US_M_DPL POL_RHT MUS CHR LNG lgdp US_TRADE US_F_AID US_TRE ///
yr2001 yr2002 yr2003 yr2004 yr2005 yr2006, inf(I_TER_FAT D_TER_FAT US_JNT_OPR US_M_DPL POL_RHT MUS CHR ///
LNG lgdp US_TRADE US_F_AID US_TRE) prm zip nbreg 

graph save "C:\usic.gph", replace

nbreg USIC I_TER_FAT D_TER_FAT US_JNT_OPR US_M_DPL POL_RHT MUS CHR LNG lgdp US_TRADE US_F_AID US_TRE ///
yr2001 yr2002 yr2003 yr2004 yr2005 yr2006, r


reg USIC I_TER_FAT D_TER_FAT US_JNT_OPR US_M_DPL POL_RHT MUS CHR LNG lgdp US_TRADE US_F_AID US_TRE

vif


log close



NOTE:Before running this do file don not forget to delete Afghanistan and Iraq cases from the data set because they are outliers.
please feel free to direct any specific questions to Musa Tuzuner (musatuzuner@yahoo.com)