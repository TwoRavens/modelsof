* this file reads the NBER family files and saves them as one merged STATA file. 
* notice: unzipped NBER files should manually be added a ".0" extension (e.g. ffile021.0).
* nber3.dct is used as a dictionary.

cd "U:/User6/oh33/NBER"
set more 1
# delimit;
quietly{;
clear;
set mem 200m;

*====================================;
local yrstart=2003; local yrend=2005; // notice: since 2004:3 and 2004:4 are missing, i only take q3 and q4 from 2003, and q1 and q2 from 2004.
*====================================;

local yr=`yrstart'; while `yr'<=`yrend' {;
  local str_yr=substr(string(`yr'),3,2);
  local q=1; while `q'<=4 {;
	if ~( (`yr'==2003 & (`q'==1 | `q'==2)) | (`yr'==2004 & (`q'==3 | `q'==4)) ) {;
		drop _all;
		infile using consp2010/nber3.dct, using ("data\updated_ce_files\ffile`str_yr'`q'.0");
		gen yearq=`yr'`q'; gen yr=`yr'; *gen q=`q';
		save "data\updated_ce_files\ffile`str_yr'`q'", replace;
	};
    local ++q;
  };
  local ++yr;
};
}; /* quietly */

* merge all files;
drop if 1==1; * drop all obs of the file in memory, to prevent duplicate records.;
count;
local yr=`yrstart'; while `yr'<=`yrend' {;
  local str_yr=substr(string(`yr'),3,2);
  local q=1; while `q'<=4 {;
    	if ~( (`yr'==2003 & (`q'==1 | `q'==2)) | (`yr'==2004 & (`q'==3 | `q'==4)) ) ///
			append using "data\updated_ce_files\ffile`str_yr'`q'";
    count;
    local ++q;
  };
  local ++yr;
};
local str_save = substr(string(`yrstart'),3,2)+substr(string(`yrend'),3,2);
save data\updated_ce_files\ffile`str_save', replace; 
