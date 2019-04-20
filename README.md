
Zookeeper container.

To run standalone, non-persistent:

```
  docker run -p 2181:2181 cybermaggedon/zookeeper:3.4.14

```

To persist data, mount a volume on /data:

```
  docker run -p 2181:2181 -v /data/zookeeper:/data cybermaggedon/zookeeper:3.4.14

```

To run a cluster of Zookeepers, need to play with more settings, and take
control of hostname or IP address allocation:

```
  docker network create --driver=bridge --subnet=10.10.10.0/24 \
    my-zk-network

  docker run --rm --ip=10.10.10.10 --net my-zk-network \
      -e ZOOKEEPERS=10.10.10.10,10.10.10.11,10.10.10.12 \
      -e ZOOKEEPER_MYID=1 \
      --name zk1 -p 2181:2181 cybermaggedon/zookeeper:3.4.14
      
  docker run --rm -i -t --ip=10.10.10.11 --net my-zk-network \
      -e ZOOKEEPERS=10.10.10.10,10.10.10.11,10.10.10.12 \
      -e ZOOKEEPER_MYID=2 --name zk2 --link zk1:zk1 \
      cybermaggedon/zookeeper:3.4.14
      
  docker run --rm -i -t --ip=10.10.10.12 --net my-zk-network \
      -e ZOOKEEPERS=10.10.10.10,10.10.10.11,10.10.10.12 \
      -e ZOOKEEPER_MYID=3 --name zk3 --link zk1:zk1 \
      cybermaggedon/zookeeper:3.4.14

```

Source at <http://github.com/cybermaggedon/zookeeper-docker>.

