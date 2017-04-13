#!/bin/bash
# This simple script sends a Twitter message when it finds potential typosquatting


function check_domain {
 DOMAIN=$1
 cp dnstwist_$DOMAIN.txt.new dnstwist_$DOMAIN.txt.old
 python dnstwist.py -r $DOMAIN > dnstwist_$DOMAIN.txt.new
 sed -i '1,8d' dnstwist_$DOMAIN.txt.new
 diff dnstwist_$DOMAIN.txt.old dnstwist_$DOMAIN.txt.new > change_$DOMAIN.txt
 sed -i ':a;N;$!ba;s/\n/ /g' change_$DOMAIN.txt
 MESSAGE=`cat change_$DOMAIN.txt`

 if [ -s change_$DOMAIN.txt ];
 then
    /opt/tweet.sh dm $2 "Potential typosquatting alert for $DOMAIN. Details: $MESSAGE" &> /dev/null
 fi

 rm change_$DOMAIN.txt
}

while true
do
 # Add your domains' names here and your Twitter handle
 check_domain domain1.com @YourTwitterHandle
 check_domain domain2.com @YourTwitterHandle
 check_domain domainX.net @YourTwitterHandle


 echo -e "\nFinished at: $(date -u).\nWill sleep for 24h...\n"
# the script runs every 24h
sleep 86400
done
