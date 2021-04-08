#!/bin/bash -x

# Say the current local ip

(
echo NICK bot
echo USER bot 8 * 
sleep 1.5
# echo 'JOIN #netops'
echo 'JOIN #general'
#echo 'PRIVMSG learnin' # argument here

while :
do
  echo 'PRIVMSG #general' $(date): $(echo "$(ip a)" | grep -Po '(?!(inet 127.\d.\d.1))(inet \K(\d{1,3}\.){3}\d{1,3})')
  sleep 60

  for i in {0..3}
    do
      echo 'PRIVMSG #general' .
      sleep 60
    done

done

#echo QUIT
) | nc desktop 6667 # server and ip
