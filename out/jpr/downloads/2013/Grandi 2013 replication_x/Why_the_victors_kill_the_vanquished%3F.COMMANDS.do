insheet using /Users/fragrandi/Desktop/PresentationsSubmissions/journals/JPR/analysis/DataMO+RE.csv
tabstat deaths, by(province) stats(mean v n)
nbreg deaths pop1936 altitude surface distance plain pci1946_percent
est store m1
nbreg deaths pop1936 altitude surface distance attacks stsentences massacres
est store m2
nbreg deaths pop1936 altitude surface distance cooperatives castrials
est store m3
nbreg deaths pop1936 altitude surface distance braccianti
est store m4
corr psu1919_percent left1924_percent
nbreg deaths pop1936 altitude surface distance psu1919_percent left1924_percent  
est store m5
nbreg deaths pop1936 altitude surface distance mont plain
est store m6
nbreg deaths pop1936 altitude surface distance plain pci1946_percent attacks stsentences massacres cooperatives castrials braccianti psu1919_percent left1924_percent mont
est store m7
est table m1 m2 m3 m4 m5 m6 m7, star
