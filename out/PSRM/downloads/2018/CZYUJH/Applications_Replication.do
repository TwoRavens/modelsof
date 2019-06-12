clear all
log using "log_file_Applications", text replace
********************************************************
******          Replication Code for              ******
******      Spatial Interdependence       		  ******
******       and Instrumental Variable Models     ******
******       									  ******    
********************************************************
******                                            ******  
******                9/17/2018                   ******         
******     this file runs stata code to estimate  ******
******      the models both applications          ******
********************************************************

// requires the following packages:  sg162.pkg, st0292.pkg, st0030 (ivreg2), ranktest

///set directory 
 

do Table2_Ramsay.do
do TablesE2E3_AshrafGalor.do

log close

