#!/bin/bash
DOCKERREPO=darkflib/kali-linux-rolling-metasploit
# Install dependencies (debootstrap)
sudo apt-get install debootstrap
# Fetch the latest Kali debootstrap script from git
curl "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=HEAD" > kali-debootstrap &&\
        sudo debootstrap kali-rolling ./kali-root http://http.kali.org/kali ./kali-debootstrap &&\
        # Import the Kali image into Docker
echo deb http://http.kali.org/kali kali-rolling main contrib non-free > ./kali-root/etc/apt/sources.list

# because we want to install from potentially multiple repos, we can use either multistrap or run a script.
# I choose the latter.

cat << EOF > ./kali-root/bootstrap.sh
#!/bin/bash

echo 'Running bootstrap script'

apt update
apt install metaspoit
echo 'Please run msfupdate to update the framework' >> /etc/motd
apt clean
EOF

sudo tar -C kali-root -c . | sudo docker import - ${DOCKERREPO}
# sudo rm -rf ./kali-root # &&\
   
# run the script
docker run -it ${DOCKERREPO} /bin/bash /bootstrap.sh

# Test the Kali Docker Image
docker run -it ${DOCKERREPO} cat /etc/debian_version &&\
        echo "Build OK" || echo "Build failed!"
