# Full debian-based install of MoveIt 2 using apt-get and source install of Ignition

ARG ROS_DISTRO=foxy
FROM ros:${ROS_DISTRO}-ros-base-focal
MAINTAINER Vatan Aksoy Tezer vatan@picknik.ai

# Commands are combined in single RUN statement with "apt/lists" folder removal to reduce image size
RUN apt-get update && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    apt-get install -y ros-${ROS_DISTRO}-moveit-* && \
    mkdir -p ~/ws_ignition/src && \
    cd ~/ws_ignition/src && \
    git clone https://github.com/vatanaksoytezer/ign-ci.git -b main && \
    vcs import < ign-ci/ignition.repos && \
    apt-get install -y python3-pip wget lsb-release gnupg curl python3-vcstool python3-colcon-common-extensions git  && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'  && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -  && \
    apt-get update  && \
    cd ~/ws_ignition/ && \
    apt-get install -y $(sort -u $(find . -iname 'packages-'`lsb_release -cs`'.apt' -o -iname 'packages.apt' | grep -v '/\.git/') | sed '/ignition\|sdf/d' | tr '\n' ' ') && \
    colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF && \
    rm -rf /var/lib/apt/lists/*
