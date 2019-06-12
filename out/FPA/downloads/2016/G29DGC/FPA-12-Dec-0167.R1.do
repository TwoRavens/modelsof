*Characteristics of Complex Rivalries

clear
clear matrix
set more off

use "/Users/mattpowers/Desktop/FPA/CIR Data, FPA.dta"

*Table 2
tab war_2
tab war_2 if endure==1
tab war_2 if censor==1
tab war_2 if strateg==1

tab war_3
tab war_3 if endure==1
tab war_3 if censor==1
tab war_3 if strateg==1

sum dur if endure==1
sum dur if censor==1

sum disp
sum disp if endure==1
sum disp if censor==1
sum disp if strateg==1

sum triadhist
sum triadhist if endure==1
sum triadhist if censor==1
sum triadhist if strateg==1

*Table 3
tab locat

*Table 4
tab twomajors
tab twomajors if endure==1
tab twomajors if censor==1
tab twomajors if strateg==1

tab onemajor
tab onemajor if endure==1
tab onemajor if censor==1
tab onemajor if strateg==1

tab nomajors
tab nomajors if endure==1
tab nomajors if censor==1
tab nomajors if strateg==1

tab threemajors
tab threemajors if endure==1
tab threemajors if censor==1
tab threemajors if strateg==1

tab oneplusmaj
tab oneplusmaj if endure==1
tab oneplusmaj if censor==1
tab oneplusmaj if strateg==1

tab twoplusmaj
tab twoplusmaj if endure==1
tab twoplusmaj if censor==1
tab twoplusmaj if strateg==1

*Table 5
list if crimean==1
list if sevenweeks==1
list if pacific==1
list if boxer==1
list if thrdcentam==1
list if wwi==1
list if wwii==1
list if palestine==1
list if korean==1
list if viet==1
list if sixday==1
list if kippur==1
list if gulf==1

*Number of Dyadic Rivals in Complex Rivalries
tab tot_rivs

*Capability Ratios less than '1'
list if caprat<1

*Positional versus spatial
tab pureposit
tab purespat
tab primposit
tab primspat
tab mixed
tab pureprimposit

*********************************

*Comparing Complex Rivalries to Dyadic Rivalries

clear
clear matrix

use "/Users/mattpowers/Desktop/FPA/complex v. dyadic, FPA.dta"

*Comparing disputes
sum disputes if id1==1
ttest dispute, by(id1)

*Comparing wars
tab war_2 if id1==1
prtest war_2, by(id1)

*Comparing duration
sum duration if id1==1
sum duration if id2==0
ttest duration, by(id1)

*Major power status of dyadic rivals
tab majmaj
tab majmin
tab minmin

*Comparing capability ratios
tab capmore4 if id3==0
tab capmore10 if id3==0
tab capmore4 if id1==1
tab capmore10 if id1==1
prtest capmore10, by(id3)
