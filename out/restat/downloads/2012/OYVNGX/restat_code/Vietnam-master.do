*==================================================================
*			    Vietnam CATFISH	 		   
*==================================================================
*version 9
drop _all
set mem 200m
set more off

**** SET WORKING DIRECTORY
*cd "F:\vietnam\programs\rstat - code\"
cd "F:\Archive\vietnam\programs\rstat - code\"

*Figure 3: plots density

*First we run all the regressions
do code\Figure3

*Main text
do code\Table5a
do code\Table6
do code\Table7a
do code\Table7b
do code\Table8a
do code\Table8b

*Appendix
do code\TableAppA1

*Supplemental Web Appendix
do code\TableA1a
do code\TableA2
do code\TableA3a
do code\TableA3b
do code\TableA4a
do code\TableA4b

*Now we prepare tex code: feed into Table.tex

do code\tex_Table5a
do code\tex_Table6
do code\tex_Table7
do code\tex_Table8

do code\tex_TableA1a
do code\tex_TableA2
do code\tex_TableA3
do code\tex_TableA4
do code\tex_TableAppA1
