***	This file calls all do files necessary to replicate the paper.

clear all
log using TaxHavens.log, replace

* prepare data 
do data.do
* replicate section 4
do descriptives.do
* replicate sections 6, 7 and appendix
do tables.do 

log close
