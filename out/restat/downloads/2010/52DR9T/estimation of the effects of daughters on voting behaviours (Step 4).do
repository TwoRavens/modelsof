
**Estimation**

 xi:logit vote_lib_lab_not_cons  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , cluster(pid)

 estimates store a1

  xi:logit vote_lib_lab_not_cons  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp i.married_gender cohabit widow divorce separated i.region i.round /*
*/ , cluster(pid)

 estimates store a_1


  xi:xtlogit vote_lib_lab_not_cons  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , fe i(pid)

 estimates store a2


  xi:xtlogit vote_lib_lab_not_cons  sex  i.nat_child_total /*
*/ nat_daughter_total  roman coe other_religion /*
*/ not_nat_daughter i.not_nat_children /*
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , fe i(pid)

 estimates store a3

  xi:xtreg all_daughter_total  vote_lib_lab_not_cons_t_1  sex   all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , fe i(pid)

estimates store b2

  xi:reg all_daughter_total  vote_lib_lab_not_cons_t_1  sex   all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , cluster(pid)

estimates store b1

estout a1 a_1 a2 a3  using "e:\BHPS\daughters\predict_voting_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   

estout    b1 b2 using "e:\BHPS\daughters\predict_daughter_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   



  xi:xtlogit vote_lib_lab_not_cons  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ if sex == 0, fe i(pid)

estimates store c1

  xi:xtlogit vote_lib_lab_not_cons  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ if sex == 1, fe i(pid)

estimates store c2

estout    c1 c2 using "e:\BHPS\daughters\predict_voting_gend_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   


  xi:xtlogit vote_lib_lab_not_cons  sex  i.nat_child_total /*
*/ nat_daughter_total  roman coe other_religion /*
*/ not_nat_daughter i.not_nat_children /*
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ if sex == 0, fe i(pid)

 estimates store c3

  xi:xtlogit vote_lib_lab_not_cons  sex  i.nat_child_total /*
*/ nat_daughter_total  roman coe other_religion /*
*/ not_nat_daughter i.not_nat_children /*
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ if sex == 1, fe i(pid)

 estimates store c4

estout    c3 c4 using "e:\BHPS\daughters\predict_voting_gend2_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   





  xi:xtlogit vote_lib_lab_not_cons  sex  all_daughter_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ if (all_son_total ==0 & all_child_total<=1  ), fe i(pid)

estimates store d1

  xi:xtlogit vote_lib_lab_not_cons  sex  all_son_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ if (all_daughter_total ==0 & all_child_total<=1  ), fe i(pid)

estimates store d2

estout    d1 d2 using "e:\BHPS\daughters\first_born_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   

*income interaction*


  xi:logit vote_lib_lab_not_cons  sex  all_daughter_total daughters_income i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , cluster(pid)

 estimates store e1

  xi:xtlogit vote_lib_lab_not_cons  sex  all_daughter_total daughters_income  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , fe i(pid)

 estimates store e2

estout    e1 e2 using "e:\BHPS\daughters\daughter_income_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   


*attitude*

  xi:xtreg opfamo  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , re i(pid)

 estimates store f1

  xi:xtreg opfamr  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , re i(pid)

 estimates store f2

  xi:xtreg opfamf sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , re i(pid)

 estimates store f3

  xi:xtreg opfamg  sex  all_daughter_total  i.all_child_total /*
*/  roman coe other_religion  /*
 
*/ age age2  income_1000 hhsize hlghq2/*
*/ first_degree higher_degree i.emp married cohabit widow divorce separated i.region i.round /*
*/ , re i(pid)

 estimates store f4

estout   f1 f2 f3 f4 using "e:\BHPS\daughters\attitude_06.03.08.xls", cells(b(star fmt(%9.3f) ) /*
*/ se)  style(fixed) stats(r2 r2_w ll N, fmt(3 %9.0g)) starl(* 0.1 ** 0.05 *** 0.01)   legend label collabels(, none)   
