# TeamViewer
In dieser Dokumentation werden die Installationsschritte für TeamViewer, die Konfiguration und die Client-Seite erläutert.

## Inhalt
* TeamViewer
* Installation Host
* Konfiguration Host
* Installation Client


# TeamViewer
TeamViewer ist ein Programm, das es ermöglicht über das Netzwerk die GUI eines entfernten Computers auf den Clienten zu übertragen und auch auf ihm zu arbeiten. (Fancy ssh)

# Installation Server
*Konsole Öffnen und folgende Eingaben tätigen

> wget http://download.teamviewer.com/download/linux/version_11x/teamviewer-host_armhf.deb

*Im Verzeichnis der heruntergeladenen Datei folgendes ausführen
> sudo dpkg -i teamviewer-host_11.0.58397_armhf.deb 
* oder 
> sudo apt install <Download Location>


> sudo apt-get -f install


> sudo teamviewer setup

# Konfiguration Server
* Für die Konfiguration muss auf der Internetseite von TeamViewer der Benutzer erstellt werden
* Mit diesem ist auf dem Host die Anmeldung durchzuführen

# Installation Client
* Die TeamViewer Client Anwendung muss installiert werden
* Hier kann dann der Desktop des Hosts genutzt werden

