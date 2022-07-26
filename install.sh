#!/bin/bash
clear
[[ "$(whoami)" != "root" ]] && {
  echo -e "\033[1;33m[\033[1;31mErro\033[1;33m] \033[1;37m- \033[1;33mvocê precisa executar como root\033[0m"
  rm $HOME/Plus > /dev/null 2>&1; exit 0
}
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
IP=$(wget -qO- ipv4.icanhazip.com)
clear
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
tput setaf 7 ; tput setab 3 ; tput bold ; printf '%40s%s%-12s\n' "BEM VINDO AO WMSSH V1.0" ; tput sgr0
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
echo ""
echo -e "             \033[1;31mATENCAO! \033[1;33mESSE SCRIPT IRA !\033[0m"
echo ""
echo -e "\033[1;33m  INSTALAR PAINEL WEB COM FERRAMENTAS PARA\033[0m"
echo -e "\033[1;33m  GERENCIAMENTO DE REDE, SISTEMA E USUARIOS.\033[0m"
echo ""
echo -e "\033[1;31m≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×≠×\033[0m"
echo ""
echo -ne "\n\033[1;32mDEFINA UMA SENHA PARA O\033[1;33m MYSQL\033[1;37m: "; read senha
echo -e "\n\033[1;36mINICIANDO INSTALACAO \033[1;33mAGUARDE..."
apt-get update -y > /dev/null 2>&1
apt-get install cron curl unzip -y > /dev/null 2>&1
echo -e "\n\033[1;36mINSTALANDO O APACHE2 \033[1;33mAGUARDE...\033[0m"
apt-get install apache2 -y > /dev/null 2>&1
apt-get install php5 libapache2-mod-php5 php5-mcrypt -y > /dev/null 2>&1
apt-get install php-ssh2 php-json php-mysqlnd php-xml -y > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
echo -e "\n\033[1;36mINSTALANDO O MySQL \033[1;33mAGUARDE...\033[0m"
echo ""
echo -e "\n\033[1;31mVAMOS PRECISAR DA SUA SENHA ROOT PARA PERMITIR OS PROXIMOS PASSOS \033[1;33mAGUARDANDO...\033[0m"
while true; do
	read -p "VOCÊ TEM A SENHA ROOT [S/N]? " cnt1
	case $cnt1 in
		[Ss]* ) break;;
		[Nn]* ) exit;;
		* ) printf "POR FAVOR, DIGITE APENAS S OU N. ";;
	esac
done
echo -e "\n\033[1;36mOBRIGADO, \033[1;33mCONTINUANDO...\033[0m"
echo ""
echo "debconf mysql-server/root_password password $senha" | debconf-set-selections
echo "debconf mysql-server/root_password_again password $senha" | debconf-set-selections
apt-get install mysql-server -y > /dev/null 2>&1
mysql_install_db > /dev/null 2>&1
(echo $senha; echo n; echo y; echo y; echo y; echo y)|mysql_secure_installation > /dev/null 2>&1
echo -e "\n\033[1;36mINSTALANDO O PHPMYADMIN \033[1;33mAGUARDE...\033[0m"
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $senha" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $senha" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $senha" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install phpmyadmin -y > /dev/null 2>&1
php5enmod mcrypt > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
apt-get install libssh2-1-dev libssh2-php -y > /dev/null 2>&1
if [ "$(php -m |grep ssh2)" = "ssh2" ]; then
  true
else
  clear
  echo -e "\033[1;31m ERRO CRITICO\033[0m"
  rm $HOME/install.sh
  exit
fi
apt-get install php5-curl > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
clear
apt-get install php-ssh2 php-json php-mysqlnd php-xml -y > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
clear
echo -e "\033[1;32m WMSSH INSTALADO COM SUCESSO!"
echo ""
echo -e "\033[1;36m SEU PAINEL:\033[1;37m http://$IP\033[0m"
cat /dev/null > ~/.bash_history && history -c
rm /root/install.sh
