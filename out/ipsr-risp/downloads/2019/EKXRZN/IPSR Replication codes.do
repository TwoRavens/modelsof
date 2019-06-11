**************
* IPSR/RISP
* "Love, Convenience or Respectability?"
* Replication data
* EB & MDC
**************

** software Stata 14.2 **

use "C:\Users\Edoardo\Desktop\EUANDI M5S.dta", clear

* Figure 1

sum EU eco imm soclib
sum group

twoway (scatter EU eco if group==3) (scatter EU eco if group==4) (scatter EU eco if group==7, mlabel(Abbreviation)), ///
legend(label(1 ALDE) label(2 G/EFA) label(3 EFDD))

* Table 2

tabstat EU eco imm soclib [fweight=seats] if Abbreviation!="M5S", by(group) s(me, n)

* Figures in the table are absolute distances between the group position and the M5S position on each dimension
* E.g. Dimension: EU; EPP position: 1.10; M5S position: -0.14; Distance: 1.24

* Cross-validation
* EUANDI & Chapel Hill measures

* EU Integration
pwcorr EU CH_EU, sig

* Economic left-right
pwcorr eco CH_LR, sig


use "C:\Users\Edoardo\Dropbox\5 Star Movement paper\Our analyses\drafts\preparing for submission\Final submission\Votes_M5S.dta", clear

* Table 3

tab Agreement EPG, col

tab Agreement Policyarea if EPG=="EFDD", col
tab Agreement Policyarea if EPG=="ECR", col
tab Agreement Policyarea if EPG=="GUE/NGGL", col
tab Agreement Policyarea if EPG=="G/EFA", col
tab Agreement Policyarea if EPG=="ALDE", col
tab Agreement Policyarea if EPG=="S&D", col
tab Agreement Policyarea if EPG=="EPP", col

use "C:\Users\Edoardo\Desktop\Image EU.dta", clear

* Figure 2

scatter Positive Date, connect(l) || scatter Negative Date, connect(l) || scatter Neutral Date, connect(l)



* Figure 3
* see www.termometropolitico.it




















