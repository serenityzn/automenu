#! /bin/bash
source 1_menu.sh
source 2_menu.sh
source sub1.sh

1_menu
while true; do
 read n
 case $n in
	1)
		sub1
	 ;;
	2)
		sub2
	 ;;
	3)
		sub3
	 ;;
	0)
		exit
	 ;;
	*)
		echo "fail"
	 ;;
 esac   
done

