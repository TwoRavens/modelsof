
/*
master do file to replicate public-use data/mortality estimates from 
	TUSKEGEE AND THE HEALTH OF BLACK MEN 
	by Marcella Alsan and Marianne Wanamaker 
prepared for the Quarterly Journal of Economics web
*/

version 14.0
capture log close 
set more off
set matsize 7000 
set scheme s1mono 
graph set window fontface "Times New Roman"

/*SET GLOBALS*/
global repdrive "D:\Dropbox\Tuskegee\QJE\Tuskegee_Replicationfiles\" /*modify to relevant folder pathname*/
global allcause_outcome "log_1940_amort_older"
global outcome "log_1940_chronicmort"
global acute_outcome "log_1940_acutemort"
global coeff_5a = -1.328 /*quad in table 1 col 1*/
global coeff_5b = 0.087  /*quad in table 1 col 7*/
global controls "c.log_socsec#i.black#i.male c.density_doctors#i.black#i.male c.density_hospitals#i.black#i.male  c.density_beds#i.black#i.male c.chc#i.black#i.male c.log_totalhe#i.black#i.male"

cd $repdrive


/*TABLES*/
do "tables1&3.do" /*Produces main mortality results; Columns 5-8 of Table I + Columns 5-8 of Table III*/

*tables123&5restricted.do /*All of Tables II and V; Columns 1-4 of Tables I and III use restricted data. See readme for info on how to access restricted data from NHIS via NCHS.*/
*table4restricted.do /*Uses restricted data - See readme for info on how to access restricted data from GSS via NORC*/

/*FIGURES*/
do "fig1.do" /*mortality differences across races, within gender*/
*Figure II is maps of treatment intensity constructed using GIS; no code available.
do "fig3.do" 
*Figure IV panels A-C in FRDC " /*utilization event study, see comment above*/
do "fig4mort.do" /*Chronic mortality event study */
*Figure V panel A /*utilization permutation test , see comment above */
do "fig5b.do" /*Chronic mortality permutation test */

