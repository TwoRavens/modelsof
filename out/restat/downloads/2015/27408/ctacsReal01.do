***********************************************************************************
* C-TaCS - The Canadian Tax and Credit Simulator
* Build 2007-2
* 
* Program name: interface.do
* Program purpose: provides the interface to the end user
* Program updated: October 23, 2007 by km
***********************************************************************************

* set stata parameters.
clear
 /* Note:  set this so that there is sufficient memory to handle your input file */
set more off

********************************
*
* There are five items to be assigned below. For each, replace what is in the quotation marks with the desired directory/filename.
* 1. assign the root directory.
* 2. assign the input/output directory.
* 3. assign the name for the logfile.
* 4. assign the name of the input dataset.
* 5. assign the name of the output dataset.
*
********************************

* Assign directories
global ctacs "/Users/mdgordon/Desktop\Selfemployment\Ctacs\CTaCS-2008-1"  		/****1****/
global inout "/Users/mdgordon/Desktop\Selfemployment\Ctacs\CTaCS-2008-1\inout\"   /****2****/

* Assign log file
global logfile "interface.log"                                    /****3****/

* Assign input and output files
* global indata "ctacs-in"                                      /****4****/
global indata "01real"                                      /****4****/
global outdata "ctacs-01real"                                    /****5****/

********************************
*
* Nothing else needs to be done below this point.
*
********************************

* load the programs
do $ctacs\files\loadprogs.do

* Run the program
ctacs

