
use data, clear

// Hierarchical model, ML estimation
xtmixed support tenurez tradez gdpz inflz inclow inchi lright olead male age ||cntry:, mle var
est sto m1
est tab m1, b se

