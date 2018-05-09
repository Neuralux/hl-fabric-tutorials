#!/usr/bin/env bash


set -e


##
# variables
docker_version=17.12.1
docker_compose_version=1.21.2
fabric_version=1.1.0
go_version=1.9.6
node_version=v8.9.4
npm_version=5.6.0
python_version=2.7.5
##


##
# yum update and essentials
mkdir -p /opt/fabric /opt/gopath
rm -rf /var/cache/yum
yum clean all
yum check-update || test $? -eq 100
yum upgrade -y
yum install -y device-mapper-persistent-data epel-release gcc gcc-c++ git lvm2 yum-utils
yum-config-manager --enable epel
cat <<- EOF >> /etc/bashrc
export GOROOT=/usr/local/go
export GOPATH=/opt/gopath
export PATH=/opt/fabric/fabric-samples/bin:\$GOPATH/bin:\$GOROOT/bin:/usr/local/bin:/opt/node/bin:\$PATH
EOF
source /etc/bashrc
##


##
# docker > 17.06.2-ce
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce-${docker_version}.ce-1.el7.centos
systemctl start docker
systemctl status docker
test "$(docker --version | awk '{print $3}')" = "${docker_version}-ce,"
##


##
# docker-compose > v1.14.0
curl -sSL https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
test "$(docker-compose --version | awk '{print $3}')" = "${docker_compose_version},"
##


##
# go = v1.10.x
curl -sSLO https://dl.google.com/go/go${go_version}.linux-amd64.tar.gz
tar xzf go${go_version}.linux-amd64.tar.gz
mv go /usr/local
rm -f go${go_version}.linux-amd64.tar.gz
test "$(go version)" = "go version go${go_version} linux/amd64"
##


##
# node > 8.9.x < 9.x
curl -sSLO https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz
tar -xf node-${node_version}-linux-x64.tar.xz
mv node-${node_version}-linux-x64 /opt
ln -s /opt/node-${node_version}-linux-x64 /opt/node
rm -f node-${node_version}-linux-x64.tar.xz
test "$(node --version)" = "${node_version}"
test "$(npm --version)" = "${npm_version}"
##


##
# python = v2.7.x
test "$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')" = "${python_version}"
##


##
# fabric-samples
cd /opt/fabric
curl -sSL https://goo.gl/6wtTN5 | bash -s ${fabric_version}
##


##
# vagrant user
usermod -a -G docker vagrant
chown -R vagrant:vagrant /opt/gopath /opt/fabric
sed -i /opt/fabric/fabric-samples/first-network/docker-compose-cli.yaml \
    -e 's/environment:/environment:\n      - GODEBUG=netdns=go/'
sed -i /opt/fabric/fabric-samples/first-network/base/peer-base.yaml \
    -e 's/environment:/environment:\n      - GODEBUG=netdns=go/'
sed -i /opt/fabric/fabric-samples/basic-network/docker-compose.yaml \
    -e 's/environment:/environment:\n      - GODEBUG=netdns=go/g'
sed -i /opt/fabric/fabric-samples/fabcar/package.json \
    -e 's/~//g'
sed -i /opt/fabric/fabric-samples/fabcar/package.json \
    -e 's/\^1.6.0/1.9.1/'
##


##
# system information
echo -e "\n---"

echo -e "\nHost OS":
cat /etc/*-release
uname -rvmpo

echo -e "\n"
docker --version

echo -e "\n"
docker-compose --version

echo -e "\n"
go version

echo -e "\n"
python --version

echo -ne "\nNodeJS Version: "
node --version

echo -ne "\nNPM Version: "
npm --version

test -d /opt/fabric/fabric-samples || exit 0

cd /opt/fabric/fabric-samples
echo -ne "\nGit repo: "
git remote -v | grep origin.*fetch | awk '{print $2}'
echo -ne "\nCommit SHA: "
git rev-parse HEAD

echo -e "\n---"
##
