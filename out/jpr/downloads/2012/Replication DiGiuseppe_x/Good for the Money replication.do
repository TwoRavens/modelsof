***********************************************************************
///////////////////////////////////////////////////////////////////////
//
// Authors: Matthew R. DiGiuseppe, Colin M. Barry and Richard W. Frank 
// 
// Do File: Replication do file
// Date: 7/11/2011
//
// Project: Good for the Money: International Finance, 
// State Capacity, and Internal Conflict
//
///////////////////////////////////////////////////////////////////////
***********************************************************************


version 11.2
set more off


//Table II. Probit estimates of conflict onset, 1981-2007

//Model 1
probit onset iiavg_1  lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn onsetdecay conflictinci_1, robust cl(ccode)

//Model 2
probit onset iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn onsetdecay conflictinci_1, robust cl(ccode)

//Model 3 
probit onset iiavg_1 ed_m6 fl_oil lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn  onsetdecay conflictinci_1, robust cl(ccode)

//Model 4 (Residual Analysis)
regress iiavg_1 ed_m6 lpop lgdppcppp1 growth1 open1 polity21 politysq, robust
predict res, r 
//probit onset  res  lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
//	mtn onsetdecay conflictinci_1, robust cl(ccode)
probit onset  res ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn onsetdecay conflictinci_1, robust cl(ccode)


//Table IV. Probit estimates of conflict onset, 1981-2007 (robustness)

//Model 5
probit onset cim1 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil onsetdecay conflictinci_1, robust cl(ccode)

//Model 6
probit onset rpc21 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil onsetdecay conflictinci_1, robust cl(ccode)
	
//Model 7
probit onset govtexp1 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil onsetdecay conflictinci_1, robust cl(ccode)



//WEB APPENDIX//

///*** Appendix Table I ***/// 
//Energy per capita

// Model 1
probit onset iiavg_1  lpop ef lnpec1 growth1 open1  polity21 politysq  ///
	mtn onsetdecay conflictinci_1, robust cl(ccode)

// Model 2
probit onset iiavg_1 ed_m6 lpop ef lnpec1 growth1 open1  polity21 politysq  ///
	mtn onsetdecay conflictinci_1, robust cl(ccode)

// Model 3
probit onset iiavg_1 ed_m6 lpop ef lnpec1 growth1 open1  polity21 politysq  ///
	mtn fl_oil  onsetdecay conflictinci_1, robust cl(ccode)



///*** Appendix Table II ***///
//Various onset wait times

// Model 4
probit onset5cv410 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil  onsetdecay conflictinci_1, robust cl(ccode)

// Model 5
probit onset8cv410 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil  onsetdecay conflictinci_1, robust cl(ccode)

// Model 6
probit onset20cv410 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil  onsetdecay conflictinci_1, robust cl(ccode)

// Model 7
probit maxintyearv410 iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn fl_oil  onsetdecay conflictinci_1, robust cl(ccode)

///*** Appendix Table III ***///
// relogit analysis

// Model 8
relogit onset iiavg_1 ed_m6 lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn onsetdecay conflictinci_1,  cl(ccode)

// Model 9
relogit onset iiavg_1 ed_m6 fl_oil lpop ef lgdppcppp1 growth1 open1  polity21 politysq  ///
	mtn  onsetdecay conflictinci_1,  cl(ccode)

