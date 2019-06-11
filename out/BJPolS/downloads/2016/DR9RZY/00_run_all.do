* Raj Arunachalam and Sara Watson
* February 2016
*
* This do file assembles datasets and performs analysis 
* for "Height, Income, and Voting" (British Journal of Political Science)
*
* Before running, place the raw BHPS data in the rawdta folder
* 
* To select specific figures and tables to produce, use the counters in height_analysis.do


version 12.1
cap log close
set more off



* Specify location of Height_replication here (if path contains spaces, map a driveletter to this location):
global root [INSERT_PATH]/Height_replication


global do 			$root/do
global log			$root/log

global rawdta	 	$root/rawdta
global cleandta	 	$root/cleandta
global bootstrap	$cleandta/bootstrap

cap mkdir $bootstrap


do $do/01_bhps_construction.do
do $do/02_bhps_gen.do
do $do/03_height_analysis.do


exit
