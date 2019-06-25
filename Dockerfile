FROM scratch
LABEL maintainer='ihipop <ihipop@gmail.com>'
ADD rootfs.tar.xz /

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install sudo -y && /usr/local/bin/clean-docker-img.sh
CMD ["/bin/bash"]