clear
clear matrix
set mem 500m


clear
insheet using students.txt

/* Create extra variables*/

merge 1:1 studentidentifier using bibliometrics
drop _merge


label var studentidentifier "Unique identifier for the student"
label var year "Year of graduation"
label var code "Identifier for the university"
label var university "Name of the university"
label var subject "Subject classification"
label var profid "Unique identifier for the advisor"
label var nsffellow "Takes value if student is recipient from NSF doctoral fellowship"
label var chineseboth "Takes value if student has a chinese first name and last name"


save ready, replace

