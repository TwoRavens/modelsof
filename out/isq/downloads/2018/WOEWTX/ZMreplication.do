*Replication Code for Zawahri & Mitchell, ISA 2011
*Table 2
logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow if bilatbasin==1, robust
logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 if multibasin==1, robust
logit multitreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 if multibasin==1, robust

*Table 3
logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow minngo minpacsett if bilatbasin==1, robust
logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 minngo minpacsett if multibasin==1, robust
logit multitreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 minngo minpacsett if multibasin==1, robust

*Table 4
logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow tradedep if bilatbasin==1, robust
logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 tradedep if multibasin==1, robust
logit multitreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 tradedep if multibasin==1, robust

*Predicted probabilities for Table 2, Model 1
estsimp logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow if bilatbasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168  
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168  
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168  
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722
simqi, pr

*Predicted probabilities for Table 2, Model 2
estsimp logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 if multibasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 contigdum 1 numbasin2 5.7136
simqi, pr

*Predicted probabilities for Table 2, Model 3
estsimp logit multitreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 if multibasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 contigdum 1 numbasin2 5.7136
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 contigdum 1 numbasin2 5.7136
simqi, pr

*Predicted probabilities for Table 3, Model 1
estsimp logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow minngo minpacsett if bilatbasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 0 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 16 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 0
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 13
simqi, pr

*Predicted probabilities for Table 3, Model 2
estsimp logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 minngo minpacsett if multibasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 0 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 16 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 0
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 13
simqi, pr

*Predicted probabilities for Table 3, Model 3
estsimp logit multitreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 minngo minpacsett if multibasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 0 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 16 minpacsett 3.236
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 0
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 minngo 1.263 minpacsett 13
simqi, pr

*Predicted probabilities for Table 4, Model 1
estsimp logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow tradedep if bilatbasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 0.0002
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 1059.4
simqi, pr

*Predicted probabilities for Table 4, Model 2
estsimp logit bilattreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 tradedep if multibasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 0.0002
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 1059.4
simqi, pr

*Predicted probabilities for Table 4, Model 3
estsimp logit multitreaty lowpolity samelegal downstreampower upstreampower percentarealow waterdependlow avgpreciplow contigdum numbasin2 tradedep if multibasin==1, robust
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 tradedep 5.7261
simqi, pr
setx lowpolity -10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity 10 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 1 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0000146 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower .3838635 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .0000141 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower .3838635 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 0.03 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 94.44 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 0 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 94.23 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 5.7261 
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 51 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 2722 contigdum 1 numbasin2 5.7136 tradedep 5.7261
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 0.0002
simqi, pr
setx lowpolity -2.6254 samelegal 0 upstreampower 0.0208 downstreampower 0.0208 percentarealow 16.732 waterdependlow 12.0605 avgpreciplow 880.168 contigdum 1 numbasin2 5.7136 tradedep 1059.4
simqi, pr




