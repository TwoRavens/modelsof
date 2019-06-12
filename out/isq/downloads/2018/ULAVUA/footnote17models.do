* Additional models referenced in footnote 17.
* Robustness, Table 2
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox territory river icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*

	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox maritime river icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox maritime territory icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
