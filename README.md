docker-netns
=======

A quick hack to run commands in the docker container network namespace.
https://docs.docker.com/articles/runmetrics/

   $ dist/build/docker-netns/docker-netns -h
   Executes given command in the docker container's netwok namespace.

   Usage: docker-netns CONTAINER_ID EXECUTABLE [ARGS...]
     Wraps up some steps mentioned in https://docs.docker.com/articles/runmetrics/
     (ip netns section), needs sudo access.

   Available options:
     -h,--help                Show this help text

   E.g. docker-netns -- 9ef24eba0123 netstat -anp
