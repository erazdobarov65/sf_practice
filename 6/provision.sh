 # Добавляем репозиторий PostgreSQL 8.4 и импортируем ключ
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    
    #Копируем файл с локального компа в нужную директорию на вируалке Vagrant
    cp /home/vagrant/synced_folder/myfile.txt /home/vagrant/ # copy the file from synced folder into the home directory of the vagrant user
    # обновляем пакеты ОС и устанвливаем нужные доп пакеты и PostgreSQL 8.4
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
    sudo apt-get install -y libpq-dev 
    pip3 install psycopg2
    pip3 install django
    sudo apt-get install -y postgresql-8.4
    sudo apt-get install postgresql-common
    sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/8.4/main/postgresql.conf
    echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/8.4/main/pg_hba.conf
    sudo systemctl start postgresql.service
