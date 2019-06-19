/*
--------------------------------------------------------------------------------

This is a demontration project created to illustrate how -project- works.


How to run:
===========

This project is managed by the "project" command. To install it, type in
Stata:

	net from http://robertpicard.com/stata/

Click on the "project" link and install by clicking "click here to install".
Once installed, type in Stata:

	help project
   
to learn how to setup and run this project and 

	project, setup
	
to select this master do-file via an open file dialog. To run this project,
type
	
	project ex12, build


--------------------------------------------------------------------------------
*/

	version 12


* Common settings

	set more off
	set varabbrev off	// for long projects, it's best not to abbreviate
	set linesize 132	// use 7pt font for printing
	
	
* Add a directory to the ado-path for programs that are local to this project

	adopath ++ "`c(pwd)'/ado"
	project, do("ado/link_ado_files.do")
	
		
* Get Stata datasets from the web

	project, do("data/stata/dta_from_http.do")
	
	
* Run examples from the Data-Management reference manual

	project, do("data-management/d_examples.do")
	
	
* Run examples from the Base reference manual

	project, do("base/r_examples.do")
