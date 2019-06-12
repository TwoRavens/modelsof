** Outreg Command File for Daniel Carpenter and Colin D. Moore, "When Canvassers Became Activists: Antislavery Petitioning and the Political Mobilization of American Women," APSR 108 (3) August 2014:   Paper *

** First load the 'antislaverypetitions_replication201408' data.
**
** The following commands produce a set of five panel regression models -- THIS REPLICATES TABLE ONE OF THE APSR ARTICLE OF AUGUST 2014

xtreg names womenpet congress25th cong26 cong27 cong28 christian republican focusdcslavery focusterritories focusnewstates focusallslavetrade focusgagrule, fe i(origincityorcountynum) cluster(origincityorcountynum)
outreg2 using c:/petition/womencanvas02.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtreg names womenpet congress25th cong26 cong27 cong28 christian republican focusdcslavery focusterritories focusnewstates focusallslavetrade focusgagrule if(names < 1001), fe i(origincityorcountynum) cluster(origincityorcountynum)
outreg2 using c:/petition/womencanvas02.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtreg lnnames womenpet congress25th cong26 cong27 cong28 christian republican focusdcslavery focusterritories focusnewstates focusallslavetrade focusgagrule, fe i(origincityorcountynum) cluster(origincityorcountynum)
outreg2 using c:/petition/womencanvas02.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtreg names womenpet christian republican focusdcslavery focusterritories focusnewstates focusallslavetrade focusgagrule if(congress25th == 1), fe i(origincityorcountynum) cluster(origincityorcountynum)
outreg2 using c:/petition/womencanvas02.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtreg lnnames womenpet christian republican focusdcslavery focusterritories focusnewstates focusallslavetrade focusgagrule if(congress25th == 1), fe i(origincityorcountynum) cluster(origincityorcountynum)
outreg2 using c:/petition/womencanvas02.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append

** Now load the 'antislaverypetitions_countypanel_replication201408' data.
**
** The following commenads produce a table of four panel regressions.  In the 4th and 5th models we add a restriction to counties where at least 1 petition appears in this congress and the one before.  THIS REPLICATES TABLE TWO OF THE APSR ARTICLE

xtreg totnamesper1000 pctpetwomen pctfocdc pctfocterr pctfocnewst pctfocslavetrade pctfocgag congress23-congress28 if( state_southplusMDKYTN == 0 & state_midwest == 0), fe i( countyid_number) cluster(countyid_number)
outreg2 using c:/petition/womencanvas07.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtregar totnamesper1000 pctpetwomen pctfocdc pctfocterr pctfocnewst pctfocslavetrade pctfocgag congress23-congress28 if( state_southplusMDKYTN == 0 & state_midwest == 0), fe
outreg2 using c:/petition/womencanvas07.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtreg totnamesper1000 pctpetwomen pctfocdc pctfocterr pctfocnewst pctfocslavetrade pctfocgag congress23-congress28 if(totpet > 0), fe i(countyid_number) cluster(countyid_number)
outreg2 using c:/petition/womencanvas07.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
xtreg totnamesper1000 pctpetwomen pctfocdc pctfocterr pctfocnewst pctfocslavetrade pctfocgag congress23-congress28 if(totpet > 0 & totpet[_n-1] > 0), fe i(countyid_number) cluster(countyid_number)
outreg2 using c:/petition/womencanvas07.doc, dec(2) noaster addnote(Put your notes here.) tex(frag) append
