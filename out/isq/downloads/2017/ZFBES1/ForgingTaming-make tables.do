********************************************************************
* 
* Replication file for "Forging then Taming Leviathan: State Capacity, Constraints on Rulers, and Development" International Studies Quarterly, June 2014.
* Jonathan Hanson

********************************************************************
* This do file assumes that the following files are located in the current working directory:
* ForgingTaming-5yr.dta
* margeffect program.do
* ForgingTaming-10yr.dta
* ForgingTaming-annual.dta
* StateHist Test data.dta
******************************************************************

clear all
set more off

***************************************************************************
* Main Tests with kixwkrgrowth as dependent variable
***************************************************************************

use "ForgingTaming-5yr.dta", clear

* Create the margeffect command to produce figures 
do "margeffect program.do"

**** Table 1: test effect of StateHist and Checks interacted with Gap

* Model 1
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het
estimates store m2

* Model 3
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Make graphs for Figure 2
keep if e(sample)
margeffect Checks Gap ChecksXGap "Effect of Checks on Capital Stock Growth" "Gap"
margeffect StateHist Gap StateHistXGap "Effect of StateHist on Capital Stock Growth" "Gap"

use "ForgingTaming-5yr.dta", clear

* Model 4: requires installation of the xtfevd.ado 
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 5
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap RationalLegal RationalLegalXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Make Figure S2(a) for Online Appendix
keep if e(sample)
margeffect RationalLegal Gap RationalLegalXGap "Effect of RationalLegal on Capital Stock Growth" "Gap"

use "ForgingTaming-5yr.dta", clear

* Model 6: requires installation of the xtfevd.ado 
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap RationalLegal RationalLegalXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap RationalLegal RationalLegalXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)


***************************************************************************
* Main Tests with TFPgrowth as dependent variable
***************************************************************************
**** Table 2: test effect of StateHist and Checks interacted with Gap

* Model 1
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks ChecksXGap  yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Make graphs for Figure 3
keep if e(sample)
margeffect Checks Gap ChecksXGap "Effect of Checks on Productivity Growth" "Gap"
margeffect StateHist Gap StateHistXGap "Effect of StateHist on Productivity Growth" "Gap"

use "ForgingTaming-5yr.dta", clear

* Model 4: requires installation of the xtfevd.ado 
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 5
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap RationalLegal RationalLegalXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Make Figure S2(b) for Online Appendix
keep if e(sample)
margeffect RationalLegal Gap RationalLegalXGap "Effect of RationalLegal on TFP Growth" "Gap"

use "ForgingTaming-5yr.dta", clear

* Model 6: requires installation of the xtfevd.ado 
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap RationalLegal RationalLegalXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap RationalLegal RationalLegalXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)


****************************************************************************
* Online Appendix 
****************************************************************************
****************************************************************************
* StateHist Construct Validity Tests
****************************************************************************

use "StateHist Test data.dta", clear

**** Table S1.
* Note: some of data have been updated since these tests were first run. The commands below may not replicate the Online Appendix exactly.

reg Roads GDPcap60 Democracy TaxRev StateHist

reg Water GDPcap60 Democracy TaxRev StateHist

reg Hospitals GDPcap60 Democracy TaxRev StateHist

reg Doctors GDPcap60 Democracy TaxRev StateHist

reg Mort5 GDPcap60 Democracy TaxRev StateHist

reg LifeExp GDPcap60 Democracy TaxRev StateHist

**** Table S2.
* Note: some of data have been updated since these tests were first run. The commands below may not replicate the Online Appendix exactly.

reg Roads GDPcap60 Democracy TaxRev SocDev Comms StateHist

reg Water GDPcap60 Democracy TaxRev SocDev Comms StateHist

reg Hospitals GDPcap60 Democracy TaxRev SocDev Comms StateHist

reg Doctors GDPcap60 Democracy TaxRev SocDev Comms StateHist

reg Mort5 GDPcap60 Democracy TaxRev SocDev Comms StateHist

reg LifeExp GDPcap60 Democracy TaxRev SocDev Comms StateHist


****************************************************************************
* Robustness Tests with kixwkrgrowth using annual data
****************************************************************************

use "ForgingTaming-annual.dta", clear

**** Table S3

* Model 1
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks, het

* Model 2
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap, het

* Model 3
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks, invariant(EthnicFrac Landlock TropicArea Gap StateHist Checks)

* Model 4
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap)

****************************************************************************
* Robustness Tests with TFPgrowth using annual data
****************************************************************************
**** Table S4

* Model 1
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks, het

* Model 2
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap, het

* Model 3
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks, invariant(EthnicFrac Landlock TropicArea Gap StateHist Checks)

* Model 4
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap)

****************************************************************************
* Robustness Tests with kixwkrgrowth using ten-year data
****************************************************************************

use "ForgingTaming-10yr.dta", clear

**** Table S5

* Model 1
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks yr1 yr2 yr3 yr4, het

* Model 2
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr1 yr2 yr3 yr4, het

* Model 3
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks yr1 yr2 yr3 yr4, invariant(EthnicFrac Landlock TropicArea Gap StateHist Checks yr1 yr2 yr3 yr4)

* Model 4
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr1 yr2 yr3 yr4, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr1 yr2 yr3 yr4)

****************************************************************************
* Robustness Tests with TFPgrowth using ten-year data
****************************************************************************
**** Table S6

* Model 1
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks yr1 yr2 yr3 yr4, het

* Model 2
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr1 yr2 yr3 yr4, het

* Model 3
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist Checks yr1 yr2 yr3 yr4, invariant(EthnicFrac Landlock TropicArea Gap StateHist Checks yr1 yr2 yr3 yr4)

* Model 4
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr1 yr2 yr3 yr4, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap Checks ChecksXGap yr1 yr2 yr3 yr4)


****************************************************************************
* Robustness Tests with kixwkrgrowth as dependent variable: AgEmp for Gap
****************************************************************************

use "ForgingTaming-5yr.dta", clear

**** Table S7: test effect of StateHist and Checks interacted with AgEmp

* Model 1
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp Checks ChecksXAgEmp  yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 4
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp Checks ChecksXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp Checks ChecksXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

****************************************************************************
* Robustness Tests with TFPgrowth as dependent variable: AgEmp for Gap
****************************************************************************
**** Table S8: test effect of StateHist and Checks interacted with AgEmp

* Model 1
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp Checks ChecksXAgEmp  yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist Checks yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 4
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp Checks ChecksXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp Checks ChecksXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

****************************************************************************
* Robustness Tests with kixwkrgrowth as dependent variable: PolCon for Checks
****************************************************************************
**** Table S9: test effect of StateHist and PolCon interacted with Gap

* Model 1
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap PolCon PolConXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 4
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap PolCon PolConXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap PolCon PolConXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

****************************************************************************
* Robustness Tests with TFPgrowth as dependent variable: PolCon for Checks
****************************************************************************
**** Table S10: test effect of StateHist and PolCon interacted with Gap

* Model 1
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap PolCon PolConXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 4
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap PolCon PolConXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea Gap StateHist StateHistXGap PolCon PolConXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

****************************************************************************
* Robustness Tests with kixwkrgrowth as dependent variable: PolCon for Checks; AgEmp for Gap
****************************************************************************
**** Table S11: test effect of StateHist and PolCon interacted with AgEmp

* Model 1
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist PolCon  yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het


* Model 2
xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp PolCon PolConXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 4
xtfevd kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp PolCon PolConXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp PolCon PolConXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

****************************************************************************
* Robustness Tests with TFPgrowth as dependent variable: PolCon for Checks; AgEmp for Gap
****************************************************************************
**** Table S12: test effect of StateHist and PolCon interacted with AgEmp

* Model 1
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist PolCon  yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 2
xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp PolCon PolConXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

* Model 3
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist PolCon yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

* Model 4
xtfevd TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp PolCon PolConXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, invariant(EthnicFrac Landlock TropicArea AgEmp StateHist StateHistXAgEmp PolCon PolConXAgEmp yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12)

****************************************************************************
* Make Figure S3: these marginal effects graphs use the original version of RationalLegal from Hendrix in which GDP per capita is a component. I replace GDP per capita with StateHist to calculate RationalLegal for use in the main tables.
****************************************************************************

use "ForgingTaming-5yr.dta", clear

* Figure S3(a)

xtpcse kixwkrgrowth kixwkrgrowtht1 EthnicFrac Landlock TropicArea Gap RationalLegalorig RationalLegalorigXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

keep if e(sample)
margeffect RationalLegalorig Gap RationalLegalorigXGap "Effect of RationalLegal_orig on k Growth" "Gap"

use "ForgingTaming-5yr.dta", clear

* Figure S3(b)

xtpcse TFPgrowth TFPgrowtht1 EthnicFrac Landlock TropicArea Gap RationalLegalorig RationalLegalorigXGap Checks ChecksXGap yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12, het

keep if e(sample)
margeffect RationalLegalorig Gap RationalLegalorigXGap "Effect of RationalLegal_orig on TFP Growth" "Gap"

