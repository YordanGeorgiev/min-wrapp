FROM ubuntu:20.04

ARG UID
ARG GID

ENV PRODUCT_NAME="min-wrapp"
ENV PRODUCT_DIR="/opt/min-wrapp"
ENV USER="ubuntu"
ENV GROUP="ubuntu"
ENV TERM="xterm-256color"
ENV TZ="Etc/UTC"
VOLUME $PRODUCT_DIR

ENV TERM="xterm-256color"
ENV PS1="`date \"+%F %T\"` \u@\h  \w \n\n  "
ENV TZ="Etc/UTC"
ENV USER=ubuntu
ENV GROUP=ubuntu

RUN echo \n\
XKBMODEL="pc105" \n\
XKBLAYOUT="se" \n\
XKBVARIANT="" \n\
XKBOPTIONS="" \n\
BACKSPACE="guess" \n\
 > /etc/default/keyboard

# ubuntu 20.04 os utils
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && \
   apt-get install -y --no-install-recommends apt-utils
RUN export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
   apt-get install -y --no-install-recommends tzdata && \
   dpkg-reconfigure --frontend noninteractive tzdata
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y \
        lsb-release sudo curl net-tools wget bsdmainutils \
        git zip unzip build-essential linux-headers-5.4.0-1037-aws \
        perl make vim ufw jq snapd debconf-utils dialog telnet
RUN export DEBIAN_FRONTEND=noninteractive && apt-get clean all && apt-get install --fix-missing

# Enable host to container edit of proj code on ubuntu and mac.
RUN test -z $(getent group $GID | cut -d: -f1) || \
      groupmod -g $((GID+1000)) $(getent group $GID | cut -d: -f1)

RUN addgroup --gid $GID $GROUP
RUN adduser \
      --gid $GID \
      --shell "/bin/bash" \
      --home "/home/$USER" \
      --uid $UID \
      $USER && exit 0

RUN echo "$USER:1432@lAFk" | chpasswd
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USER


ADD --chown=$USER:$GROUP "." "/home/$USER/$PRODUCT_DIR"

WORKDIR $PRODUCT_DIR

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
