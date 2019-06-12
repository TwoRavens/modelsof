* Replication code for "Backlash and Legitimation: Macro Political Responses to Supreme Court Decisions"
* Originally run on IC Stata 11.2 for Windows
* Please direct inquiries to Joe Ura at joe.ura@gmail.com.

use "supreme court mood replication.dta"
log using "supreme court mood replication.smcl"

** Note: You may need to alter file paths to correct locations on your computer.

tsset year

** These reproduce the model estimates and diagnositics reported in Table 1.

*** This block is the error correction model (ECM) and its diagnostics.
reg d.mood l.mood d.policy l.policy d.unemployment l.unemployment d.inflation l.inflation d.caselaw l.caselaw
hettest
estat bgodfrey
predict residuals, r
corr residuals l.residuals
dfuller residuals

*** This is the Bewley transformation of the ECM, which produces estimates of long-run multipliers and their standard errors.
ivregress 2sls mood d.policy policy d.unemployment unemployment d.inflation inflation d.caselaw caselaw (d.mood=l.mood d.policy policy d.unemployment unemployment d.inflation inflation d.caselaw caselaw)

** These reproduce the analysis reported in the online appendix to the article.

*** This block is the set of Granger causality tests reported in Table 1 of the appendix.
var segalmedmeancum d.mood, lags(1) small
vargranger
var segalmedmeancum d.mood, lags(1 2) small
vargranger
var segalmedmeancum d.mood, lags(1 2 3) small
vargranger
var segalmedmeancum d.mood, lags(1 2 3 4) small
vargranger

*** This block is the IV re-estimation of the ECM reported in the article and associated diagnostics reported in Table 2 of the appendix.
ivregress 2sls d.mood l.mood d.policy l.policy d.unemployment l.unemployment d.inflation l.inflation (d.caselaw l.caselaw=l.party_gdp l.segalmedmeancum)
estat firststage, all

*** These are OLS and IV estimates and diagnostics of lagged dependent variable models of public mood reported in Table 3 of the appendix.
reg mood l.mood l.policy  l.inflation l.unemployment l.caselaw
ivregress 2sls mood l.mood l.policy  l.inflation l.unemployment (l.caselaw=l.segalmedmeancum), first
estat firststage, all

*** These are OLS and IV estimates of a lagged dependent variable model of public mood reported in Table 4 of the appendix.
reg d.mood l.mood d.policy l.policy d.unemployment l.unemployment d.inflation l.inflation d.caselaw_nonsal l.caselaw_nonsal

log close
