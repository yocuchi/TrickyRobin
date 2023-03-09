#
#
# Mete en el fichero URL ROBINS todas las URL, y te saca  las urls.

if [ $# -eq 0 ]; then
    >&2 echo "Pon argumentos. No seas gañan, tienes que poner la URL a la que quieres ir."
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color



cowsay "Vamos a por un fichero tocho para probar robins"

temp_file=$(mktemp)
or_ip=$(curl -s icanhazip.com)
echo "Or_IP=$or_ip Temp file=$temp_file"
cat $1 | grep -i -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u > $temp_file
urls_count=$(wc -l < $temp_file)
echo "Encontradas $urls_count urls de Robin"
echo ""
temp_file_msi=$(mktemp).msi
i=0
while read p; do
i=$((i+1))
echo " == Fichero $i de $urls_count =="
Dir=$(dirname $p)
#Para usar un fichero de salida con windows
size_m=$(shuf -i 4-22 -n 1)
size_u=$(shuf -i 4-22 -n 1)
maquina=$(tr -dc A-Za-z0-9 </dev/urandom | head -c $size_m ; echo '')
user=$(tr -dc A-Za-z0-9 </dev/urandom | head -c $size_u ; echo '')
#vamos a probar netcat
dominio=$(echo $Dir | awk -F[/:] '{print $4}')
puerto=$(echo $Dir | awk -F[/:] '{print $5}')
path=$(echo $Dir | grep -Po '\w\K/\w+[^?]+')
host=$dominio:$puerto

#exporto el dominio a VT
echo $dominio >> domain_list.txt

#VERIFICAR PUERTO ABIERTO
port_test=$(nc -w 5 -z  $dominio $puerto; echo $?)

if [ $port_test -eq 0 ]; then
   echo " Puerto abierto en $dominio $puerto. URL $dominio:$puerto$path/$maquina?$user"

start_time=$(date +%s)

elapsed=$(( end_time - start_time ))
{
  printf "GET %s HTTP/1.1\r\n" "$path/$maquina?$user"
  printf "Connection: Close\r\n"
  # printf "Connection: Keep-Alive\r\n"
  printf "Accept: */*\r\n"
  printf "User-Agent: Windows Installer\r\n"
  printf "Host: %s\r\n" "$host"
  printf "\r\n" 
  printf "\r\n"
} | nc -w 5 $dominio $puerto > /tmp/cuchi_netcat_$i
nc_result=$(grep HTTP /tmp/cuchi_netcat_$i)
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))

echo "NC $elapsed segs; out en /tmp/cuchi_netcat_$i Result $nc_result"



start_time=$(date +%s)
status=$(curl -H "Connection: Keep-Alive" -H "User-Agent: Windows Installer" -s --write-out %{http_code} http://$dominio:$puerto$path/$maquina?$user --output /tmp/Cuchi_curl_out_$i)
if [ $status == "202" ]; then
color=$GREEN
else
color=$RED
fi
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))

echo -e "CURL $elapsed segs;out en /tmp/Cuchi_curl_out_$i con status ${color}$status${NC}"


else
echo -e "${RED}Puerto no disponible ${NC} en $dominio $puerto"
    
fi


echo "msiexec /q /I http://$dominio:$puerto$path$maquina?$user">>$temp_file_msi
  #cuchi_trikirobin2 $p
done <$temp_file
echo "====== FIN ========"
echo "Fichero msi en $temp_file_msi"

