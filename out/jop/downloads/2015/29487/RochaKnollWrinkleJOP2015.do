*Models for Table 1, Trust in Local Government
*Total Removals
ologit localtrust female dem ind edu platino border empower ptr fblatino fblxptr nblatino nblxptr, cluster(countyfips)
*Noncriminal Removals
ologit localtrust female dem ind edu platino border empower pncr fblatino fblxpncr nblatino nblxpncr, cluster(countyfips)
*Criminal Removals
ologit localtrust female dem ind edu platino border empower pcr fblatino fblxpcr nblatino nblxpcr, cluster(countyfips)

*Models for Table 1, Trust in Federal Government
*Total Removals
ologit fedtrust female dem ind edu platino border empower ptr fblatino fblxptr nblatino nblxptr, cluster(countyfips)
*Noncriminal Removals
ologit fedtrust female dem ind edu platino border empower pncr fblatino fblxpncr nblatino nblxpncr, cluster(countyfips)
*Criminal Removals
ologit fedtrust female dem ind edu platino border empower pcr fblatino fblxpcr nblatino nblxpcr, cluster(countyfips)

*Models for Table 2, External Efficacy
*Total Removals
ologit external female dem ind edu platino border empower ptr fblatino fblxptr nblatino nblxptr, cluster(countyfips)
*Noncriminal Removals
ologit external female dem ind edu platino border empower pncr fblatino fblxpncr nblatino nblxpncr, cluster(countyfips)
*Criminal Removals
ologit external female dem ind edu platino border empower pcr fblatino fblxpcr nblatino nblxpcr, cluster(countyfips)

*Models for Table 2, Internal Efficacy
*Total Removals
ologit internal female dem ind edu platino border empower ptr fblatino fblxptr nblatino nblxptr, cluster(countyfips)
*Noncriminal Removals
ologit internal female dem ind edu platino border empower pncr fblatino fblxpncr nblatino nblxpncr, cluster(countyfips)
*Criminal Removals
ologit internal female dem ind edu platino border empower pcr fblatino fblxpcr nblatino nblxpcr, cluster(countyfips)


*Conditional Margin Effects 
*Figure 2
ologit localtrust female dem ind edu platino border empower nblatino nblxptr c.ptr##i.fblatino, cluster(countyfips)
margins, dydx(fblatino) at(ptr=(0(1)15)) at((min) dem ind border empower nblatino nblxptr (asobserved) platino edu) predict(outcome(1))
marginsplot, x(ptr)
ologit localtrust female dem ind edu platino border empower fblatino fblxptr c.ptr##i.nblatino, cluster(countyfips)
margins, dydx(nblatino) at(ptr=(0(1)15)) at((min) dem ind border empower fblatino fblxptr (asobserved) platino edu) predict(outcome(1))
marginsplot, x(ptr)
*Figure 3
ologit external female dem ind edu platino border empower nblatino nblxptr c.ptr##i.fblatino, cluster(countyfips)
margins, dydx(fblatino) at(ptr=(0(1)15)) at((min) dem ind border empower nblatino nblxptr (asobserved) platino edu) predict(outcome(1))
marginsplot, x(ptr)
ologit external female dem ind edu platino border empower fblatino fblxptr c.ptr##i.nblatino, cluster(countyfips)
margins, dydx(nblatino) at(ptr=(0(1)15)) at((min) dem ind border empower fblatino fblxptr (asobserved) platino edu) predict(outcome(1))
marginsplot, x(ptr)
*Figure 4
ologit localtrust female dem ind edu platino border empower nblatino nblxpncr c.pncr##i.fblatino, cluster(countyfips)
margins, dydx(fblatino) at(pncr=(0(1)5)) at((min) dem ind border empower nblatino nblxpncr (asobserved) platino edu) predict(outcome(1))
marginsplot, x(pncr)
ologit localtrust female dem ind edu platino border empower nblatino nblxpcr c.pcr##i.fblatino, cluster(countyfips)
margins, dydx(fblatino) at(pcr=(0(1)5)) at((min) dem ind border empower nblatino nblxpcr (asobserved) platino edu) predict(outcome(1))
marginsplot, x(pcr)
*Figure 5
ologit external c.ptr##c.numimm if anglo==1, cluster(countyfips)
margins, dydx(ptr) at(numimm=(1(1)5)) predict(outcome(5))
marginsplot, x(numimm)




