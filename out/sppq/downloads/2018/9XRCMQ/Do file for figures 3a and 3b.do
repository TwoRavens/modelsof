* Loading data with user's persona file pathway
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
* commands to produce the data for Figure 3a
gen neaXgrad = neafactor * reversedgradratechange
gen diffXgrad = diffusion * gradrateaveragechange
xtmixed cerscore neafactor reversedgradratechange neaXgrad diffusion gradrateaveragechange diffXgrad dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if upcer==1, mle
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
gen change=((_n+794)/1000)
replace change=. if _n > 414
gen conbx = b1 + b3 * change if _n < 415
gen consx = sqrt(varb1 + varb3 * (change^2)+2 * covb1b3 * change) if _n < 415
gen ax= 1.96 * consx
gen upperbound = conbx + ax
gen lowerbound = conbx - ax
sort change
rename conbx marginal_effect
* To create an EXCEL file to reproduce Figure 3a:
export excel marginal_effect lowerbound upperbound using "fig3adata.xlsx", firstrow(variables)
* This created a new EXCEL file called "fig3adata.xlsx"
* Open the EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph and customize
* commands to produce the data for Figure 3b
xtmixed cerscore fallinggradrates##c.neafactor diffusion gradrateaveragechange diffXgrad dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if upcer==1, mle
* The "margins" command below produces the result report in the paper's endnote 27
margins, dydx(neafactor) at(fallinggradrates=(0 1))
* The "margins" command below produces the raw data for Figure 3b
margins i(1).fallinggradrates, at(neafactor=(-1.35 (.05) 3.35))
* Figure 3b was created by cutting and pasting the "margin" results and the two columns of 95% confidence intervals results into EXCEL
* Since this cannot be easily done in a replication file, the following STATA command reproduces Figure 3b in STATA:
marginsplot, recast(line) recastci(rline) scheme(s2mono) xtitle("Increasing strength of state teacher's unions", size(2.5)) ytitle("Predicted state CER score", size(2.5)) graphregion(fcolor(white) ilcolor(white) lcolor(white)) title("Figure 3b: Predicted CER score for a state with declining graduation rates as teacher's union strength increases", size(2.5)) xlabel(-1.35 -1.0 0 1.0 2.0 3.0 3.35, labsize(2.5)) ylabel(5 7 9 11 13 15 17 19 21 23, labsize(2.5))
* To create "dash" or "dot" 95% CI confidence bands, as in Figure 3b, in STATA's Figure 3b click on "Graph Editor" in the tool bar (icon looking like a bar graph and pencil)
* Then double click on either the upper or lower confidence interval line.  In the new dialogue box, under "Patterns," click either "dash" or "dot" and then "OK".
* An example, file name "Figure 3b_STATA version" is included in the replication file
