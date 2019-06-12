use "Bush Prather Promise and Limits of EOs Manuscript.dta", clear

****Figure 1****
*distribution of "trust" among control group respondents
tab trust if treat_pos==0

*distribution of "will" among control group respondents
tab will if treat_pos==0



****Table 1****
*Model 1
reg credibility treat_pos_neg age education rural polknowledge, robust

*Model 2
reg credibility treat_pos age education rural polknowledge, robust

*Model 3
reg credibility treat_neg age education rural polknowledge, robust

