# Hyperledger Fabric Tutorials

1. Provision a vm with all of the [prerequisites](http://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html); [binaries and docker images](http://hyperledger-fabric.readthedocs.io/en/latest/install.html); and the [fabric-samples](https://github.com/hyperledger/fabric-samples/tree/master/first-network/base) repository:
    ```
      $: vagrant up
    ```
1. [Build Your First Network](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html):
    ```
      $: vagrant ssh
      [vagrant@localhost ~]$ cd /opt/fabric/fabric-samples/first-network
      [vagrant@localhost first-network]$ ./byfn.sh up
    ```
1. [Writing Your First Application](http://hyperledger-fabric.readthedocs.io/en/latest/write_first_app.html):
    ```
      [vagrant@localhost first-network]$ ./byfn.sh down
      [vagrant@localhost first-network]$ cd /opt/fabric/fabric-samples/fabcar
      [vagrant@localhost fabcar]$ npm install
      [vagrant@localhost fabcar]$ ./startFabric.sh
    ```
