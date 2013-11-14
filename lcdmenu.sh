#!/bin/bash

#PIN des boutons
bt_h=11
bt_b=1
bt_g=5
bt_d=10

# N° Menu
menu=1

# N° Ligne
ligne=1
minligne=1
maxligne=5

# Lumière
light=1


DATE='/bin/date'
BEFORE=$($DATE +'%s')
MAX_TIME=10




setup ()
{
	init_bouton
}

init_bouton ()
{
 # echo "Init des boutons"
 /usr/local/bin/gpio mode $bt_h out
 /usr/local/bin/gpio mode $bt_b out
 /usr/local/bin/gpio mode $bt_g out
 /usr/local/bin/gpio mode $bt_d out
 
 /usr/local/bin/gpio write $bt_h 0
 /usr/local/bin/gpio write $bt_b 0
 /usr/local/bin/gpio write $bt_g 0
 /usr/local/bin/gpio write $bt_d 0
 
 /usr/local/bin/gpio mode $bt_h in
 /usr/local/bin/gpio mode $bt_b in
 /usr/local/bin/gpio mode $bt_g in
 /usr/local/bin/gpio mode $bt_d in
}

enter_menu ()
{
	#ACCUEIL
	if [ $menu = 1 ]
	then
		#CONTRASTE
		if [ $ligne = 1 ]
		then
			menu=2
			ligne=1
			minligne=1
			maxligne=1
			/my_scripts/lcd/pcd8544 -m $menu $ligne
		#LIGHT
		else if [ $ligne = 2 ]
		then
			if [ $light = 0 ] 
			then
				sh /my_scripts/lcd/lcdon.sh
				light=1
			else
				sh /my_scripts/lcd/lcdoff.sh
				light=0
			fi
		#IP
		else if [ $ligne = 3 ]
		then
			/my_scripts/lcd/pcd8544 -i
		#SCRIPTS
		else if [ $ligne = 4 ]
		then
			menu=3
			maxligne=1
		#QUIT
		else if [ $ligne = 5 ]
		then
			menu=4
			maxligne=2
			ligne=1
			/my_scripts/lcd/pcd8544 -m $menu $ligne
		fi
		fi
		fi
		fi
		fi
	else if [ $menu = 4 ]
	then
		if [ $ligne = 1 ]
		then
			reboot
		else if [ $ligne = 2 ]
		then
			halt
		fi
		fi
	fi
	fi
}

attBouton ()
{
 echo -n "Attente Bouton ... "
 
 quit=0;
  while [ $quit = 0 ]; do
	# if [`/usr/local/bin/gpio read $bt_h` = 1] 
	# then
		# quit=$bt_h
	# else if [`/usr/local/bin/gpio read $bt_b` = 1] 
	# then
		# quit=$bt_b
	# else if [`/usr/local/bin/gpio read $bt_g` = 1]
	# then
		# quit=$bt_g
	# else if [`/usr/local/bin/gpio read $bt_d` = 1] 
	# then
		# quit=$bt_d
	# fi
	# fi
	# fi
	# fi
	
	while [ `/usr/local/bin/gpio read $bt_h` = 1 ]; do
		sleep 0.1
		quit=$bt_h
		init_bouton
		sleep 0.1
	done
	while [ `/usr/local/bin/gpio read $bt_b` = 1 ]; do
		sleep 0.1
		quit=$bt_b
		init_bouton
		sleep 0.1
	done
	while [ `/usr/local/bin/gpio read $bt_g` = 1 ]; do
		sleep 0.1
		quit=$bt_g
		init_bouton
		sleep 0.1
	done
	while [ `/usr/local/bin/gpio read $bt_d` = 1 ]; do
		sleep 0.1
		quit=$bt_d
		init_bouton
		sleep 0.1
	done
	
	AFTER=$($DATE +'%s')
	ELAPSED=`expr $AFTER - $BEFORE`
 
	#if [ "$ELAPSED" -gt "$MAX_TIME" ]
	if [ $ELAPSED = $MAX_TIME ]
	then
		echo "Extinction LCD"
		/my_scripts/lcd/lcdoff.sh
	fi
 done
 # echo "Got it"
 
 DATE='/bin/date'
 BEFORE=$($DATE +'%s')
 /my_scripts/lcd/lcdon.sh
	

 return "$quit"
}

setup
/my_scripts/lcd/pcd8544 -m 1 1	
/my_scripts/lcd/lcdon.sh

while true; do
 attBouton
 retval=$?
 
	#HAUT
 	if [ $retval = $bt_h ]
	then
		if [ $ligne = $minligne ]
		then
			ligne=$maxligne
		else
			ligne=`expr $ligne - 1`
		fi
		echo "Haut"
		
		# Si menu CONTRASTE
		if [ $menu = 2 ]
		then
			# contrast=`cat /my_scripts/lcd/contrast.conf`
			#contrast=`hexdump /my_scripts/lcd/contrast.conf`
			# contrast=`expr $contrast + 2`
			#contrast=$(($contrast + 1))
			# /my_scripts/lcd/contrast.conf < echo $contrast
			#echo $contrast > /my_scripts/lcd/contrast.conf 
			
			voppp=1
			/my_scripts/lcd/pcd8544 -m $menu $ligne $voppp
		else	
			/my_scripts/lcd/pcd8544 -m $menu $ligne
		fi
		
		

	#BAS
	else if [ $retval = $bt_b ]
	then
		if [ $ligne = $maxligne ]
		then
			ligne=$minligne
		else
			ligne=`expr $ligne + 1`
		fi
		echo "Bas"
		
		# Si menu CONTRASTE
		if [ $menu = 2 ]
		then
			# contrast=`cat /my_scripts/lcd/contrast.conf`
			#contrast=`hexdump /my_scripts/lcd/contrast.conf`
			#echo -n "Contrast Init "
			#echo $contrast
			# contrast=`expr $contrast + 2`
			#contrast=$(($contrast + 1))
			#echo -n "Contrast Apres "
			#echo $contrast
			#echo $contrast > /my_scripts/lcd/contrast.conf 
			
			vopmm=0
			/my_scripts/lcd/pcd8544 -m $menu $ligne $vopmm
		else	
			/my_scripts/lcd/pcd8544 -m $menu $ligne
		fi
		
	#GAUCHE
	else if [ $retval = $bt_g ]
	then
		# Depuis l'accueil
		if [ $menu = 1 ]
		then
			ligne=5 # pour quitter?
			
		# Depuis Contrast
		else if [ $menu = 2 ]
		then
			menu=1
			ligne=2
			maxligne=5
			
		# Depuis le menu de reboot
		else if [ $menu = 4 ]
		then
			menu=1
			ligne=5
			maxligne=5
		fi
		fi
		fi
		/my_scripts/lcd/pcd8544 -m $menu $ligne	
		echo "Gauche"
		
	#DROITE
	else if [ $retval = $bt_d ]
	then
		enter_menu
		echo "Droite"
		
	#DEFAUT
	else
		echo "Touche Inconnue"
	fi
	fi
	fi
	fi
	
	echo $ligne

done
return "$retval"
