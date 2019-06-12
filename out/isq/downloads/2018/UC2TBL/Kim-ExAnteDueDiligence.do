******************************
* Logit models for competition 
* 100a, 100b, 100a2 and 100b2
******************************
/* Models */
	btscs pdciri year ccode_2, g(t2ciri) nspl(2)
	sort dyad year

// * 100a * Without year restriction
	qui xi3: logit pdciri ta2002 lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year t2ciri _spline?, vce(cluster ccode_2) nolog
	estimates store m100a, title("Model 1")

// * 100b * With year restriction
	qui xi3: logit pdciri ta2002 lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year t2ciri _spline? if year > 1994, vce(cluster ccode_2) nolog
	estimates store m100b, title("Model 2")

// * 100a2 * Window without year restriction
	qui xi3: logit pdciri window lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year t2ciri _spline?, vce(cluster ccode_2) nolog
	estimates store m100a2, title("Model 3")

// * 100b2 * Window with year restriction
	qui xi3: logit pdciri window lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year t2ciri _spline? if year > 1994, vce(cluster ccode_2) nolog
	estimates store m100b2, title("Model 4")

/* CLARIFY PV and FD */
* Based on Model 2 (100b)
drop b? b??
qui xi3: estsimp logit pdciri ta2002 lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year t2ciri _spline? if year > 1994, vce(cluster ccode_2) nolog
		
	// PV
	setx mean
	setx lciri 0 ta2002 0
	simqi, prval(1)

	setx mean
	setx lciri 0 ta2002 1
	simqi, prval(1)
		
	// FD mandate
	setx mean
	setx lciri 0
	simqi, fd(prval(1)) changex(ta2002 0 1)

********************************
* Oprobit models for competition 
* 200a, 200b, 200a2 and 200b2
********************************
/* Models */

// * 200a * Without year restriction 
	qui xi3: oprobit dciri ta2002 lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year, vce(cluster ccode_2) nolog
	estimates store m200a, title(Model 5)

// * 200b * With year restriction
	qui xi3: oprobit dciri ta2002 lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if year > 1994, vce(cluster ccode_2) nolog
	estimates store m200b, title(Model 6)

// * 200a2 * Without year restriction 
	qui xi3: oprobit dciri window lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year, vce(cluster ccode_2) nolog
	estimates store m200a2, title(Model 7)

// * 200b2 * With year restriction
	qui xi3: oprobit dciri window lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if year > 1994, vce(cluster ccode_2) nolog
	estimates store m200b2, title(Model 8)

/* CLARIFY PV and FD */
* Based on Model 6 (200b)
drop b? b??
qui xi3: estsimp oprobit dciri ta2002 lciri llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if year > 1994, vce(cluster ccode_2) nolog
	
	// PV mandate
	setx mean
	setx lciri 0 ta2002 0
	simqi, prval(0)
	simqi, prval(1)
	simqi, prval(2)
	
	setx mean
	setx lciri 0 ta2002 1
	simqi, prval(0)
	simqi, prval(1)
	simqi, prval(2)
	
	// FD mandate
	setx mean
	setx lciri 0
	simqi, fd(prval(0)) changex(ta2002 0 1)
	simqi, fd(prval(1)) changex(ta2002 0 1)
	simqi, fd(prval(2)) changex(ta2002 0 1)

**************************************
* Logit models for PTA effects
* 303a and 303b
**************************************
/* Models */

// * 303a * 3-year negotiation period (neg-sig)
	qui xi3: logit pdciri ta2002 lciri noneg3 negs3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 ltotann se_std year t2ciri _spline? if everpta == 1, vce(cluster ccode_2) nolog
	estimates store m303a, title(Model 9)

// * 303b * 3-year negotiation period (neg-onset)
	qui xi3: logit pdciri ta2002 lciri noneg3 negl3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 ltotann se_std year t2ciri _spline? if everpta == 1, vce(cluster ccode_2) nolog
	estimates store m303b, title(Model 10)

/* CLARIFY PV and FD */
* Based on Model 9
drop b? b??
qui xi3: estsimp logit pdciri ta2002 lciri noneg3 negs3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 ltotann se_std year t2ciri _spline? if everpta == 1, vce(robust) nolog

	// PV mandate
	setx mean
	setx lciri 0 ta2002 1 noneg3 0 negs3 1
	simqi, prval(1)
	setx mean
	setx lciri 0 ta2002 1 noneg3 0 negs3 0
	simqi, prval(1)
	
	// FD PTA
	setx mean
	setx lciri 0 ta2002 1 noneg3 0
	simqi, fd(prval(1)) changex(negs3 1 0)

**********************************************
* Oprobit models for PTA effects 
* 313a and 313b
**********************************************
/* Models */

// * 313a * 3-year negotiation period (short)
	qui xi3: oprobit dciri ta2002 lciri noneg3 negs3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if everpta == 1, vce(cluster ccode_2) nolog
	estimates store m313a, title(Model 11)

// * 313b * 3-year negotiation period (long)
	qui xi3: oprobit dciri ta2002 lciri noneg3 negl3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if everpta == 1, vce(cluster ccode_2) nolog
	estimates store m313b, title(Model 12)

/* CLARIFY PV and FD */
* Based on Model 11
drop b? b??
qui xi3: estsimp oprobit dciri ta2002 lciri noneg3 negs3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade  lxprop lpc5_2 lp_2 totannu se_std year if everpta == 1, vce(robust) nolog
	
	// PV
	setx mean
	setx lciri 0 ta2002 1 noneg3 0 negs3 1
	simqi, prval(0)
	simqi, prval(1)
	simqi, prval(2)
	
	setx mean
	setx lciri 0 ta2002 1 noneg3 0 negs3 0
	simqi, prval(0)
	simqi, prval(1)
	simqi, prval(2)
	
	// FD
	setx mean
	setx lciri 0 ta2002 1 noneg3 0
	simqi, fd(prval(0)) changex(negs3 1 0)
	simqi, fd(prval(1)) changex(negs3 1 0)
	simqi, fd(prval(2)) changex(negs3 1 0)

**********************************************
* Oprobit models for PTA effects 
* 323a and 323b
**********************************************
/* Models */

// * 323a * 3-year negotiation period (short) sans Lat Am
	xi3: oprobit dciri ta2002 lciri noneg3 negs3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if everpta == 1 & reg3 ~= 1, vce(cluster ccode_2) nolog

// * 323b * 3-year negotiation period (long) sans Lat Am
	xi3: oprobit dciri ta2002 lciri noneg3 negl3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade lxprop lpc5_2 lp_2 totannu se_std year if everpta == 1 & reg3 ~= 1, vce(cluster ccode_2) nolog

/* CLARIFY PV and FD */
* Based on Model 13
drop b? b??
qui xi3: estsimp oprobit dciri ta2002 lciri noneg3 negs3 llkgdp_2 llkgdppc_2 ldgdp_2 llttrade_2 llbtrade  lxprop lpc5_2 lp_2 totannu se_std year if everpta == 1 & reg3 ~= 1, vce(robust) nolog

	// PV
	setx mean
	setx lciri 0 ta2002 1 noneg3 0 negs3 1
	simqi, prval(0)
	simqi, prval(1)
	simqi, prval(2)
	
	setx mean
	setx lciri 0 ta2002 1 noneg3 0 negs3 0
	simqi, prval(0)
	simqi, prval(1)
	simqi, prval(2)
	
	// FD
	setx mean
	setx lciri 0 ta2002 1 noneg3 0
	simqi, fd(prval(0)) changex(negs3 1 0)
	simqi, fd(prval(1)) changex(negs3 1 0)
	simqi, fd(prval(2)) changex(negs3 1 0)
