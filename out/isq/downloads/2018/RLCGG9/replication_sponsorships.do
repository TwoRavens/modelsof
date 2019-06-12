* This do file provides the Stata commands necessary to reproduce the results
* in "The Domestic Politics of Trade and Conflict." We provide information on 
* our sources of data in the text of the article.

* The results for Table 3 require 'replication_votes.dta'

* Results for Table 3
* Without DW-NOMINATE
logit hostvote highskill msens109 xorn109 vote353 vote332, cluster(idno) 
* With DW-NOMINATE
logit hostvote dwnom1 highskill msens109 xorn109 vote353 vote332, cluster(idno)
* With Party
logit hostvote republican highskill msens109 xorn109 vote353 vote332, cluster(idno)
* Diverse districts
logit hostvote highskill msens109 xorn109 vote353 vote332 if diversity>=0.46, cluster(idno)
* Homogenous districts
logit hostvote highskill msens109 xorn109 vote353 vote332 if diversity<0.46, cluster(idno)
* Republicans
logit hostvote highskill msens109 xorn109 vote353 vote332 if republican==1, cluster(idno)
* Democrats
logit hostvote highskill msens109 xorn109 vote353 vote332 if republican==0, cluster(idno)


* The results for Tables 4 and 5 require 'replication_sponsorships.dta'

* Results for Table 4 (109th Congress)
* Basic model
nbreg allsponsor highskill xorn109 msens109 if cong==109
* With DW-NOMINATE
nbreg allsponsor dwnom1 highskill xorn109 msens109 if cong==109
* With party instead of DW-NOMINATE
nbreg allsponsor republican highskill xorn109 msens109 if cong==109
* With controls for extremism and seniority
nbreg allsponsor highskill xorn109 msens109 seniority109 extreme if cong==109
* Diverse districts
nbreg allsponsor highskill xorn109 msens109 if cong==109 & diversity>0.46
* Homogenous districts
nbreg allsponsor highskill xorn109 msens109 if cong==109 & diversity<=0.46
* Republicans
nbreg allsponsor highskill xorn109 msens109 if cong==109 & republican==1
* Democrats
nbreg allsponsor highskill xorn109 msens109 if cong==109 & republican==0

* For footnote: robustness check on split sample models with additional controls
* Diverse districts
nbreg allsponsor highskill xorn109 msens109 seniority109 extreme if cong==109 & diversity>0.46
* Homogenous districts
nbreg allsponsor highskill xorn109 msens109 seniority109 extreme if cong==109 & diversity<=0.46
* Republicans
nbreg allsponsor highskill xorn109 msens109 seniority109 extreme if cong==109 & republican==1
* Democrats
nbreg allsponsor highskill xorn109 msens109 seniority109 extreme if cong==109 & republican==0



* Results for Table 5 (110th Congress)
nbreg allsponsor highskill xorn110 msens110 if cong==110
* With DW-NOMINATE
nbreg allsponsor dwnom1 highskill xorn110 msens110 if cong==110
* With party instead of DW-NOMINATE
nbreg allsponsor republican highskill xorn110 msens110 if cong==110
* With controls for extremism and seniority
nbreg allsponsor highskill xorn110 msens110 seniority110 extreme if cong==110
* Diverse districts
nbreg allsponsor highskill xorn110 msens110 if cong==110 & diversity>0.46
* Homogenous districts
nbreg allsponsor highskill xorn110 msens110 if cong==110 & diversity<=0.46
* Republicans
nbreg allsponsor highskill xorn110 msens110 if cong==110 & republican==1
* Democrats
nbreg allsponsor highskill xorn110 msens110 if cong==110 & republican==0

* Robustness check: split sample models with additional controls
* Diverse districts
nbreg allsponsor highskill xorn110 msens110 seniority110 extreme if cong==110 & diversity>0.46
* Homogenous districts
nbreg allsponsor highskill xorn110 msens110 seniority110 extreme if cong==110 & diversity<=0.46
* Republicans
nbreg allsponsor highskill xorn110 msens110 seniority110 extreme if cong==110 & republican==1
* Democrats
nbreg allsponsor highskill xorn110 msens110 seniority110 extreme if cong==110 & republican==0


