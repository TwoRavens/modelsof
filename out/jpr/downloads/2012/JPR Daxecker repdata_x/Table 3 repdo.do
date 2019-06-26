set more off
estsimp nbreg     postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
setx mean
setx seriousfraud 0
setx observed 0
setx obs_serfraud 0
simqi, ev

setx seriousfraud 1
setx observed 0
setx obs_serfraud 0
simqi, ev

setx seriousfraud 0
setx observed 1
setx obs_serfraud 0
simqi, ev

setx seriousfraud 1
setx observed 1
setx obs_serfraud 1
simqi, ev
