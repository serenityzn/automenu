#! /bin/bash
function sub1 {
2_menu

while true; do
 read n
 case $n in
	1)
		echo 1
	 ;;
	2)
		echo 2
	 ;;
	3)
		echo 3
	 ;;
	0)
		1_menu
		break
	 ;;
	*)
		echo "fail"
	 ;;
 esac   
done
}

