*Replication do file for Payton & Woo, "Attracting Investment"

// ECM for Model 1 //

xtreg d.in_pctgdp l.in_pctgdp d.lawpos l.lawpos d.practicepos /* 
	*/l.practicepos d.marketsize l.marketsize d.tradeopen l.tradeopen /* 
	*/d.logincome l.logincome d.growth l.growth  /* 
	*/d.fuelexport l.fuelexport d.p_polity2 l.p_polity2, fe robust
	
//ECM for Model 2 //

xtreg d.labordiff l.labordiff d.in_pctgdp l.in_pctgdp  /* 
	*/ d.logincome l.logincome d.fuelexport l.fuelexport /* 
	*/  d.laborpart l.laborpart d.p_polity2 l.p_polity2/* 
	*/  d.ciri_physint l.ciri_physint d.civilwar l.civilwar, fe robust
	
//ECM for Model 3 //

xtreg d.labordiff l.labordiff d.in_pctgdp l.in_pctgdp d.icrg_qog l.icrg_qog /* 
	*/ d.logincome l.logincome d.fuelexport l.fuelexport /* 
	*/  d.laborpart l.laborpart d.p_polity2 l.p_polity2/* 
	*/  d.ciri_physint l.ciri_physint d.civilwar l.civilwar, fe robust
	
//Models for supplementary online appendix//

	//Model 1b //

xtreg d.in_pctgdp_stk l.in_pctgdp_stk d.lawpos l.lawpos d.practicepos /* 
	*/l.practicepos d.marketsize l.marketsize d.tradeopen l.tradeopen /* 
	*/d.logincome l.logincome d.growth l.growth  /* 
	*/d.fuelexport l.fuelexport d.p_polity2 l.p_polity2, fe robust
	
	//Model 2b //

xtreg d.labordiff l.labordiff d.in_pctgdp_stk l.in_pctgdp_stk  /* 
	*/ d.logincome l.logincome d.fuelexport l.fuelexport /* 
	*/  d.laborpart l.laborpart d.p_polity2 l.p_polity2/* 
	*/  d.ciri_physint l.ciri_physint d.civilwar l.civilwar, fe robust
	
	//Model 3b //

xtreg d.labordiff l.labordiff d.in_pctgdp_stk l.in_pctgdp_stk d.icrg_qog l.icrg_qog /* 
	*/ d.logincome l.logincome d.fuelexport l.fuelexport /* 
	*/  d.laborpart l.laborpart d.p_polity2 l.p_polity2/* 
	*/  d.ciri_physint l.ciri_physint d.civilwar l.civilwar, fe robust

	//Instrumental variables regression //

xtivreg in_pctgdp (lawpos = regionalpractices) l.in_pctgdp practicepos /* 
	*/p_polity2 tradeopen /* 
	*/logincome growth /* 
	*/ fuelexport marketsize, fe 

