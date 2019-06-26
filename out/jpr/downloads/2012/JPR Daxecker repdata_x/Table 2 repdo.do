*Table 2, Predicted Count of Conflict Events for 
set more off
estsimp nbreg     postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
setx mean
setx seriousfraud 0
setx observed 0
setx obs_serfraud 0
simqi, ev
setx seriousfraud 1
setx observed 1
setx obs_serfraud 1
simqi, ev
setx mean
setx preelec 0
simqi, ev
setx preelec 1
simqi, ev
setx mean
setx pop_ln 7.5
simqi, ev
setx pop_ln 10.3
simqi, ev
drop b*

estsimp nbreg postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if firstelec==0 , robust
setx mean
setx seriousfraud 0
setx observed 0
setx obs_serfraud 0
simqi, ev
setx seriousfraud 1
setx observed 1
setx obs_serfraud 1
simqi, ev
setx mean
setx preelec 0
simqi, ev
setx preelec 1
simqi, ev
setx mean
setx pop_ln 7.5
simqi, ev
setx pop_ln 10.3
simqi, ev
drop b*

estsimp nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights] , robust
setx mean
setx seriousfraud 0
setx observed 0
setx obs_serfraud 0
simqi, ev
setx seriousfraud 1
setx observed 1
setx obs_serfraud 1
simqi, ev
setx mean
setx preelec 0
simqi, ev
setx preelec 1
simqi, ev
setx mean
setx gdpcaplag_ln 6.0
simqi, ev
setx gdpcaplag_ln 8.1
simqi, ev
setx mean
setx pop_ln 7.5
simqi, ev
setx pop_ln 10.3
simqi, ev
drop b*
estsimp nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights] if firstelec==0, robust
setx mean
setx seriousfraud 0
setx observed 0
setx obs_serfraud 0
simqi, ev
setx seriousfraud 1
setx observed 1
setx obs_serfraud 1
simqi, ev
setx mean
setx preelec 0
simqi, ev
setx preelec 1
simqi, ev
setx mean
setx gdpcaplag_ln 6.0
simqi, ev
setx gdpcaplag_ln 8.1
simqi, ev
setx mean
setx pop_ln 7.5
simqi, ev
setx pop_ln 10.3
simqi, ev
drop b*
