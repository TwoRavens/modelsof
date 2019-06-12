/* ----------------------------
Creates new department codes which group up the product groups is a more reasonable way
--------------------------------*/

gen dept_est=.

replace dept_est=1 if group==-17
replace dept_est=4 if group==-16
replace dept_est=3 if group==-15
replace dept_est=3 if group==-14
replace dept_est=6 if group==-13
replace dept_est=6 if group==-12
replace dept_est=2 if group==-11
replace dept_est=1 if group==501
replace dept_est=6 if group==506
replace dept_est=2 if group==507
replace dept_est=1 if group==510
replace dept_est=1 if group==511
replace dept_est=6 if group==512
replace dept_est=1 if group==513
replace dept_est=3 if group==1001
replace dept_est=5 if group==1007
replace dept_est=4 if group==1008
replace dept_est=6 if group==1011
replace dept_est=2 if group==1012
replace dept_est=3 if group==1013
replace dept_est=6 if group==1014
replace dept_est=5 if group==1015
replace dept_est=3 if group==1016
replace dept_est=5 if group==1017
replace dept_est=4 if group==1501
replace dept_est=2 if group==1503
replace dept_est=4 if group==1505
replace dept_est=4 if group==1506
replace dept_est=4 if group==1507
replace dept_est=2 if group==1508
replace dept_est=7 if group==-23
replace dept_est=7 if group==-22
replace dept_est=7 if group==-21
replace dept_est=7 if group==2004
replace dept_est=7 if group==2009
replace dept_est=7 if group==2010
replace dept_est=8 if group==-31
replace dept_est=8 if group==2501
replace dept_est=8 if group==2502
replace dept_est=8 if group==2503
replace dept_est=8 if group==2505
replace dept_est=8 if group==2506
replace dept_est=8 if group==2510
replace dept_est=9 if group==3001
replace dept_est=9 if group==-51
replace dept_est=9 if group==4001


gen dept_est_des=""
replace dept_est_des="Ready to eat meals-Dry" if dept_est==1
replace dept_est_des="Drinks" if dept_est==2
replace dept_est_des="Staples" if dept_est==3
replace dept_est_des="Snacks" if dept_est==4
replace dept_est_des="Condiments/Spices" if dept_est==5
replace dept_est_des="Canned/Dried Fresh Items" if dept_est==6
replace dept_est_des="Frozen" if dept_est==7
replace dept_est_des="Dairy" if dept_est==8
replace dept_est_des="Refridgerated/Fresh" if dept_est==9
