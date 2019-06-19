/* 
-------------------------------------------------------------------------------

This directory contains local copies of all user-written programs used in this
project. This is done to ensure replicability in the event that user-written
programs change or become unavailable after this project is distributed. 

If you cannot install -project- using:

	ssc install project
	
use the version included in this directory in "project_package.zip"

Indicate that this project is dependent on these programs and all their
ancillary files. This makes them visible to -project-, who will then include
them in any -project, archive- or -project, share()- calls. This will also
shield these files from -project, cleanup-.	

-------------------------------------------------------------------------------
*/

	version 12
	
	
* ----- project ---------------------------------------------------------------
*
*! version 1.3.0b7  26nov2013  picard@netbox.com

	project, relies_on("project_package.zip")
	

* ----- outreg (also available from SSC)---------------------------------------
*
*! Write formatted regression output to a text file
*! version 4.30  28oct2013 by John Luke Gallup (jlgallup@pdx.edu)

	which outreg
	
	project, relies_on("frmt_opts.sthlp")
	project, original("frmttable.ado")
	project, relies_on("frmttable.sthlp")
	project, relies_on("greek_in_word.sthlp")
	project, original("l_cfrmt.mlib")
	project, relies_on("outreg_complete.sthlp")
	project, relies_on("outreg_update.sthlp")
	project, original("outreg.ado")
	project, relies_on("outreg.sthlp")


* ----- ivregress2 (also available from SSC)---------------------------------
* version 1.0.0  16mar2010
	project, relies_on("ivregress2.sthlp")
	project, original("ivregress2.ado")


* ----- countby ---------------------------------------------------------------
*! version 1.1  01dec2013  Robert Picard, Picard@netbox.com
	project, original("countby.ado")
