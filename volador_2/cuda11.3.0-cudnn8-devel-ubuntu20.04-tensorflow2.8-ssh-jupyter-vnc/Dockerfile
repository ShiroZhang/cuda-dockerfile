FROM c8ff2e8cf112

RUN apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
# 替换镜像源
COPY sources.list /etc/apt/sources.list

# 更新软件源
RUN apt update

# 安装pip
RUN DEBIAN_FRONTEND=noninteractive apt install -y python3-pip
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 安装tensorflow2.8
# RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip install tensorflow==2.8.0

# 设置软链接
RUN ln -s /usr/bin/python3.8 /usr/bin/python

# 安装远程图形界面程序、xfce桌面环境
RUN DEBIAN_FRONTEND=noninteractive apt install -y xorg openbox xfce4 xfce4-goodies 
RUN DEBIAN_FRONTEND=noninteractive apt install -y vim net-tools firefox

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

# 配置XRDP
#RUN adduser xrdp ssl-cert
#RUN echo "exec startxfce4" >> /etc/xrdp/xrdp.ini
#RUN sed -i "s@KillDisconnected=false@KillDisconnected=1@g" /etc/xrdp/sesman.ini
# 解决连接闪退
#RUN echo "xfce4-session" > ~/.xsession

# 配置VNC、xfce
ADD xstartup /root/.vnc/xstartup
RUN chmod 755 /root/.vnc/xstartup
ADD xfce-stripes.png /usr/share/backgrounds/xfce/xfce-stripes.png
ADD helpers.rc /root/.config/xfce4/helpers.rc 

# 复制服务执行文件
RUN mkdir -p /run/sshd
ADD run.sh /run.sh
RUN chmod 755 /run.sh

EXPOSE 22
EXPOSE 8888
#EXPOSE 3389
EXPOSE 5901

#ENTRYPOINT /run.sh

