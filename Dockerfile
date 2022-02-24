# Full debian-based install of MoveIt 2 using apt-get and source install of Ignition

ARG ROS_DISTRO=foxy
FROM ghcr.io/ros-planning/moveit2:${ROS_DISTRO}-release
MAINTAINER Vatan Aksoy Tezer vatan@picknik.ai

# Commands are combined in single RUN statement with "apt/lists" folder removal to reduce image size
RUN echo "deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub $(lsb_release -cs) robotpkg" | sudo tee /etc/apt/ sources.list.d/robotpkg.list && \
    curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | sudo apt-key add - && \
    apt-get -q update && \
    apt-get -q -y dist-upgrade && \
    apt-get install -y robotpkg-pinocchio && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    mkdir -p ~/ws_ros/src && \
    cd ~/ws_ros/src && \
    git clone https://github.com/vatanaksoytezer/ign-ci.git -b main && \
    apt-get install -y python3-pip && \
    rosdep update && \
    DEBIAN_FRONTEND=noninteractive \
    rosdep install -y --from-paths . --ignore-src --rosdistro ${ROS_DISTRO} --as-root=apt:false  && \
    rm -rf ~/ws_ros && \
    rm -rf /var/lib/apt/lists/*
