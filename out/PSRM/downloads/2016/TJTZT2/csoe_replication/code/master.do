* MASTER DO FILE
* Replication material for 
* Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
* "How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
* Forthcoming in Political Science Research and Methods
*********************************************************

version 13
set more off
clear all

* set working directory
* cd "XXX/Replication/"  // you need to changes this to your directory to run the do files manually


** Ado file management
capture ado uninstall estout
net install st0085_2, from("http://www.stata-journal.com/software/sj14-2") // fresh estout install
ssc install stripplot
net install sutex, from("http://fmwww.bc.edu/RePEc/bocode/s")
ssc install listtab, replace

* Figure 4 (alternative)
do "code/dofiles/figure4.do"
 
* Table 2
do "code/dofiles/table02.do"

* Table 3
do "code/dofiles/table03.do"

* Appendix
do "code/dofiles/appendix/figure03-appendix.do"
do "code/dofiles/appendix/table02-appendix, table05-appendix, figure01-appendix.do"
do "code/dofiles/appendix/table03-appendix.do"
do "code/dofiles/appendix/table04-appendix.do"
do "code/dofiles/appendix/table08-appendix.do"
do "code/dofiles/appendix/table09-appendix.do"
do "code/dofiles/appendix/table10-appendix.do"
do "code/dofiles/appendix/table11-appendix.do"

exit

