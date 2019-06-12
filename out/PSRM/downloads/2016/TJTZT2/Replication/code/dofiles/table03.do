*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************


*********
**The following code reproduces the contents of Manuscript Table 3
*********

*requires the following Packages:  

*'SUTEX': module to generate LaTeX output from sum, by Antoine Terracol (2001)
*net install sutex

*'LISTTAB': module to generate LaTeX output from list, SJ12-2 st0254 - by Roger B. Newson, National Heart and Lung Institute, Imperial College London, London, United Kingdom
*net install st0254



***Manuscript Table 3 rows '2013 singular ME run-off' and '2014 singular ME run-off'

import excel "datasets/nds_counterfactual_to.xlsx", sheet(Table3) firstrow clear

*display table contents
list // for calculation of values see excel file

*save to tex
import excel "datasets/nds_counterfactual_to.xlsx", sheet(Table3) clear
listtab A B C D E F using "output/table03.tex", replace rstyle(tabular) head("\begin{tabular}{lrrrrrr}") foot("\end{tabular}")


***Manuscript Table 3 row '2014 singular EE' and row '2014 concurrent EE and ME'

use "datasets/nds_ee_ge_1998-2014.dta", clear

*display table contents
sum to if year == 2014 & csoe2014==0 // '2014 singular EE'
sum to if year == 2014 & csoe2014==1 // '2014 concurrent EE and ME'

*save to tex
sutex to if year == 2014 & csoe2014==0, nobs minmax label file("output/table03") append title("2014 singular EE") 
sutex to if year == 2014 & csoe2014==1, nobs minmax label file("output/table03") append title("2014 concurrent EE and ME") 

