yum install vim gcc gcc-c++ wget net-tools lrzsz iotop lsof iotop bash-completion -y
yum install curl policycoreutils openssh-server openssh-clients postfix -y
yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm
sed -i 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
systemctl disable firewalld
sed -i '/SELINUX/s/enforcing/disabled/' /etc/sysconfig/selinux
hostnamectl set-hostname gitlab.example.com
reboot


