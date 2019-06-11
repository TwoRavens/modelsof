/**************************************************************************
File Name:		beer_cruz aceves_2nov17.do				
Date:   		November 17, 2017.								
Purpose:		this file replicates tables of  Beer and Cruz Aceves: 
				"Extending Rights to Marginalized  Minorities:  Same-Sex 
				Relationship Recognition in Mexico and the United States" 		
Input Files:	MX.dta & US.dta				
Output Files:	None; all tables are shown in Stata's results' window.
				
Version:		Stata 13.
		
Note: 			1. Install "outreg" package before running code.
				2. Execute lines 18-44 to generate Table 1 (two tables are 
				generated; the second one--the one with 4 coulumns--is the table
				reported in the article; the same applies to Table A2). 
				3. Execute lines 45-end to generate Appendix tables.
***************************************************************************/
clear all
set more off						/*Opening macros*/
global x LGBT_orgs electoral_competition lwealth lracial_diversity diffusion past_events
global um urban
global uu lurban
global gm PRI_governor PRD_governor
global tm durat durat2 durat3
global gu democrat_governor
global tu durat durat2
global o outreg, bd(2) se starlevels(10 5 1 .1) sigsymbols(+,*,**,***) summstat(chi2 \ df_m \ p \ ll \ N) nocons
global lo local merge "merge"
global m1 levangelicals
global m2 lcatholics

									/*Table 1*/
use MX, clear 		/*Load data for Mexican Models & generate columns 1-2*/
forval j = 1/2 {
qui oprobit DV ${m`j'} $x $um $gm $tm , cluster(stateno)
qui $o ctitle ("","MX") keep($x $gm $um ${m`j'}) `merge'
$lo
}
use US, clear		/*Load data for US Models & generate columns 3-4 */
forval j = 1/2 {
qui oprobit DV ${m`j'} $x $uu $gu $tu , cluster(stateno)
$o ctitle ("","US") title ("","Table 1") keep($x $uu $gu ${m`j'}) `merge'
$lo
}
									/*Appendix Tables*/
clear all							
use MX, clear  		
forval j = 1/2 {
qui oprobit DV ${m`j'} $x $um $gm $tm , cluster(stateno)
qui $o or ctitle ("","MX") keep($x $gm $um ${m`j'}) `merge'
$lo
}
corr $m1 $m2 $x $um ${gm}			/*Table A3*/
sum DV $m1 $m2 $x $um $gm ${tm}		/*Table A5*/
use US, clear						/*Table A2*/
forval j = 1/2 {
qui oprobit DV ${m`j'} $x $uu $gu $tu , cluster(stateno)
$o or ctitle ("","US") title ("","Table A2")keep($x $uu $gu ${m`j'}) `merge'
$lo
}
corr $m1 $m2 $x $uu ${gu}			/*Table A4*/
sum DV $m1 $m2 $x $uu $gu ${tu}		/*Table A6*/
