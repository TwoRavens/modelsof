**Replication code for "Misinformation and the Justification of Socially Undesirable Preferences"
** D.J. Flynn and Yanna Krupnikov
** Journal of Experimental Political Science

** Note: This file contains code necessary to replicate results presented in the Appendix 7. Additional replication code can be found in "FlynnKrupnikov_replication code.R”, which also contains a list of all empirical results presented in the paper and notes on which results can be generated using this file. For an explanation of all files included in the replication folder, see “FlynnKrupnikov_README.docx" or contact the corresponding author at <d.j.flynn@dartmouth.edu>. 

** Note: the read-in code below assumes that the dataset is saved to the directory "stata" that exists on the hard drive (insert your own working directory).
use "C:\stata\FlynnKrupnikov_SuitCheck.dta"

**This is the do file only for Appendix 7, which relies on a different dataset than the rest of the results in the Appendix and the main manuscript

**Table 7A1
**All participants
ttest patriotic, by(treatment)
ttest honest, by(treatment)
ttest old, by(treatment)
ttest kind, by(treatment)
ttest friendly, by(treatment)

**White participants only
ttest patriotic if white==1, by(treatment)
ttest honest if white==1, by(treatment)
ttest old if white==1, by(treatment)
ttest kind if white==1, by(treatment)
ttest friendly if white==1, by(treatment)
