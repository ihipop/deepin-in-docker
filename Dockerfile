FROM scratch
LABEL maintainer='ihipop <ihipop@gmail.com>'
ADD rootfs.tar.xz /

ARG DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash"]