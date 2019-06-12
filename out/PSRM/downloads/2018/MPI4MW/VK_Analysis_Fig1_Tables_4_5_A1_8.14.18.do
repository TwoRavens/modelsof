
****************************************
**Peter K. Enns and Christopher Wlezien
**Understanding Equation Balance in Time Series Regression: An Extension
**Political Science Research Methods
**Replication code for Figure 1, Table 4, Table 5 (Columns 1 & 2), 
**column 3 of Table 5, comes from Grant & Lebo's (2016) FECM reanalysis of 
**Volscho and Kelly Model 5 (from Grant & Lebo's supplementary appendix, p. 50)
**Volscho and Kelly data can be obtained at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/18325
**Rember to cite:
**Volscho, Thomas W. and Nathan J. Kelly. 2012. "The Rise of the Super-Rich: Power
**Resources, Taxes, Financial Markets, and the Dynamics of the Top 1 Percent, 1949 to
**2008." American Sociological Review 77(5):679-699.
****************************************

use "VoschloKelly2012.dta", clear

*********************************
**Figure 1:
*********************************
twoway line top1_cg year


*********************************
**Table 4: Time Sereis Properties of Variables Analyzed by V&K
*********************************

**Column 1 (ADF Test)
*ADF tests allowed for trend and lags(1) to start and then 
*dropped when not sig and added a second lag where first was sig:

dfuller top1_cg if year>1948, regr trend
dfuller dempres if year>1948, regr
dfuller divided if year>1948, regr
dfuller topmarg if year>1948, regr trend lags(1)
dfuller capgtax if year>1948, regr lags(1)
dfuller tbill if year>1948, regr lags(2)
dfuller openness if year>1948, regr trend
dfuller ln_rgdp if year>1948, regr
dfuller real_sp if year>1948, regr lags(1) trend
dfuller shiller if year>1948, regr lags(1)
dfuller union if year>1948, regr lags(2) trend
dfuller cdpercen if year>1948, regr trend

**Column 2 (Phillips-Perron test)
pperron top1_cg if year>1948, regr trend
pperron dempres if year>1948, regr
pperron divided if year>1948, regr
pperron topmarg if year>1948, regr trend lags(1)
pperron capgtax if year>1948, regr lags(1)
pperron tbill if year>1948, regr lags(2)
pperron openness if year>1948, regr trend
pperron ln_rgdp if year>1948, regr
pperron real_sp if year>1948, regr lags(1) trend
pperron shiller if year>1948, regr lags(1)
pperron union if year>1948, regr lags(2) trend
pperron cdpercen if year>1948, regr trend


*********************************
**Table 5: Replication of V&K Table 1, Column 5
*********************************

**Column 1: Exact Replication
prais d.top1_cg l.top1_cg l.cdpercen l.divided l.union l.topmarg d.capgtax l.capgtax l.tbill_3 d.openness l.ln_rgdp05 d.real_sp l.real_sp l.shiller_hpi if year>1948

**Column 2: ARDL Bounds Approach

*ARDL Bounds Test
reg d.top1_cg l.top1_cg l.cdpercen l.divided l.union l.topmarg d.capgtax l.capgtax l.tbill_3 d.openness l.ln_rgdp05 d.real_sp l.real_sp l.shiller_hpi if year>1948
*Portmanteau test of residuals (as discussed in the text)
predict res_ardl if year>1948, r
wntestq res_ardl
*F-test on lagged variables (must use correct critical value)
test l.top1_cg l.cdpercen l.divided l.union l.topmarg l.capgtax l.tbill_3 l.ln_rgdp05 l.real_sp l.shiller_hpi


****************
*Table A-1, BG test for serially independent residuals
reg d.top1_cg l.top1_cg dl.top1_cg l.cdpercen l.divided l.union l.topmarg d.capgtax dl.capgtax l.capgtax l.tbill_3 d.openness dl.openness l.ln_rgdp05 d.real_sp dl.real_sp l.real_sp l.shiller_hpi if year>1948
estat bgodfrey, lags(1/2)

*****************************************************
**Robustness check reported in footnote
**with short and long-term effects
reg d.top1_cg l.top1_cg l.cdpercen l.divided d.union l.union d.topmarg l.topmarg d.capgtax l.capgtax d.tbill_3 l.tbill_3 d.openness d.ln_rgdp05 l.ln_rgdp05 d.real_sp l.real_sp d.shiller_hpi l.shiller_hpi if year>1948

test l.top1_cg l.cdpercen l.divided l.union l.topmarg l.capgtax l.tbill_3 l.ln_rgdp05 l.real_sp  l.shiller_hpi


