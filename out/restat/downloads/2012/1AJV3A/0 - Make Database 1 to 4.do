/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 250m
version 9
global datapath "C:\Users\Michael McMahon\Dropbox\GSOEP21"
global repfiles "C:\Users\Michael McMahon\Dropbox\Giavazzi Restat - Publication version\Replication files"
cd "$datapath\GiavazziMcMahonReStat"

global head = 2

do "$repfiles\1a - assembling database - CNEF"

do "$repfiles\1b - assemble database - extra data"

local i=1994
while `i'<=2004 {
	do "$repfiles\2 - `i' database (full).do"
	local i=`i'+1
	}
*

do "$repfiles\3 - assemble panel.do"

do "$repfiles\4 - creating database.do"

* LOOP TO ERASE EXCESS FILES CREATED

local i=94
while `i'<=99 {
erase "$datapath\GiavazziMcMahonReStat\19`i'.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'_panel.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i' gen.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'h weight.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'h.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'hw.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'p weight.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'p.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'pw.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i'pw cnef.dta"
erase "$datapath\GiavazziMcMahonReStat\\`i'extra.dta"
erase "$datapath\GiavazziMcMahonReStat\19`i' cnef.dta"
local i = `i'+1
}
*
local i=0
while `i'<=4 {
erase "$datapath\GiavazziMcMahonReStat\200`i'.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'_panel.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i' gen.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'h weight.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'h.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'hw.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'p weight.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'p.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'pw.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i'pw cnef.dta"
erase "$datapath\GiavazziMcMahonReStat\\0`i'extra.dta"
erase "$datapath\GiavazziMcMahonReStat\200`i' cnef.dta"
local i = `i'+1
}
*
erase "$datapath\GiavazziMcMahonReStat\panel.dta"
erase "$datapath\GiavazziMcMahonReStat\2000p_smoke.dta"
erase "$datapath\GiavazziMcMahonReStat\2002 industry.dta"
