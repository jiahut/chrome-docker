# Run Chrome in a container
#
# docker run -it \
#	--net host \ # may as well YOLO
#	--cpuset-cpus 0 \ # control the cpu
#	--memory 512mb \ # max memory it can use
#	-v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
#	-e DISPLAY=unix$DISPLAY \
#	-v $HOME/Downloads:/home/chrome/Downloads \
#	-v $HOME/.config/google-chrome/:/data \ # if you want to save state
#	--security-opt seccomp=$HOME/chrome.json \
#	--device /dev/snd \ # so we have sound
#   --device /dev/dri \
#	-v /dev/shm:/dev/shm \
#	--name chrome \
#	jess/chrome
#
# You will want the custom seccomp profile:
# 	wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O ~/chrome.json

# Base docker image
FROM ubuntu:20.04

COPY sources.list  /etc/apt/

# Install Chrome
RUN apt update && apt install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
  fonts-wqy-microhei \
	# hicolor-icon-theme \
	# libcanberra-gtk* \
	# libgl1-mesa-dri \
	# libgl1-mesa-glx \
	# libpangox-1.0-0 \
	# libpulse0 \
	# libv4l-0 \
	# fonts-symbola \
  # fonts-arphic-ukai \ 
  # fonts-arphic-uming \
  # fonts-ipafont-mincho \
  # fonts-ipafont-gothic \
  # fonts-unfonts-core  \
	--no-install-recommends

RUN	curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
	&& apt update && apt install -y \
	google-chrome-stable \
	--no-install-recommends 

# RUN apt install language-pack-zh* && apt install chinese*
RUN apt purge --auto-remove -y curl && rm -rf /var/lib/apt/lists/*

# Add chrome user
RUN groupadd -r chrome --gid 1000 && useradd -r -g chrome --uid 1000 -G audio,video chrome \
    && mkdir -p /home/chrome/Downloads && chown -R chrome:chrome /home/chrome

COPY local.conf /etc/fonts/local.conf

# Run Chrome as non privileged user
USER chrome

# CMD dbus-daemon --system --fork && google-chrome --user-data-dir=/data
# Autorun chrome
ENTRYPOINT [ "google-chrome" ]
CMD [ "--user-data-dir=/data" ]
