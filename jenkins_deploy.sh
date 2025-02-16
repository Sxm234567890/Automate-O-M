#!/bin/bash
DATE=`date +%Y_%m_%d_%H-%M-%S`
METHOD=$1
BRANCH=$2
GROUP_LIST=$3

PROJECT="AI_modle"
SERVER="Knowledge_Q&A"
HAPROXY1="192.168.75.140"
HAPROXY2="192.168.75.141"
GIT_ADDRESS="git@172.31.5.101:AI_modele/web1.git"


IP_LIST(){
  if [[ ${GROUP_LIST}=="GROUP1" ]];then
      Server_IP="192.168.75.133"               #灰度部署第一次
  elif [[ ${GROUP_LIST} == "GROUP2" ]];then  
     Server_IP="192.168.75.134 192.168.75.135"   #灰度部署第二次
  elif [[ ${GROUP_LIST} == "GROUP3" ]];then
     Server_IP="192.168.75.134 192.168.75.135 192.168.75.133"   #全部部署
  fi
     echo $Server_IP

}
CLONE_CODE(){
   echo "即将开始从clone ${BRANCH}分支的代码"
   cd /data/git/${PROJECT} && rm -rf ${SERVER} && git clone -b  ${BRANCH} ${GIT_ADDRESS}
   echo "${BRANCH}分支代码cllone完成，即开始编译"
  #tar czvf myapp.tar.gz ./index.html
  #echo "代码编译完成，即将开始分发部署包"
}

SCANNER_CODE(){
  cd /data/git/${PROJECT}/${SERVER}    && /apps/sonarscanner/bin/sonar-scanner
  echo "代码扫描完成,请打开sonarqube查看扫描结果"
}


CODE_MAVEN(){
  echo  "cd /data/git/${PROJECT}/${SERVER} && mvn clean package -Dmaven.test.skip=true"
   echo "代码编译完成"
}


MAKE_ZIP(){
    cd /data/git/${PROJECT}/${SERVER} && zip -r code.zip ./index.html   #
    echo "代码打包完成"
}

DOWN_NODE(){
     for node in ${Server_IP};do
       ssh root@${HAPROXY1}  "echo "disable server  web_port/${node}" | socat stdio /var/lib/haproxy/haproxy.sock"
     echo "${node} 从负载均衡${HAPROXY1}下线成功"
       ssh root@${HAPROXY2}  "echo "disable server  web_port/${node}" | socat stdio /var/lib/haproxy/haproxy.sock"
     echo "${node} 从负载均衡${HAPROXY2}下线成功"
     done
}

SCP_ZIPFILE(){
    for node in ${Server_IP};do
    scp /data/git/${PROJECT}/${SERVER}/code.zip  tomcat@${node}:/data/tomcat/tomcat_appdir/code-${DATE}.zip
    ssh tomcat@${node} "unzip /data/tomcat/tomcat_appdir/code-${DATE}.zip  -d /data/tomcat/tomcat_webdir/code-${DATE} && rm -rf  /data/tomcat/tomcat_webapps/myapp && ln -sv  /data/tomcat/tomcat_webdir/code-${DATE} /data/tomcat/tomcat_webapps/myapp"
  done
}


STOP_TOMCAT(){
   for node in ${Server_IP};do
     ssh tomcat@${node}   "/etc/init.d/tomcat stop"
   done
}

START_TOMCAT(){
   for node in ${Server_IP};do
    ssh magedu@${node}   "/etc/init.d/tomcat start"
   done
}

WEB_TEST(){
  sleep 10
  for node in ${Server_IP};do
    NUM=`curl -s  -I -m 10 -o /dev/null  -w %{http_code}  http://${node}:8080/myapp/index.html`
    if [[ ${NUM} -eq 200 ]];then
       echo "${node} myapp URL 测试通过,即将添加到负载"
       add_node ${node}
    else
       echo "${node} 测试失败,请检查该服务器是否成功启动tomcat"
    fi
  done
}

ADD_NODE(){
   node=$1
    echo ${node},"----->"    
      ssh root@${HAPROXY1} ""echo enable  server web_port/172.31.5.105" | socat stdio /var/lib/haproxy/haproxy.sock"
      ssh root@${HAPROXY2} ""echo enable  server web_port/172.31.5.105" | socat stdio /var/lib/haproxy/haproxy.sock"	 
   
}

ROOLLBACK_LAST_VERSION(){
     for node in ${Server_IP};do
       echo $node
       NOW_VERSION=`ssh tomcat@${node} ""/bin/ls -l  -rt /data/tomcat/tomcat_webapps/ | awk -F"->" '{print $2}'  | tail -n1""`
       NOW_VERSION=`basename ${NOW_VERSION}`
       echo $NOW_VERSION,"NOW_VERSION"
       NAME=`ssh  magedu@${node}  ""ls  -l  -rt  /data/tomcat/tomcat_webdir/ | grep -B 1 ${NOW_VERSION} | head -n1 | awk '{print $9}'""`
       echo $NAME,""NAME
       ssh tomcat@${node} "rm -rf /data/tomcat/tomcat_webapps/myapp && ln -sv  /data/tomcat/tomcat_webdir/${NAME} /data/tomcat/tomcat_webapps/myapp"
     done 

}

main(){
  case $1 in
     deploy)
       IP_LIST;
       CLONE_CODE;
       SCANNER_CODE;
       MAKE_ZIP;
       DOWN_NODE;
       STOP_TOMCAT;
       SCP_ZIPFILE;
       START_TOMCAT
       WEB_TEST;      
;;
    rollback_last_version)
      IP_LIST;
      DOWN_NODE;
      STOP_TOMCAT;
      ROLLBACK_LAST_VERSION;
      START_TOMCAT;
      WEB_TEST;
;;
  esac
}

main $1 $2 $3































