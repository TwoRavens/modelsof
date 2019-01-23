
use "20171204_AJPS_MaleskyMosely_w_markups.dta", clear
set more off

/*Heterogenous Effects*/
#delimit;
drop if export_potential==0;
replace g1_3=100*g1_3 if g1_3<1;
replace g1_1=100*g1_1 if g1_1<1;
replace g1_2=100*g1_2 if g1_2<1;
replace g1_6=100*g1_6 if g1_6<1;
replace g1_5=100*g1_5 if g1_5<1;
replace g4_2=100*g4_2 if g4_2<1;

#delimit;
generate destination_USA=1 if destination_1=="United Kingdom United States of America";
replace destination_USA=1 if destination_1=="United Kingdom United States of Ameri..";
replace destination_USA=1 if destination_1==" United States of America";
replace destination_USA=1 if destination_1=="United States of America";
replace destination_USA=0 if destination_USA==.;
tab destination_USA;

#delimit;
reg g13 India if hundred==0, robust;
outreg2 using "AppendixI_heteffects",  tdec(3) bdec(3) 2aster addtext("1. Joint Venture")  replace ;
reg g13 India if hundred==1, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("2. 100% Foreign Owned");
reg g13 India if hundred==1 & MandA==0, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("3. Greenfield Investor");
reg g13 India if hundred==1 & MandA==1, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("4. Entered through Merger & Aquisition");
reg g13 India if MNC==0, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("5. Branch of Multinational Corporation=0"); 
reg g13 India if MNC==1, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("6. Branch of Multinational Corporation=1"); 
reg g13 India if European==1, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("7. Home Country is in Europe"); 
reg g13 India if companycountry=="Japan", robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("8. Home Country is Japan"); 
reg g13 India if companycountry=="South Korea", robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("9. Home Country is South Korea");  
reg g13 India if companycountry=="Taiwan", robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("10 Home Country is Taiwan");  
reg g13 India if companycountry=="Singapore", robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("11. Home Country is Singapore");   
reg g13 India if companycountry=="China", robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("12. Home Country is China");  
reg g13 India if companycountry=="United States", robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("13. Home Country is USA");  

#delimit;
reg g13 India if destination_Europe==1, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("14. Primarily exports to Europe");  
reg g13 India if destination_USA==1, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("15. Primarily exports to USA"); 
reg g13 India if destination_Europe==0 & destination_USA==0, robust;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("16. Primarily exports to Asia"); 


reg g13 India if labor<10;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("17. Less than 10 employees"); 
reg g13 India if labor>=10 & labor<=200;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("18. Between 10 and 200 employees"); 
reg g13 India if labor>200;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("19. Over 200 employees");


#delimit;
reg g13 India if capital<=100;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("20. Less than $100,000 in capital"); 
reg g13 India if capital>100 & capital<=1000;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("21. Between $100,000 and $1 Million in capital"); 
reg g13 India if capital>1000;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("22. Over $1 Million in capital"); 

reg g13 India if expand<=2;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("23. Firm plans to expand pperations"); 
reg g13 India if expand>2;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("24. Firm has no plans to expand operations"); 

reg g13 India if profitable==0;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("25. Firm profitable in 2014");
reg g13 India if profitable==1;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("26. Firm not profitable in 2014");


#delimit;
reg g13 India if g1_3<=50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("27. Less than 50% of employees under contract");
reg g13 India if g1_3>50 & g1_3<100;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("28. Between 50% and 90% employees under contract");
reg g13 India if g1_3==100;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("29. 100% of employees under contract");


#delimit;
reg g13 India if g1_1<=50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("30. Less than 50% of employees are female");
reg g13 India if g1_1>50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("31. More than 50% of employees are female");

#delimit;
reg g13 India if g1_5<=50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("32. Less than 50% of employees are foreign");
reg g13 India if g1_5>50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("33. More than 50% of employees are foreign");


#delimit;
reg g13 India if g1_2<=50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("34. Less than 50% of employees are migrants");
reg g13 India if g1_2>50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("35. More than 50% of employees are migrants");

#delimit;
reg g13 India if g1_6<=5;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("36. Recruitment costs less than 5% of operating costs");
reg g13 India if g1_6>5;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("37. Recruitment costs more than 5% of operating costs");


#delimit;
reg g13 India if g4_2<=50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster addtext("38. Less than 50% of employees are college graduates");
reg g13 India if g4_2>50;
outreg2 using "AppendixI_heteffects", tdec(3) bdec(3) 2aster  addtext("39. More than 50% of employees are college graduates") excel;
