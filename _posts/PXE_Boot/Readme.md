# PXE Boot

Damit die Slaves später über den Master auch neu aufgesetzt werden können, wollen wir die Slaves so konfigurieren, dass sie vom Master booten. Auf diese Weise kann ein Betriebssystem geladen werden, ohne dass ein Datenträger (Festplatte, Diskette, CD etc.) auf dem Rechner (Client) benötigt wird. Alternativ kann man beispielsweise eine "Rettungsdistribution" laden, um sein System wieder herzustellen.

## Inhalt

* Einrichten des NFS-Servers
* TFTP-Server
* Einrichtung PXE System




### Einrichten des NFS-Servers

Damit Ubuntu-Live-Images oder ganze Distribuntionen funktionieren, muss ein NFS-Server aufgesetzt werden. Ansonsten könnten Änderungen nicht gesichert werden.

> sudo apt-get install nfs-kernel-server 


* Nach der Installation muss (für jede freizugebende Distribution) dann eine NFS-Freigabe erstellt werden.

> sudo mkdir /var/lib/tftp/Freigabe_einer_Distribution 

* In der Datei /etc/exports muss noch folgende Zeile angehängt werden. Diese gibt das Verzeichnis /var/lib/tftp/Freigabe_einer_Distribution und seine Unterverzeichnisse für alle IP-Adressen von 192.168.178.0 bis 192.168.178.255 mit Lese- und Schreibzugriff frei.

> /var/lib/tftp/Freigabe_einer_Distribution 192.168.178.0/255.255.255.0(rw,no_root_squash,sync,no_subtree_check)

* Mit dem folgenden Befehl[3][5] wird dann die /etc/exports neu eingelesen:

> sudo service nfs-kernel-server reload 

### TFTP-Server

#### Verzeichnisstruktur
* /var/lib/tftp/ ist das Rootverzeichnis des tftp-Servers. Hier werden die Kernel bzw. die zu bootenden Daten hinterlegt. Des Weiteren muss dieses Verzeichnis das Konfigurationsverzeichnis pxelinux.cfg beinhalten, es wird nicht automatisch erstellt und muss manuell angelegt werden.

* /var/lib/tftpboot/pxelinux.cfg/ ist das Konfigurationsverzeichnis. Darin muss die Datei default enthalten sein. Auch werden hier alle clientspezifischen Konfigurationen abgelegt. Die Datei default wird nicht automatisch erstellt, sondern muss manuell angelegt werden, zur Syntax siehe unter "Beispielkonfigurationen".

* /var/lib/tftp/Freigabe_einer_Distribution/ - dieses Verzeichnis ist das Rootverzeichnis des Clients in der jeweiligen gebooteten Distribution.

#### Die KOnfigurationsdateien
 Es gibt zum einen die Datei mit dem Namen default. Diese Datei wird immer geladen, wenn keine client-spezifische Konfigurationsdatei gefunden werden kann. Somit kommen wir zu den client-spezifischen Dateien. Diese Dateien sind auf identische Art und Weise zu erstellen [3] wie die default-Datei, haben jedoch einen anderen Dateinamen.

Diese Dateinamen, können entweder die MAC-Adresse der clientseitigen Netzwerkkarte mit vorangestellter 01 sein (01-XX-XX-XX-XX-XX-XX) oder die IP des Clients in hexadezimaler Form. Beispielweise entspricht die IP-Adresse 192.0.2.91 dem hexadezimalem Wert/Dateiname C000025B. wobei dieser Dateiname auch am Ende gekürzt werden kann, um eine Konfiguration auch für mehrere Clients zu haben. Dies wird Anhand des folgenden grauen Kastens aufgezeigt, denn in diesem Kasten wird die Reihenfolge der Konfigurationsdateiaufrufe angeführt. Wenn eine Konfigurationsdatei nicht vorhanden ist, dann wird die Nächste aufgerufen (in /var/log/syslog wird die Wahl auch vermerkt).

    /var/lib/tftpboot/pxelinux.cfg/01-88-99-aa-bb-cc-dd
    /var/lib/tftpboot/pxelinux.cfg/C000025B
    /var/lib/tftpboot/pxelinux.cfg/C000025
    /var/lib/tftpboot/pxelinux.cfg/C00002
    /var/lib/tftpboot/pxelinux.cfg/C0000
    /var/lib/tftpboot/pxelinux.cfg/C000
    /var/lib/tftpboot/pxelinux.cfg/C00
    /var/lib/tftpboot/pxelinux.cfg/C0
    /var/lib/tftpboot/pxelinux.cfg/C
    /var/lib/tftpboot/pxelinux.cfg/default

#### Beispiele

##### Minimal Konfiguration
Bei dieser Konfigurationsdatei wird als Defaultwert das Label memtest gewählt. Da keine weiteren Parameter wie PROMPT oder TIMEOUT angegeben sind, wird direkt memtest und damit der Kernel mt86plus im Verzeichnis memtest/ aufgerufen.

    DEFAULT    memtest
    
    LABEL      memtest
    KERNEL     memtest/mt86plus

##### Ohne Menü

Bei dieser Konfiguration kommen zusätzlich noch die Parameter PROMPT und TIMEOUT hinzu. Wenn PROMPT auf 1 gesetzt, erscheint eine Eingabezeile beim Bootvorgang, in der dann das zu bootende Label eingegeben werden kann. Bei dem Parameter TIMEOUT handelt es sich um die Zeitangabe, wie lange auf eine Eingabe gewartet werden soll, bevor das mit DEFAULT gesetzte LABEL aufgerufen wird. Die Einheit für TIMEOUT ist 1/10 Sekunde.

* Beispiel:

Würde man memtest in die Befehlszeile eintippen, dann würde sofort der Kernel mt86plus gestartet werden. andernfalls würde die Ubuntu LiveDVD nach 10 Sekunden geladen werden.

Des Weiteren, sieht man an dieser Stelle das erste Mal den Parameter APPEND. Mit diesem Parameter werden dem Kernel zusätzliche Informationen übergeben, beispielsweise, dass der Rootverzeichnis des Clients im Verzeichnis "192.168.178.2:/var/lib/tftp/ubuntu-1404" zu finden ist.

    DEFAULT ubuntu-1404
    PROMPT 1
    TIMEOUT 100

    LABEL      ubuntu-1404
    KERNEL     ubuntu-1404/casper/vmlinuz.efi
    APPEND     root=/dev/nfs boot=casper netboot=nfs nfsroot=192.168.178.2:/var/lib/tftp/ubuntu-1404 initrd=ubuntu-1404/initrd.lz
    
    LABEL      memtest
    KERNEL     memtest/mt86plus



Man kann pxelinux auch dazu anweisen, eine Textdatei vor dem Prompt anzuzeigen. Die hierzu benötigte Direktive lautet DISPLAY, gefolgt von einem Leerzeichen und dem Namen der Textdatei. Ebenfalls lassen sich, wie von diversen Linux Installations-CDs (z.B. Debian) bekannt, auch die Funktionstasten belegen. Hierzu nutzt man den Namen der Funktionstaste als Direktive, sprich F1 bis F10, ebenfalls gefolgt von einem Leerzeichen und einem Dateinamen.

##### Mit menu.c32

 Wenn man es etwas komfortabler haben möchte, kann man mit Hilfe von menu.c32 auch ein einfaches Menü erstellen. Hier jedoch zuvor die Datei /usr/lib/syslinux/menu.c32 in das Rootverzeichnis des TFTP-Servers kopieren oder eine Verknüpfung erstellen, in unserem Falle nach: /var/lib/tftp/.

Das ^ markiert in dem Menü den "HotKey" zur Anwahl der entsprechenden Zeile. (Bei dem Tastaturlayout "Deutsch" ist diese Taste nicht belegt! Näheres siehe Spracheinstellungen.)

An dieser Stelle ist in der Beispielkonfiguration nur ein sehr einfaches Menü angelegt worden. Auf dieser Seite {en} lassen sich die vielfältigen Einstellmöglichkeiten bezüglich des Menüs nachlesen.


    DEFAULT menu.c32
    ALLOWOPTIONS 0
    PROMPT 0
    TIMEOUT 0
    
    MENU TITLE Server PXE Boot Menu
    
    LABEL      ubuntu-1404
    MENU LABEL Ubuntu ^14.04 Desktop Live
    KERNEL     ubuntu-1404/casper/vmlinuz.efi
    APPEND     root=/dev/nfs boot=casper netboot=nfs nfsroot=192.168.178.2:/var/lib/tftp/ubuntu-1404 initrd=ubuntu-1404/initrd.lz
    
    LABEL      memtest
    MENU LABEL ^Memtest86+ v2.11
    KERNEL     memtest/mt86plus


### Einrichtung des PXE-Systems

Die folgenden Konfigurationsbeispiele sind für menu.c32 Menüs gedacht.

#### Lokales System booten

Um über PXE vom lokalen System zu booten, gibt es die Anweisung "LOCALBOOT 0". Hierfür sind die folgenden Zeilen in die Konfigurationsdatei einzufügen. 

    LABEL      localhdd1
    MENU LABEL Local ^HDD
    LOCALBOOT  0

Das Booten des lokalen Systems über PXE mag zwar auf den ersten Blick unsinnig erscheinen, jedoch macht es Sinn, wenn der Client nicht die Möglichkeit hat, über einen Hotkey beim Booten über die Netzwerkkarte zu booten und man sich das Umstellen im BIOS ersparen will. Des Weiteren wäre es denkbar, dass man dem Benutzer nicht die Möglichkeit geben will, in das Bios zu gelangen bzw. die Bootreihenfolge zu ändern.


#### Memtest86+

Memtest86+ ist ein Programm, mit dem man den Arbeitsspeicher eines PCs auf Fehler überprüfen kann. Es eignet sich hervorragend zum Testen der Einstellungen des DHCP- sowie des TFTP-Servers, da man keine großen Kopieraktionen oder andere großartige Manipulationen an den PXE-Einstellungen vornehmen muss. Des Weiteren ist dieses Programm auf vielen Linux-CDs wie auch auf der Ubuntu Desktop CD zu finden.

Zuerst erstellt man im Verzeichnis tftp das Unterverzeichnis memtest und kopiert anschließend die Datei mt86plus von der Ubuntu-CD/DVD dort hinein. Die Datei mt86plus ist auf der Ubuntu CD im Verzeichnis /install zu finden.

> sudo mkdir /var/lib/tftp/memtest && sudo cp /path-to-ubuntu-cd/install/mt86plus /var/lib/tftp/memtest/ 

Anschließend noch in der default Konfigurationsdatei unter /var/lib/tftp/pxelinux.cfg/ folgende Zeilen anzufügen

    LABEL      memtest
    MENU LABEL ^Memtest86+ v2.11
    KERNEL     memtest/mt86plus

> sudo service dnsmasq restart 

und nach einem Neustart von Dnsmasq, kann es dann auch schon mit dem ersten PXE-Boot losgehen.

#### Ubuntu NetInstall

Für Ubuntu NetInstall wird auf den Artikel PXE-Installation verwiesen, da an dieser Stelle schon eine gute Anleitung speziell für diesen Fall vorhanden ist.

#### Ubuntu-Live-DVD

Verwendet werden kann jede Live-DVD von Ubuntu und all seinen Derivaten. Dieses muss lediglich heruntergeladen werden und wird für die folgende Veranschaulichung in /home/Benutzer/Downloads abgelegt

Als nächstes muss dieses nun ausgelesen und in das TFTP-Server-Verzeichnis kopiert werden. Dies geschieht mit folgendem Befehl 

> sudo mount /home/Benutzer/Downloads/ubuntu.iso /mnt
> sudo cp -R /mnt /var/lib/tftp/ubuntu-live 


Danach muss die /var/lib/tftp/pxelinux.cfg/default angepasst und folgende Zeilen hinzugefügt werden:

    LABEL       ubuntu-live
    MEMU LABEL  ^Ubuntu-Live-DVD 14.04          # Nur wenn menu.c32 benutzt wird!
    KERNEL      ubuntu-live/casper/vmlinuz.efi
    APPEND      root=/dev/nfs boot=casper netboot=nfs nfsroot=192.168.178.2:/var/lib/tftp/ubuntu-live/ initrd=ubuntu-live/casper/initrd.lz quiet splash --

#### Ubuntu Diskless

Es gibt diverse Möglichkeiten, eine komplette Ubuntuinstallation über das Netzwerk zu booten:

    debootstrap (um direkt eine Installation über das Netzwerk aufzusetzen)

    die Installation des Servers kopieren

    [K/X]Ubuntu auf dem Client von CD installieren. Nachdem Alles installiert ist und läuft, das Netzlaufwerk /var/lib/tftp/NFS-Freigabe mounten und das komplette System dorthin kopieren.

siehe dafür Ubuntu.com













