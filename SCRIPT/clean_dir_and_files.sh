#!/bin/sh

logfile="./notwritable.log"
xuser=`whoami`

echo "***** [$0] start " `date +'%Y/%m/%d %H:%M:%S'` " *****"

while read LINE; do
  server=`echo ${LINE} | cut -d " " -f 1`
  pathname=`echo ${LINE} | cut -d " " -f 2`

  if [ ${server} = `hostname` ]; then
     if [ -e ${pathname} ]; then
       if [ -w ${pathname} ]; then
          rm -rf ${pathname}
          echo "${server} : ${pathname} was removed."
       else
          echo "${server} : ${pathname} was not writable by ${xuser}."
          echo "${server} ${xuser} ${pathname}" >> $logfile
       fi
      else
        if [ -d ${pathname} ]; then
          if [ -w ${pathname} ]; then
            rm -rf ${pathname}
            echo "${server} : ${pathname} was removed."
          else
            echo "${server} : ${pathname} was not writable."
            echo "${server} : ${pathname}" >> $logfile
          fi 
        else   
          echo "${server} : ${pathname} was not found."
        fi
      fi
  else
      echo "There was no ${pathname}."
  fi 
done

echo "***** [$0] end " `date +'%Y/%m/%d %H:%M:%S'` " *****"
