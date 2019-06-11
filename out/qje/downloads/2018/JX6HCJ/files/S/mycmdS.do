global cluster = "session"

use DatS, clear
rename wgaptr wgptr
rename wgaptroc wgaptrc

global i = 1
global j = 1

*Table 5
foreach X in "" "0" {
	mycmd (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6 
foreach X in "" "0" {
	mycmd( trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc if p1 == 1, re cluster(session)
	}

*Table 7 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
		}
	}

mycmd (troca0 treata0) xtreg investment troca0 treata0 oc if p1==1, re cluster(session)
mycmd (troca treata) xtreg reject troca treata oc if p1==1, re cluster(session)

*Table B4
foreach X in "" "dumneg" {
	mycmd (wgptr wgaptrc treat troc) xtprobit investment wgptr wgaptrc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}
foreach X in "" "dumneg" {
	mycmd (wgptr wgaptrc treat troc wexptr wexptroc) xtprobit reject wgptr wgaptrc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}

*Table B5 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X', re cluster(session) 
		}
	}
mycmd (troca0 treata0) xtreg investment troca0 treata0 oc, re cluster(session)
mycmd (troca treata) xtreg reject troca treata oc, re cluster(session)





