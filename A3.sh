#!/bin/bash
export backup_count=0
sour=$1
backup=$2
ext=$3
if [ ! -d "$backup" ];then
  mkdir "$backup"
  if [ $? -ne 0 ] ; then
  echo "wrong"
  exit 1
  fi
fi

if [ $# -ne 3 ]; then
   echo " wrong input "
   fi
   
files=("$sour"/*"$ext")

if [ ! -e "${files[0]}" ]; then
   echo "no files"
   fi
size=0


for i in "${files[@]}"
do
   echo "$i"
   done

for i in "${files[@]}"
do
file=$(basename "$i" )
s=$(stat -c %s "$i")
dest="$backup"/"$file"
if [ ! -e "$dest" ]; then
  cp "$i" "$dest"
else
  
  if [ "$i" -nt "$dest" ]; then
  cp "$i" "$dest"
  fi
fi
backup_count=$((backup_count+1))
size=$((size+s))
done

report="$backup"/"backup_report.log"

{
echo "the total files is $backup_count "
echo "the size is $size"
} > "$report"



  
  

