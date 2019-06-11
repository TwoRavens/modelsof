
****************************************************************
* Run do-files to reproduce the figures and replication analyses 
****************************************************************

* Programme:	msim-analysis.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This master do-file runs all do-files used to construct the figures 
* and to produce the results of the replication analyses


* Set up Stata
**************
version 11
clear all
macro drop _all
set more off


* Generate Figure 1
do "Data analysis\Descriptive analysis\msim-desc01-figure1.do"

* Generate Figure 6 
do "Data analysis\Descriptive analysis\msim-desc02-figure6.do"

* Conduct replication analysis of Crescenzi (2007)
do "Data analysis\Replication analyses\msim-replic01-crescenzi2007.do"

* Conduct replication analysis of Salehyan (2008)
do "Data analysis\Replication analyses\msim-replic02-salehyan2008.do"

* Generate Figure 1 in supporting information
do "Data analysis\Replication analyses\msim-replic03-sifigure.do"

* Generate component variables for calculation of similarity measures based on valued alliance data for individual years
do "Data analysis\Replication analyses\msim-replic04-gartzke2007.do"


* Exit do-file
log close
exit
