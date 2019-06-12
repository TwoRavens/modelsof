clear
*cd "/Users/jeffcolgan/Dropbox/Academic research, solo/Syllabi for PhD IR/data analysis"

** Analysis Part I **
* Paste in data from columns C-E and G-I from the "Combined Journal rank" tab of supplementary data file to Stata's data editor

/* Figure 1: TIS compared to SSCI for IR journals */
gen ln_TIS = ln(colgan)
scatter ln_TIS ssci, mlabel(jcode)

** Analysis Part II **
clear
insheet using "cutpaste - Colgan Syllabi readings and TRIPS - 2014July7.csv"
ren  tripsdatabaseid id
sort id
merge id using "Maliniak_et_al_replication_data_sorted.dta" , _merge(maliniak_merge) 
*exit

/* Figure 2: Comparing "canonical" assigned readings to citations*/
gen initdate = substr(author1last,1,4) + substr(author2last,1,1) + substr(author3last,1,1) + substr(year,3,2) 
replace initdate = substr(A0Last,1,4) + substr(string(C__Year),3,2) if initdate==""
gen tempassign = assignments
replace tempassign = 0 if ssci>200 & assign==.
ren tempassign Teach_Assign
*edit A0Last Teach_Assign ssci C__Year if ssci>200 & ssci!=.
replace Teach_Assign =2 if C__Year == 1990 & A0Last=="Mearsheimer"
replace Teach_Assign =2 if C__Year == 1992 & A0Last=="Haas" & id==1263
replace Teach_Assign =1 if id==286
replace Teach_Assign =1 if id==1290
replace Teach_Assign =2 if id==1293
replace Teach_Assign =1 if id==1371
replace Teach_Assign =2 if id==5862
replace Teach_Assign =2 if id==6339
replace Teach_Assign =1 if id==6488
replace Teach_Assign =1 if id==9426
*twoway scatter assignments ssci
*twoway (scatter assignments ssci if ((ssci>200 & assign!=6) | ssci>300 | assign > 11), mlabel(initdate)) (scatter assignments ssci)
*twoway scatter assignments ssci
*twoway (scatter tempassign ssci if ((ssci>200 & tempassign!=6 & tempassign!=0) | (ssci>300 & tempassign==0) | ssci>400 | tempassign > 11), mlabel(initdate)) (scatter tempassign ssci)
ren sscie_count ssci
twoway (scatter Teach_Assign ssci if ((ssci>200 & Teach_Assign!=6 & Teach_Assign>2) | (ssci>300 & (Teach_Assign==1|Teach_Assign==6)) | ssci>400 | Teach_Assign > 11), mlabel(initdate)) (scatter Teach_Assign ssci), legend(off)

/* Table 4: Comparing "canonical" assigned readings to all publications*/
ttest meth_quant, by(malin)
ttest meth_qual, by(malin)
ttest meth_formal, by(malin)
ttest meth_anal, by(malin)
ttest meth_exp, by(malin)
ttest meth_desc, by(malin)
ttest meth_cou, by(malin)
ttest meth_policy, by(malin)

ttest para_real, by(malin)
ttest para_lib, by(malin)
ttest para_const, by(malin)
ttest para_non, by(malin)
ttest para_atheo, by(malin)

ttest A0Tenure, by(malin)
ttest all_male, by(malin)
ttest positivist, by(malin)

