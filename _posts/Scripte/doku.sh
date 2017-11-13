#!/bin/bash

#Pull das git Repository mit der Doku des Clustersystems

path=""
url= "https://github.com/traendy/BigDataWS17.git"
cd $path

if [test -w BigDataWS17]
 then 
  cd BigDataWS17
  git pull origin master
 else
  git clone $url
fi

