use "C:\replication.dta", clear

**Means For Table 1**

**Party ID 1965**
mean V84 
**Party ID 1973**
mean V482 
**Party ID 1982**
mean V1608 
**Party ID 5754**
mean V5754 

**Ideology 1973**
mean V380 
**Ideology 1982**
mean V1304 
**Ideology 1997**
mean V5300 

**Minority Assistance 1973**
mean V343 
**Minority Assistance 1982**
mean V1233 
**Minority Assistance 1997**
mean V5252 

**Women's Rights 1973**
mean V364 
**Women's Rights 1982**
mean V1248 
**Women's Rights 1997**
mean V5254 

**Rights of the Accused 1973**
mean V335 
**Rights of the Accused 1982**
mean V1227 
**Rights of the Accused 1997**
mean V5251 

**Guaranteed Jobs 1973**
mean V328 
**Guaranteed Jobs 1982**
mean V1221 
**Guaranteed Jobs 1997**
mean V5250 

**Legalized Marijuana 1973**
mean V351 
**Legalized Marijuana 1982**
mean V1239 
**Legalized Marijuana 1997**
mean V5253 

****T-Tests For Table 1****

*T-Tests For Mean 1973 Cells*

**Party Identification**
ttest V84==V482 

*T-Tests For Mean 1982 Cells*

**Party Identification**
ttest V482==V1608 
**Ideology**
ttest V380==V1304 
**Minority Assistance**
ttest V343==V1233 
**Women's Rights**
ttest V364==V1248 
**Rights of the Accused**
ttest V335==V1227 
**Guaranteed Jobs**
ttest V328==V1221 
**Legalized Marijuana**
ttest V351==V1239 

*T-Tests For Mean 1991 Cells*

**Party Identification**
ttest V1608==V5754 
**Ideology**
ttest V1304==V5300 
**Minority Assistance**
ttest V1233==V5252 
**Women's Rights**
ttest V1248==V5254 
**Rights of the Accused**
ttest V1227==V5251 
**Guaranteed Jobs**
ttest V1221==V5250 
**Legalized Marijuana**
ttest V1239==V5253 


 