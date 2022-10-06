
OUT_ALERT() {
    echo -e "${CYELLOW} $1 ${CEND}"
}

DOCKER_INSTALL() {
    docker_exists=$(docker version 2>/dev/null)
    if [[ ${docker_exists} == "" ]]; then
        OUT_ALERT "[?] 正在安装docker"

        curl -fsSL get.docker.com | bash 
    fi

    docker_compose_exists=$(docker-compose version 2>/dev/null)
    if [[ ${docker_compose_exists} == "" ]]; then
        OUT_ALERT "[?] 正在安装docker-compose"

        curl -L --fail https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose && \
	    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    fi
}


DOCKER_UP() {
    chmod +x /elmmb
    cd /elmmb

    if [ ! -f "/elmmb/Dockerfile" ]; then
        wget https://ghproxy.com/https://raw.githubusercontent.com/lu0b0/ELM/main/images/Dockerfile -O /elmmb/Dockerfile
    fi
    
    if [ ! -f "/elmmb/elmmb" ]; then
        wget https://ghproxy.com/https://github.com/lu0b0/releases/download/1.0/elmmb -O /elmmb/elmmb
    fi
    
    if [[ $1 == "" ]]; then
        wget https://ghproxy.com/https://raw.githubusercontent.com/lu0b0/ELM/main/images/Config.json -O /elmmb/Config.json
    else
        wget $1 -O /elmmb/Config.json
    fi
	
	chmod -R 777 /elmmb
	
    docker build -t='elmmb' .
}

echo -e $"\n欢迎使用饿了么登陆面板 Docker一键部署脚本"
read -p "输入Y/y确认安装 跳过安装请直接回车:  " CONFIRM
CONFIRM=${CONFIRM:-"N"}
if [[ ${CONFIRM} == "Y" || ${CONFIRM} == "y" ]];then
	if [ ! -d "/elmmb" ]; then
		mkdir /elmmb
	fi
	DOCKER_INSTALL
	DOCKER_UP
fi

read -p $'\n 输入授权码: ' sqm
sqm=${sqm:-""}

read -p $'\n 输入青龙url: 例：（http:192.168.0.1）：' qlurl
qlurl=${qlurl:-""}

read -p $'\n 输入容器CLIENTID: ' CLIENTID
CLIENTID=${CLIENTID:-""}

read -p $'\n 输入容器SECRET: ' SECRET
SECRET=${SECRET:-""}

echo "{
	\"Authorization\":\"$sqm\",
    \"Title\": \"饿了么\",
    \"Announcement\": \"公告\",
    \"Config\": [
        {
            \"QLkey\": 1,
            \"QLName\": \"容器1\",
            \"QLurl": "$qlurl\",
            \"QL_CLIENTID\": \"$CLIENTID\",
            \"QL_SECRET\": \"$SECRET\",
            \"QL_CAPACITY\": 40
        }
    ]
}" > Config.json

read -p "输入容器映射端口: （回车默认为3000）" pp
pp=${pp:-"3000"}
if [[ ${pp} != "3000" || ${pp} != "3000" ]];then
	eval "docker run -dit   -v /elmmb:/etc/elm   -p $pp:3000   --name elmmb   --hostname elmmb   --restart unless-stopped    --restart always   elmmb:latest"
else	
	eval "docker run -dit   -v /elmmb:/etc/elm   -p 3000:3000   --name elmmb   --hostname elmmb   --restart unless-stopped    --restart always   elmmb:latest"
fi

exit 0
