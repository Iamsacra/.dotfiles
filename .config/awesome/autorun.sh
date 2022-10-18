#!/bin/sh

apps='cbatticon nm-applet'

for app in $apps 
 do
   if pgrep -x $app > /dev/null
   then
     echo "Running"
   else
     $app &
   fi
done
