#!/bin/bash
#*******
#auth:songxiaomin
#date:2024-01-12
#*******

CA_SUBJ="/C=CN/ST=Anhui/L=Anqin/O=mimijiang/OU=yunwei/CN=dami.com/emailAddress=123456@qq.com"
SERVER_NAME="www.xiaomin.org"
SUBJ="/C=CN/ST=Anhui/L=Anqin/O=xiaomin.org/OU=xiaomin.org/CN=www.xiaomin.org/emailAddress=123456@qq.com"

openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 3650 -out ca.crt -subj ${CA_SUBJ}
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ${SERVER_NAME}.key -out ${SERVER_NAME}.csr  -subj ${SUBJ}
openssl x509 -req -days 3650 -in ${SERVER_NAME}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ${SERVER_NAME}.crt

cat  ${SERVER_NAME}.crt ca.crt > ${SERVER_NAME}.pem
#CA和服务器证书在一个文件pem,服务器私钥文件.key

