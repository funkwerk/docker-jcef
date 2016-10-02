[![Docker pulls](https://img.shields.io/docker/pulls/funkwerk/jcef.svg)](https://hub.docker.com/r/funkwerk/jcef/)
[![Docker Build](https://img.shields.io/docker/automated/funkwerk/jcef.svg)](https://hub.docker.com/r/funkwerk/jcef/)

# funkwerk-jcef

JCEF Browser Docker Image based on https://bitbucket.org/chromiumembedded/java-cef

## Usage

docker run -ti -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix funkwerk/jcef
