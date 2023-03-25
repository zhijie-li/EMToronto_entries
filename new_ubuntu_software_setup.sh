sudo apt update
#!/bin/sh
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install nfs-kernel-server 

sudo apt -y remove unattended-upgrades
sudo apt -y install vim tree wget curl filezilla bless
sudo apt -y install gparted net-tools
sudo apt -y install git
sudo apt -y install nfs-kernel-server
sudo apt -y install libopenmpi-dev

sudo apt -y install libx11-dev
sudo apt -y install libtiff-dev
sudo apt -y install libssl-dev
sudo apt -y install cmake

sudo apt -y install mesa-common-dev
sudo apt -y install libnetcdf-dev libglew-dev
sudo apt -y install build-essential

#https://www.kevin-custer.com/blog/disabling-the-plymouth-boot-screen-in-ubuntu-20-04/


#sudo vi /etc/default/grub
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
#------------>
#GRUB_CMDLINE_LINUX_DEFAULT="quiet"


sudo update-grub
#sudo apt purge plymouth


sudo apt -y  autoremove
#sudo rm -rf /usr/share/plymouth


##Nvidia driver issue: https://forums.developer.nvidia.com/t/whats-the-process-for-fixing-nvidia-drivers-after-kernel-updates-in-ubuntu-20-04/208870/12

＃sudo apt -y install linux-headers-$(uname -r)
