set more off
probit voteref calsenz pknowh calsenknow calgovz greens libconf eccog vrisk surisk vurisk incz educ gender ///
 black hispanic orace repid demid opid jobless agez ///
 demcon repcon obamalk [iweight=weightd]
inteff voteref calsenz pknowh calsenknow calgovz greens libconf eccog vrisk surisk vurisk incz educ gender ///
 black hispanic orace repid demid opid jobless agez ///
 demcon repcon obamalk,savedata(c:\us2010\psrmversion\probrefsenpsrm,replace) ///
  savegraph1(c:\us2010\psrmversion\probrefsengr1psrm,replace) ///
  savegraph2(c:\us2010\psrmversion\probrefsengr2psrm,replace)



