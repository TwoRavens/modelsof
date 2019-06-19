* AI.do does runs for the Asset integration paper

* setup
clear all
set more off
set scheme s1mono
capture log close _all

* use version control if running under later versions of Stata
version 13.0

* global for demographic controls
global demog "male age age2 married hsize net_income net_income2"

* global for wealth covariates
global sumvarlist "assets_total assets_realesta assets_stocks assets_bond assets_banks assets_pension assets_cars liab_total liab_bankdebt liab_mortgage liab_private wealth_net wealth_T"
			
* global for recovering the log-likelihood
global getLL "y"
capture log close _all

* read in the user-written functions
qui do MLfunctions

* get data
do Data

* Estimates with wealth clean runs
* do Analysis_A
	
* Due to confidentiality the log files for the individual analysis is not provided only inside of Statistics Denmark.
* Do individual estimation
do Analysis_I
		
