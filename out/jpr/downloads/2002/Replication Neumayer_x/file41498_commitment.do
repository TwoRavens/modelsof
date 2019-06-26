/* Stata do file that generates tables and appendices for Neumayer: Do democracies exhibit stronger international environmental commitment? */
/* Stata version 6 */


*Table I
corr lnGDP freerev polity demID governan
corr lnGDP freerev polity demID governan if develop==0

*Table II
dprobit kyoto lnGDP mid low lnPOP, robust
lrtest, saving(0)
dprobit kyoto lnGDP lnPOP if e(sample), robust
lrtest
dprobit kyoto lnGDP mid low lnPOP if develop==0, robust
lrtest, saving(0)
dprobit kyoto lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP mid low lnPOP, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP mid low lnPOP if develop==0, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit rotterda lnGDP mid low lnPOP, robust
lrtest, saving(0)
dprobit rotterda lnGDP lnPOP if e(sample), robust
lrtest
dprobit biosafe lnGDP mid low lnPOP, robust
lrtest, saving(0)
dprobit biosafe lnGDP lnPOP if e(sample), robust
lrtest
dprobit biosafe lnGDP mid low lnPOP if develop==0, robust
lrtest, saving(0)
dprobit biosafe lnGDP lnPOP if e(sample), robust
lrtest

*Table III
oprobit sumtreat lnGDP mid low lnPOP if develop==0, robust
lrtest, saving(0)
predict poor fair avg good exc
summarize poor fair avg good exc if low==1
summarize poor fair avg good exc if mid==1
summarize poor fair avg good exc if low==0 & mid==0
drop poor
drop fair
drop avg
drop good
drop exc
oprobit sumtreat lnGDP lnPOP if e(sample), robust
lrtest
oprobit sumtreat lnGDP politmid politlow lnPOP if develop==0, robust
lrtest, saving(0)
oprobit sumtreat lnGDP lnPOP if e(sample), robust
lrtest
oprobit sumtreat lnGDP autocra lnPOP if develop==0, robust
oprobit sumtreat lnGDP govmid govlow lnPOP if develop==0, robust
lrtest, saving(0)
oprobit sumtreat lnGDP lnPOP if e(sample), robust
lrtest

*Table IV
reg numenvIO lnGDP mid low lnPOP, robust
test mid low
reg numenvIO lnGDP mid low lnPOP if develop==0, robust
test mid low
reg numenvIO lnGDP politmid politlow lnPOP, robust
test politmid politlow
reg numenvIO lnGDP politmid politlow lnPOP if develop==0, robust
test politmid politlow
reg numenvIO lnGDP autocra lnPOP, robust
reg numenvIO lnGDP autocra lnPOP if develop==0, robust
reg numenvIO lnGDP govmid govlow lnPOP, robust
test govmid govlow
reg numenvIO lnGDP govmid govlow lnPOP if develop==0, robust
test govmid govlow

*Table V
reg cites lnGDP mid low lnPOP, robust
test mid low
reg cites lnGDP mid low lnPOP if develop==0, robust
test mid low
reg cites lnGDP politmid politlow lnPOP, robust
test politmid politlow
reg cites lnGDP politmid politlow lnPOP if develop==0, robust
test politmid politlow
reg cites lnGDP autocra lnPOP, robust
reg cites lnGDP autocra lnPOP if develop==0, robust
reg cites lnGDP govlow govmid lnPOP, robust
test govmid govlow
reg cites lnGDP govlow govmid lnPOP if develop==0, robust
test govmid govlow

*Table VI
reg landproc lnGDP mid low lnPOP popdens, robust
test mid low
reg landproc lnGDP mid low lnPOP popdens if develop==0, robust
test mid low
reg landproc lnGDP politmid politlow lnPOP popdens, robust
test politmid politlow
reg landproc lnGDP politmid politlow lnPOP popdens if develop==0, robust
test politmid politlow
reg landproc lnGDP autocra lnPOP popdens, robust
reg landproc lnGDP autocra lnPOP popdens if develop==0, robust
reg landproc lnGDP govlow govmid lnPOP popdens, robust
test govmid govlow
reg landproc lnGDP govlow govmid lnPOP popdens if develop==0, robust
test govmid govlow

*Table VII
dprobit NCSD lnGDP mid low lnPOP, robust
lrtest, saving(0)
dprobit NCSD lnGDP lnPOP if e(sample), robust
lrtest
dprobit NCSD lnGDP mid low lnPOP if develop==0, robust
lrtest, saving(0)
dprobit NCSD lnGDP lnPOP if e(sample), robust
lrtest
dprobit NCSD lnGDP politmid politlow lnPOP, robust
lrtest, saving(0)
dprobit NCSD lnGDP lnPOP if e(sample), robust
lrtest
dprobit NCSD lnGDP politmid politlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit NCSD lnGDP lnPOP if e(sample), robust
lrtest
dprobit NCSD lnGDP autocra lnPOP, robust
dprobit NCSD lnGDP autocra lnPOP if develop==0, robust
dprobit NCSD lnGDP govmid govlow lnPOP, robust
lrtest, saving(0)
dprobit NCSD lnGDP lnPOP if e(sample), robust
lrtest
dprobit NCSD lnGDP govmid govlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit NCSD lnGDP lnPOP if e(sample), robust
lrtest

*Table VIII
reg ESI lnGDP mid low lnPOP, robust
test mid low
reg ESI lnGDP mid low lnPOP if develop==0, robust
test mid low
reg ESI lnGDP politmid politlow lnPOP, robust
test politmid politlow
reg ESI lnGDP politmid politlow lnPOP if develop==0, robust
test politmid politlow
reg ESI lnGDP autocra lnPOP, robust
reg ESI lnGDP autocra lnPOP if develop==0, robust
reg ESI lnGDP govmid govlow lnPOP, robust
test govmid govlow
reg ESI lnGDP govmid govlow lnPOP if develop==0, robust
test govmid govlow

*Appendix 1
corr freerev polity governan demID

*Appendix 2
corr sumtreat numenvIO cites landproc NCSD ESI

*Appendix 3
summarize cites landproc ESI numenvIO sumtreat
summarize freedom
summarize freedom if low==1
summarize freedom if mid==1
summarize freedom if low!=1 & mid!=1
summarize polity
summarize polity if politlow==1
summarize polity if politmid==1
summarize polity if politlow!=1 & politmid!=1
summarize governan
summarize governan if govlow==1
summarize governan if govmid==1
summarize governan if govlow!=1 & govmid!=1
summarize demID
summarize demID if autocra==1
summarize demID if autocra!=1
summarize lnGDP lnPOP popdens

*Appendix 4
dprobit kyoto lnGDP politmid politlow lnPOP, robust
lrtest, saving(0)
dprobit kyoto lnGDP lnPOP if e(sample), robust
lrtest
dprobit kyoto lnGDP politmid politlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit kyoto lnGDP lnPOP if e(sample), robust
lrtest
dprobit kyoto lnGDP autocra lnPOP, robust
dprobit kyoto lnGDP autocra lnPOP if develop==0, robust
dprobit kyoto lnGDP govmid govlow lnPOP, robust
lrtest, saving(0)
dprobit kyoto lnGDP lnPOP if e(sample), robust
lrtest
dprobit kyoto lnGDP govmid govlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit kyoto lnGDP lnPOP if e(sample), robust
lrtest
dprobit biosafe lnGDP politmid politlow lnPOP, robust
lrtest, saving(0)
dprobit biosafe lnGDP lnPOP if e(sample), robust
lrtest
dprobit biosafe lnGDP politmid politlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit biosafe lnGDP lnPOP if e(sample), robust
lrtest
dprobit biosafe lnGDP autocra lnPOP, robust
dprobit biosafe lnGDP autocra lnPOP if develop==0, robust
dprobit biosafe lnGDP govmid govlow lnPOP, robust
lrtest, saving(0)
dprobit biosafe lnGDP lnPOP if e(sample), robust
lrtest
dprobit biosafe lnGDP govmid govlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit biosafe lnGDP lnPOP if e(sample), robust
lrtest
dprobit rotterda lnGDP politmid politlow lnPOP, robust
lrtest, saving(0)
dprobit rotterda lnGDP lnPOP if e(sample), robust
lrtest
dprobit rotterda lnGDP autocra lnPOP, robust
dprobit rotterda lnGDP govmid govlow lnPOP, robust
lrtest, saving(0)
dprobit rotterda lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP politmid politlow lnPOP, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP politmid politlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP autocra lnPOP, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP autocra lnPOP if develop==0, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP govmid govlow lnPOP, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
dprobit copenhag lnGDP govmid govlow lnPOP if develop==0, robust
lrtest, saving(0)
dprobit copenhag lnGDP lnPOP if e(sample), robust
lrtest
