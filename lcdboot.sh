#!/bin/sh

pinScreen=7

# Petit message de bienvenue ... mais apparemment ... nous n'avons pas encore l'IP
/my_scripts/lcd/pcd8544 -p "Helloooo!      RaspTools     Demarre    Merci   de   patienter =)"

# init  de la broche permettant la gestion de l'affichage
/usr/local/bin/gpio mode $pinScreen out

# On fait clignoter l'écran.
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1

# On le laisse allumé 30s
# /etc/lcd/screen -i
sleep 10s
/my_scripts/lcd/pcd8544 -i

# dans le cas ou l'IP n'apparaitrait pas encore ... et bien on refait la manip
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 10s

# On le laisse allumé 30s en affichant l'IP ... si on l'a récup...!
/my_scripts/lcd/pcd8544 -m 1
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1
sleep 0.5s
/usr/local/bin/gpio write $pinScreen 0
sleep 0.2s
/usr/local/bin/gpio write $pinScreen 1

sh /my_scripts/lcd/lcdmenu.sh


