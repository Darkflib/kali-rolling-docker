#!/bin/bash
DOCKERREPO=darkflib/kali-linux-rolling
# Install dependencies (debootstrap)
sudo apt-get install debootstrap
# Fetch the latest Kali debootstrap script from git
curl "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=HEAD" > kali-debootstrap &&\
        sudo debootstrap kali-rolling ./kali-root http://http.kali.org/kali ./kali-debootstrap &&\
        # Import the Kali image into Docker
echo deb http://http.kali.org/kali kali-rolling main contrib non-free > ./kali-root/etc/apt/sources.list
sudo tar -C kali-root -c . | sudo docker import - ${DOCKERREPO}
        # sudo rm -rf ./kali-root 
        # Test the Kali Docker Image
docker run -it --rm ${DOCKERREPO} cat /etc/debian_version &&\
        echo "Build OK" || echo "Build failed!"
