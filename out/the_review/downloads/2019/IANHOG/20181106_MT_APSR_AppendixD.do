
#delimit;
cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Clean.dta", clear;

tab r1_group, gen(group);


/**************************************Balance************************************/


#delimit;
reg success group1 group2 group3, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90) replace  ;

test group1=group2;
scalar define p_1_1=r(p);
test group1=group3;
scalar define p_2_1=r(p);
test group2=group3;
scalar define p_3_1=r(p);


#delimit;
reg access group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90) ;

test group1=group2;
scalar define p_1_2=r(p);
test group1=group3;
scalar define p_2_2=r(p);
test group2=group3;
scalar define p_3_2=r(p);


#delimit;
reg ceo group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90) ;

test group1=group2;
scalar define p_1_3=r(p);
test group1=group3;
scalar define p_2_3=r(p);
test group2=group3;
scalar define p_3_3=r(p);


#delimit;
reg female group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90) ;

test group1=group2;
scalar define p_1_4=r(p);
test group1=group3;
scalar define p_2_4=r(p);
test group2=group3;
scalar define p_3_4=r(p);


#delimit;
reg hanoi group1 group2 group3 if success==1, nocons ;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_5=r(p);
test group1=group3;
scalar define p_2_5=r(p);
test group2=group3;
scalar define p_3_5=r(p);

#delimit;
split district, generate(district) parse("") limit(4);
generate rural=1 if district1=="Huyen";
replace rural=0 if district1 !="Huyen";

reg rural group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_6=r(p);
test group1=group3;
scalar define p_2_6=r(p);
test group2=group3;
scalar define p_3_6=r(p);


#delimit;
reg r1_emp group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_7=r(p);
test group1=group3;
scalar define p_2_7=r(p);
test group2=group3;
scalar define p_3_7=r(p);

#delimit;
generate r1_emp2=r1_emp;
replace r1_emp2=4 if r1_emp>4 & r1_emp<=6;
tab r1_emp2, gen(labor_size);

#delimit;
reg labor_size1 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_8=r(p);
test group1=group3;
scalar define p_2_8=r(p);
test group2=group3;
scalar define p_3_8=r(p);

#delimit;
reg labor_size2 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_9=r(p);
test group1=group3;
scalar define p_2_9=r(p);
test group2=group3;
scalar define p_3_9=r(p);

#delimit;
reg labor_size3 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_10=r(p);
test group1=group3;
scalar define p_2_10=r(p);
test group2=group3;
scalar define p_3_10=r(p);

#delimit;
reg labor_size4 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_11=r(p);
test group1=group3;
scalar define p_2_11=r(p);
test group2=group3;
scalar define p_3_11=r(p);



generate labor_change=ln(c3a);
replace labor_change=0 if c3==1;
replace labor_change=0-ln(c3b) if labor_change==.;


#delimit;
reg labor_change group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90);

test group1=group2;
scalar define p_1_12=r(p);
test group1=group3;
scalar define p_2_12=r(p);
test group2=group3;
scalar define p_3_12=r(p);


#delimit;
reg c2 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_13=r(p);
test group1=group3;
scalar define p_2_13=r(p);
test group2=group3;
scalar define p_3_13=r(p);

#delimit;
reg r1_c11 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_14=r(p);
test group1=group3;
scalar define p_2_14=r(p);
test group2=group3;
scalar define p_3_14=r(p);


#delimit;
generate capital_size=r1_c11;
replace capital_size=5 if r1_c11>5;
tab capital_size, gen(capital_size);

#delimit;
reg capital_size1 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_15=r(p);
test group1=group3;
scalar define p_2_15=r(p);
test group2=group3;
scalar define p_3_15=r(p);

#delimit;
reg capital_size2 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_16=r(p);
test group1=group3;
scalar define p_2_16=r(p);
test group2=group3;
scalar define p_3_16=r(p);


#delimit;
reg capital_size3 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_17=r(p);
test group1=group3;
scalar define p_2_17=r(p);
test group2=group3;
scalar define p_3_17=r(p);


#delimit;
reg capital_size4 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_18=r(p);
test group1=group3;
scalar define p_2_18=r(p);
test group2=group3;
scalar define p_3_18=r(p);


#delimit;
reg capital_size5 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_19=r(p);
test group1=group3;
scalar define p_2_19=r(p);
test group2=group3;
scalar define p_3_19=r(p);

#delimit;
gen capital_labor=r1_c11/r1_c12a;

#delimit;
reg capital_labor group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_20=r(p);
test group1=group3;
scalar define p_2_20=r(p);
test group2=group3;
scalar define p_3_20=r(p);

#delimit;
generate manufacturing=1 if r1_catsector=="C";
replace manufacturing=0 if r1_catsector!="C";


#delimit;
reg manufacturing group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_21=r(p);
test group1=group3;
scalar define p_2_21=r(p);
test group2=group3;
scalar define p_3_21=r(p);



#delimit;
generate wood=1 if sector_plus=="C16";
replace wood=0 if sector_plus!="C16";

#delimit;
reg wood group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_22=r(p);
test group1=group3;
scalar define p_2_22=r(p);
test group2=group3;
scalar define p_3_22=r(p);

#delimit;
generate metal=1 if sector_plus=="C25";
replace metal=0 if sector_plus!="C25";

#delimit;
reg metal group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;


test group1=group2;
scalar define p_1_23=r(p);
test group1=group3;
scalar define p_2_23=r(p);
test group2=group3;
scalar define p_3_23=r(p);

#delimit;
generate paper=1 if sector_plus=="C17";
replace paper=0 if sector_plus!="C17";

#delimit;
reg paper group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_24=r(p);
test group1=group3;
scalar define p_2_24=r(p);
test group2=group3;
scalar define p_3_24=r(p);


#delimit;
generate chemicals=1 if sector_plus=="C20";
replace chemicals=0 if sector_plus!="C20";

#delimit;
reg chemicals group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_25=r(p);
test group1=group3;
scalar define p_2_25=r(p);
test group2=group3;
scalar define p_3_25=r(p);

#delimit;
generate transport=1 if sector_plus=="H";
replace transport=0 if sector_plus!="H";

#delimit;
reg transport group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_26=r(p);
test group1=group3;
scalar define p_2_26=r(p);
test group2=group3;
scalar define p_3_26=r(p);

#delimit;
replace r1_lg_form=4 if r1_lg_form>4;


#delimit;
tab r1_lg_form, gen(type);
reg type1 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_27=r(p);
test group1=group3;
scalar define p_2_27=r(p);
test group2=group3;
scalar define p_3_27=r(p);

#delimit;
reg type2 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_28=r(p);
test group1=group3;
scalar define p_2_28=r(p);
test group2=group3;
scalar define p_3_28=r(p);

#delimit;
reg type3 group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_29=r(p);
test group1=group3;
scalar define p_2_29=r(p);
test group2=group3;
scalar define p_3_29=r(p);


/*Legitimacy*/
#delimit;
reg gov_understands group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_30=r(p);
test group1=group3;
scalar define p_2_30=r(p);
test group2=group3;
scalar define p_3_30=r(p);


#delimit;
reg rents group1 group2 group3 if success==1, nocons;
outreg2 using balance_test_tax, bdec(3) tdec(3)  ci e(rmse) noaster level(90)  ;

test group1=group2;
scalar define p_1_31=r(p);
test group1=group3;
scalar define p_2_31=r(p);
test group2=group3;
scalar define p_3_31=r(p);




#delimit;
matrix define p_value=(p_1_1, p_2_1, p_3_1\p_1_2, p_2_2, p_3_2\p_1_3, p_2_3, p_3_3\p_1_4, p_2_4, p_3_4\p_1_5, p_2_5, p_3_5\p_1_6, p_2_6, p_3_6\p_1_7, p_2_7, p_3_7\p_1_8, p_2_8, p_3_8\p_1_9, p_2_9, p_3_9\p_1_10, p_2_10, p_3_10\
p_1_11, p_2_11, p_3_11\p_1_12, p_2_12, p_3_12\p_1_13, p_2_13, p_3_13\p_1_14, p_2_14, p_3_14\p_1_15, p_2_15, p_3_15\p_1_16, p_2_16, p_3_16\p_1_17, p_2_17, p_3_17\p_1_18, p_2_18, p_3_18\p_1_19, p_2_19, p_3_19\p_1_20, p_2_20, p_3_20\
p_1_21, p_2_21, p_3_21\p_1_22, p_2_22, p_3_22\p_1_23, p_2_23, p_3_23\p_1_24, p_2_24, p_3_24\p_1_25, p_2_25, p_3_25\p_1_26, p_2_26, p_3_26\p_1_17, p_2_27, p_3_27\p_1_28, p_2_28, p_3_28\p_1_29, p_2_29, p_3_29\p_1_30, p_2_30, p_3_30\
p_1_31, p_2_31, p_3_31);

mat list p_value;
collapse c0;
svmat p_value;






