/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	input str6 sex
	male
	female
	end
	
	tempfile sex
	save "`sex'"

	drop _all
	input agecat
	20
	30
	40
	end
	
	cross using "`sex'"
	
	list
	