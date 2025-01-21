#!/bin/bash
#*****
#author:songxiaomin
#date:2025-01-20
#*****
DIR=`pwd`
JDK_FILE="jdk-21_linux-x64_bin.tar.gz"
JDK_VERSION="jdk-21.*"
JDK_DIR="/usr/local/jdk"
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
cd $JDK_DIR && ln -s $JDK_VESION/  jdk   #这里要注意，$JDK_VERSION/不能写成$JDK_VERSION ,会报循环链接的错
cat > /etc/profile.d/jdk.sh << EOF
export JAVA_HOME=$JDK_DIR/jdk
export JRE_HOME=\$JAVA_HOME/jre
export CLASSPATH=\$JAVA_HOME/lib/:\$JRE_HOME/lib/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
. /etc/profile.d/jdk.sh    #/etc/profile.d 存放针对shell环境的配置脚本。用于设置环境变量、别名、路径影响用户登陆时的shell会话
                           #.shell登陆的时候（终端或者图形）这下面的脚本就会自动执行
                           #/etc/init.d   存放系统服务的启动脚本。管理系统的启动停止
java -version && color 0 "JDK安装完成" || { color 1 "JDK安装失败" ; exit; }
}
install_jdk
