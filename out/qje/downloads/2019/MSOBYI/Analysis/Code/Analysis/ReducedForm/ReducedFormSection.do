/* ReducedFormSection.do */
** This is the master file for the reduced form sections.
clear matrix
clear mata
clear all
set more off

capture cd C:/Users/Hunt/Dropbox/NutritionIncomeFinal/Analysis



*************************************************

/* REDUCED FORM ENTRY REGS */
include Code/Analysis/ReducedForm/EntryRegs.do 


/* MOVERS */
include Code/Analysis/ReducedForm/InSampleMoverRegs.do 



/* POST-MODEL SECTION */
tk
/* Gelbach decomposition of preferences */
include Code/Analysis/ReducedForm/GelbachDecomp.do 

