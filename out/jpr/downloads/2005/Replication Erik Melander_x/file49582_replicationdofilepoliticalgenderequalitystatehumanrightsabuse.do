*Complete model*
gllamm HRabuse HRabuselag  femalerulerlag femrulerwipDec04lag /*
*/ wipDec04lag intwipD4pol2mlag thres33wipD4lag  /*
*/ polity2modlag polity2modsqlag transitionlag collapselag /*
*/ leftlag milcontrollag britlag /*
*/ lnpcgnplag lnpopulationlag elflag cwarcowlag iwarcowlag  /*
*/ , link(ologit) i(ccode3)

test polity2modlag polity2modsqlag


*First trimmed model*
gllamm HRabuse HRabuselag  wipDec04lag  intwipD4pol2mlag  /*
*/ polity2modlag polity2modsqlag /*
*/ lnpcgnplag lnpopulationlag cwarcowlag iwarcowlag  /*
*/ , link(ologit) i(ccode3)


test polity2modlag polity2modsqlag


*Second trimmed model*
gllamm HRabuse HRabuselag  wipDec04lag intwipD4pol2mlag /*
*/ polity2modlag polity2modsqlag /*
*/ lnpcgnplag lnpopulationlag cwarcowlag iwarcowlag  /*
*/ dynasticrlag nondynasticrlag, link(ologit) i(ccode3)

test polity2modlag polity2modsqlag
