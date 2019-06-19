#delimit;

*gen linTrend=_n;
local allCountries "can deu fra gbr ita usa";	* country list (for for loops); 

* rescale income;
replace rpdi_can=rpdi_can/(10^4);
replace rpdi_deu=rpdi_deu/(10^3);
replace rpdi_fra=rpdi_fra/(10^3);
replace rpdi_gbr=rpdi_gbr/(10^4);
replace rpdi_ita=rpdi_ita/(10^4);
replace pop_usa=pop_usa/(10^3);

replace fw_can=w_can;
replace fw_deu=fw_deu*10^3;
replace fw_fra=fw_fra*10^3;
replace fw_ita=fw_ita*10^3;

foreach cName of local allCountries {;	
	gen rpdiPC_`cName'=rpdi_`cName'/pop_`cName';
	gen cPC_`cName'=4*c_`cName'/pop_`cName';
	gen ndcPC_`cName'=4*ndc_`cName'/pop_`cName';
	gen svcPC_`cName'=4*svc_`cName'/pop_`cName';
};

local allCntrsSdc "can ita gbr";
foreach cName of local allCntrsSdc {;	* semidurables;
	gen sdcPC_`cName'=4*sdc_`cName'/pop_`cName';
};

local allCntrsDc "ita gbr usa";
foreach cName of local allCntrsDc {;	* durables;
	gen dcPC_`cName'=4*dc_`cName'/pop_`cName';
};

replace rpdiPC_gbr=rpdipc_gbr;	* UK's income is read in directly as a per capita series;

replace cPC_can=cPC_can/4;			* rescale Canadian and US consumption back;
replace ndcPC_can=ndcPC_can/4;
replace svcPC_can=svcPC_can/4;
replace sdcPC_can=sdcPC_can/4;

replace cPC_usa=cPC_usa/4;
replace ndcPC_usa=ndcPC_usa/4;
replace svcPC_usa=svcPC_usa/4;

replace rpdiPC_gbr=rpdiPC_gbr*4;

* calculate nondurables+services+semidurables [where applicable];
gen ndscPC_can=ndcPC_can+svcPC_can+sdcPC_can;
gen ndscPC_deu=ndcPC_deu+svcPC_deu;
gen ndscPC_fra=ndcPC_fra+svcPC_fra;
gen ndscPC_gbr=ndcPC_gbr+svcPC_gbr+sdcPC_gbr;
gen ndscPC_ita=ndcPC_ita+svcPC_ita+sdcPC_ita;
gen ndscPC_usa=ndcPC_usa+svcPC_usa;

* calculate nondurables+semidurables [where applicable];
gen ndsdcPC_can=ndcPC_can+sdcPC_can;
gen ndsdcPC_deu=ndcPC_deu;
gen ndsdcPC_fra=ndcPC_fra;
gen ndsdcPC_gbr=ndcPC_gbr+sdcPC_gbr;
gen ndsdcPC_ita=ndcPC_ita+sdcPC_ita;
gen ndsdcPC_usa=ndcPC_usa;

/* small data check;
foreach cName of local allCountries {;	
	gen ndscCratio_`cName'=ndscPC_`cName'/cPC_`cName';
	summ ndscCratio_`cName';
	gen cRpdiRatio_`cName'=cPC_`cName'/rpdiPC_`cName';
	summ cRpdiRatio_`cName';
}; */;

foreach cName of local allCountries {;	
	gen lcPC_`cName'=log(cPC_`cName');
	gen diffcPC_`cName'=D.lcPC_`cName';

	gen lndcPC_`cName'=log(ndcPC_`cName');
	gen diffndcPC_`cName'=D.lndcPC_`cName';
	
	gen lsvcPC_`cName'=log(svcPC_`cName');
	gen diffsvcPC_`cName'=D.lsvcPC_`cName';
	
	gen lndscPC_`cName'=log(ndscPC_`cName');
	gen diffndscPC_`cName'=D.lndscPC_`cName';

	gen lndsdcPC_`cName'=log(ndsdcPC_`cName');
	gen diffndsdcPC_`cName'=D.lndsdcPC_`cName';

	gen lrpdiPC_`cName'=log(rpdiPC_`cName');
	gen diffrpdiPC_`cName'=D.lrpdiPC_`cName';
	
	gen infl_`cName'=100*log(pced_`cName'/L4.pced_`cName');  * log(cpi_`cName'/L4.cpi_`cName');
	gen rsr_`cName'=sr_`cName'-infl_`cName';
	gen rlr_`cName'=lr_`cName'-infl_`cName';
	gen irSpread_`cName'=lr_`cName'-sr_`cName';

	gen diffsr_`cName'=D.sr_`cName';
	gen difflr_`cName'=D.lr_`cName';
	gen diffrsr_`cName'=D.rsr_`cName';
	gen diffrlr_`cName'=D.rlr_`cName';
	
	gen lsp_`cName'=log(sp_`cName');
	gen diffsp_`cName'=D.lsp_`cName';
	
	gen rfwPC_`cName'=100*fw_`cName'/(pced_`cName'*pop_`cName');
	gen lfwPC_`cName'=log(rfwPC_`cName');
	gen difffwPC_`cName'=D.lfwPC_`cName';	
	
	gen wcRatio_`cName'=rfwPC_`cName'/cPC_`cName';
	sum wcRatio_`cName';
	gen wyRatio_`cName'=rfwPC_`cName'/rpdiPC_`cName';
};

gen dummy91q1=0;
replace dummy91q1=1 if tin(1991q1,1991q2);
