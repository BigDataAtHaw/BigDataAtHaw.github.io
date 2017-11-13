# Guacamole
In diesem Dokument werden die Schritte zur Installation von Guacamole auf dem Master des Clusters beschrieben

## Inhalt

## Installation

### Abhängigkeiten

#### Cairo
* Cairo is used by libguac for graphics rendering. Guacamole cannot function without Cairo installed.
> sudo apt-get install libcairo2-dev

#### libjpeg-turbo
* libjpeg-turbo is used by libguac to provide JPEG support. Guacamole will not build without this library present:
> sudo apt-get install libjpeg62-turbo-dev


#### libpng
* libpng is used by libguac to write PNG images, the core image type used by the Guacamole protocol. Guacamole cannot function without libpng.
> sudo apt-get install 	libpng12-dev

#### OSSP UUID
* OSSP UUID is used by libguac to assign unique IDs to each Guacamole connection. These unique IDs are the basis for connection sharing support.
> sudo apt-get install 	libossp-uuid-dev

#### FFmpeg
* The libavcodec, libavutil, and libswscale libraries provided by FFmpeg are used by guacenc to encode video streams when translating recordings of Guacamole sessions. 
> sudo apt-get install libavcodec-dev
> sudo apt-get install libavutil-dev
> sudo apt-get install libswscale-dev

#### FreeRDP
* FreeRDP is required for RDP support.
> sudo apt-get install libfreerdp-dev

#### Pango
* Pango is a text layout library which Guacamole's SSH and telnet support uses to render text.
> sudo apt-get install 	libpango1.0-dev

#### libssh2
* libssh2 is required for SSH support.
> sudo apt-get install libssh2-1-dev

#### libVNCServer
* libVNCServer provides libvncclient, which is required for VNC support.
> libvncserver-dev

#### OpenSSL
* OpenSSL provides support for SSL and TLS - two common encryption schemes that make up the majority of encrypted web traffic.

If you have libssl installed, guacd will be built with SSL support, allowing communication between the web application and guacd to be encrypted. This library is also required for SSH support for the sake of manipulating public/private keys.
> sudo apt-get install 	libssl-dev

#### libwebp
* libwebp is used by libguac to write WebP images.
> sudo apt-get install libwebp-dev

### Guacamole Source Code
* Guacamole stable herunterladen, von der Website

> tar -xzf guacamole-server-0.9.13-incubating.tar.gz
> cd guacamole-server-0.9.13-incubating/

>  ./configure --with-init-dir=/etc/init.d
* The --with-init-dir=/etc/init.d shown above prepares the build to install a startup script for guacd into the /etc/init.d directory, such that we can later easily configure guacd to start automatically on boot.

> make

> make install


# Guacamole Client : http://guacamole.incubator.apache.org/doc/gug/installing-guacamole.html

## Einstellungen
