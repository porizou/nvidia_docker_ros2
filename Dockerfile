# ベースイメージの設定
FROM nvidia/opengl:base-ubuntu22.04 

# 環境設定
ENV DEBIAN_FRONTEND=noninteractive

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release

# ROSのリポジトリをsource listに追加
ENV UBUNTU_CODENAME=focal
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

# ROS2のインストール
RUN apt-get update && apt-get install -y \
    ros-humble-desktop

# colconのインストール
RUN apt-get install -y python3-colcon-common-extensions

# Gazeboのインストール
RUN apt-get install -y gazebo \
    ros-humble-gazebo-*

# rqtのプラグインをインストール
RUN apt-get install -y ros-humble-rqt-*


# ワークスペースの作成
RUN mkdir -p ~/ros2_ws/src
WORKDIR /root/ros2_ws/
RUN /bin/bash -c '. /opt/ros/humble/setup.bash; colcon build'

# エントリーポイントを設定
COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]

ENV __NV_PRIME_RENDER_OFFLOAD=1
ENV __GLX_VENDOR_LIBRARY_NAME=nvidia
# コマンドを設定
CMD ["bash"]
