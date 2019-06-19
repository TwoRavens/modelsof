/*
--------------------------------------------------------------------------------

This directory contains all the programs and data necessary to replicate the
results presented in

"Organizational Form and Performance: Evidence from the Hotel Industry"

by

Renáta Kosová, r.kosova@imperial.ac.uk
Francine Lafontaine, laf@umich.edu
Rozenn Perrigot, rozenn.perrigot@univ-rennes1.fr


How to run
----------

See the _READ_ME.txt file in this directory

--------------------------------------------------------------------------------
*/

	version 12
	

* Common settings

	set more off
	set varabbrev off	// for long projects, it's best not to abbreviate
	set linesize 132	// use 7pt font for printing
	
	
* System and Stata version info

	dis c(stata_version) 
	dis c(born_date)
	dis c(flavor)
	dis c(bit)
	dis c(SE)
	dis c(MP)
	dis c(processors)
	dis c(mode)
	dis c(console)
	dis c(os)
	dis c(osdtl)
	dis c(machine_type)
	
	
* Make the read me file part of this project

	project, relies_on("_READ_ME.txt")

	
* User-written programs used in this project

	adopath ++ "`c(pwd)'/ado"	// copies of user-written programs
	project, do("ado/user-written_programs.do")
	
	// rebuild Mata's library index let Mata find outreg's library
	mata: mata mlib index
	
	
* Combine monthly operational data with hotel and market level data

	project, do("data_combo.do")
	

* Generate tables

	project, do("tables/all_tables.do")


* Generate figures
	
	project, do("figures/all_figures.do")
