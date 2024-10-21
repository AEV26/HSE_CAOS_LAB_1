#!/bin/bash

# Переданный путь
WAY=$1

# Процент максимальной заполненности папки
MAXPCENT=$2

# Проверяем, что переданная папка существует
if [ -d "$WAY" ]

then

	# Проверка существования папки BACKUP
	if [ -d "/BACKUP" ]
	
	then
	
		# Фактический процент заполненности переданной папки
		PCENT=$((`df -k $WAY | tail -1 | awk '{print $5}' | cut -d '%' -f 1`))
			
		# Проверка заполнености папки
		if [ $PCENT -gt $MAXPCENT ]
	
		then
		
			# Заходим в указанную папку
			cd $WAY
					
			# Количество файлов в указанной папке
			COUNT=$((`ls | wc -l`))
		
			echo "Input max number of files:"
		
			# Необходимо ввести максимальное количество файлов
			read N
		
			# Проверка количества файлов в указанной папке
			if [ $COUNT -gt $N ]
		
			then
			
				# Создаем список последних N файлов
				LIST=$(ls -t | head -n $N)
			
			else
		
				# Создаем список всех файлов
				LIST=$(ls -t | head -n $COUNT)
		
			fi
		
			# Создание архива файлов переданной папки
			sudo tar -zcf LOG.tar.gz $LIST
		
			# Перемещение архива из исходной папки в BACKUP
			sudo mv $WAY/LOG.tar.gz /BACKUP
		
			cd $WAY
			
			# Удаление файлов из исходной папки
			sudo rm $LIST
			
			# Сообщаем, что утилита закончила работу
			echo "Work is done."
		
		else
		
			# Сообщаем пользователю, если процент занятости папки 
			# не превышает максимальный введеный
			echo "Use percent is $PCENT%, so it's OK."
		
		fi
	
	else 
	
		# Выдает ошибку, если папки /BACKUP не существует
		echo "Error: /BACKUP dosen't exist."
	
	fi

else 

# Если указанной папки не существует, то выводим уведомление
echo "This folder don't exist."

fi
