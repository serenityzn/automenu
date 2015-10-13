#your_str='1a){}: tosooso'
#echo $your_str | cut -d ":" -f1

function start_b {
	echo '#! /bin/bash'			>> start.sh
}

function start_e {
	echo 'sub1'				>> start.sh
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

	echo 'source 1_menu.sh'					>> start.sh
	echo 'function '$1'_menu {'				>> $1_menu.sh
	echo 'clear'						>> $1_menu.sh
	echo ' echo -e "\x1B[36m[ MAIN ]"'			>> $1_menu.sh
	echo 'source '$1'_menu.sh'				>> start.sh
	echo 'source '$1'_sub.sh'				>> start.sh
	echo '#! /bin/bash'					>> $1_sub.sh
	echo 'function sub'$1' {'				>> $1_sub.sh
	echo 'clear'						>> $1_sub.sh
	echo $1'_menu'						>> $1_sub.sh
	echo ''							>> $1_sub.sh
	echo 'while true; do'					>> $1_sub.sh
	echo ' read n'						>> $1_sub.sh
	echo ' case $n in'					>> $1_sub.sh

	for i in $(seq 0 $size)
	do
		if [ "${y[$i]}" == ":" ];then
			subnum=$((i-1))
			subbackcount=$((i-2))
			prom_count=${#prom}
			prom_count=$((prom_count-2))
			prom1=${prom:0:$prom_count}
			echo ' echo "'$menucount' - '$prom1'"'	>> $1_menu.sh
			echo '	'$menucount')'			>> $1_sub.sh
			echo '		sub'${y[$subnum]}	>> $1_sub.sh
			echo '	 ;;'				>> $1_sub.sh
			prom=''
			prom1=''
			menucount=$((menucount+1))
		else
			prom=$prom${y[$i]}
		fi
	done
	echo ' echo "0 - Back"'					>> $1_menu.sh
	echo ' echo -e "\x1B[0m"'				>> $1_menu.sh
	echo '}'						>> $1_menu.sh


	echo '	0)'						>> $1_sub.sh
	echo '		'${y[$subbackcount]}'_menu'		>> $1_sub.sh
	echo '		break'					>> $1_sub.sh
	echo '	 ;;'						>> $1_sub.sh
	echo '	*)'						>> $1_sub.sh
	echo '		echo "fail"'				>> $1_sub.sh
	echo '	 ;;'						>> $1_sub.sh
	echo ' esac   '						>> $1_sub.sh
	echo 'done'						>> $1_sub.sh
	echo '}'						>> $1_sub.sh


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

start_b
arrsize=${#arr[@]}
arrsize=$((arrsize-1))
for j in $(seq 1 $arrsize)
do
	fill ${arr_num[$j]} "${arr[$j]}"
done
start_e

