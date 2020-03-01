#!/usr/bin/env bash

apt-get update
apt-get -y install figlet jq wget

##
## Setup SSH Config
##
cat <<"__EOF__" > /home/${ssh_user}/.ssh/config
Host *
    StrictHostKeyChecking no
__EOF__
chmod 600 /home/${ssh_user}/.ssh/config
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

# Setup default `make` support
echo 'alias make="make -C /usr/local/include --no-print-directory"' >> /etc/skel/.bash_aliases
cp /etc/skel/.bash_aliases /root/.bash_aliases
cp /etc/skel/.bash_aliases /home/${ssh_user}/.bash_aliases

echo 'default:: help' > /usr/local/include/Makefile
echo '-include Makefile.*' >> /usr/local/include/Makefile

aws configure set region ${region}
aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${allocation_id} --allow-reassociation
sudo echo ${public_key} >> /home/ec2-user/.ssh/authorized_keys
#mv -f /tmp/.bashrc /home/ec2-user/.bashrc
#chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.bashrc
#curl -sL -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator && chmod +x /usr/local/bin/aws-iam-authenticator
#wget -q https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm  && chmod +x /usr/local/bin/helm


${user_data}

