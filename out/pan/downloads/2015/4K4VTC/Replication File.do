cd "C:\Users\Sara\Desktop\Sara\Documents\MIT\Work for Adam\Draft Lottery\ANES Data Files"

use "final.dta", clear

* Table 1: Fourth Quarter Births versus All Other Respondents: Full Sample *

* Education (4 category)*
tab  VCF0110  q4 if VCF0110>0, col chi

* Education (7 category) *
tab  VCF0140a  q4 if VCF0140a>0 & VCF0140a<8, col chi

* Income *
tab   VCF0114  q4 if VCF0114>0, col chi

* Political Knowledge (Pre) *
tab   VCF0050a q4 if VCF0050a<6, col chi

* Political Knowledge (Post) *
tab   VCF0050b q4 if VCF0050b>0 & VCF0050b<6, col chi

* Interest in Campaigns *
tab  VCF0310 q4 if VCF0310 >0 & VCF0310 <8, col chi

* Party Identification *
tab VCF0301 q4 if VCF0301>0 & VCF0301<9, col chi
ttest pid7, by(q4)

* Liberal/Conservative Ideology *
tab VCF0803 q4 if VCF0803>0 & VCF0803<9, col chi
ttest lc, by(q4) 

* Voter Registration
tab VCF0737 q4 if VCF0737>0 & VCF0737<9, col chi

* Voter Participation
tab VCF0702 q4 if VCF0702>0 & VCF0702<9, col chi



* Table 2: Fourth Quarter Births versus All Other Respondents: Draft Cohort *

* Education (4 category)*
tab  VCF0110  q4 if VCF0110>0 & nam==1, col chi

* Education (7 category) *
tab  VCF0140a  q4 if VCF0140a>0 & VCF0140a<8 & nam==1, col chi

* Income *
tab   VCF0114  q4 if VCF0114>0 & nam==1, col chi

* Political Knowledge (Pre) *
tab   VCF0050a q4 if VCF0050a<6 & nam==1, col chi

* Political Knowledge (Post) *
tab   VCF0050b q4 if VCF0050b>0 & VCF0050b<6 & nam==1, col chi

* Interest in Campaigns *
tab  VCF0310 q4 if VCF0310 >0 & VCF0310 <8 & nam==1, col chi

* Party Identification *
tab VCF0301 q4 if VCF0301>0 & VCF0301<9 & nam==1, col chi
ttest pid7 if nam==1, by(q4)

* Liberal/Conservative Ideology *
tab VCF0803 q4 if VCF0803>0 & VCF0803<9 & nam==1, col chi
ttest lc, by(q4) 

* Voter Registration
tab VCF0737 q4 if VCF0737>0 & VCF0737<9 & nam==1, col chi

* Voter Participation
tab VCF0702 q4 if VCF0702>0 & VCF0702<9 & nam==1, col chi

* ONLINE APPENDIX Table 1: First Quarter Births versus All Other Respondents: Full Sample*

* Education (4 category)*
tab  VCF0110  q1 if VCF0110>0, col chi

* Education (7 category) *
tab  VCF0140a  q1 if VCF0140a>0 & VCF0140a<8, col chi

* Income *
 tab   VCF0114  q1 if VCF0114>0, col chi

* Political Knowledge (Pre) *
tab   VCF0050a q1 if VCF0050a<6, col chi

* Political Knowledge (Post) *
tab   VCF0050b q1 if VCF0050b>0 & VCF0050b<6, col chi

* Interest in Campaigns *
tab  VCF0310 q1 if VCF0310 >0 & VCF0310 <8, col chi

* Party Identification *
tab VCF0301 q1 if VCF0301>0 & VCF0301<9, col chi
ttest pid7, by(q1)

* Liberal/Conservative Ideology *
tab VCF0803 q1 if VCF0803>0 & VCF0803<9, col chi
ttest lc, by(q1)

* Voter Registration
tab VCF0737 q1 if VCF0737>0 & VCF0737<9, col chi

* Voter Participation
tab VCF0702 q1 if VCF0702>0 & VCF0702<9, col chi

* ONLINE APPENDIX Table 2: First Quarter Births versus All Other Respondents: Draft Cohort *

* Education (4 category)*
tab  VCF0110  q1 if VCF0110>0  & nam==1, col chi

* Education (7 category) *
tab  VCF0140a  q1 if VCF0140a>0 & VCF0140a<8  & nam==1, col chi

* Income *
tab   VCF0114  q1 if VCF0114>0  & nam==1, col chi

* Political Knowledge (Pre) *
tab   VCF0050a q1 if VCF0050a<6  & nam==1, col chi

* Political Knowledge (Post) *
tab   VCF0050b q1 if VCF0050b>0 & VCF0050b<6  & nam==1, col chi

* Interest in Campaigns *
tab  VCF0310 q1 if VCF0310 >0 & VCF0310 <8  & nam==1, col chi

* Party Identification *
tab VCF0301 q1 if VCF0301>0 & VCF0301<9  & nam==1, col chi
ttest pid7 if nam==1, by(q1)

* Liberal/Conservative Ideology *
tab VCF0803 q1 if VCF0803>0 & VCF0803<9  & nam==1, col chi
ttest lc if nam==1, by(q1) 

* Voter Registration
tab VCF0737 q1 if VCF0737>0 & VCF0737<9  & nam==1, col chi

* Voter Participation
tab VCF0702 q1 if VCF0702>0 & VCF0702<9  & nam==1, col chi


