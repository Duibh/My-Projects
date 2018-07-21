#!/bin/bash
# Author: Conor Duff
# version 3.0

Auswahl(){
echo; read -p "Wählen Sie aus, was Sie tun möchten (schliessen mit exit): " choice
case $choice in
    1)Kontakt_Aufnahme;;
    2)Loeschen_TXT;;
    3)Kontakte_SQlite;;
    4)Ausgabe_SQlite_DB;;
    5)Bearbeiten_DB;;
    "exit")clear; echo Auf Wiedersehen!;;
    *)echo; read -p "Ungültige Eingabe! Versuchen Sie es noch einmal."; Intro;;
esac
}


Kontakt_Aufnahme(){
echo; read -p "Neue Adresse aufnehmen? (y|n): " again
echo
case $again in
    'y')read -p "Nachname: " nachname
	read -p "Vorname: " vorname
	read -p "TelefonNr.: " telNr \n
	printf "$nachname:$vorname:$telNr\n" >> Kontakte.txt
	Kontakt_Aufnahme;;
    *)Intro;;
esac
}

Loeschen_TXT(){
echo; read -p "Kontakte.txt löschen? (y|n): " omg
case $omg in
'y')if [ -e Kontakte.txt ]
then
    rm Kontakte.txt
    read -p "Wurde erfolgreich gelöscht."
    Intro
else
    read -p "Kontakte.txt nicht vorhanden."
    Intro
fi;;
*)Intro;;
esac
}

Kontakte_SQlite(){
if [ -e Kontakte.txt ]
then
sqlite3 kontakte.db << EOF
create table if not exists AlleKontakte (Nachname text, Vorname text, TelNr integer);
EOF

IFS=$'\n'

for user in $(cat Kontakte.txt)
do
f1=$(echo $user | cut -d$':' -f1)
f2=$(echo $user | cut -d$':' -f2)
f3=$(echo $user | cut -d$':' -f3)
sqlite3 kontakte.db << EOF
insert into AlleKontakte (Nachname, Vorname, TelNr) values ('$f1','$f2','$f3');
EOF
done
echo -e "\nErfolgreich übertragen."
read -p "Enter für weiter..."
Intro
else
echo; read -p "Kontakte.txt ist nicht vorhanden."
Intro
fi
}

Ausgabe_SQlite_DB(){
if [ -e kontakte.db ]
then
echo
sqlite3 kontakte.db << EOF
.header on
.mode column
select rowid,* from AlleKontakte;
EOF
echo; read -p "Enter für weiter..."
Intro
else
echo; read -p "Datenbank nicht vorhanden."
Intro
fi
}

Bearbeiten_DB(){
if [ -e kontakte.db ]
then
echo
sqlite3 kontakte.db << EOF
.header on
.mode column
select rowid,Nachname,Vorname,TelNr from AlleKontakte;
EOF
echo; read -p "Welcher Eintrag soll gelöscht werden (beenden mit 'q')? " dead
case $dead in
'q')Intro;;
*)sqlite3 kontakte.db << EOF
delete from AlleKontakte where rowid = '$dead';
vacuum;
EOF
echo; read -p "Weiterfahren?(y|n)" contin
if [ $contin = 'y' ]
then
    Bearbeiten_DB
else
    echo; read -p "Enter für weiter..."
    Intro
fi;;
esac
else
echo; read -p "Datenbank nicht vorhanden."
Intro
fi
}

Intro(){
clear
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
printf "\nWillkommen zur KontaktAufnahme mit SQlite eingabe\n"
printf "\n1. Kontakt in .txt aufnehmen\n2. Kontakt.txt löschen\n3. Kontakte in SQlite übertragen\n4. SQlite Datenbank wiedergeben\n5. SQlite Datenbank Eintrag löschen\n\n"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
Auswahl
}

Intro
