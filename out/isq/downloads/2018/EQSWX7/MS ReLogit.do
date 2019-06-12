use "global ed ms data (all simmulations all ages with message volume control).dta" 


relogit  collab sim_gend mgroup fgroup mes_vol

relogit  confl sim_gend mgroup fgroup mes_vol

relogit  recip sim_gend mgroup fgroup mes_vol

relogit  self sim_gend mgroup fgroup mes_vol

relogit  assert sim_gend mgroup fgroup mes_vol

relogit  creativ sim_gend mgroup fgroup mes_vol

relogit  multiple sim_gend mgroup fgroup mes_vol
