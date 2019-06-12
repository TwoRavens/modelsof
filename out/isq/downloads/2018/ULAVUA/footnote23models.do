* syntax for models referenced in footnote 23 *
* Table 2 with Territory and Rivalry Interaction dummies *

*Excluding terival
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox ternonrival nonterival nonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900, shared(ddyadidclaim2) 
	
*Excluding ternonrival
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox terival nonterival nonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900,  shared(ddyadidclaim2) 
	
*Excluding nonterival	
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox terival ternonrival nonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900, shared(ddyadidclaim2) 
	
*Excluding nonternonrival
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox terival ternonrival nonterival icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900, shared(ddyadidclaim2) 

************************************************************************************
* Table 2 with Maritime and Rivalry Interaction dummies *

*Excluding marival
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox marnonrival nonmarival nonmarnonriv icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900, shared(ddyadidclaim2) 
	
*Excluding marnonrival
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox marival nonmarival nonmarnonriv icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900,  shared(ddyadidclaim2) 
	
*Excluding nonmarival	
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox marival marnonrival nonmarnonriv icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900, shared(ddyadidclaim2) 
	
*Excluding nonmarnonriv
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox marival marnonrival nonmarival icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 ///
	if year>1900, shared(ddyadidclaim2) 
	