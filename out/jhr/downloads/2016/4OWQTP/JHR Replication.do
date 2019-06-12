


** Table 1 **
sum LWnumberofstatements LWdomesticngos LWregionalngos LWinternationalngos LWsouthernngos if year>=1998

** Table 2 **
sum LWnumberofstatements LWdomesticngos LWregionalngos LWinternationalngos LWsouthernngos if year>=1998 & year<=2005
sum LWnumberofstatements LWdomesticngos LWregionalngos LWinternationalngos LWsouthernngos if year>=2007

** Table 3 **
zinb LWnumberofstatements LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) vuong zip

zinb LWnumberofstatements LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) robust

** Table 4 **
zinb LWdomesticngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) vuong zip

zinb LWdomesticngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) robust

zinb LWregionalngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) vuong zip

zinb LWregionalngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) robust

zinb LWinternationalngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) vuong zip

zinb LWinternationalngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) robust

zinb LWsouthernngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) vuong zip

zinb LWsouthernngos LW_HRC LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint wdi_gdpc NAME SSA AsiaPacific LatinCarib if year>=1998, /*
*/ inflate(LW_HRCMembership LW_CHRMembership p_polity2 ciri_empinx_new ciri_physint dr_pg wdi_gdpc) robust



