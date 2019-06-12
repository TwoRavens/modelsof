* This file contains the order in which to run the ATUS data creation files.
*
* Jeff Shrader
* Creation date: 2017-09-09
* Time-stamp: "2018-02-04 17:35:33 jgs"

* Set paths
local work "/DIRECTORY"

local atus_code = "`work'/code"

* First, download files
do "`atus_code'/download_atus_zip_files.do"

* Second, unzip files and makde .dta files
do "`atus_code'/atus_create_stata_files.do"

* Third, process the main files to create activity data and
* a combined ATUS file that matches individual characteristics with
* daily time uses
do "`atus_code'/atus_combine.do"
