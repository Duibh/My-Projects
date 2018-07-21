#!/bin/bash
#Grades CsBe

Intro(){
clear
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo "Grade Input CsBe"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
printf "1. Input Grades\n2. Output Grades\n3. Backup\n4. Search Grade\n"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
Menu
}

Menu(){
read -p "Choose your option: " choice
case "$choice" in
    1)Input;;
    2)Output;;
    3)Backup;;
    4)SearchModule;;
    "exit")clear
    echo Good Bye;;
    *)read -p "Ivalid Input!"
    Intro;;
esac
}

Input(){
read -p "Modul: " modul
read -p "First Grade: " gradeOne
read -p "Weight: " weightFirst
read -p "Second Grade: " gradeTwo
read -p "Weight: " weightSecond
weightedGradeOne=$(bc<<<"scale=1; $gradeOne*$weightFirst")
weightedGradeTwo=$(bc<<<"scale=1; $gradeTwo*$weightSecond")
average=$(bc<<<"scale=1; $weightedGradeOne+$weightedGradeTwo")

sqlite3 grades.db << EOF
create table if not exists GradesCsbe (Module integer, FirstGrade real, SecondGrade real, Average real);
insert into GradesCsbe (Module, FirstGrade, SecondGrade, Average) values ("$modul", "$gradeOne", "$gradeTwo", "$average");
EOF
echo; read -p "Continue with random key..."
Intro
}

Output(){
echo
sqlite3 grades.db << EOF
.header on
.mode column
select * from GradesCsbe order by Module asc;
EOF
echo; read -p "Contiue with random key..."
Intro
}

Backup(){
date=$(date +%d%m%y)
echo
sqlite3 grades.db << EOF
.output $date.txt
select * from GradesCsbe;
EOF
read -p "Continue with random key..."
Intro
}

SearchModule(){
echo
sqlite3 grades.db << EOF
select Module from GradesCsbe;
EOF
echo; read -p "Which Module? " choice; echo
sqlite3 grades.db << EOF
.header on
.mode column
select Average from GradesCsbe where Module = $choice;
EOF
echo; read -p "Continue with random key..."
Intro
}
Intro
