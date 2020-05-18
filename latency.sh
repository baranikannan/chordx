#!/bin/bash
#Network Delay using Linux Traffic Control command
#Script requires tc command, if not present install iproute package
#Reference: https://netbeez.net/blog/how-to-use-the-linux-traffic-control/
#			https://www.cs.unm.edu/~crandall/netsfall13/TCtutorial.pdf	

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


if ! [ -x "$(command -v tc)" ]; then
  echo 'Error: tc command is not present, please install iproute' >&2
  exit 1
fi
pri=$(route | grep '^default' | grep -o '[^ ]*$')

echo "$pri" "is primary interface"

echo "Existing settings of $pri"
echo 
tc qdisc show dev "$pri"
echo 
echo 


read -r -p "By Proceeding above existing rules will be removed. Continue? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo "Proceed"
        ;;
    *)
        exit 1
        ;;
esac


PS3='Please enter your choice: '
options=("Low 100ms Delays" "Medium 500ms Delays" "High 1000ms Delays" "Custom input" "Clear all Rules" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Low 100ms Delays")
            echo "you chose choice 100ms"
            tc qdisc del dev "$pri" root > /dev/null 2>&1
            tc qdisc add dev "$pri" root netem delay 100ms
            tc qdisc show dev "$pri"
            exit
            ;;
        "Medium 500ms Delays")
            echo "you chose choice 500ms"
            tc qdisc del dev "$pri" root > /dev/null 2>&1
            tc qdisc add dev "$pri" root netem delay 500ms
            tc qdisc show dev "$pri"
            exit
            ;;
        "High 1000ms Delays")
            echo "you chose choice 1000ms"
            tc qdisc del dev "$pri" root > /dev/null 2>&1
            tc qdisc add dev "$pri" root netem delay 1000ms
            tc qdisc show dev "$pri"
            exit
            ;;
        "Custom input")
            read -r -p "Enter your choice in number only: " choice
            re='^[0-9]+$'
            if ! [[ $choice =~ $re ]] ; then
   				echo "error: Not a number" >&2; exit 1
			fi
            tc qdisc del dev "$pri" root > /dev/null 2>&1
            tc qdisc add dev "$pri" root netem delay "$choice""ms"
            tc qdisc show dev "$pri"
            exit
            ;;
        "Clear all Rules")
            echo "Cleared existing rule for delay"
            tc qdisc del dev "$pri" root > /dev/null 2>&1
            tc qdisc show dev "$pri"
            exit
            ;;
        "Quit")
        	echo "No Changes made"
        	tc qdisc show dev "$pri"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


