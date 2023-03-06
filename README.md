# TrickyRobin
Proyecto Para realizar descargas masivas de Rasp Robin, creado por @yocuchi dentro de PROTAAPP para la RootedCon2023.

Se necesita de lo siguiente:

Se parte de un fichero de dominios o de URLs.

Hay tres herramientas:

*cuchi_trikirobin* - Le pasas una URL de Raspberry robin, y te genera una peticion aleatoria con contenido de maquina y de usuario random. Hace la peticion por CURL 
*cuchi_trikirobin2* - Le pasas una URL de Raspberry robin, y te genera una peticion aleatoria con contenido de maquina y de usuario random. Hace la peticion por NETCAT

*cuchi_robin_bulk.sh* - It receives a file with URL's of Robin and makes the request in a similar way of cuchi_trikirobin (CURL AND NC) to all of them. it alos creates a bat file to use a machine and try to infect it.

Also, if you have a VT suscription, this script to get all the url's related to one domain:

*cuchi_vt_dominio_urls* Can receive a domain or a file with domains.

Sadly, haven't testet it sucessfully. In the DB theres is a mix of ton's of ROBIN domains and URLs.



