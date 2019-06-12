xtset Dyad_ID renegade_episode

**TABLE 1**

**MODEL 1**
xi: xtpcse  Expertscore pp100 trade_to_GDP Armingeon_lag Milex i.Democracy, c(ar1)

**MODEL 2**
xi: xtpcse  Expertscore pp100 trade_to_GDP str_sh Armingeon_lag Milex i.Democracy, c(ar1)

**MODEL 3**
xi: xtpcse Expertscore pp100 trade_to_GDP Armingeon_lag Milex  en_sh  nf_sh  ch_sh  el_sh  nu_sh  ar_sh i.Democracy, c(ar1)


**TABLE 2**

**MODEL 1A**
xi: xtpcse  Expertscore pp100 trade_to_GDP Armingeon_lag Milex i.Democracy if us_isr==0, c(ar1)

**MODEL 2A**
xi: xtpcse  Expertscore pp100 trade_to_GDP str_sh Armingeon_lag Milex i.Democracy if us_isr==0, c(ar1)

**MODEL 3A** 
xi: xtpcse Expertscore pp100 trade_to_GDP Armingeon_lag Milex  en_sh  nf_sh  ch_sh  el_sh  nu_sh  ar_sh i.Democracy if us_isr==0, c(ar1)


