# Installing the Master-Node
The Master Node will include following services
* OS: Ubuntu Server 16.04.3 LTS, User: bigdata ; PW: theoddsareagainstjohnmcclane...
* Parted Magic on another Partition for backups
* SSH (on Port 443)
* RDP (Port 3389 Through SSH-Tunnel)
* ZSH-Shell with "dieter"-theme and syntax-highlighting
* Lubuntu-Desktop
* Teamviewer, ID: 243428258 ; PW: #JohnMcClane123
* WakeOnLan for all other Hosts -> WOL has to be activated in the BIOS of all worker Nodes
* HaltOnLan and RebootOnLan over SSH
* SSL-Certificate
* MaaS (WebGui: https://141.22.45.4:5443/MAAS/ ), Region and Rack Controller, User: bigdata ; PW: #JohnMcClane123
* Juju on Kube01: https://141.22.45.41:17070/gui/u/admin/kube ; User: admin ; PW: #JohnMcClane123
* Kubernetes (installed via Juju ; http://141.22.45.42:8001/ui )

## Configure Parted Magic

* Partition Filesystem FAT32

```sudo mkdir /media/pmagic```

```sudo sh -c "echo 'UUID=7F93-697C	/media/pmagic vfat	defaults	0	0' >> /etc/fstab"```

```sudo mount -a```

```sudo sh -c "echo 'menuentry "Parted Magic" {' >> /etc/grub.d/40_custom"```

```sudo sh -c "echo 'set root=(hd0,2)' >> /etc/grub.d/40_custom"```

```sudo sh -c "linux /boot/pmagic/bzImage64 root=/dev/sdXX directory=boot edd=on vga=normal' >> /etc/grub.d/40_custom```

```sudo sh -c "echo 'initrd /boot/pmagic/initrd.img' >> /etc/grub.d/40_custom```

```sudo sh -c "echo '}' >> /etc/grub.d/40_custom```

```sudo update-grub```

## Configure System

### Configure /etc/hosts
```sudo sh -c "echo '141.22.45.41    Kube01.maas     Kube01' >> /etc/hosts"```

```sudo sh -c "echo '141.22.45.42    Kube02.maas     Kube02' >> /etc/hosts"```

```sudo sh -c "echo '141.22.45.43    Kube03.maas     Kube03' >> /etc/hosts"```

```sudo sh -c "echo '141.22.45.44    Kube04.maas     Kube04' >> /etc/hosts"```

```sudo sh -c "echo '141.22.45.45    Kube05.maas     Kube05' >> /etc/hosts"```

### To deactivate password prompt for sudo-statements
```echo 'bigdata ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo```

### System update
```sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y```

### Install LXDE-Desktop
```sudo apt-get install lubuntu-desktop -y```

### Disable error reporting
```sudo sed -i -- 's/enabled=1/enabled=0/g' /etc/default/apport```

## OPTIONAL: Install some useful tools
```sudo apt-get install -y wireshark tcpdump zenmap wireshark-gtk```

```sudo adduser $USER wireshark```

## OPTIONAL: Install Grub Customizer

### Add Repository
```sudo add-apt-repository ppa:danielrichter2007/grub-customizer```

### Update local APT-Cache
```sudo apt-get update```

### Install
```sudo apt-get install grub-customizer-y```

## SSH Settings

### Change ssh-Port from 22 to 443
```sudo sed -i -- 's/Port 22/Port 443/g' /etc/ssh/sshd_config```

```sudo systemctl restart ssh.service``` 

### Create SSH-Key
```ssh-keygen```

### Cronjob for Kubernetes Dashboard Tunnel

```crontab -l > mycron```

```echo "@reboot ssh bigdata@localhost -p 443 -L 8001:141.22.45.42:8001 &```

```crontab mycron```

```rm mycron```

### Passphrase = diehard

## Install RDP

### Install
```sudo apt-get install xrdp -y```

### OPTIONAL: Use Lubuntu-Destop instead of LXDE
```echo "lxsession -s Lubuntu -e LXDE" > ~/.xsession```

### Configure SSH 

### Start SSH Session on client machine
```ssh bigdata@141.22.45.4 -L 2222:localhost:3389```

### Connect with local host and specified port
```localhost:2222```

## Install and Configure ZSH-Shell

### Install
```sudo apt-get install git dialog zsh -y```

### Change-Shell
```chsh```

```/usr/bin/zsh```

### Restart
```exit```

### !restart terminal!
### Take Option 2
### Add some useful aliases
```echo '' >> ~/.zshrc```

```echo '### Useful Aiases' >> .zshrc```

```echo 'alias sourcezsh="source ~/.zshrc"' >> ~/.zshrc```

```echo 'alias zshrc="nano ~/.zshrc"' >> ~/.zshrc```

```echo 'alias apt-upgrade="sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y"' >> ~/.zshrc```

```echo 'alias apt-update="sudo apt-get update"' >> ~/.zshrc```

```echo '' >> ~/.zshrc```

### Install Oh-My-ZSH
```sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"```

### Change ZSH-Theme to "dieter"
```sed -i -- 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dieter"/g' ~/.zshrc```

### Install syntax highlighting
```git clone https://github.com/zsh-users/zsh-syntax-highlighting.git```

```echo '### Activate Syntax-Highlighting' >> .zshrc```

```echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc```

```echo '' >> ~/.zshrc```

### Create SSH-aliases (Secure Shell)
```echo '### Secure Shell' >> .zshrc```

```echo 'alias kube01="ssh ubuntu@Kube01"' >> ~/.zshrc```

```echo 'alias kube02="ssh ubuntu@Kube02 -L 8001:141.22.45.42:8001"' >> ~/.zshrc```

```echo 'alias kube03="ssh ubuntu@Kube03"' >> ~/.zshrc```

```echo 'alias kube04="ssh ubuntu@Kube04"' >> ~/.zshrc```

```echo 'alias kube05="ssh ubuntu@Kube05"' >> ~/.zshrc```

```echo '' >> ~/.zshrc```

### Activate the ZSH-Settings
```source ~/.zshrc```

### OPTIONAL: Install and configure TeamViewer

## Install
```cd ~/Downloads```

```wget https://download.teamviewer.com/download/teamviewer_i386.deb```

```sudo dpkg -i teamviewer_i386.deb```

```sudo apt-get install -f -y```

```cd ~```

### Go in Teamviewer -> Extras -> Options -> Security -> Password
### Password: #JohnMcClane123

## Install WakeOnNan

### Install
```sudo apt-get install wakeonlan -y```

### Create wol-aliases
```echo '### WakeOnLan' >> .zshrc```

```echo 'alias wolkube01="wakeonlan 90:1B:0E:D5:90:1F"' >> .zshrc```

```echo 'alias wolkube02="wakeonlan 90:1B:0E:D5:91:0E"' >> .zshrc```

```echo 'alias wolkube03="wakeonlan 90:1B:0E:D5:91:0D"' >> .zshrc```

```echo 'alias wolkube04="wakeonlan 90:1B:0E:D5:90:1D"' >> .zshrc```

```echo 'alias wolkube05="wakeonlan 90:1B:0E:D5:90:23"' >> .zshrc```

```echo 'alias wolall="wolkube01 && wolkube02 && wolkube03 && wolkube04 && wolkube05"' >> .zshrc```

```echo '' >> ~/.zshrc```

### Create hol-aliases (HaltOnLan)
```echo '### HaltOnLan' >> .zshrc```

```echo 'alias holkube01="ssh ubuntu@Kube01 '\''sudo halt -p'\''"' >> .zshrc```

```echo 'alias holkube02="ssh ubuntu@Kube02 '\''sudo halt -p'\''"' >> .zshrc```

```echo 'alias holkube03="ssh ubuntu@Kube03 '\''sudo halt -p'\''"' >> .zshrc```

```echo 'alias holkube04="ssh ubuntu@Kube04 '\''sudo halt -p'\''"' >> .zshrc```

```echo 'alias holkube05="ssh ubuntu@Kube05 '\''sudo halt -p'\''"' >> .zshrc```

```echo 'alias holall="holkube01 && holkube02 && holkube03 && holkube04 && holkube05"' >> .zshrc```

```echo '' >> ~/.zshrc```

### Create rol-aliases (RebootOnLan)
```echo '### RebootOnLan' >> .zshrc```

```echo 'alias rolkube01="ssh ubuntu@Kube01 '\''sudo reboot'\''"' >> .zshrc```

```echo 'alias rolkube02="ssh ubuntu@Kube02 '\''sudo reboot'\''"' >> .zshrc```

```echo 'alias rolkube03="ssh ubuntu@Kube03 '\''sudo reboot'\''"' >> .zshrc```

```echo 'alias rolkube04="ssh ubuntu@Kube04 '\''sudo reboot'\''"' >> .zshrc```

```echo 'alias rolkube05="ssh ubuntu@Kube05 '\''sudo reboot'\''"' >> .zshrc```

```echo 'alias rolall="rolkube01 && rolkube02 && rolkube03 && rolkube04 && rolkube05"' >> .zshrc```

```echo '' >> ~/.zshrc```

### Activate the aliases
```source ~/.zshrc```

## Install and configure MaaS

### Install
```sudo apt-get install -y maas```

### Create MaaS-Admin
```sudo maas createadmin```

```username: bigdata```

```password: #JohnMcClane123```

### Configure SSL
```sudo rm /etc/apache2/ssl/*```

```sudo openssl genrsa -out /etc/apache2/ssl/server.key 2048```

```sudo openssl req -new -x509 -key /etc/apache2/ssl/server.key -days 3650 -sha256 -out /etc/apache2/ssl/server.crt```

```
> DE
> HH
> HH
> HAW-Hamburg
> Informatik
> Kube00.Maas
> nomail.local
```

```sudo sed -i -- 's/Listen 80/#Listen 80/g' /etc/apache2/ports.conf```

```sudo sed -i -- 's/Listen 443/Listen 5443/g' /etc/apache2/ports.conf```

```sudo nano /etc/apache2/sites-available/ssl.conf```

```
<VirtualHost *:5443>
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache.crt
    SSLCertificateKeyFile /etc/ssl/private/apache.key
    DocumentRoot /var/www/html/
</VirtualHost>
```

```sudo a2ensite ssl.conf```

```sudo service apache2 force-reload ```

### Login to the MaaS WebGUI https://141.22.45.4:5443/MAAS/

### Save selection and Continue 

### Get the ssh-key

```cat .ssh/id_rsa.pub```

* Choose Source Upload, paste the ssh-key into the field and go to dashboard

* MaaS-Regional Controller has been set

* Go to MaaS WebGUI and Configure VLAN

* The Configured Network should look like this:
fabric-0  untagged  141.22.45.0/26

* Click on "untagged" -> Take action -> Provide DHCP
  * Name: 141.22.45.0/26
  * CIDR: 141.22.45.0/26
  * Gateway: 141.22.45.1
  * DNS: 141.22.192.100
  * DHCP Range: 141.22.45.10 - 141.22.45.19

### Add MaaS machine (Info tab at Readme.md)

* Start a bare metal server with pxe boot
* server boots
* after a short time MaaS recognizes the server and enlists it on the WebGUI (Nodes-tab -> machines)
* Wait for the server shutting down
* Go to Nodes -> Machines -> Click on your server -> Change Name at top of the page: Kube02.maas
* Go to Nodes -> Machines -> Click on your server -> Power -> Edit -> Choose "Manual"
* Take Action -> Comission
* Reboot the server
* After a short time the server is ready
* Go to Nodes -> Machines -> Click on your server -> type in your tags
* Go to Nodes -> Machines -> Click on your server -> Interfaces -> Actions -> Edit -> IP mode **Static**
 * Type in IP address

## Juju install

### Add Repository
```sudo add-apt-repository -u ppa:juju/stable```

### Update local APT-Cache
```sudo apt-get update```

### Install
```sudo apt install juju```

### Add local MaaS cloud
```juju add-cloud```

```> maas```

```> BigData```

### Add credentials for local MaaS Cloud
```sudo maas-region apikey --username=bigdata```

```juju add-credential BigData```

```> bigdata```

### Additional Config
```sudo mkdir /var/lib/juju```

```sudo sh -c "echo 'user-admin:bootstrap' > /var/lib/juju/nonce.txt"```

### Deploy JuJu Controller
```juju bootstrap --debug --constraints tags=juju BigData maas-controller```

* Set admin passwod for JuJu GUI https://141.22.45.41:17070/gui/u/admin/kube
```juju change-user-password admin```

```> #JohnMcClane123```

### Add machines

```add-machine Kube02.maas```

```wolkube02```

## Kubernetes Install

### Autostart Kubernetes Dashboard

* After Kubernetes install login to Kube02

```kube02```

```sudo sh -c "echo '[Unit]' > /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo 'Description=Kubernetes WebGUI' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo '' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo 'Service]' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo 'Type=simple' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo 'ExecStart=/snap/bin/kubectl proxy --address 141.22.45.42' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo '' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo '[Install]' >> /etc/systemd/system/kube-proxy.service"```

```sudo sh -c "echo 'WantedBy=multi-user.target' >> /etc/systemd/system/kube-proxy.service"```

```sudo systemctl daemon-reload```

```sudo systemctl enable kube-proxy.service```

```sudo systemctl start kube-proxy.service```

```sudo systemctl status kube-proxy.service```

### To acces the dash board _you have to create ssh-tunnel_! Also on the master machine! no idea why!

```8001:141.22.45.42:8001```

* Access the Dashboard with localhost:8001/ui
