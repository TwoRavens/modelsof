use data.dta, clear
gen diffngoalmatch=nextngoalmatch-previousngoalmatch if nextmatchindataset==1 & previousmatchindataset==1
gen diffngoalmatch2=nextngoalmatch2-previousngoalmatch2 if nextmatchindataset==1 & previousmatchindataset==1

gen diffnote=nextnote-previousnote if nextmatchindataset==1 & previousmatchindataset==1
gen diffnote2=nextnote2-previousnote2 if nextmatchindataset==1 & previousmatchindataset==1

foreach var in  diffngoalmatch diffngoalmatch2 diffnote diffnote2 {	
	teffects nnmatch (`var' absx2 absy2) (postin)  ///
		if nextmatchindataset==1 & previousmatchindataset==1  ///
		,  nneighbor(1)  biasadj(absx2 absy2)   metric(euclidean)
}  	
