#!/bin/bash
cd /home/semjaza/Desktop/infocom/ozmoo
ruby make.rb $@
rm temp1.d64 2&>/dev/null
#mv *.d64 ./disks/