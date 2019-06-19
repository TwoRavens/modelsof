/**************************************************************************
 |                                                                         
 |                    STATA SETUP FILE FOR ICPSR 21480
 |             STATE LEGISLATIVE ELECTION RETURNS, 1967-2003
 |
 |
 |  Please edit this file as instructed below.
 |  To execute, start Stata, change to the directory containing:
 |       - this do file
 |       - the ASCII data file
 |       - the dictionary file
 |
 |  Then execute the do file (e.g., do 21480-0001-statasetup.do)
 |
 **************************************************************************/

set mem 200m  /* Allocating 200 megabyte(s) of RAM for Stata SE to read the
                 data file into memory. */


set more off  /* This prevents the Stata output viewer from pausing the
                 process */

/****************************************************

Section 1: File Specifications
   This section assigns local macros to the necessary files.
   Please edit:
        "data-filename" ==> The name of data file downloaded from ICPSR
        "dictionary-filename" ==> The name of the dictionary file downloaded.
        "stata-datafile" ==> The name you wish to call your Stata data file.

   Note:  We assume that the raw data, dictionary, and setup (this do file) all
          reside in the same directory (or folder).  If that is not the case
          you will need to include paths as well as filenames in the macros.

********************************************************/

local raw_data "data-filename"
local dict "dictionary-filename"
local outfile "stata-datafile"

/********************************************************

Section 2: Infile Command

This section reads the raw data into Stata format.  If Section 1 was defined
properly, there should be no reason to modify this section.  These macros
should inflate automatically.

**********************************************************/

infile using `dict', using (`raw_data') clear


/*********************************************************

Section 3: Value Label Definitions
This section defines labels for the individual values of each variable.
We suggest that users do not modify this section.

**********************************************************/


label data "State Legislative Election Returns, 1967-2003, Dataset 0001"

#delimit ;
label define V1        8907 "icpsr study no." ;
label define V2        1 "spring,1988 release" 2 "winter,1989 release"
                       3 "fall,1989 release" 4 "sept,1990 release"
                       5 "Jan,1992 release" ;
label define V3        1 "icpsr part no." ;
label define V5        1 "ct -1788-" 2 "maine -1820-" 3 "ma -1788-"
                       4 "nh -1788-" 5 "ri -1790-" 6 "vermont -1791-"
                       11 "delaware -1787-" 12 "nj -1787-"
                       13 "new york -1788-" 14 "pa -1787-"
                       21 "illinois -1818-" 22 "indiana -1816-"
                       23 "michigan -1837-" 24 "ohio -1803-"
                       25 "wisconsin -1848-" 31 "iowa -1846-"
                       32 "kansas -1861-" 33 "minnesota -1858-"
                       34 "missouri -1821-" 35 "nebraska -1867-"
                       36 "nd -1889-" 37 "sd -1889-" 40 "virginia -1788-"
                       41 "alabama -1819-" 42 "arkansas -1836-"
                       43 "florida -1845-" 44 "georgia -1788-"
                       45 "louisiana -1812-" 46 "ms -1817-" 47 "nc -1789-"
                       48 "sc -1788-" 49 "texas -1845-" 51 "kentucky -1792-"
                       52 "maryland -1788-" 53 "oklahoma -1907-"
                       54 "tennessee -1796-" 55 "washington, d.c."
                       56 "wv -1863-" 61 "arizona -1912-"
                       62 "colorado -1876-" 63 "idaho -1890-"
                       64 "montana -1889-" 65 "nevada -1864-" 66 "nm -1912-"
                       67 "utah -1896-" 68 "wyoming -1890-" 71 "ca -1850-"
                       72 "oregon -1859-" 73 "wa -1889-" 81 "alaska -1959-"
                       82 "hawaii -1959-" ;
label define V7        8 "senate and nebr" 9 "house of rep" ;
label define V8        999 "missing data -di" ;
label define V10       1 "single-member dt" 2 "mm dt positions"
                       3 "mm free-for-all" 4 "mm alternating"
                       5 "floterial sm" 6 "floterial mm-p"
                       7 "floterial mm-ff" ;
label define V12       1 "january" 2 "february" 3 "march" 4 "april" 5 "may"
                       6 "june" 7 "july" 8 "august" 9 "september"
                       10 "october" 11 "november" 12 "december" 99 "unknown" ;
label define V13       -9 "missing data -re" ;
label define V15       0 "Not Incumbent" 1 "Incumbent" ;
label define V31       0 "otherwise" 1 "Candidate won the election" ;
label define V33       0 "no" 1 "yes" ;


#delimit cr

/********************************************************************

 Section 4: Save Outfile

  This section saves out a Stata system format file.  There is no reason to
  modify it if the macros in Section 1 were specified correctly.

*********************************************************************/

save `outfile', replace

