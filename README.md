# docker-drill
Apache Drill docker image for development and testing purposes. https://hub.docker.com/r/zhicwu/drill/ 

## What's inside
```
ubuntu:14.04
 |
 |--- zhicwu/java:8
       |
       |--- zhicwu/drill:latest
```
* Official Ubuntu Trusty(14.04) docker image
* Oracle JDK 8 latest release
* [Apache Drill](http://drill.apache.org/) 1.5.0

## How to use
- Pull the image
```
# docker pull zhicwu/drill
```
- Setup scripts
```
# git clone https://github.com/zhicwu/docker-drill.git
# cd docker-drill
# chmod +x *.sh
```
- Edit drill-cluster-env.sh
- Start Drill
```
# ./start-drill.sh
# docker logs -f my-drill
```
You can now access its web console via http://hostname:8047.

## How to build
```
# git clone https://github.com/zhicwu/docker-drill.git
# cd docker-drill
# chmod +x *.sh
# docker build -t zhicwu/drill .