#!/bin/bash
#FastJavaC (20150326) by Syneart
which javxa && clear || (clear && echo "Error: 請先下載安裝 Java SE Development Kit (JDK)" && exit 0)
while [ true ]; do  
case $1 in
	*.java) break;;
	*) clear; echo -n "Error: 請將 *.Java 拖曳至本腳本當參數"; exit 0;
esac
done
FILE_TEMP_PATH=/tmp/fastJavaTmp
WILL_CLOSE=true &&COMPILED_RIGHT=false &&MAINFUNCTION=*
while [[ "${COMPILED_RIGHT}" == "false" ]]; do
	clear &&COMPILED_RIGHT=true
	PACKAGE_PATH=`grep "^package " "$1" | sed -e "s/package//g;s/;/\/Syneart/g;s/\./\//g;s/ //g"`
	PACKAGE_PATH=$([ -z ${PACKAGE_PATH} ] && echo "" || echo $(dirname ${PACKAGE_PATH})"/")$(basename ${1%.*})
	mkdir $FILE_TEMP_PATH >/dev/null 2>&1
	rm $FILE_TEMP_PATH/$PACKAGE_PATH.class >/dev/null 2>&1
	echo ">> $(basename ${1%.*}) 檔案編譯中, 請稍後 ..."
	grep -q "void main" "$1" && MAINFUNCTION=$(basename ${1%.*})
	cd $(dirname "$1")
	#javac -encoding MS950 $MAINFUNCTION.java -d $FILE_TEMP_PATH
	javac $MAINFUNCTION.java -d $FILE_TEMP_PATH
	if [ ! -f ${FILE_TEMP_PATH}/$PACKAGE_PATH.class ]; then 
		echo -n ">> 請修正以上錯誤 !! 並按 Enter 鍵重新編譯 ..." &&read &&COMPILED_RIGHT=false
	fi
done
grep -q "arg.*[0-9]" "$1" && clear && echo "您所拖曳的 Java 程式需要輸入參數，請輸入參數 :"&&read argument
grep -E -q "(.awk|.swing)" "$1" && WILL_CLOSE=false
echo ">> 執行 $(basename ${1%.*}) ..." && $WILL_CLOSE && clear
cd $FILE_TEMP_PATH
java $PACKAGE_PATH $argument
$WILL_CLOSE && echo -n ">> 執行完畢，按任意鍵結束程式 ... " &&read
