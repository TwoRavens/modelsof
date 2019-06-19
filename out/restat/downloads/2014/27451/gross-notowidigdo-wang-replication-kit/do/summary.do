** This summary file re-creates all regressions and figures presented in the
** Gross, Notowidigdo, Wang bankruptcy paper. 
** To run the file properly, have Stata use the `do` directory as its working 
** directory. Then type the command `do summary.do`.

#delim cr
clear all
set more off


**
* Macs can export to pdf, Unix can only do eps/ps
**
*global gph_extension = "pdf"
global gph_extension = "eps"



************************************************************
**   Data Cleaning, Other Data
************************************************************
/*
do create-ssn-crosswalk.do

do state-codes.do

do organize-zip-characteristics.do

************************************************************
**   Main Analysis
************************************************************

do main-exercises.do

do event-study-maker.do 2001
do event-study-maker.do 2008

do stratified-regs.do

do long-run-exercise.do
 */

************************************************************
**   Micro Analysis
************************************************************

*do create-micro-figures.do 2001
*do create-micro-figures.do 2008

************************************************************
**   Permutation test
************************************************************

*do make-permutation-test-data.do
do create-permutation-figure.do
