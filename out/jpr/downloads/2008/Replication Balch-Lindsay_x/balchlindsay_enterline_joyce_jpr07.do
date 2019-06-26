**********************************************************************************************************************
** 
** File name: 	balchlindsay_enterline_joyce_jpr07.do
** Date: 		February 4, 2007
** Author: 		Kyle Joyce (kjoyce@psu.edu)
** Purpose: 	Estimates Cox Competing Risks Models for "Third Parties and the Civil War Process"
** Requires: 	balchlindsay_enterline_joyce_jpr07.dta
** Output: 		balchlindsay_enterline_joyce_jpr07.log
**
**********************************************************************************************************************

clear
#delimit;
set more off;
set mem 200m;
capture log close;

use "balchlindsay_enterline_joyce_jpr07.dta";
log using "balchlindsay_enterline_joyce_jpr07_website.log", replace;

**********************************************************************************************************************;
*Government Military Victory Model				1816-1997									    ;
**********************************************************************************************************************;

stset End, origin(Start) fail(GovWin) id(cwarnum);

stcox IntGov IntOpp IntBalanced Separatist WarCosts_pc GovReputation EconDevelopment LagPolity_b, 
	efron cluster(cwarnum) robust nohr nolog schoenfeld(sch*) scaledsch(sca*);

*****Test PH assumption;
stphtest, detail;
drop sca* sch*;

*****If significance level <= 0.10 correct for proportionality assumption;
*****IntGov, WarCosts, and EconDevelopment violates the proportional hazards assumption in the Government Military Victory Model;
*****WarCosts violates the proportional hazards assumption in the Opposition Military Victory Model;
*****Separatist violates the proportional hazards assumption in the Negotiated Settlement Model;
*****Estimate model with corrections for violations of the proportionality assumption;

stcox IntGov IntGovxlntime_GW IntOpp IntBalanced Separatist Separatistxlntime_GW WarCosts_pc WarCosts_pcxlntime_GW
	GovReputation EconDevelopment EconDevelopmentxlntime_GW LagPolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_GovWin) basehc(haz_GovWin);

*****Estimate Survival Curve for IntGov in GovWin model;
*IntGov=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=1 IntOpp=0 IntBalanced=0 Separatist=0 LagPolity_b=0) 
	outfile("survival_GovWin_IntGov", replace);

*****Estimate Survival Curve for IntOpp in GovWin model;
*IntOpp=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=0 IntOpp=1 IntBalanced=0 Separatist=0 LagPolity_b=0) 
	outfile("survival_GovWin_IntOpp", replace);

*****Estimate Survival Curve for IntBalanced in GovWin model;
*IntBalanced=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=0 IntOpp=0 IntBalanced=1 Separatist=0 LagPolity_b=0) 
	outfile("survival_GovWin_IntBalanced", replace);

**********************************************************************************************************************;
*Opposition Military Victory Model				1816-1997									    ;
**********************************************************************************************************************;

stset End, origin(Start) fail(OppWin) id(cwarnum);

stcox IntGov IntOpp IntBalanced Separatist WarCosts_pc GovReputation EconDevelopment LagPolity_b, 
	efron cluster(cwarnum) robust nohr nolog schoenfeld(sch*) scaledsch(sca*);

*****Test PH assumption;
stphtest, detail;
drop sca* sch*;

*****If significance level <= 0.10 correct for proportionality assumption;
*****IntGov, WarCosts, and EconDevelopment violates the proportional hazards assumption in the Government Military Victory Model;
*****WarCosts violates the proportional hazards assumption in the Opposition Military Victory Model;
*****Separatist violates the proportional hazards assumption in the Negotiated Settlement Model;
*****Estimate model with corrections for violations of the proportionality assumption;

stcox IntGov IntGovxlntime_OW IntOpp IntBalanced Separatist Separatistxlntime_OW WarCosts_pc WarCosts_pcxlntime_OW 
	GovReputation EconDevelopment EconDevelopmentxlntime_OW LagPolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_OppWin) basehc(hazard_OppWin);

*****Estimate Survival Curve for IntGov in OppWin model;
*IntGov=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=1 IntOpp=0 IntBalanced=0 Separatist=0 LagPolity_b=0) 
	outfile("survival_OppWin_IntGov", replace);

*****Estimate Survival Curve for IntOpp in OppWin model;
*IntOpp=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=0 IntOpp=1 IntBalanced=0 Separatist=0 LagPolity_b=0) 
	outfile("survival_OppWin_IntOpp", replace);

*****Estimate Survival Curve for IntBalanced in OppWin model;
*IntBalanced=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=0 IntOpp=0 IntBalanced=1 Separatist=0 LagPolity_b=0) 
	outfile("survival_OppWin_IntBalanced", replace);

**********************************************************************************************************************;
*Negotiated Settlement Model					1816-1997								 	    ;
**********************************************************************************************************************;

stset End, origin(Start) fail(Negotiat) id(cwarnum);

stcox IntGov IntOpp IntBalanced Separatist WarCosts_pc GovReputation EconDevelopment LagPolity_b, 
	efron cluster(cwarnum) robust nohr nolog schoenfeld(sch*) scaledsch(sca*);

*****Test PH assumption;
stphtest, detail;
drop sca* sch*;

*****If significance level <= 0.10 correct for proportionality assumption;
*****IntGov, WarCosts, and EconDevelopment violates the proportional hazards assumption in the Government Military Victory Model;
*****WarCosts violates the proportional hazards assumption in the Opposition Military Victory Model;
*****Separatist violates the proportional hazards assumption in the Negotiated Settlement Model;
*****Estimate model with corrections for violations of the proportionality assumption;

stcox IntGov IntGovxlntime_N IntOpp IntBalanced Separatist Separatistxlntime_N WarCosts_pc WarCosts_pcxlntime_N 
	GovReputation EconDevelopment EconDevelopmentxlntime_N LagPolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_Negotiate) basehc(hazard_Negotiate);

*****Estimate Survival Curve for IntGov in Negotiat model;
*IntGov=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=1 IntOpp=0 IntBalanced=0 Separatist=0 LagPolity_b=0) 
	outfile("survival_Negotiate_IntGov", replace);

*****Estimate Survival Curve for IntOpp in Negotiat model;
*IntOpp=1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=0 IntOpp=1 IntBalanced=0 Separatist=0 LagPolity_b=0) 
	outfile("survival_Negotiate_IntOpp", replace);

*****Estimate Survival Curve for IntBalanced  in Negotiat model;
*IntBalanced =1, discrete variables at 0 (i.e., mode), continuous variables at mean;

stcurve, survival at(IntGov=0 IntOpp=0 IntBalanced=1 Separatist=0 LagPolity_b=0) 
	outfile("survival_Negotiate_IntBalanced", replace);




