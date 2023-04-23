
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
    chmod +x /radish
    cd /radish
	
	docker stop radish
	
	docker rm radish
	
	docker rmi radish

    if [ ! -f "/radish/Dockerfile" ]; then
        wget https://raw.githubusercontent.com/lu0b0/ELM/main/JD/Dockerfile -O /radish/Dockerfile
    fi
    
    
    wget https://github.com/lu0b0/ELM/releases/download/3.0/radish -O /radish/radish
    
    chmod -R 777 /radish
	
    docker build -t='radish' .
}

echo -e $"\n欢迎使用radish登陆面板1.0 Docker一键部署脚本"
read -p "输入Y/y确认安装 跳过安装请直接回车:  " CONFIRM
CONFIRM=${CONFIRM:-"N"}


##if [[ ! -f "/radish/Config.json"  ]]; then
	
##fi
if [[ ${CONFIRM} == "Y" || ${CONFIRM} == "y" ]];then
	if [ ! -d "/radish" ]; then
		mkdir /radish
	fi
	read -p $'\n 输入授权码: ' sqm
	sqm=${sqm:-""}

	read -p $'\n 输入青龙url: 例：（http://192.168.0.1:5700）：' qlurl
	qlurl=${qlurl:-""}

	read -p $'\n 输入容器CLIENTID: ' CLIENTID
	CLIENTID=${CLIENTID:-""}

	read -p $'\n 输入容器SECRET: ' SECRET
	SECRET=${SECRET:-""}
	
	read -p $'\n 输入wxpusher推送的app_token 获取地址：https://wxpusher.zjiecode.com/admin (不设置推送按回车): ' wxpusher
	wxpusher=${wxpusher:-""}

	echo "{
		\"Authorization\":\"$sqm\",
		\"Title\": \"萝卜呀\",
		\"Announcement\": \"公告\",
		\"wxpusher_token\":\"$wxpusher\",
		\"Config\": [
			{
				\"QLkey\": 1,
				\"QLName\": \"容器1\",
				\"QLurl\": \"$qlurl\",
				\"QL_CLIENTID\": \"$CLIENTID\",
				\"QL_SECRET\": \"$SECRET\",
				\"QL_CAPACITY\": 999
			}
		]
	}" > /radish/Config.json
	DOCKER_INSTALL
	DOCKER_UP
fi
read -p "输入容器映射端口: （回车默认为3001）" pp
pp=${pp:-"3001"}
if [[ ${pp} != "3001" || ${pp} != "3001" ]];then
	eval "docker run -dit   -v /radish:/etc/lb   -p $pp:3001   --name radish   --hostname radish   --restart unless-stopped    --restart always   radish:latest"
else	
	eval "docker run -dit   -v /radish:/etc/lb   -p 3001:3001   --name radish   --hostname radish   --restart unless-stopped    --restart always   radish:latest"
fi

exit 0
