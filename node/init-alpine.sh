apk add curl bash
curl -fsSLo test.sh https://cdn.nosadnile.net/docker-init.sh
PS1="[\u@\h $(pwd)]\$ "
echo "PS1=\"[\\u@\\h \\\$(pwd)]\$ \"" > $HOME/.bashrc
bash
