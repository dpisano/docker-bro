# docker-bro
Docker version of Bro to run with live network traffic.

This Dockerfile was inspired by Jon Schipp blog about running Bro in docker on live network traffic.

http://sickbits.net/running-bro-on-live-network-traffic-in-a-docker-container/

I started with what he had and fix some bugs that I ran into. After that I optimize the build process to make the  smallest possible image that I could.

To run this you should use the following command line options.

``-d --net=host -v /opt/bro/logs:/opt/bro/logs -v /opt/bro/spool:/opt/bro/spool`
