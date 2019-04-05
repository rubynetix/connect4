#!/usr/bin/env bash

install_gem() {
    echo "Installing gem $1"
    gem install $1 --quiet --no-document
}

install_package() {
    if [[ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ]];
    then
        echo "Installing $1..."
        sudo apt-get -y install $1 >/dev/null
    else
        echo "Package $1 already installed"
    fi
}

install_mysql() {
    if [[ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]];
    then
        echo "Installing mysql-server..."
        mkdir tmp
        wget -P ./tmp/ "https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb"
        sudo dpkg -i ./tmp/mysql-apt-config_0.8.12-1_all.deb
        rm -rf tmp
        sudo apt-get update
        sudo apt-get -y install mysql-server >/dev/null
    else
	echo "Package mysql-server already installed"
    fi
}

install_mysql
install_package libmysqlclient-dev

gem update --system
install_gem bundler
bundle install
