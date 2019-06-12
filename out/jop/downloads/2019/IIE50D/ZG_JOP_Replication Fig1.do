
********************************************************************************
** Replication data for														  **
** "Local Government Efficiency and Anti-Immigrant Violence"  				  **
** Authors: Conrad Ziller and Sara Wallace Goodman							  **
** forthcoming in The Journal of Politics									  **
** Date: January, 21, 2019													  **
**																			  **
** Figure 1													                  **
********************************************************************************




use "ZG_JOP_lits.dta" , clear



//Recode

recode q812a -98=. -97=. , gen(LGP)
recode gender_pr 2=0, gen(female)
gen age = age_pr
gen copinc=q225a //coping on income

recode q908 -99=. -90=99, gen(leng)

gen edu=q109_1

gen socdis=0
replace socdis=1 if q429d==1 | q429o==1 | q429g==1

gen kids=0
replace kids=1 if q104_2==4 | q104_3==4 | q104_4==4 | q104_5==4 | q104_6==4 

gen interact=0
replace interact=1 if q802a==1 |  q802b==1 | q802c==1 | q802d==1 | q802e==1 | q802f==1 | q802g==1 | q802h==1 





***//predicting resiudals
reg LGP leng interact female age  i.copinc edu  socdis kids 
 
predict resLGP, resid
*predict u0, reffects
*gen resLGP=u0+e




preserve
collapse resLGP  LGP lge_g , by(town)
pwcorr *



drop if resLGP==. | lge_g==.
reg resLGP lge_g , beta
pwcorr LGP resLGP lge_g
reg LGP lge_g , beta
tw sc  resLGP lge_g, mlabel(town) ytitle("Aggregated ratings of" "local government performance") xtitle("Efficiency scores") || lfit  resLGP lge_g  
restore




