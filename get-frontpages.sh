#!/bin/bash
echo "***** This utility downloads all files of a certain type from a webpage ****";
echo "(Copyleft) Dimitris Kalamaras"
echo " "

# Εδώ ορίζουμε την ημερομηνία για τα πρωτοσέλιδα που θέλουμε να κατεβάσουμε
echo "enter date (ie. 2011-08-18)";
read DATE;

# Εδώ ορίζουμε τη διεύθυνση της ιστοσελίδας από όπου θα κατεβάζουμε τα πρωτοσέλιδά μας
url="http://news247.gr/newspapers/Afternoon/?dtmDate=$DATE"

# Εδώ ορίζουμε τα strings με τα οποία γίνεται η αναζήτηση των εφημερίδων στην ιστοσελίδα
#efimerides='dimokratia\|ta_nea\|to_ethnos\|eleftherotypia\|eleftheros_typos\|adesmeftos_typos'
efimerides='dimokratia\|ta_nea';

echo "Δημιουργία λίστας με τις διευθύνσεις των ιστοσελίδων που περιέχουν τις εικόνες των εφημερίδων ...";
lynx -dump $url | grep $efimerides  | awk '{print $2}' > urllist.txt

# Δημιουργούμε το φάκελο όπου θα αποθηκεύονται οι εικόνες
directory=$DATE
str='src="'
echo "Παρακαλώ περιμένετε όσο κατεβάζω τις εικόνες των εφημερίδων...";
if [ -d $directory ]; then
 mv urllist.txt  $directory/;
 cd $directory;
else 
 mkdir $directory;
 mv urllist.txt  $directory/;
 cd  $directory;
fi

i=1;
for x in $(cat urllist.txt) ; do 
	# Από τα links που υπάρχουν στις ιστοσελίδες κατεβάζουμε μόνο όσα αφορούν:
        # - εικόνες JPEG και έχουν το μοτίβο 600
	# Μετά κάνουμε split το string στο 'src="'
	# Και από το αποτέλεσμα κρατάμε πάλι μόνο ότι είναι εικόνα JPEG
	url_list[$i]=`wget --quiet  $x -O - | grep "jpg"  | grep "600" | sed -e 's/'"$str"'/\n/g' | grep "jpg" | cut -d'"' -f1 ` ;
	echo $i ${url_list[$i]};
	i=$[i+1];
done

echo "Οι διεθύνσεις:"
for (( x=1; x<$i; x++ )); do
	if [[ ${url_list[$x]} == ${ta_nea} ]] ; then
		echo $x ${url_list[$x]};
	fi
done


