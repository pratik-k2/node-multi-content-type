#!/bin/bash
NONE='\033[00m'
GREEN='\033[01;32m'
RED='\033[01;31m'
BLUE='\033[0;34m'

for ((i=1;i<=30;i++));
do
   response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/)
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

#Curl1 Pass None application/xml
curl --location --request GET 'localhost:8000/application/xml' \
--header 'Content-Type: application/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli>{"type":"fairy"}</nosqli>
    <sqli>{"email": "admin", "password": "admin"}</sqli>
	<xpath>{"username": "admin", "password": "xpath"}</xpath>
</data>'

#Curl2 Pass None application/xml 
curl --location 'localhost:8000/application/xml' \
--header 'Content-Type: application/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli>{"type":"fairy"}</nosqli>
    <sqli>{"email": "admin", "password": "admin"}</sqli>
	<xpath>{"username": "admin", "password": "xpath"}</xpath>
</data>'

#Curl4 Pass None text/xml
curl --location --request GET 'localhost:8000/application/xml' \
--header 'Content-Type: text/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli>{"type":"fairy"}</nosqli>
    <sqli>{"email": "admin", "password": "admin"}</sqli>
	<xpath>{"username": "admin", "password": "xpath"}</xpath>
</data>'

#Curl5 Pass None text/xml
curl --location 'localhost:8000/application/xml' \
--header 'Content-Type: text/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli>{"type":"fairy"}</nosqli>
    <sqli>{"email": "admin", "password": "admin"}</sqli>
	<xpath>{"username": "admin", "password": "xpath"}</xpath>
</data>'

#Curl7 Pass None application/json
curl --location --request GET 'localhost:8000/application/json' \
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

#Curl8 Pass None application/json
curl --location 'localhost:8000/application/json' \
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

#Curl9 Pass None application/urlencode
curl --location --request GET 'localhost:8000/application/urlencoded' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'filename=sample.js' \
--data-urlencode 'script=test' \
--data-urlencode 'username=test' \
--data-urlencode 'url=http://google.com' \
--data-urlencode 'cmd=google.com' \
--data-urlencode 'nosqli={"type":"fairy"}' \
--data-urlencode 'sqli={"email": "admin", "password": "admin"}' \
--data-urlencode 'xpath={"username": "admin", "password": "xpath"}'

#Curl10 Pass None application/urlencode
curl --location 'localhost:8000/application/urlencoded' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'filename=sample.js' \
--data-urlencode 'script=test' \
--data-urlencode 'username=test' \
--data-urlencode 'url=http://google.com' \
--data-urlencode 'cmd=google.com' \
--data-urlencode 'nosqli={"type":"fairy"}' \
--data-urlencode 'sqli={"email": "admin", "password": "admin"}' \
--data-urlencode 'xpath={"username": "admin", "password": "xpath"}'

#Curl11 Pass None multipart/form-data
curl --location --request GET 'localhost:8000/multipart/formdata' \
--header 'Content-Type: multipart/form-data' \
--form 'filename="sample.js"' \
--form 'script="test"' \
--form 'username="test"' \
--form 'url="http://google.com"' \
--form 'cmd="google.com"' \
--form 'nosqli="{\"type\":\"fairy\"}"' \
--form 'sqli="{\"email\": \"admin\", \"password\": \"admin\"}"' \
--form 'xpath="{\"username\": \"admin\", \"password\": \"xpath\"}"'

#Curl12 Pass None multipart/form-data
curl --location 'localhost:8000/multipart/formdata' \
--header 'Content-Type: multipart/form-data' \
--form 'filename="sample.js"' \
--form 'script="test"' \
--form 'username="test"' \
--form 'url="http://google.com"' \
--form 'cmd="google.com"' \
--form 'nosqli="{\"type\":\"fairy\"}"' \
--form 'sqli="{\"email\": \"admin\", \"password\": \"admin\"}"' \
--form 'xpath="{\"username\": \"admin\", \"password\": \"xpath\"}"'

#Curl13 Pass None application/octet-stream 
curl --location --request GET 'localhost:8000/application/octet-stream' \
--header 'Content-Type: application/octet-stream' \
--data '@batman.png'

#Curl14 Pass None application/octet-stream
curl --location 'localhost:8000/application/octet-stream' \
--header 'Content-Type: application/octet-stream' \
--data '@batman.png'

#Curl15 Pass None image/png
curl --location --request GET 'localhost:8000/image/png' \
--header 'Content-Type: image/png' \
--data '@batman.png'

#Curl16 Pass None image/png
curl --location 'localhost:8000/image/png' \
--header 'Content-Type: image/png' \
--data '@batman.png'

#Curl17 Pass None text/plain
curl --location --request GET 'localhost:8000/text/plain' \
--header 'Content-Type: text/plain' \
--data 'test'

#Curl18 Pass None text/plain
curl --location 'localhost:8000/text/plain' \
--header 'Content-Type: text/plain' \
--data 'Test'
fi



# #Curl3 Attack application/xml 
# curl --location 'localhost:8000/application/xml' \
# --header 'Content-Type: application/xml' \
# --data '<?xml version="1.0" encoding="UTF-8" ?>
# <data>
# 	<filename>../../etc/passwd</filename>
# 	<script>%3Cscript%3Ealert(%22Hacked%22)%3C/script%3E</script>
# 	<username>*)(uid=*</username>
# 	<url>http://google.com</url>
# 	<cmd>google.com;ls</cmd>
# 	<nosqli>{"type":{"$gte":""}}</nosqli>
#     <sqli>{"email": "admin'\'' OR '\''1'\''='\''1", "password": "--"}</sqli>
# 	<xpath>{"username": "'\'' or '\''1'\''='\''1", "password": "'\'' or '\''1'\''='\''1"}</xpath>
# </data>'

# #Curl6 Attack text/xml
# curl --location 'localhost:8000/application/xml' \
# --header 'Content-Type: text/xml' \
# --data '<?xml version="1.0" encoding="UTF-8" ?>
# <data>
# 	<filename>../../etc/passwd</filename>
# 	<script>%3Cscript%3Ealert(%22Hacked%22)%3C/script%3E</script>
# 	<username>*)(uid=*</username>
# 	<url>http://google.com</url>
# 	<cmd>google.com;ls</cmd>
# 	<nosqli>{"type":{"$gte":""}}</nosqli>
#     <sqli>{"email": "admin'\'' OR '\''1'\''='\''1", "password": "--"}</sqli>
# 	<xpath>{"username": "'\'' or '\''1'\''='\''1", "password": "'\'' or '\''1'\''='\''1"}</xpath>
# </data>'