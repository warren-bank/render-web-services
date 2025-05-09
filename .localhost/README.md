#### localhost

* the content of this directory is an Easter egg
  - it has nothing to do with hosting [this _Dockerfile_](../Dockerfile) on [_render.com_](https://render.com/)
* these are the scripts that I used to test the container on my local machine
  - in VirtualBox
  - on [_DietPi_ v9.12](https://dietpi.com/)
* they are standalone
  - [_1-build.sh_](./1-build.sh)
    * downloads the rest of this branch of this repo
    * reads build arguments from [_build-args.txt_](./build-args.txt)
    * uses [`buildx`](https://github.com/docker/buildx) to build [this _Dockerfile_](../Dockerfile)
  - [_2-run.sh_](./2-run.sh)
    * runs the built container
      - remaps the following ports:
        * `22` to: `1022`
        * `80` to: `1080`

__notes__:

* VirtualBox is using bridged networking
  - the DietPi guest OS is assigned an IP address on the LAN&hellip; by DHCP on the router
* DietPi is running in text-only (non-graphical) mode
* to access servers:
  - using `localhost` from the DietPi guest OS is a pain
  - using the LAN IP from the host OS (or any other computer on the LAN) is much more convenient
