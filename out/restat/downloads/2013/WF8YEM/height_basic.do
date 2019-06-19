/*HEIGHT AND LEADERSHIP*/

**** Use data file from Lindqvist, Erik & Roine Vestman, "The Labor Market Returns to Cognitive and Noncognitive Ability", AEJ: Applied, 3 (2011), 101-128.

drop if bari==.
drop if l_ngdcm >= 318 & l_ngdcm~=.
drop if l_ngdcm==.

/* Fitness index */

gen syre = (wmax/viktkg) if wmax~=. & viktkg~=. & wmax~=0 & viktkg~=0 & viktkg>=40
gen syresq = syre*syre
gen syrecub = syresq*syre
gen syrequad = syresq*syresq
gen wmaxsq=wmax*wmax
gen wmaxcub=wmax*wmaxsq
gen wmaxquad=wmaxsq*wmaxsq

gen sjuk = tsal + tsjpersl if year == 2006
gen dsjuk = 1 if sjuk>0 & sjuk~=. & year == 2006
replace dsjuk = 0 if sjuk == 0 & sjuk~=. & year == 2006

reg dsjuk syre* wmax* if year == 2006
predict sjukindex if syre~=. & wmax~=. & year == 2006

/*Basic manager measure for 2006 only*/
gen chef = 1 if ssykgrupp == 1 & year == 2006
replace chef = 0 if ssykgrupp~=. & ssykgrupp~=1 & year == 2006

/*Basic manager measure with imputed occupation*/
sort bidnr year
gen impssyk = ssykgrupp if year == 2006
replace impssyk = ssykgrupp[_n-1] if year == 2006 & bidnr == bidnr[_n-1] & year[_n-1] == 2005 & impssyk==.
replace impssyk = ssykgrupp[_n-1] if year == 2006 & bidnr == bidnr[_n-1] & year[_n-1] == 2004 & impssyk==.
replace impssyk = ssykgrupp[_n-2] if year == 2006 & bidnr == bidnr[_n-2] & year[_n-2] == 2004 & impssyk==.

gen impchef = 1 if impssyk == 1 & year == 2006
replace impchef = 0 if impssyk~=1 & impssyk~=. & year == 2006

/*Transform VARIABLES*/

gen l_ngdm = l_ngdcm/100
gen tarbinsj_hh = arbinsj_hh/100

/* FIGURE 1 (not using imputed "chef")*/

collapse (mean) chef, by(l_ngdcm)


/* TABLE 1: Height and wages */

reg lwage l_ngdm cd* if year == 2006 & impchef~=., robust
outreg2 l_ngdm using table2,ctitle("1") bdec(3) se replace

reg lwage l_ngdm cd* impchef if year == 2006, robust
outreg2 l_ngdm impchef using table2,ctitle("2") bdec(3) se append

reg lwage l_ngdm cd* ed* if year == 2006 & impchef~=., robust
outreg2 l_ngdm using table2,ctitle("3") bdec(3) se append

reg lwage l_ngdm  cd* ed* impchef if year == 2006, robust
outreg2 l_ngdm impchef using table2,ctitle("4") bdec(3) se append


/* TABLE 2: imputed managers */

reg impchef l_ngdm cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, robust
outreg2 l_ngdm using table1,ctitle("base") bdec(3) se replace

reg impchef l_ngdm halsa* cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, robust
outreg2 l_ngdm using table1,ctitle("health") bdec(3) se append

reg impchef l_ngdm cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006 & halsaA~=., robust
outreg2 l_ngdm using table1,ctitle("health-r") bdec(3) se append

reg impchef l_ngdm sjukindex cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, robust
outreg2 l_ngdm sjukindex using table1,ctitle("end") bdec(3) se append

reg impchef l_ngdm c n cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, robust
outreg2 l_ngdm c n using table1,ctitle("ability") bdec(3) se append

bootstrap: eivreg impchef l_ngdm c n cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, reliab(c .8675 n .70267)
outreg2 l_ngdm c n using table1,ctitle("ability-me") bdec(3) se append

reg impchef l_ngdm c n tarbinsj_hh bgeo* cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, robust
outreg2 l_ngdm c n using table1,ctitle("family") bdec(3) se append

reg impchef l_ngdm c n bgeo* tarbinsj_hh experience expsq edgym edpostgym2 eduniv edphd geogbg geosthlm geomalmo geogota geosvea cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006, robust
outreg2 l_ngdm c n using table1,ctitle("full") bdec(3) se append

reg impchef l_ngdm c n cd66 cd67 cd68 cd69 cd70 cd71 cd72 cd73 cd74 if year == 2006 & experience~=., robust
outreg2 l_ngdm c n using table1,ctitle("exp-r") bdec(3) se append
