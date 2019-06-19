/* demo_plausex.do: Sample program to run ivreg with a slight modification.*/
#delimit ;
clear ;


infile C1 C2 dep indep1 instr1 instr2 using data_plausex.dat;

generate const = 1;

matrix omega_eta = I(2)/20; 








/************************************************************************/
/* ltz.ado                                                              */
/*									*/
/*		Local to Zero Approximation				*/
/************************************************************************/
/************************************************************************/
/*  To invoke this command type:                                        */
/*	>>ltz var_matrix_for_gamma depvar 				*/
/*			(independantlist=instrumentlist) [if] [in],     */
/*					[cluster()] [robust]		*/
/************************************************************************/

*ltz omega_eta dep (indep1=instr1 instr2);

*ltz omega_eta dep (indep1=instr1 instr2), cluster(C1);
















/************************************************************************/
/* uci.ado                                                              */
/*									*/
/*	Does a union of confidence intervals				*/	
/************************************************************************/
/************************************************************************/
/*  To invoke this command type:                                        */
/*	>>uci depvar (independantlist=instrumentlist) [if] [in], g1min()*/
/*		g1max() g2min() g2max() ... grid() [cluster()] [robust] */
/*									*/
/*NOTE:									*/
/* gmins and gmaxs are defaulted to -.1 and .1				*/
/* grid defaults to 4.  This number is the number of lattice 		*/
/*	points in each direction.					*/
/************************************************************************/


uci dep (indep1=instr1 instr2) C1 , inst(instr1 instr2);
uci dep (indep1=instr1 instr2) , inst(instr1 instr2);
*uci dep (indep1=instr1 instr2);

*uci dep (indep1=instr1) in 1/50, robust;

*uci dep (indep1 = instr1 instr2) if C1>C2;



