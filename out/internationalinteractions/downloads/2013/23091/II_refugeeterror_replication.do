set more off

*     ****************************************************************  *;
*		Run The Models Necessary To Create Table 1						*;
*		NOTE: In order to run all of the models, you must download and	*;
*		install RELOGIT													*;
*     ****************************************************************  *;

relogit terrord refugees rivalry jointDem capabilitityratio midinitiation contiguity coldwar trade terrord_lag, cluster(seid) wc(0.008)

nbreg terrorCounts refugees rivalry jointDem capabilitityratio midinitiation contiguity coldwar logterror trade, cluster(seid)

zinb terrorCounts refugees rivalry jointDem capabilitityratio midinitiation contiguity coldwar logterror trade, inflate(jointDem) cluster(seid)

*     ****************************************************************  *;
*		Run The Models Necessary To Create Table 2						*;
*		NOTE: You must install CLARIFY in order to run this code		*;
*     ****************************************************************  *;

relogit terrord refugees rivalry jointDem capabilitityratio midinitiation contiguity coldwar trade terrord_lag, cluster(seid) wc(0.008)

setx (refugees capabilitityratio) mean jointDem 1 rivalry 0 contiguity 1 midinitiation 0 coldwar 1 trade 1 terrord_lag 1

relogitq, fd(pr) changex(refugees .4101209 2.39835)

setx refugees .4101209

relogitq, pr

setx refugees 2.39835

relogitq, pr



