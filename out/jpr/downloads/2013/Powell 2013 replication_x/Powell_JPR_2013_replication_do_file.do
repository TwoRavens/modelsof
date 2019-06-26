***Emilia Justyna Powell "Islamic law states and International Court of Justice" Journal of Peace Research 2013, 50(2)


**** final model used in the paper:

*table III (COMPLULSORY JURISDICTION)



*Predicted probabilities 
estsimp logit dichacceptance    custom_oral_law prd  rule_of_law constitution_HO  civil_code  koran_education  constitution_Sharia_God democracy  cap   pacsettg pacsettr, cluster (ccode)


*****

 
 *LOGIT MODELS WITHOUT SUDAN (1958-65) (CCODE 625) (because these observations are outliers)

 *Table III:
 
drop if ccode==625& year==1958
drop if ccode==625& year==1959
drop if ccode==625& year==1960
drop if ccode==625& year==1961
drop if ccode==625& year==1962
drop if ccode==625& year==1963
drop if ccode==625& year==1964
drop if ccode==625& year==1965
 
 
 estsimp logit dichacceptance    custom_oral_law prd  rule_of_law constitution_HO  civil_code  koran_education  constitution_Sharia_God democracy  cap   pacsettg pacsettr, cluster (ccode)
 

 
 *TABLE IV (COMPROMISSORY JURISDICTION)


* I am using negative binomial model and then calculating the expected counts using clarify


nbreg numcompt custom_oral_law prd rule_of_law constitution_HO civil_code koran_education constitution_Sharia_God cap democracy pacsettg pacsettr, cluster (ccode)

*predicted probabilities compromissory jurisdiction:
estsimp nbreg numcompt custom_oral_law prd rule_of_law constitution_HO civil_code koran_education constitution_Sharia_God cap democracy pacsettg pacsettr, cluster (ccode)




*NEGATIVE BINOMIAL MODEL WITHOUT IRAN 1986-2001 and GAMBIA 2000-2004(because these observations are outliers)
drop if ccode==630& year==1986
drop if ccode==630& year==1987
drop if ccode==630& year==1988
drop if ccode==630& year==1989
drop if ccode==630& year==1990
drop if ccode==630& year==1991
drop if ccode==630& year==1992
drop if ccode==630& year==1993
drop if ccode==630& year==1994
drop if ccode==630& year==1995
drop if ccode==630& year==1996
drop if ccode==630& year==1997
drop if ccode==630& year==1998
drop if ccode==630& year==1999
drop if ccode==630& year==2000
drop if ccode==630& year==2001
drop if ccode==630& year==2002

drop if ccode==420& year==2000
drop if ccode==420& year==2001
drop if ccode==420& year==2002
drop if ccode==420& year==2003
drop if ccode==420& year==2004

*******
*predicted probabilities compromissory jurisdiction table IV from JPR (model without outliers (iran and gambia):
estsimp nbreg numcompt custom_oral_law prd rule_of_law constitution_HO civil_code koran_education constitution_Sharia_God cap democracy pacsettg pacsettr, cluster (ccode)




 
 