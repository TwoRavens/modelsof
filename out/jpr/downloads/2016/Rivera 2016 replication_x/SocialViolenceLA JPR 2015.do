***************************************************
* The Sources of Social Violence in Latin America *
*                                                 *
*	Author: Mauricio Rivera Celestino             *
* 	Date: May 24, 2015							  *
***************************************************



xtset cowcode year
		
		
*** TABLE  II

* Model 1
xi: xtpcse homrates l.lnwdi_gdppc wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 2	
xi: xtpcse homrates l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 3	
xi: xtpcse homrates_ip l.lnwdi_gdppc wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 4	
xi: xtpcse homrates_ip l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 5	
xi: xtpcse homrates l.homrates l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.bl_asy15mf_ip l.femalelabor_ne_ip i.cowcode

* Model 6	
xi: xtpcse homrates_ip l.homrates_ip l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.bl_asy15mf_ip l.femalelabor_ne_ip i.cowcode

* Model 7
xi: xtabond homrates_ip wdi_urban femalelabor_ne_ip i.year, ///
  pre(lnwdi_gdppc lnwdi_gdppc2 wdi_gdppcg gini_net wdi_ue_ip gd_ptss lji p_polity2 p_polity2sq youth_pop bl_asy15mf_ip) robust		
		

		
*** TABLE III
 
* Model 8
xi: xtpcse homrates_ip l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
	l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25 if year >1989, pairwise corr(ar1)

* Model 9		
xi: xtpcse homrates_ip l.homrates_ip l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
	l.youth_pop l.bl_asy15mf_ip l.femalelabor_ne_ip i.cowcode if year >1989
		
* Model 10
xi: xtpcse homrates l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
	l.youth_pop l.bl_asy15mf_ip l.femalelabor_ne_ip l.drugproducer l.Laundering i.cowcode if year >1989, corr(ar1)
	
* Model 11
xi: xtpcse homrates_ip  l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
	l.youth_pop l.bl_asy15mf_ip l.femalelabor_ne_ip l.drugproducer l.Laundering i.cowcode if year >1989, corr(ar1)
	

	
*** APPENDIX

* Table  A2 - controlling for the number of battle-related deaths

* Model 1
xi: xtpcse homrates l.lnwdi_gdppc wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip brdPRIO, pairwise corr(ar1)

* Model 2
	
xi: xtpcse homrates l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip brdPRIO, pairwise corr(ar1)

* Model 3	
xi: xtpcse homrates_ip l.lnwdi_gdppc wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip brdPRIO, pairwise corr(ar1)
		
* Model 4	
xi: xtpcse homrates_ip l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip brdPRIO, pairwise corr(ar1)
	


* Table A3 - replacing inequality data from The Standardized World Income ///
* Inequality Database for data from the World Bank
	
* Model 1
xi: xtpcse homrates l.lnwdi_gdppc wdi_gdppcg l.wdi_gini_ip l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 2	
xi: xtpcse homrates l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.wdi_gini_ip l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 3	
xi: xtpcse homrates_ip l.lnwdi_gdppc wdi_gdppcg l.wdi_gini_ip l.wdi_ue_ip l.gd_ptss l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 4	
xi: xtpcse homrates_ip l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.wdi_gini_ip l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)
		


* Table  A5 - using homicide data from the World Health Organization


* Model 1
xi: xtpcse homratesWHO l.lnwdi_gdppc wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

* Model 2
xi: xtpcse homratesWHO l.lnwdi_gdppc l.lnwdi_gdppc2 wdi_gdppcg l.gini_net l.wdi_ue_ip l.gd_ptss  l.lji l.p_polity2 l.p_polity2sq l.wdi_urban ///
		l.youth_pop l.warlegacy l.bl_asy15mf_ip l.femalelabor_ne_ip cwarPRIO25, pairwise corr(ar1)

