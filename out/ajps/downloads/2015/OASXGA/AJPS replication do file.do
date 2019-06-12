*ACTOR FRAGMENTATION AND CIVIL WAR
*This do file contains replication of Table 3 in the article and Tables 4 - 7 in the appendix.
*TABLE 3 
*MODEL 1
logit civilwaronset logfactions prevconcessions_l democracy kin yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 2
logit acdcivilwar1 logfactions prevconcessions_l democracy kin yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw , robust cluster(kgcid)


*APPENDIX
*TABLE 4
*MODEL 1
logit civilwaronset logfactions prevconcessions_l democracy kin logSDsize_relative tbase  logmountain oilexp instab avgecdis loggdp logpop milexpc  numgrps yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 2
logit acdcivilwar1 logfactions prevconcessions_l democracy kin logSDsize_relative tbase  logmountain oilexp instab avgecdis loggdp logpop milexpc  numgrps yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw, robust cluster(kgcid)

*TABLE 5
*MODEL 1
logit civilwaronset laglogfactions prevconcessions_l democracy kin yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 2
logit civilwaronset endogfac1 prevconcessions_l democracy kin yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 3
logit civilwaronset logSDfactionsendogcivilwar prevconcessions_l democracy kin yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 4
logit civilwaronset logfactions prevconcessions_l democracy kin prevcivilwaronset yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 5
logit firstonset logfactions prevconcessions_l democracy kin yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 6
logit civilwaronset logfactions prevconcessions_l democracy kin yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1 & multiplecws==0, robust cluster(kgcid)

**TABLE 6
*MODEL 1logit acdcivilwar1 laglogfactions prevconcessions_l democracy kin yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw , robust cluster(kgcid)*MODEL 2logit acdcivilwar1 endogfac1 prevconcessions_l democracy kin yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw , robust cluster(kgcid)*MODEL 3logit acdcivilwar1 logSDfactionsendogcivilwar prevconcessions_l democracy kin yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw , robust cluster(kgcid)*MODEL 4logit acdcivilwar1 logfactions prevconcessions_l democracy kin prevcivilwaronset yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw, robust cluster(kgcid)*MODEL 5logit acdcivilwar1 logfactions prevconcessions_l democracy kin yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw  if multiplecws==0, robust cluster(kgcid)

*TABLE 7
*MODEL 1
logit civilwaronset logfactions prevconcessions_l democracy kin logSDsize_relative tbase  logmountain oilexp instab avgecdis loggdp logpop milexpc  numgrps yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1, robust cluster(kgcid)
*MODEL 2
logit civilwaronset prevconcessions_l democracy kin logSDsize_relative tbase  logmountain oilexp instab avgecdis loggdp logpop milexpc  numgrps yrnocwonset _spline1_cwonset _spline2_cwonset _spline3_cwonset if ongoingcivilwar!=1 & factions!=., robust cluster(kgcid)
*MODEL 3
logit acdcivilwar1 logfactions prevconcessions_l democracy kin logSDsize_relative tbase  logmountain oilexp instab avgecdis loggdp logpop milexpc  numgrps yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw, robust cluster(kgcid)
*MODEL 4
logit acdcivilwar1 prevconcessions_l democracy kin logSDsize_relative tbase  logmountain oilexp instab avgecdis loggdp logpop milexpc  numgrps yrsnocivilwar _spline1_cw _spline2_cw _spline3_cw if factions!=., robust cluster(kgcid)
