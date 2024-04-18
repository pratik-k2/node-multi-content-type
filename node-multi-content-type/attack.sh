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

#$ Curl1 <data><filename>sample.js</filename><script>test</script><username>test</username><url>http://localhost:8000</url><cmd>google.com</cmd><nosqli><type>fairy</type></nosqli><sqli>admin</sqli><xpath>admin</xpath></data> Pass None
curl --location --request GET 'localhost:8000/application/xml' \
--header 'Content-Type: application/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli><type>fairy</type></nosqli>
    <sqli>admin</sqli>
	<xpath>admin</xpath>
</data>'

#$ Curl2 <data><filename>sample.js</filename><script>test</script><username>test</username><url>http://localhost:8000</url><cmd>google.com</cmd><nosqli><type>fairy</type></nosqli><sqli>admin</sqli><xpath>admin</xpath></data> Pass None
curl --location 'localhost:8000/application/xml' \
--header 'Content-Type: application/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli><type>fairy</type></nosqli>
    <sqli>admin</sqli>
	<xpath>admin</xpath>
</data>'

#$ Curl3 <data><filename>sample.js</filename><script>test</script><username>test</username><url>http://localhost:8000</url><cmd>google.com</cmd><nosqli><type>fairy</type></nosqli><sqli>admin</sqli><xpath>admin</xpath></data> Pass None
curl --location --request GET 'localhost:8000/application/xml' \
--header 'Content-Type: text/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli><type>fairy</type></nosqli>
    <sqli>admin</sqli>
	<xpath>admin</xpath>
</data>'

#$ Curl4 <data><filename>sample.js</filename><script>test</script><username>test</username><url>http://localhost:8000</url><cmd>google.com</cmd><nosqli><type>fairy</type></nosqli><sqli>admin</sqli><xpath>admin</xpath></data>  Pass None
curl --location 'localhost:8000/application/xml' \
--header 'Content-Type: text/xml' \
--data '<?xml version="1.0" encoding="UTF-8" ?>
<data>
	<filename>sample.js</filename>
	<script>test</script>
	<username>test</username>
	<url>http://localhost:8000</url>
	<cmd>google.com</cmd>
	<nosqli><type>fairy</type></nosqli>
    <sqli>admin</sqli>
	<xpath>admin</xpath>
</data>'

#$ Curl5 {"data":{"filename":"sample.js","script":"test","username":"test","url":"http://google.com","cmd":"google.com","nosqli":{"type":"fairy"},"sqli":"admin","xpath":"admin"}} Pass None
curl --location --request GET 'localhost:8000/application/json' \
--header 'Content-Type: application/json' \
--data '{
    "data":{
        "filename":"sample.js",
        "script":"test",
		"username":"test",
		"url":"http://google.com",
		"cmd":"google.com",
		"nosqli":{"type":"fairy"},
    	"sqli":"admin",
		"xpath":"admin"
    }
}'

#$ Curl6 {"data":{"filename":"sample.js","script":"test","username":"test","url":"http://google.com","cmd":"google.com","nosqli":{"type":"fairy"},"sqli":"admin","xpath":"admin"}}  Pass None
curl --location 'localhost:8000/application/json' \
--header 'Content-Type: application/json' \
--data '{
    "data":{
        "filename":"sample.js",
        "script":"test",
		"username":"test",
		"url":"http://google.com",
		"cmd":"google.com",
		"nosqli":{"type":"fairy"},
    	"sqli":"admin",
		"xpath":"admin"
    }
}'

#$ Curl7 filename=sample.js&script=test&username=test&url=http%3A%2F%2Fgoogle.com&cmd=google.com&nosqli=%7B%22type%22%3A%22fairy%22%7D&sqli=admin&xpath=admin Pass None
curl --location --request GET 'localhost:8000/application/urlencoded' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'filename=sample.js' \
--data-urlencode 'script=test' \
--data-urlencode 'username=test' \
--data-urlencode 'url=http%3A%2F%2Fgoogle.com' \
--data-urlencode 'cmd=google.com' \
--data-urlencode 'nosqli=%7B%22type%22%3A%22fairy%22%7D' \
--data-urlencode 'sqli=admin' \
--data-urlencode 'xpath=admin'


#$ Curl8 filename=sample.js&script=test&username=test&url=http%3A%2F%2Fgoogle.com&cmd=google.com&nosqli=%7B%22type%22%3A%22fairy%22%7D&sqli=admin&xpath=admin Pass None
curl --location 'localhost:8000/application/urlencoded' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'filename=sample.js' \
--data-urlencode 'script=test' \
--data-urlencode 'username=test' \
--data-urlencode 'url=http%3A%2F%2Fgoogle.com' \
--data-urlencode 'cmd=google.com' \
--data-urlencode 'nosqli={"type":"fairy"}' \
--data-urlencode 'sqli=admin' \
--data-urlencode 'xpath=admin'

#$ Curl9 --form'filename="sample.js"'\--form'script="test"'\--form'username="test"'\--form'url="http://google.com"'\--form'cmd="google.com"'\--form'nosqli="{\"type\":\"fairy\"}"'\--form'sqli="admin"'\--form'xpath="admin"' Pass None
curl --location --request GET 'localhost:8000/multipart/formdata' \
--header 'Content-Type: multipart/form-data' \
--form 'filename="sample.js"' \
--form 'script="test"' \
--form 'username="test"' \
--form 'url="http://google.com"' \
--form 'cmd="google.com"' \
--form 'nosqli="{\"type\":\"fairy\"}"' \
--form 'sqli="admin"' \
--form 'xpath="admin"'

#$ Curl10 --form'filename="sample.js"'\--form'script="test"'\--form'username="test"'\--form'url="http://google.com"'\--form'cmd="google.com"'\--form'nosqli="{\"type\":\"fairy\"}"'\--form'sqli="admin"'\--form'xpath="admin"' Pass None
curl --location 'localhost:8000/multipart/formdata' \
--header 'Content-Type: multipart/form-data' \
--form 'filename="sample.js"' \
--form 'script="test"' \
--form 'username="test"' \
--form 'url="http://google.com"' \
--form 'cmd="google.com"' \
--form 'nosqli="{\"type\":\"fairy\"}"' \
--form 'sqli="admin"' \
--form 'xpath="admin"'

#$ Curl11 @batman.png Pass None
curl --location --request GET 'localhost:8000/application/octet-stream' \
--header 'Content-Type: application/octet-stream' \
--data '@batman.png'

#$ Curl12 @batman.png Pass None
curl --location 'localhost:8000/application/octet-stream' \
--header 'Content-Type: application/octet-stream' \
--data '@batman.png'

#$ Curl13 @batman.png Pass None
curl --location --request GET 'localhost:8000/image/png' \
--header 'Content-Type: image/png' \
--data '@batman.png'

#$ Curl14 @batman.png Pass None
curl --location 'localhost:8000/image/png' \
--header 'Content-Type: image/png' \
--data '@batman.png'

#$ Curl15 test Pass None
curl --location --request GET 'localhost:8000/text/plain' \
--header 'Content-Type: text/plain' \
--data 'test'

#$ Curl16 test Pass None
curl --location 'localhost:8000/text/plain' \
--header 'Content-Type: text/plain' \
--data 'Test'
fi



# #Curl17 Attack application/xml 
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

# #Curl18 Attack text/xml
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
