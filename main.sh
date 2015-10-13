#your_str='1a){}: tosooso'
#echo $your_str | cut -d ":" -f1

function create_dirs {
	maindir='project'
	libdir=./$maindir/libs
	confdir=./$maindir/conf
	mkdir ./$maindir
	mkdir ./$maindir/conf
	mkdir ./$maindir/libs
}

function create_messages {
	echo '#!/bin/bash'			>>$libdir/messages.sh
	echo 'message[0]="Fail."'		>>$libdir/messages.sh
}

function start_b {
	echo '#! /bin/bash'			>> $maindir/start.sh
	echo 'source ./libs/messages.sh'	>> $maindir/start.sh
}

function start_e {
	echo 'sub1'				>> $maindir/start.sh
}

function fill { # 1 - name of the menu 2 - menu array string 
	x=$2
	i=0
	y=('')
	menucount=1
	while [ $i -lt ${#x} ]; do y[$i]=${x:$i:1};  i=$((i+1));done
	size=${#y[@]}
	size=$((size-1))
#	subnum=$((size-1))
#	echo ${y[@]}
#	echo $[y[$subnum]]
	#echo "size"$size
	echo 'function '$1'_menu {'				>> $libdir/$1_menu.sh
	echo 'clear'						>> $libdir/$1_menu.sh
	echo ' echo -e "\x1B[36m[ MAIN ]"'			>> $libdir/$1_menu.sh
	echo 'source ./libs/'$1'_menu.sh'			>> $maindir/start.sh
	echo 'source ./libs/'$1'_sub.sh'			>> $maindir/start.sh
	echo '#! /bin/bash'					>> $libdir/$1_sub.sh
	echo 'function sub'$1' {'				>> $libdir/$1_sub.sh
	echo 'clear'						>> $libdir/$1_sub.sh
	echo $1'_menu'						>> $libdir/$1_sub.sh
	echo ''							>> $libdir/$1_sub.sh
	echo 'while true; do'					>> $libdir/$1_sub.sh
	echo ' read n'						>> $libdir/$1_sub.sh
	echo ' case $n in'					>> $libdir/$1_sub.sh

	for i in $(seq 0 $size)
	do
		if [ "${y[$i]}" == ":" ];then
			subnum=$((i-1))
			subbackcount=$((i-2))
			prom_count=${#prom}
			prom_count=$((prom_count-2))
			prom1=${prom:0:$prom_count}
			echo ' echo "'$menucount' - '$prom1'"'	>> $libdir/$1_menu.sh
			echo '	'$menucount')'			>> $libdir/$1_sub.sh
			echo '		sub'${y[$subnum]}	>> $libdir/$1_sub.sh
			echo '	 ;;'				>> $libdir/$1_sub.sh
			prom=''
			prom1=''
			menucount=$((menucount+1))
		else
			prom=$prom${y[$i]}
		fi
	done
	echo ' echo "0 - Back"'					>> $libdir/$1_menu.sh
	echo ' echo -e "\x1B[0m"'				>> $libdir/$1_menu.sh
	echo '}'						>> $libdir/$1_menu.sh


	echo '	0)'						>> $libdir/$1_sub.sh
	echo '		'${y[$subbackcount]}'_menu'		>> $libdir/$1_sub.sh
	echo '		break'					>> $libdir/$1_sub.sh
	echo '	 ;;'						>> $libdir/$1_sub.sh
	echo '	*)'						>> $libdir/$1_sub.sh
	echo '		echo ${message[0]}'			>> $libdir/$1_sub.sh
	echo '	 ;;'						>> $libdir/$1_sub.sh
	echo ' esac   '						>> $libdir/$1_sub.sh
	echo 'done'						>> $libdir/$1_sub.sh
	echo '}'						>> $libdir/$1_sub.sh


	################# Functions ######################


}

function arr_init {
	for i in $(seq 1 $1)
	do
		arr=("${arr[@]}" "")		
		arr=("${arr_num[@]}" "")		
	done
}

function arr_fill {
# Generating menus array
	while read -r line
	do
		str_attr=$(echo $line | cut -d ":" -f1)
		str_value=$(echo $line | cut -d ":" -f2)
		tblnum=${str_attr:0:1}
		str_sub=${str_attr: -2:1}
		str_sub_back=${str_attr: -3:1}
		echo "STRING=$str_attr sub="$str_sub" back="$str_sub_back
		arr[$tblnum]=${arr[$tblnum]}$str_value$str_sub_back$str_sub":"
		arr_num[$tblnum]=$tblnum
	
	done < "$filename"
}

##################################   MAIN PROGRAM STARTS HERE ##################

# Inint variables
arr=('first')
arr_num=('0')
size=5
arr_init $size
filename="tpl"
arr_fill
#echo ${arr[@]}
create_dirs
create_messages
start_b
arrsize=${#arr[@]}
arrsize=$((arrsize-1))
for j in $(seq 1 $arrsize)
do
	fill ${arr_num[$j]} "${arr[$j]}"
done
start_e

