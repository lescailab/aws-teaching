# sudo mkfs -t ext4 xvdb
# sudo mkdir /data
# sudo mount /dev/xvdb /data

##############################################
### install jupyter system wide no conda #####
##############################################

sudo apt-get update
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-testresources
sudo python3 -m pip install --upgrade pip setuptools wheel
sudo pip3 install jupyterlab

sudo jupyter notebook --generate-config
jupyter notebook --generate-config
echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" | sudo tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" >>/home/ubuntu/.jupyter/jupyter_notebook_config.py

cat << EOF >jupyter.service

[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=jupyter lab --notebook-dir=/home/ubuntu/notebook
User=ubuntu
Group=ubuntu
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

EOF

sudo mv jupyter.service /etc/systemd/system/.
sudo systemctl daemon-reload
sudo systemctl enable jupyter
sudo systemctl start jupyter


##############################################
### install R & Rserver no conda #####
##############################################

sudo apt-get install -y r-base \
    libapparmor1 \
    gdebi-core \
    make \
    build-essential \
    libcurl4-openssl-dev \
    libxml2-dev \
    texlive-* \
    pandoc

sudo groupadd rstudio-users
sudo useradd -m -p 'argon2:$argon2id$v=19$m=10240,t=10,p=8$D8x/X0XCdzLb4fIBc4ZjmQ$Wl2oztW2Xzjo2218APCV1g' -s /bin/bash –G rstudio-users rstudiouser

wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb
sudo gdebi -n rstudio-server-1.4.1106-amd64.deb

sudo mkdir -p /opt/software/anaconda
cd /opt/software/anaconda
sudo wget -O Anaconda2-2019.10-Linux-x86_64.sh "https://repo.anaconda.com/archive/Anaconda2-2019.10-Linux-x86_64.sh"
sudo bash Anaconda2-2019.10-Linux-x86_64.sh -b -f -p /opt/software/anaconda
eval "$(/opt/software/anaconda/bin/conda shell.bash hook)"
conda init

cd ~
wget https://raw.githubusercontent.com/lescailab/aws-teaching/master/aws_environment.yml
conda env create -f aws_environment.yml

export PATH=/home/ubuntu/.conda/envs/aws-env/bin:${PATH}
conda activate aws-env 

sudo ufw allow 8787




