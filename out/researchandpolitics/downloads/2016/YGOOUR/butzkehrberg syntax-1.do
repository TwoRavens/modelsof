 
**  Following Syntax is for the quantitative results presented in "Estimating Anti-Immigrant Sentiment for the American States Using Multi-Level Modeling and Poststratification, 2004-2008" by Adam Butz and Jason Kehrberg **
** The syntax presented is for the validity and reliability checks of the state-level estimates.  Due to the sensitive data in the GSS, the individual-level codes and syntex to generate the anti-immigrant estimates are not included in this file. **
** The syntax provides the results in the order that appears in the manuscript.  We include notes indicating page numbers or table numbers for each piece of the analysis. **

*** Opening the data ***
use "E:\Research\State Policy Research\Estimating Immigration Attitudes\butzkehrbergdata.dta"
** The above command should be changed to match the pathway to your directory with the saved data **

** Table 2 results **

* Column 1, within years *
pwcorr anes04 gss04, sig
pwcorr anes08 gss08, sig

* Column 2, across years *
pwcorr combine04 gss06 combine08, sig

** Correlation between estimates and foreign-born population, page 9-10 **
pwcorr combine04 changeforeign, sig
pwcorr gss06 changeforeign, sig
pwcorr combine08 changeforeign, sig

pwcorr combine04 pctforeign, sig
pwcorr gss06 pctforeign, sig
pwcorr combine08 pctforeign, sig

** Correlation between estimates and citizen ideology, page 10 **
pwcorr combine04 citid04, sig
pwcorr gss06 citid06, sig
pwcorr combine08 citid08, sig

** Correlation between estimates and immigrant policies, Table 3 **
pwcorr combine04 immig0511, sig
pwcorr combine04 ICI, sig
pwcorr combine04 IPSN, sig
pwcorr combine04 CPSN, sig
pwcorr combine08 sb1070, sig

** Regression Models for estimates and immigrant policies, Table 4 **

* Model 4A *
regress immig0511 combine04 repunif pcgsp1000 termlimits squireprofess, robust

* Model 4B *
regress immig0511 citid04 repunif pcgsp1000 termlimits squireprofess, robust

* Model 4C *
regress immig0511 changeforeign repunif pcgsp1000 termlimits squireprofess, robust

* Model 4d *
regress immig0511 combine04 citid04 repunif pcgsp1000 termlimits squireprofess, robust

* Model 4e *
regress immig0511 combine04 changeforeign repunif pcgsp1000 termlimits squireprofess, robust

* Model 4f *
regress immig0511 combine04 citid04 changeforeign repunif pcgsp1000 termlimits squireprofess, robust
