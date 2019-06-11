clear all
set memory 100000
set matsize 10000
set maxvar 30000

global root = "C:\users\alwynyoung\Desktop"

foreach paper in CMS {
	local dir = "$root" + "\files\" + "`paper'"
	cd `dir'
	capture mkdir results
	capture mkdir ip
	foreach file in Replication FisherN FisherA Fisherred OBootstrap OBootstrapA OBootstrapred Bootstrap JackKnife JackKnifeA Jackknifered OJackknife {
		global reps = 10000
		capture do `file'`paper'
		}
	}

