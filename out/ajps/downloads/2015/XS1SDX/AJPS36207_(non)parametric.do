clear

set more off


/*SET YOUR PATH*/

cd "C:\Users\YOUR PATH\"

use AJPS36207.dta


drop if cand==0
/***Results Section: Campaigns***/


ranksum promise if treat!=3, by(treat)
ttest promise if treat!=3, by(treat)



/***Results Section: Benevolence of Representatives***/

mean fractionofpromisekept if elec==1
mean fractionofpromisekept if random==1


ranksum avgmyshare if treat!=3, by(treat)
ttest avgmyshare if treat!=3, by(treat)

ranksum avgmyshare if treat!=2, by(treat)
ttest avgmyshare if treat!=2, by(treat)

ranksum avgmyshare if treat!=1, by(treat)
ttest avgmyshare if treat!=1, by(treat)

ranksum mysharev1 if treat!=3, by(treat)
ranksum mysharev2 if treat!=3, by(treat)
ranksum mysharev3 if treat!=3, by(treat)


ranksum mysharev1 if treat!=2, by(treat)
ranksum mysharev2 if treat!=2, by(treat)
ranksum mysharev3 if treat!=2, by(treat)

ranksum mysharev1 if treat!=1, by(treat)
ranksum mysharev2 if treat!=1, by(treat)
ranksum mysharev3 if treat!=1, by(treat)
