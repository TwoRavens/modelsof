* Import data into Stata

import delimited "C:\Users\User\Box Sync\data\research\Australia\nsw1889.repfile.csv"


* Label included variables

label var electorate "Electorate official name"
label var areasqkm "Electorate's area, in square kilometers"
label var prot1889 "Votes for Protectionists in 1889 New South Wales election"
label var free1889 "Votes for Free Traders in 1889 New South Wales election"
label var inf1889 "Votes for independents in 1889 New South Wales election"
label var seats1889 "District magnitude (i.e., number of seats) in 1889"
label var exporter "Export-intense electorate (1 = yes; 0 = no)"
label var minecent "Mining center in 1880s, per Atlas of Australian Resources"
label var sheeppercap "Sheep per capita in 1891 Census"
label var sheep91 "Number of sheep in electorate in 1891 Census"
label var totalpop "Electorate's total population in 1891 Census"
label var under21m "Electorate's male, under-21 population in 1891 Census"
label var over20m "Electorate's male, 21-and-over population in 1891 Census"
label var under21f "Electorate's female, under-21 population in 1891 Census"
label var over20f "Electorate's female, 21-and-over population in 1891 Census"
label var chinese "Electorate's population identified as Chinese in 1891 Census"
label var mallages "Electorate's total male population in 1891 Census"
label var fallages "Electorate's total female population in 1891 Census"
label var t50andunder55 "Electorate's population aged 50 to 54 in 1891 Census"
label var t55andunder60 "Electorate's population aged 55 to 59 in 1891 Census"
label var t60andunder65 "Electorate's population aged 60 to 64 in 1891 Census"
label var t65andunder70 "Electorate's population aged 65 to 69 in 1891 Census"
label var t70andunder75 "Electorate's population aged 70 to 74 in 1891 Census"
label var t75andunder80 "Electorate's population aged 75 to 79 in 1891 Census"
label var t80andunder85 "Electorate's population aged 80 to 84 in 1891 Census"
label var t85andunder90 "Electorate's population aged 85 to 89 in 1891 Census"
label var t90andunder95 "Electorate's population aged 90 to 94 in 1891 Census"
label var t95andunder100 "Electorate's population aged 95 to 99 in 1891 Census"
label var t100 "Electorate's population aged 100 in 1891 Census"
label var t101 "Electorate's population aged 101 in 1891 Census"
label var t102 "Electorate's population aged 102 in 1891 Census"
label var t103 "Electorate's population aged 103 in 1891 Census"
label var t104 "Electorate's population aged 104 in 1891 Census"
label var t107 "Electorate's population aged 107 in 1891 Census"
label var rdwrto20m "Over-20 males who could read and write English in 1891 Census"
label var onlyrdo20m "Over-20 males who could read but not write English in 1891 Census"
label var rwforo20m "Over-20 males who could read and write non-English language in 1891 Census"
label var rdforo20m "Over-20 males who could read but not write non-English language in 1891 Census"
label var rdwrto20f "Over-20 females who could read and write English in 1891 Census"
label var onlyrdo20f "Over-20 females who could read but not write English in 1891 Census"
label var rwforo20f "Over-20 females who could read and write non-English language in 1891 Census"
label var rdforo20f "Over-20 females who could read but not write non-English language in 1891 Census"
label var weight "Proportion of electorate population living in municipal areas"
label var otheuro "Population born in mainland Europe, per Statistical Register"
label var infirmpct "Percent of population with infirmities in 1891 Census"
label var uninhab "Percent of buildings uninhabited in 1891 Census"
label var construct "Percent of buildings under construction in 1891 Census"


* Generate derived variables

gen chipop = 100*chinese/totalpop
label var chipop "Percent of population of Chinese descent, per 1891 Census"
gen protect = 100*prot1889/(prot1889+free1889+inf1889)
label var protect "Percent of votes in 1889 going to Protectionist party"
* This "protect" variable is the basis for Figure 1
gen popdns = ln(totalpop/areasqkm)
label var popdns "Natural logarithm, population per square kilometer"
gen pop50up = 100*(t50andunder55+t55andunder60+t60andunder65+t65andunder70+t70andunder75+t75andunder80+t80andunder85+t85andunder90+t90andunder95+t95andunder100+t100+t101+t102+t103+t104+t107)/totalpop
label var pop50up "Percent of population aged 50 or above"
gen young = 100*( under21m+under21f)/ totalpop
label var young "Percent of population aged 20 or below"
gen sexratio = 100*mallages/fallages
label var sexratio "Males per 100 females in electorate population"
gen literate = 100*(rdwrto20m+rdwrto20f+rwforo20m+rwforo20f+(onlyrdo20m+rdforo20m+onlyrdo20f+rdforo20f)/2)/(over20m+over20f)
label var literate "Literacy rate in any language (adjusted for semi-literacy)"
gen foreign = 100*(rwforo20m+rdforo20m+rwforo20f+rdforo20f)/(over20m+over20f)
label var foreign "Literacy rate in non-English languages (adjusted for semi-literacy)"
gen expchipop = exporter*chipop
label var expchipop "Interaction: Export-oriented electorate times Chinese population share"
gen explit = exporter*literate
label var explit "Interaction: Export-oriented electorate times literacy rate"


* Table 1 regressions

reg protect chipop exporter popdns pop50up young sexratio if prot1889*free1889 > 0 [iweight = seats1889], r
reg protect chipop exporter popdns pop50up young sexratio if prot1889*free1889 > 0, r
reg protect chipop exporter popdns pop50up young sexratio infirmpct if prot1889*free1889 > 0 [iweight = weight], r
reg protect chipop exporter popdns pop50up young sexratio uninhab construct if prot1889*free1889 > 0 [iweight = weight], r


* Table 2 regressions

reg protect chipop exporter popdns pop50up young sexratio otheuro if prot1889*free1889 > 0 [iweight = weight], r
reg protect chipop exporter popdns pop50up young sexratio foreign if prot1889*free1889 > 0 [iweight = seats1889], r
reg protect chipop exporter popdns pop50up young sexratio literate if prot1889*free1889 > 0 [iweight = seats1889], r
reg protect chipop exporter popdns pop50up young sexratio literate explit if prot1889*free1889 > 0 [iweight = seats1889], r
reg protect chipop exporter popdns pop50up young sexratio expchipop if prot1889*free1889 > 0 [iweight = seats1889], r


* Appendix: descriptive statistics and correlation matrix

sum protect chipop exporter popdns pop50up young sexratio infirmpct uninhab construct otheuro foreign literate explit expchipop seats1889 weight if prot1889*free1889 > 0 
pwcorr protect chipop exporter popdns pop50up young sexratio infirmpct uninhab construct otheuro foreign literate explit expchipop seats1889 weight if prot1889*free1889 > 0 
