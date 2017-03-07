i2pd Docker container
=====================

Run I2P client in Docker container.

Based on Debian Jessie. By default, builds i2pd from `master` git branch.

Usage
-----

Install prerequisits and clone repository (on Ubuntu):

    sudo apt-get install git docker.io
    git clone https://github.com/l-n-s/i2pd-docker.git
    cd i2pd-docker

Customize `i2pd.conf` and `tunnels.conf` if you need to.

Building image:

    sudo docker build -t i2pd . 

You can customize `GIT_BRANCH` and `GIT_TAG` arguments like this:

    # build specific i2pd branch
    sudo docker build -t i2pd --build-arg GIT_BRANCH=openssl . 

    # or specific version
    sudo docker build -t i2pd --build-arg GIT_TAG=2.12.0 .

Run container with published `$I2PD_PORT` at host machine:

    # pick random free port (make sure it is not taken!)
    export I2PD_PORT=$RANDOM
    
    sudo docker run --name=i2pd-container -dt -p $I2PD_PORT:$I2PD_PORT/udp \
                -p $I2PD_PORT:$I2PD_PORT i2pd --port=$I2PD_PORT

To publish HTTP/Socks proxy and other ports, add `-p` keys to run command:

    sudo docker run --name=i2pd-container -dt -p 127.0.0.1:4444:4444 -p 127.0.0.1:4447:4447 \
                -p $I2PD_PORT:$I2PD_PORT/udp \
                -p $I2PD_PORT:$I2PD_PORT i2pd --port=$I2PD_PORT

Append i2pd config keys to the end of the run command to override default settings:

    sudo docker run .... --port=$I2PD_PORT --floodfill --reseed.urls="http://example.com/"

Watch container logs:

    sudo docker logs -t i2pd-container

Stop container:

    sudo docker stop i2pd-container
    

License
-------

Public Domain
