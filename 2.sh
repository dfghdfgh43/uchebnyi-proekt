#!/bit/bash

# Задание
# Написать bash скрипт анализа размера каждой директории и
# файла в текущей директории с выводом результатов в терминал,
# используя функции и циклы.

# Дополнение 1
# Добавить сортировку по уменьшению размера;


# Получение имени каталога
getNameDir() {
	dirName=${1%/}
	echo "$dirName"
}

# Получение размера каталога
getSizeDir() {
	du -sh "$1" --bytes | cut -f1
}

# Получение размера файла
getSizeFile() {
	du -h "$1" --bytes| cut -f1
}

# Занесение данных в файл
# $1 - Файл, в который заносятся данные
# $2 - Размер файла
# $3 - Путь
postFileInfo() {
	if [ "$1" == "k" ]; then
		echo "$2 $3" >> tmpKatalog.txt
	elif [ "$1" == "f" ]; then
		echo "$2 $3" >> tmpFile.txt
	fi
}

convByteToHum() {
	bytes=$1
	
	if [ $bytes -lt 1024 ]; then
    	echo "${bytes} bytes"
	elif [ $bytes -lt 1048576 ]; then
		echo "$(echo "scale=2; $bytes / 1024" | bc) KB"
	elif [ $bytes -lt 1073741824 ]; then
		echo "$(echo "scale=2; $bytes / 1048576" | bc) MB"
	else
		echo "$(echo "scale=2; $bytes / 1073741824" | bc) GB"
	fi
}

# Сортировка и вывод значений
printSortFile() {
	# Сортировка каталогов по размеру
	sort -nr -k1 tmpKatalog.txt > tmpSortKatalog.txt
	# Сортировка файлов по размеру
	sort -nr -k1 tmpFile.txt > tmpSortFile.txt


	file="tmpSortKatalog.txt"
	
	while IFS=" " read -r value1 value2 remainder; do
		echo "Каталог: $value2 $remainder"
		echo "Размер: $(convByteToHum $value1)"
		echo "---------------------------"
	done < "$file"


	file="tmpSortFile.txt"

	while IFS=" " read -r value1 value2 remainder; do
		echo "Файл: $value2 $remainder"
		echo "Размер: $(convByteToHum $value1)"
		echo "---------------------------"
	done < "$file"
}

# Вывод размера и файлов в текущем каталоге
printSizeAndDir() {
	for dir in */; do
		# Имя каталога
		dirName=$(getNameDir "$dir")
		# Размер каталога
		dirSize=$(getSizeDir "$dir")
		
		postFileInfo "k" "$dirSize" "$dir"
	done

	for file in *; do
		# Имя файла
		fileName="$file"
		# Размер файла
		fileSize=$(getSizeFile "$file")

		if [ -f "$file" ]; then
			postFileInfo "f" "$fileSize" "$file"
		fi
	done

	printSortFile

	# Удаление временных файлов
	rm tmpKatalog.txt
	rm tmpSortKatalog.txt
	rm tmpFile.txt
	rm tmpSortFile.txt
}

# Выполнение
printSizeAndDir