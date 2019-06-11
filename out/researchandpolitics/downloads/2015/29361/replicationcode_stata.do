/* Akisato Suzuki "Is More Better or Worse?" Stata replication code */
/* open "systemleveldata_r_t+1.dta" */
tsset year

/* Table A-9 correlation matrix */
cor numnuke numnuke2 nukeyear nukeyear2 demonum gwp unipolar

/* Table A-10 ARMA models */
/* unit root test */
pperron disstateratiot1
/* The null hypothesis that a unit root is present is rejected.
   Thus, the assumption of stationarity is met in time-series models. */

/* visual inspection of autocorrelations */
/* autoregressive */
pac  disstateratiot1, lag(10)
/* the 1st year is significantly correlated, so AR parameter should be set at 1 */

/* moving-average */
ac  disstateratiot1, lag(10)
/* the 1st and 2nd years are significantly correlated, so MA parameter should be set at 2 */

arima disstateratiot1 numnuke nukeyear, arima(1,0,2) robust
outreg2 using "morebetterworse_system.doc", alpha(0.01,0.05,0.1)
/* autocorrelation test by residuals */
predict residuals, resid
wntestq residuals
drop residuals
/* p>0.05 therefore no autocorrelation */

arima disstateratiot1 numnuke2 nukeyear2, arima(1,0,2) robust
outreg2 using "morebetterworse_system.doc", alpha(0.01,0.05,0.1)
/* autocorrelation test by residuals */
predict residuals, resid
wntestq residuals
drop residuals
/* p>0.05 therefore no autocorrelation */

arima disstateratiot1 demonum, arima(1,0,2) robust
outreg2 using "morebetterworse_system.doc", alpha(0.01,0.05,0.1)
/* autocorrelation test by residuals */
predict residuals, resid
wntestq residuals
drop residuals
/* p>0.05 therefore no autocorrelation */

arima disstateratiot1 gwp, arima(1,0,2) robust
outreg2 using "morebetterworse_system.doc", alpha(0.01,0.05,0.1)
/* autocorrelation test by residuals */
predict residuals, resid
wntestq residuals
drop residuals
/* p>0.05 therefore no autocorrelation */

arima disstateratiot1 unipolar, arima(1,0,2) robust
outreg2 using "morebetterworse_system.doc", alpha(0.01,0.05,0.1)
/* autocorrelation test by residuals */
predict residuals, resid
wntestq residuals
drop residuals
/* p>0.05 therefore no autocorrelation */
