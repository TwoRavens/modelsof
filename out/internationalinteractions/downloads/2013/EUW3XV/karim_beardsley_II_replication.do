use karim_beardsley_II_replication, clear

*Table 3/Figure 3
xtreg propfem peacekeepingdeathsbyyear bdbest_max10 gdppc traditional political, cluster(pko)
lincom peacekeepingdeathsbyyear*8.98*2, level(90)
lincom bdbest_max10*7.97*2, level(90)
lincom gdppc*6.067*2, level(90)
factor peacekeepingdeathsbyyear bdbest_max10 gdppc, factors(1)
predict f_risk

*Table 4/Figure 4
xtreg propfem fat_best_max10 gdppc traditional political, cluster(pko)
lincom fat_best_max10*5.4*2, level(90)
xtreg propfem allegation gdppc traditional political, cluster(pko)
lincom allegation*11.44*2, level(90)
xtreg propfem femrep gdppc traditional political, cluster(pko)
lincom femrep*8.78*2, level(90)
xtreg propfem primary gdppc traditional political, cluster(pko)
lincom primary*20.58*2, level(90)
xtreg propfem rape gdppc traditional political, cluster(pko)
lincom rape*.95*2, level(90)
xtreg propfem sexratio gdppc traditional political, cluster(pko)
lincom sexratio*.92*2, level(90)
xtreg propfem security gdppc traditional political, cluster(pko)
lincom security*.57*2, level(90)
xtreg propfem law gdppc traditional political, cluster(pko)
lincom law*.66*2, level(90)
factor fat_best_max10 allegation femrep primary rape sexratio security law, factors(1)
predict f_need

*Table 5/Figure 5
xtreg propfem mandate_gender gdppc traditional political, cluster(pko)
xtreg propfem mandate_mainstream gdppc traditional political, cluster(pko)
xtreg propfem mandate_1325 gdppc traditional political, cluster(pko)
xtreg propfem mandate_sexviol gdppc traditional political, cluster(pko)
xtreg propfem mandate_protect gdppc traditional political, cluster(pko)
factor mandate_gender mandate_mainstream mandate_1325 mandate_sexviol mandate_protect, factors(1)
predict f_mandate

*Table 6
xtreg propfem f_risk f_need f_mandate gdppc traditional political, cluster(pko)



