#!/bin/bash
# from https://www.jamf.com/jamf-nation/discussions/24971/importing-departments-into-jamfpro-from-a-csv

#Declare variables
server="https://hamiltoncollege.jamfcloud.com:8443"
username=""                           #JSS username with API privileges
password=""                           #Password for the JSS account
file=""      #Path to CSV

#Do not modify below this line

#Variables used to create the XML
a="<department><name>"
b="</name></department>"

#Count the number of entries in the file so we know how many Departments to submit
count=$(cat -n ${file} | tail -n 1 | cut -f1 | xargs)

#Set a variable to start counting how many Departments we've submitted
index="0"

#Loop through the Department names and submit to the JSS until we've reached the end of the CSV
while [ $index -lt ${count} ] 
do
	#Increment our counter by 1 for each execution
	index=$[$index+1]

	#Set a variable to read the next entry in the CSV
	var=`cat ${file} | sed 's/&/&amp;/g'| awk -F, 'FNR == '$[$index]' {print $1}'`

	#Output the data and XML to a file
	echo "${a}""${var}""${b}" > /tmp/test.xml

	#Submit the data to the JSS via the API
	curl -k -v -u ${username}:${password} ${server}/JSSResource/departments/name/Name -T "/tmp/test.xml" -X POST
done

#Clean up the temporary XML file
rm /tmp/test.xml

exit 0