#!/bin/bash
res=0
memleak="FAIL"
race="FAIL"
cd $1
make
if [ $? -eq 0 ]
then
  comp="PASS"
  valgrind --leak-check=full --error-exitcode=55 ./$2
  if [ $? -eq 0 ]
  then
      memleak="PASS"
  else    
      res=$(($res+2))
  fi
  valgrind --tool=helgrind --error-exitcode=55 ./$2
  if [ $? -eq 0 ]
  then
      race="PASS"
  else
      res=$(($res+1))
  fi
else
  res=$(($res+4))
  comp="FAIL"
fi

echo -e "Compilation‬‬\tMemory‬ leaks\tthread race"
echo -e "$comp\t\t$memleak\t\t$race"
exit $res
