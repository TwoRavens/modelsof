
*************************************************************************
* Run all msim-data?? do-files to reproduce datasets used in the analysis
*************************************************************************

* Programme:	msim-data00-master.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This master do-file runs all do-files used to construct the similarity measures 


* Set up Stata
**************
version 11
clear all
macro drop _all
set more off


* Generate a dataset of directed dyads of all COW state system members between 1816 and 2001
do "Data analysis\Data management\msim-data01-sysdyad.do"

* Add national material capabilities for the first country to the directed dyadic dataset
do "Data analysis\Data management\msim-data02-weightsysdyad.do"

* Add alliance relationship information to the directed dyadic dataset 
do "Data analysis\Data management\msim-data03-allydyad.do"

* Reshape dyadic alliance dataset into socio-matrices for individual years and the entire time period
do "Data analysis\Data management\msim-data04-allysocio.do"

* Generate a dataset of UN voting by all state system members
do "Data analysis\Data management\msim-data05-voterecord.do"

* Reshape the UN voting dataset into vote by country affiliation matrices for individual years and the entire time period
do "Data analysis\Data management\msim-data06-voteaffil.do"

* Generate component variables for calculation of similarity measures based on valued alliance data for individual years
do "Data analysis\Data management\msim-data07-allysimvalued.do"

* Generate component variables for calculation of similarity measures based on binary alliance data for individual years
do "Data analysis\Data management\msim-data08-allysimbinary.do"

* Generate component variables for calculation of similarity measures based on valued UN voting data for individual years
do "Data analysis\Data management\msim-data09-votesimvalued.do"

* Stack datasets containing component variables for calculation of similarity measures to generate datasets for the entiry time period
do "Data analysis\Data management\msim-data10-simdata.do"

* Calculate various similarity measures based on different input datasets
do "Data analysis\Data management\msim-data11-simmeasures.do"

* Generate dataset containing S values from EUGene for comparative purposes
do "Data analysis\Data management\msim-data12-eugene.do"


* Exit do-file
log close
exit
