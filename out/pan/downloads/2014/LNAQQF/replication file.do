** Tables 3 and 4: Roll Call Voting
** First stage results go in table 3
** Second stage results go in table 4
ivregress 2sls  ln_all pres2 st party i.cong (bldg=lottery2),cl(id) first
estat first
ivregress 2sls  ln_all pres2 st party i.cong (floor=lottery2),cl(id) first
estat first
ivregress 2sls  ln_all pres2 st party i.cong (wing=lottery2),cl(id) first
estat first

** Tables 3 and 6: Cosponsorship
** First stage results go in table 3
** Second stage results go in table 6
ivregress 2sls  ln_c pres2 st party i.cong (bldg=lottery2),cl(id) first
estat first
ivregress 2sls  ln_c pres2 st party i.cong (floor=lottery2),cl(id) first
estat first
ivregress 2sls  ln_c pres2 st party i.cong (wing=lottery2),cl(id) first
estat first
