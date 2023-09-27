FROM c8ff2e8cf112

RUN apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
# 替换镜像源
COPY sources.list /etc/apt/sources.list

# 更新软件源
RUN apt update

# 安装pip
RUN DEBIAN_FRONTEND=noninteractive apt install -y python3-pip
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 设置软链接
RUN ln -s /usr/bin/python3.8 /usr/bin/python

# 安装远程图形界面程序
RUN DEBIAN_FRONTEND=noninteractive apt install -y gnome-session-flashback gnome-terminal nautilus gnome-settings-daemon 

# 安装tightvncserver、xrdp
RUN apt install -y tightvncserver
ENV USER root

# 安装SSH、Jupyter-lab
RUN apt install -y openssh-server
RUN pip install jupyterlab 

# 设置时间
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

ADD profile /etc/profile 
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.3"

# 添加参数ssh支持root登录
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN ssh-keygen -A

# 配置jupyterlab默认存储路径
ENV JUPYTER_CONFIG_DIR /root/.jupyter/config
ENV JUPYTER_DATA_DIR /root/.jupyter/data
ENV JUPYTER_RUNTIME_DIR /root/.jupyter/runtime

RUN jupyter lab --generate-config
RUN sed -i "602a c.ServerApp.allow_root = True" /root/.jupyter/config/jupyter_lab_config.py
RUN sed -i "755a c.ServerApp.ip = '0.0.0.0'" /root/.jupyter/config/jupyter_lab_config.py
RUN sed -i "971a c.ServerApp.token = ''" /root/.jupyter/config/jupyter_lab_config.py

# 安装locales
RUN apt install -y locales
RUN locale-gen en_US.utf8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8


# 配置VNC、xfce
ADD xstartup /root/.vnc/xstartup
RUN chmod 755 /root/.vnc/xstartup

# 复制服务执行文件
RUN mkdir -p /run/sshd
ADD run.sh /run.sh
RUN chmod 755 /run.sh

EXPOSE 22
EXPOSE 8888
EXPOSE 5901
