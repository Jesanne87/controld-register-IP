#!/bin/bash
clear
rm -f /root/kontold
rm -f /root/kontoldpass
#Email Kontol Anda
echo -e "\e[93mPlease Enter Your Kontrold Email \033[0m"
read -p "Email : " kontol
echo $kontol > /root/kontold
echo -e ""

#Pasword Kontol Anda
echo -e "\e[93mPlease Enter Your Kontrold Password \033[0m"
read -p "Password : " Password
echo $Password > /root/kontoldpass
echo -e ""

email=$(cat /root/kontold)
pass=$(cat /root/kontoldpass)

# Get the user token
token=$(curl -Ss --request POST \
    --url https://api.controld.com/preauth/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\"}" | jq -r '.body.token')

# Get the session ID
sessionID=$(curl -Ss --request POST \
    --url https://api.controld.com/users/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\",\"token\":\"$token\"}" | jq -r '.body.session')

# Get the device ID
deviceId=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].resolvers.uid')

# Add IP
addIP=$(curl -Ss --request POST \
    --url "https://api.controld.com/access?device_id=${deviceId}" \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' \
    --data "{\"ips\":[\"$(curl -Ss ipv4.icanhazip.com)\"]}" | grep -ic "1 IPs added")

# Print result
if [[ ${addIP} != '0' ]]; then
    echo "Success, Add $(curl -Ss ipv4.icanhazip.com)"
    echo "Moded By : @hehehe"
    echo "Credit   : @sam_sfx"
sleep 1
else
    echo "Sorry, Unsuccessful"
    echo "Moded By  : @hehehe"
    echo "Credit To : @sam_sfx"
fi    
sleep 1
rm -f /root/kontold
rm -f /root/kontoldpass
#rm -f /root/kontol.sh
exit