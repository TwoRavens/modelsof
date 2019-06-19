/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local author RP									// author of this file
	local sig {bind:{hi:[`author' : `dofile'.do]}}	// a signature in notes


* It is a good idea to add information in a note about who added the note and
* in which do-file this was done. This can be done using the sig macro defined 
* above.

	note: Send copy to Bob once verified. `sig'
	notes
	
	note: Mary wants a copy, too. `sig'
	notes
	

* Time stamps are not a good idea because do-files that list the notes will be
* different at each replication build. Since the log file already contains a
* time stamp, a note with a signature can be used to trace back which do-file
* added the note. It would be acceptable if the time stamps were part of an
* interactive session and the dataset that contains the notes is included in the
* project using the -original()- build directive.

	note: merged updates from JJ&F `sig'
	notes


	project, original("`pdir'/data/stata/auto.dta")
	use "`pdir'/data/stata/auto.dta"
	
	note: check reason for missing values in {cmd:rep78} `sig'
	notes


	note mpg: is the 44 a mistake? Ask Bob. `sig'
	note mpg: what about the two missing values? `sig'
	notes
