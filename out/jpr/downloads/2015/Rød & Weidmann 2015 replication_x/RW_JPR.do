clear all
capture cd "/Users/roed/Documents/Work/internetdemoc"

use "RW_JPR.dta"

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

* TABLE I

xtset cow

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l pruralpop_l lntotpop_l internet2_l 

xtreg internet2 fh_press_l  ///
           `ctrl', fe

est sto m1

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l

xtreg internet2_change fh_press_l ///
           `ctrl', fe

est sto m3

xtset cow

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l internet2_l

xtreg internet2 fh_press_l3 ///
           `ctrl', fe

est sto m2

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l

xtreg internet2_change fh_press_l3 ///
           `ctrl', fe

est sto m4

* Exporting models *

estout m1 m2 m3 m4, cells(b & _star t) stats(sigma_u N N_g)

*esttab m1 m2 m3 m4 ///
*using "Tables/reg1.tex", ///
*b(3) se label scalar(N N_g) star(* 0.05 ** 0.01 *** 0.001) title("The Implementation of Internet in Authoritarian Regimes") replace

* TABLE AI

xtset cow

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l pruralpop_l lntotpop_l gwf_military gwf_monarchy gwf_personal lnoilgas_l internet2_l

xtreg internet2 fh_press_l ///
           `ctrl', fe

est sto m1

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l gwf_military gwf_monarchy gwf_personal lnoilgas_l

xtreg internet2_change fh_press_l ///
           `ctrl', fe

est sto m3

xtset cow

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l gwf_military gwf_monarchy gwf_personal lnoilgas_l internet2_l

xtreg internet2 fh_press_l3 ///
           `ctrl', fe

est sto m2

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l gwf_military gwf_monarchy gwf_personal lnoilgas_l

xtreg internet2_change fh_press_l3 ///
           `ctrl', fe

est sto m4

* Exporting models *

estout m1 m2 m3 m4, cells(b & _star t) stats(sigma_u N N_g)

*esttab m1 m2 m3 m4 ///
*using "Tables/reg1_rob.tex", ///
*b(3) se label scalar(N N_g) star(* 0.05 ** 0.01 *** 0.001) title("The Implementation of Internet in Authoritarian Regimes") replace


****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

* TABLE II

tab year polity_ch2
tab year demtrans

tab polity_ch2 if year<2000
tab polity_ch2 if year>=2000 & year<=2005
tab polity_ch2 if year>2005

tab demtrans if year<2000
tab demtrans if year>=2000 & year<=2005
tab demtrans if year>2005

local ctrl lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l lnoilgas_l typeofconflict gwf_military gwf_monarchy gwf_personal lntotpop_l pruralpop_l t_s_dem_l t_s_dem_l2 t_s_dem_l3 

xtlogit polity_ch2 internet2_l ///
	 `ctrl', re

est sto m5

local ctrl lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l lnoilgas_l typeofconflict gwf_military gwf_monarchy gwf_personal lntotpop_l pruralpop_l gwf_duration_l gwf_duration_l2 gwf_duration_l3 

xtlogit demtrans internet2_l ///
	 `ctrl', re

est sto m6

local ctrl lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l lnoilgas_l typeofconflict gwf_military gwf_monarchy gwf_personal lntotpop_l pruralpop_l t_s_dem_l t_s_dem_l2 t_s_dem_l3 

xtlogit polity_ch2 internet2_change_l ///
	 `ctrl', re

est sto m7

local ctrl lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l lnoilgas_l typeofconflict gwf_military gwf_monarchy gwf_personal lntotpop_l pruralpop_l gwf_duration_l gwf_duration_l2 gwf_duration_l3 

xtlogit demtrans internet2_change_l ///
	 `ctrl', re

est sto m8

estout m5 m6 m7 m8, cells(b & _star t) stats(sigma_u N N_g)

*esttab m5 m6 m7 m8 ///
*using "Tables/reg2.tex", ///
*b(3) se label scalar(N N_g) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) title("Estimated Effect of Internet Adoption on Democratization") replace

* TABLE AII

local ctrl lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l lnoilgas_l typeofconflict gwf_military gwf_monarchy gwf_personal lntotpop_l pruralpop_l polity_lndur_l polity_lndur_l2 polity_lndur_l3

mlogit polity_ch internet2_l ///
	 `ctrl', cluster(cow)

est sto m9

estout m9, cells(b & _star t) stats(sigma_u N N_g)

*outreg2 [m9] using "Tables/reg3.tex", ///
*e(all) replace dec(3) label alpha(0.001, 0.01, 0.05)


* TABLE AIII

xtset cow

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l pruralpop_l lntotpop_l fh_press_l

xtreg fh_press internet2_l  ///
           `ctrl', fe

est sto m11

local ctrl gwf_lndur_l polity2_l typeofconflict lngdppc_l2 gdppcgrpwth_l2 lnpwt_openc_l  pruralpop_l lntotpop_l fh_press_l

xtreg fh_press internet2_change_l ///
           `ctrl', fe

est sto m12

estout m11 m12, cells(b & _star t) stats(sigma_u N N_g)

*esttab m11 m12 ///
*using "Tables/reg1_rev.tex", ///
*b(3) se label scalar(N N_g) star(* 0.05 ** 0.01 *** 0.001) title("The Implementation of Internet in Authoritarian Regimes") replace


* TABLE III


* Episodes of autocratization and democratization 2006-2010

sort cow year

* Below median Internet penetration

summ cow if internet2<=medianinternet & year>=2006 & polity_ch==1 & polity_ch!=. & internet2!=.

summ cow if internet2<=medianinternet & year>=2006 & polity_ch==2 & polity_ch!=. & internet2!=.

summ cow internet2 fh_press if internet2<=medianinternet & year>=2006 & polity_ch!=. & internet2!=.

* 11 episodes of democratization

list gwf_countryx year internet2 polity_ch if internet2<=medianinternet & year>=2006 & polity_ch==1 & polity_ch!=.

* 0 episodes of autocratization

list gwf_countryx year internet2 polity_ch if internet2<=medianinternet & year>=2006 & polity_ch==2 & polity_ch!=.

* Stable 

tab gwf_countryx if internet2<=medianinternet & year>=2006 & polity_ch==0 & polity_ch!=.




* Above median Internet penetration

summ cow if internet2>medianinternet & year>=2006 & polity_ch==1 & polity_ch!=. & internet2!=.

summ cow if internet2>medianinternet & year>=2006 & polity_ch==2 & polity_ch!=. & internet2!=.

summ cow internet2 fh_press if internet2>medianinternet & year>=2006 & polity_ch!=. & internet2!=.

* 7 episodes of democratization

list gwf_countryx year internet2 polity_ch if internet2>medianinternet & year>=2006 & polity_ch==1 & polity_ch!=.

* 8 episodes of autocratization

list gwf_countryx year internet2 polity_ch if internet2>medianinternet & year>=2006 & polity_ch==2 & polity_ch!=.

* Stable 

tab gwf_countryx if internet2>medianinternet & year>=2006 & polity_ch==0 & polity_ch!=.
