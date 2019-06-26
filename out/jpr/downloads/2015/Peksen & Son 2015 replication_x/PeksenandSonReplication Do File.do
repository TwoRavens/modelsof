* Do File: Peksen and Son "Economic Sanctions and Curency Crises in Target Countries"
* Table I
tab crisis3 lsanctnew if _mj==0, chi column

* TABLE II
* Models with Sanctions Dummy
* Bivariate Sanction Dummy
mim, storebv: probit crisis3 lsanctnew lt_3 lt2_3 lt3_3, robust cluster(code)
* Full Model
mim, storebv: probit crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
* BIVARIATE AND FULL MODELS WITH FINANCIAL SANCTIONS
mim, storebv: probit crisis3 lf lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lf lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
*BIVARIATE AND FULL MODELS WITH EXPORT SANCTIONS
mim, storebv: probit crisis3 lx lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lx lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
*Bivariate and Full Models with IMPORT SANCTIONS
mim, storebv: probit crisis3 lm lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lm lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)

* TABLE III
*Bivariate and Full Models with IGO Sanctions
mim, storebv: probit crisis3 lintlorgsend lnonIGOsanct lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
*Bivariate and Full Models with US Sanctions
mim, storebv: probit crisis3 luscase lnonUSsanct lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
* Models with Sanction Cost Variable
mim, storebv: probit crisis3 lmajsanct lminsanct lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)

*TABLE IV Substantive Effects
local var "lsanctnew lf lx lm"
foreach X of local var {

probit crisis3 `X' lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)

prvalue, x(`X'=0) rest(mean)
prvalue, x(`X'=1) rest(mean)

}
*
* IGO and non-IGO sanctions
probit crisis3 lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
prvalue, x(lintlorgsend=0) rest(mean)
prvalue, x(lintlorgsend=1) rest(mean)
prvalue, x(lnonIGOsanct=0) rest(mean)
prvalue, x(lnonIGOsanct=1) rest(mean)

* US and non-US sacntions 
probit crisis3 luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
prvalue, x(luscase=0) rest(mean)
prvalue, x(luscase=1) rest(mean)
prvalue, x(lnonUSsanct=0) rest(mean)
prvalue, x(lnonUSsanct=1) rest(mean)

* high- and low-cost sanctions
probit crisis3 lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
prvalue, x(lmajsanct=0) rest(mean)
prvalue, x(lmajsanct=1) rest(mean)
prvalue, x(lminsanct=0) rest(mean)
prvalue, x(lminsanct=1) rest(mean)

* control variables
probit crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
local var "lpublic=12.6 lpublic=27 lboa=-3.60 lboa=8.91 lnorth=2.78 lnorth=3.86"
foreach Y of local var {

prvalue, x(`Y') rest(mean)

}
*

* TABLE A1.Patterns of missing observations 
** column 1
corr lsanctnew crisis3 if _mj==0
** column 2 and 3 
local var "ldebt lpublic lreserve lboa"
foreach X of local var {
corr lsanctnew crisis3 if `X'==. & _mj==0
corr lsanctnew crisis3 if `X' !=. & _mj==0
}
*

* TABLE A2. Summary Statistics
probit crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)

probit crisis3 lf lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 lf lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)

probit crisis3 lx lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 lx lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)

probit crisis3 lm lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 lm lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)

probit crisis3 lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)

probit crisis3 luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)

probit crisis3 lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1, robust cluster(code)
sum crisis3 lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if _mj==1 & e(sample)


****************** ONLINE APPENDIX TABLES *********************

* Online Appendix Table GRANGER CAUSALITY
xtset codemj year
tab lcrisis3 crisis3
firthlogit crisis3 lsanctnew l2sanctnew lcrisis3 l2crisis3 if _mj==0
testparm lsanctnew l2sanctnew
firthlogit sanctnew lcrisis3 l2crisis3 lsanctnew l2sanctnew if _mj==0
testparm lcrisis3 l2crisis3

* Online Appendix Table -(Sanctions as DV and currency crisis as IV)
* Multivariate sanctions and currency crisis 
xtlogit sanctnew lcrisis3 lagpolity2 lagtradelog laggdplog lagcwar trend lsanctnew if _mj==0
xtlogit sanctnew lcrisis3 lsanctnew if _mj==0 & e(sample)

* Online Appendix Table - DEVELOPING COUNTRIES MODEL
mim, storebv: probit crisis3 lsanctnew lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lf lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lf lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lx lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lx lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lm lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lm lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)

*Online Appendix Table - DEVELOPING COUNTRIES
mim, storebv: probit crisis3 lintlorgsend lnonIGOsanct lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 luscase lnonUSsanct lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lmajsanct lminsanct lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)
mim, storebv: probit crisis3 lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3 if developedIMF==0, robust cluster(code)

* Online Appendix Table -  Dropping Debt Variables 
probit crisis3 lsanctnew lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)
probit crisis3 lf lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)
probit crisis3 lx lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)
probit crisis3 lm lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)

* Online Appendix Table - Dropping Debt Variables 
probit crisis3 lintlorgsend lnonIGOsanct lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)
probit crisis3 luscase lnonUSsanct lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)
probit crisis3 lmajsanct lminsanct lgrowth lreserve lboa lnorth lt lt2 lt3 if _mj==0, robust cluster(code)

* Online Appendix Table - ADDING ONE CONTROL AT A TIME
mim, storebv: probit crisis3 lsanctnew lgrowth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew ldebt lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew lpublic lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew lreserve lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew lboa lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)

* Online Appendix Table - Models with additional controls
mim, storebv: probit crisis3 lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lf lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lx lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lm lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)


* Online Appendix Table - Models with additional controls 
mim, storebv: probit crisis3 lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis3 lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lmulti_debt lshort lconcession lfdi dcredit lforeign lt_3 lt2_3 lt3_3, robust cluster(code)


* Online Appendix Table - Models with an alternative DV (incidence of currency crisis as DV)
mim, storebv: probit crisis lsanctnew lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lsanctnew lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lf lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lf lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lx lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lx lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lm lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lm lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)

* Online Appendix Table - Models with an alternative DV (incidence of currency crisis as DV)
mim, storebv: probit crisis lintlorgsend lnonIGOsanct lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lintlorgsend lnonIGOsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis luscase lnonUSsanct lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis luscase lnonUSsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lmajsanct lminsanct lt_3 lt2_3 lt3_3, robust cluster(code)
mim, storebv: probit crisis lmajsanct lminsanct lgrowth ldebt lpublic lreserve lboa lnorth lt_3 lt2_3 lt3_3, robust cluster(code)
