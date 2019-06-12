/* TABLE 1 */

/* Government Victory */

stset time, f(GovVictory) id(conflict)

stcox GovIntDecay RebIntDecay RelRebCap Intense000 EthRel ColdWar Mountains Democracy, nohr robust


/* Rebel Victory */

stset time, f(RebVictory) id(conflict)

stcox GovIntDecay RebIntDecay RelRebCap Intense000 EthRel ColdWar Mountains Democracy, nohr robust


/* Negotiated Settlement */

stset time, f(NegSett) id(conflict)

stcox GovIntDecay RebIntDecay RelRebCap Intense000 EthRel ColdWar Mountains Democracy, nohr robust tvc(EthRel)




/* TABLE 2 */

/* Government Intervention */

stset time, f(GovInt) id(conflict)

stcox RelRebCap Intense000 Neighbors EthRel ColdWar RebIntDecay, nohr robust


/* Rebel Intervention */

stset time, f(RebInt) id(conflict)

stcox RelRebCap Intense000 Neighbors EthRel ColdWar GovIntDecay, nohr robust tvc(ColdWar)
