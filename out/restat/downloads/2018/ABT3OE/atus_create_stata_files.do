* File to create Stata dta versions of the ATUS datasets using the .do files provided by ATUS.
*
* Jeff Shrader
* Creation date: 2013-09-03
* Time-stamp: "2018-02-04 17:34:32 jgs"

* Set paths
local work "/DIRECTORY"

* Data directory
local ext_dir = "`work'/data"

* What files are going to be processed
local atusmain "0316"
local atusrostec "1116"
local atuswb "1013"

foreach dir in "atuswb_`atuswb'" "atus`atusmain'" "atuseh" "atuslv" "atusrostec_`atusrostec'" {
   * Unzip files
   cd "`ext_dir'/`dir'"
   local file_list: dir . files "*.zip"
   foreach i of local file_list {
      unzipfile "`i'", replace
   }
   * Calling each of the ATUS .do files to create and sort the datasets
   local file_list: dir . files "*.do"
   foreach i of local file_list {
      capture erase "`ext_dir'/temp.do"
      capture erase "`ext_dir'/temp1.do"
      local F : subinstr local i ".do" ""
      filefilter "`i'" "`ext_dir'/temp.do", from("c:\BS") to("")
      * There is an idiosyncratic error
      filefilter "`ext_dir'/temp.do" "`ext_dir'/temp1.do", from("label e") to("label variable e")
      clear
      do "`ext_dir'/temp1.do"
      erase "`ext_dir'/temp.do"
      erase "`ext_dir'/temp1.do"
      save "`ext_dir'/`dir'/`F'.dta", replace
   }
   * Re-zip the files
   * Stata unzip doesn't delete the original zip file
   foreach j in "txt" "dat" "do" "sas" "sps" {
      local allfiles : dir "`ext_dir'/`dir'" files "*.`j'"
      foreach i of local allfiles {
         erase "`ext_dir'/`dir'/`i'"
      }
   }
}

*
