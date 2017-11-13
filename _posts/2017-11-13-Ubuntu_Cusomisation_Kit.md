# Ubuntu Customization Kit

## Inhalt
 * Installation
 * Entwickler Quelle
 * CD-Image
 * Benutzung
 * Sprache
 * Desktop
 * ISO
 * Paketauswahl
 * Benutzereinstellungen
 * Fertigstellung

### Installation
> sudo apt-get install uck 

### Entwickler Quelle
Um den Startbildschirm des Installationsmediums auf eine beliebige Sprache umstellen zu können, muss in der eigenen sources.list die Zeile für die Entwicklerpakete der Hauptkomponente der jeweiligen Ubuntu-Versions-Quelle freigeschaltet sein [1]. Bei Ubuntu 14.04 Trusty ist dies beispielsweise:

> deb-src http://de.archive.ubuntu.com/ubuntu trusty main

### CD-Image
Es wird eine ISO-Datei einer Desktop- oder Alternate-CD benötigt, die – wie im Artikel Downloads beschrieben – der Rechner-Architektur entsprechen muss (z.B. ubuntu-14.04-desktop-i386.iso). Alternativ kann man auch das inoffizielle Ubuntu Mini Remix {en} verwenden.

### Benutzung
UCK kann per Dash bzw. bei Ubuntu-Varianten mit einem Anwendungsmenü über den Menü-Eintrag "Anwendungen -> Systemwerkzeuge -> Ubuntu Customization Kit" gestartet werden.[2] Der Befehl im Terminal lautet uck-gui. Es öffnen sich ein Terminal und ein Fenster, in dem alle weiteren Schritte (in Englisch) erklärt werden.

### Sprache
Zuerst werden die Sprachpakete ausgewählt, die später auf dem Desktop zur Verfügung stehen sollen, anschließend die Pakete, die schon während des Startvorgangs bereitstehen sollen (z.B. "de" für Deutsch und "en" für Englisch).

### Desktop
Nun kann gewählt werden, ob eine typische Unity-, GNOME- oder KDE-Umgebung gewünscht ist oder anhand eines anderen ISO-Image der Vorgang fortgesetzt werden soll. Xfce- und LXDE-Nutzer wählen hier "Others".

### Iso
Nun kann die ISO-Datei, auf deren Basis die persönliche Anpassung vorgenommen werden soll, gewählt werden und man kann einen maximal 32 Buchstaben langen Namen für die neue CD/DVD eingeben, beispielsweise mein-desktop-i386-DATUM.iso.

Anschließend wählt man zwischen manueller oder automatischer Fortsetzung der Prozedur.
* Manuell ("yes"): Pakete können hinzugefügt oder entfernt und eine chroot-Umgebung genutzt werden
* Automatisch ("no"): Die Standardpakete der zuvor gewählten Live-CD werden installiert

### Paketauswahl
Wurde manuelles Erstellen der Live-CD ausgewählt, dann gibt es die Möglichkeit, mit "Run console application" ein Terminal[3] in einer chroot-Umgebung des Live-Systems zu öffnen. Dort kann man zusätzliche Programmpakete installieren[4] oder vorhandene deinstallieren. Es ist möglich, als erstes eine grafische Paketverwaltung wie Synaptic zu installieren. Dazu aktiviert[1] man die Paketquelle universe und, falls für andere Programme noch benötigt, auch multiverse und aktualisiert die Paketquellen:

> add-apt-repository universe
> add-apt-repository multiverse
> apt-get update

Danach kann man Programme wie Synaptic installieren[4] und aufrufen[2]:

> apt-get install synaptic
> synaptic

 Nach der Installation der benötigten Software kann man Synaptic schließen, um im Terminal eventuell mit weiteren Änderungen fortzusetzen. Darüber können alle weiteren Programme gestartet werden, beispielsweise um Konfigurationsdateien zu bearbeiten oder Benutzer und Gruppen anzulegen[5].

Möchte man Pakete installieren, die sich nicht in den Quellen befinden, können entsprechende .deb-Dateien[6] in ein Unterverzeichnis von ~/tmp/remaster-root/ kopiert werden. Sie stehen dann in der chroot-Umgebung zur Verfügung. Natürlich können auch andere Daten, wie Bilder, Texte usw. auf diese Weise hinzugefügt werden. Dabei sollte nichts im ~/tmp/remaster-root/home/-Ordner abgelegt werden, da dieses Verzeichnis später überschrieben wird. Ein geeigneter Ort ist zum Beispiel /opt.

Je nach gewähltem Installationsumfang wird das Image unter Umständen zu groß (>700MB) für eine CD. In solch einem Fall lassen sich mit UCK auch bootfähige DVDs erstellen, mit denen sich das System wie gewohnt installieren lässt. Vor dem Brennvorgang ist einfach ein der Installationsgröße entsprechendes Medium einzulegen.

### Benutzereinstellungen

 Auf der Live-CD gibt es natürlich keinen Benutzer im eigentlichen Sinne. Also werden Änderungen an /home/* grundsätzlich ignoriert. Dennoch existiert der Benutzer ubuntu, und der hat auch ein /home/ubuntu/ auf der Live-CD. Wenn man nun Änderungen an dieser vordefinierten Umgebung vornehmen will, sollte man dies in dem Verzeichnis tun, welches als Grundlage für jeden neuen Nutzer dient. In /etc/skel/ wird ein solches "skeleton" - also Skelett - angelegt. Wenn man z.B. einen Programm-Starter als Desktop-Icon nach einem Live-Start zur Verfügung stellen will, erstellt man das Verzeichnis /etc/skel/Desktop/. Dort erstellt man dann einen Link auf das eigentliche Programm und schon liegt ein zusätzliches Icon auf dem Standard-Desktop, mit dem man dieses Programm starten kann.

Auf diese Weise könnte man auch eine Arbeitsumgebung sichern oder klonen: man erstellt einen Benutzer und generiert dort alle Einstellungen, die später als Standard dienen sollen. Anschließend wird dieses Homeverzeichnis nach /etc/skel/ kopiert und das Image ist fertig. Damit können z.B. 100 Arbeitsplätze einer Firma mit einem "Standard-Ubuntu" ausgerüstet werden, bei dem der Support genau weiß, wie es eingerichtet ist.

### Fertigstellung
 Mit dem Befehl exit verlässt man die Konsole wieder. Wenn man danach "Continue building" wählt, beginnt die Erstellung des neuen ISO-Abbildes. Von jetzt an wird der Prozessor des Rechners belastet und die ISO-Datei erzeugt. Den aktuellen Status kann man im Terminal verfolgen.

Ist alles erfolgreich abgeschlossen, wird der Ordner ~/tmp/remaster-new-files angegeben, der die ISO-Datei enthält. Diese sollte umgehend an einen sicheren Ort kopiert oder mit Root-Rechten verschoben werden, da der nächste Start von UCK den Ordner mit der ISO-Datei ungefragt überschreibt.

Um CD-/DVD-Rohlinge zu sparen, bietet es sich an, die ISO-Datei zunächst in einer virtualisierten Umgebung zu testen, beispielsweise mit QEMU oder VirtualBox.

Die fertige ISO-Datei kann mit einem Brennprogramm auf ein leeres Medium gebrannt werden oder man benutzt einen USB-Stick, um die angepasste Ubuntu Version zu starten. 
