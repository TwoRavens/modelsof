set more off

set scheme s1manual

* change what's between the "" below to your own working directory

local mywd "~/Dropbox/Summer 2015/research/prediction/data"

cd "`mywd'"

* clean up

local myfilelist : dir . files"*.eps"
foreach myfile in `myfilelist' {
	di "Erasing `myfile'..."
	qui: erase "`myfile'"
}
local myfilelist : dir . files"*.tex"
foreach myfile in `myfilelist' {
	di "Erasing `myfile'..."
	qui: erase "`myfile'"
}

* make new figures and tables

local myfilelist : dir . files"*.do"
foreach myfile in `myfilelist' {
	if "`myfile'" != "replication.do" {
		di "Doing `myfile'..."
		qui: do `"`myfile'"'
	}
}

