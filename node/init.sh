apt-get update
apt-get -y install curl
curl -fsSLo test.sh https://cdn.nosadnile.net/docker-init.sh
history -s "bash /test.sh"
bash
