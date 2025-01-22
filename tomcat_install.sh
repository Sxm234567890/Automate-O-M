#!/bin/bash
#*****
#author:songxiaomin
#date:2025-01-20
#*****
#wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
#wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz
DIR=`pwd`
JDK_FILE="jdk-21_linux-x64_bin.tar.gz"
#JDK_VERSION="jdk-21.*"                                 #这个在下面替换一下还是不要用变量了
TOMCAT_FILE='apache-tomcat-10.1.34.tar.gz'
#TOMCAT_VERSION="apache-tomcat-10.1.34"
TOMCAT_VERSION=`basename $TOMCAT_FILE .tar.gz`
JDK_DIR="/usr/local/jdk"
TOMCAT_DIR="/usr/local/tomcat"
color(){
   RES_COL=60
   MOVE_TO_COL="echo -en \\033[${RES_COL}G"
   SETCOLOR_SUCCESS="echo -en \\033[1;32m"
   SETCOLOR_FAILE="echo -en \\033[1;33m"
   SETCOLOR_WARNING="echo -en \\033[1;30m"
   SETCOLOR_END="echo -en \\033[0m"
   echo -n $2 && $MOVE_TO_COL
   echo -n "["
   if [ $1 = "success" -o $1 = "0" ];then
        ${SETCOLOR_SUCCESS}
        echo -n $"ok"                          #$"ok" =  "ok"
   elif [ $1 = "fail" -o $1 = "1" ];then
        ${SETCOLOR_FAILE}
        echo -n $"fail"
   else
       ${SETCOLOR_WARING}
       echo -n $"warning"
        
   fi
   ${SETCOLOR_END}
   echo -n "]"
   echo 
}

install_jdk(){
  if ! [ -f "$DIR/$JDK_FILE" ] ;then
       color 1 "$JDK_FILE 文件不存在"
       exit
  elif [ -d "$JDK_DIR" ];then
       color 1 "JDK已经安装"
       exit
  else
      [ -d "$JDK_DIR" ] || mkdir -pv $JDK_DIR
  fi
tar -xvf  $DIR/$JDK_FILE -C $JDK_DIR
#cd $JDK_DIR && ln -s $JDK_VESION/  jdk   #这里要注意，$JDK_VERSION/不能写成$JDK_VERSION ,会报循环链接的错
cd $JDK_DIR && ln -s jdk-21.*/  jdk       #这个版本还是不要用变量了，会报错有时候
cat > /etc/profile.d/jdk.sh << EOF
export JAVA_HOME=$JDK_DIR/jdk
export JRE_HOME=\$JAVA_HOME/
export CLASSPATH=\$JAVA_HOME/lib/:\$JRE_HOME/lib/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile.d/jdk.sh    #/etc/profile.d 存放针对shell环境的配置脚本。用于设置环境变量、别名、路径影响用户登陆时的shell会话
                           #.shell登陆的时候（终端或者图形）这下面的脚本就会自动执行
                           #/etc/init.d   存放系统服务的启动脚本。管理系统的启动停止
java -version && color 0 "JDK安装完成" || { color 1 "JDK安装失败" ; exit; }     
#source /etc/profile.d/jdk.sh 最后还是要执行一次才能在所在终端看见java -version,但是不执行也行反正jdk安装了
}

install_tomcat(){
   if ! [ -f "$DIR/$TOMCAT_FILE" ] ; then
           color 1 "没有${TOMCAT_FILE}安装包"
           exit
   elif  [ -d  "$TOMCAT_DIR" ] ;then
           color 1 "tomcat已经安装"
           exit
   else
        [ -d ${TOMCAT_DIR} ] || mkdir -pv ${TOMCAT_DIR}
fi
        tar -xvf  $DIR/$TOMCAT_FILE  -C  ${TOMCAT_DIR}
        cd $TOMCAT_DIR && ln -s ${TOMCAT_VERSION}/  tomcat
#      echo "PATH=$TOMCAT_DIR/tomcat/bin:" '$PATH' >/etc/profile.d/tomcat.sh
#        echo "PATH=$TOMCAT_DIR/tomcat/bin:" 
        echo "export PATH=\$TOMCAT_FILE/tomcat/bin:\$PATH" > /etc/profile.d/tomcat.sh
        . /etc/profile.d/tomcat.sh
        id tomcat &>/dev/null || useradd -r -s /sbin/nologin  tomcat
        
        cat > $TOMCAT_DIR/tomcat/conf/tomcat.conf << EOF
JAVA_HOME=$JDK_DIR/jdk
EOF
chown -R tomcat.tomcat $TOMCAT_DIR/tomcat/
cat > /lib/systemd/system/tomcat.service << EOF
[Unit]
Description=Tomcat
#After=syslog.target network.target remote-fs.target nss-lookup.target
After=syslog.target network.target
[Service]
Type=forking
EnvironmentFile=$TOMCAT_DIR/tomcat/conf/tomcat.conf
ExecStart=$TOMCAT_DIR/tomcat/bin/startup.sh
ExecStop=$TOMCAT_DIR/tomcat/bin/shutdown.sh
RestartSec=3
PrivateTmp=true
User=tomcat
Group=tomcat
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now tomcat.service &>/dev/null
systemctl is-active tomcat &>/dev/null && color 0 "TOMCAT安装并启动成功" || { color 1 "TOMCAT安装启动失败" ; exit ; }

}

#install_jdk
install_tomcat
