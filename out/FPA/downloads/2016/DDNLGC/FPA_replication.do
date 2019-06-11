* This syntax will replicate the results in "International Trade and 
* United States Relations with China." There are two data files, one 
* derived from the 2006 CCGA study, the other from the 1975 and 1979
* CCFR studies. We urge those replicating our study to examine the original
* data, all of which is available online from either the CCGA or the 
* ICPSR.

* Unless otherwise noted, these commands should be run using the 
* 'ccga2006.dta' file.

* Table 1, column 1
xi: ologit critthreat3 cmsens06 cxint06 highschool somecoll college graddegree i.incquintile i.ideology i.frinterest female age agesquared, cluster(ppstaten)
test highschool somecoll college graddegree 
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology_2 _Iideology_3 _Iideology_4 _Iideology_5 _Iideology_6
test _Ifrinteres_2 _Ifrinteres_3 _Ifrinteres_4
test age agesquared

* Table 1, column 2
xi: ologit critthreat3 cmsens06 cxint06 highschool somecoll college graddegree i.incquintile i.ideology i.frinterest female age agesquared globgood, cluster(ppstaten)
test highschool somecoll college graddegree 
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology_2 _Iideology_3 _Iideology_4 _Iideology_5 _Iideology_6
test _Ifrinteres_2 _Ifrinteres_3 _Ifrinteres_4
test age agesquared

* Table 2, column 1  
xi: logit contain cmsens06 cxint06 highschool somecoll college graddegree i.incquintile i.ideology i.frinterest female age agesquared, cluster(ppstaten)
test highschool somecoll college graddegree 
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology_2 _Iideology_3 _Iideology_4 _Iideology_5 _Iideology_6 
test _Ifrinteres_2 _Ifrinteres_3 _Ifrinteres_4

* Table 2, column 2
xi: logit troopstaiwan cmsens06 cxint06 highschool somecoll college graddegree i.incquintile i.ideology i.frinterest female age agesquared, cluster(ppstaten)
test highschool somecoll college graddegree 
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology_2 _Iideology_3 _Iideology_4 _Iideology_5 _Iideology_6 
test _Ifrinteres_2 _Ifrinteres_3 _Ifrinteres_4

* Table 2, column 3  
xi: logit troopstaiwan cmsens06 cxint06 highschool somecoll college graddegree i.incquintile i.ideology i.frinterest female age agesquared isolat, cluster(ppstaten)
test highschool somecoll college graddegree 
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology_2 _Iideology_3 _Iideology_4 _Iideology_5 _Iideology_6 
test _Ifrinteres_2 _Ifrinteres_3 _Ifrinteres_4
test age agesquared

* Table 3, column 2
xi: logit troopstaiwan highschool somecoll college graddegree i.incquintile i.ideology2 i.frinterest3 female age agesquared isolat
test highschool somecoll college graddegree 
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology2_2 _Iideology2_3 
test _Ifrinteres_2 _Ifrinteres_3 
test age agesquared

* Table 3, column 4
xi: tobit chinatherm i.education i.incquintile i.ideology3 i.frinterest3 female age agesquared, ll(0) ul(100)
test _Ieducation_2 _Ieducation_3 _Ieducation_4
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology3_2 _Iideology3_3 _Iideology3_4 _Iideology3_5 
test _Ifrinteres_2 _Ifrinteres_3
test age agesquared

* The remaining models should be run on the 'ccfr7579.dta," which contains
* data from earlier CCFR surveys.

* Table 3, column 1
xi: logit troopstaiwan i.education2 i.incquintile i.ideology2 i.frinterest3 isolat female age agesquared if survey==1975
test _Ieducation_2 _Ieducation_3 _Ieducation_4 _Ieducation_5
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology2_2 _Iideology2_3
test _Ifrinteres_2 _Ifrinteres_3
test age agesquared

* Table 3, column 3
xi: tobit chinatherm i.education i.incquintile i.ideology3 i.frinterest3 female age agesquared if survey==1979, ll(0) ul(100)
test _Ieducation_2 _Ieducation_3 _Ieducation_4
test _Iincquinti_2 _Iincquinti_3 _Iincquinti_4 _Iincquinti_5
test _Iideology3_2 _Iideology3_3 _Iideology3_4 _Iideology3_5
test _Ifrinteres_2 _Ifrinteres_3

