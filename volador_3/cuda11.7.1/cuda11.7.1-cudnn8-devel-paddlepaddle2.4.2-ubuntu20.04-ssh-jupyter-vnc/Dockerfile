FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# 替换ubuntu镜像源为国内USTC源
COPY ./sources.list /etc/apt/

# 更新软件包信息
RUN apt update

# 复制文件、安装python、pip
COPY ./get-pip.py /root/tools/
COPY ./pip.conf /root/.config/pip/
RUN apt install -y python3 python3-distutils
RUN python3 /root/tools/get-pip.py
RUN ln -s /usr/bin/python3.8 /usr/bin/python

# 设置时间
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

# 安装图形界面、tightvncserver
RUN DEBIAN_FRONTEND=noninteractive apt install -y xorg openbox xfce4 xfce4-goodies xfce4-terminal
RUN apt install -y tigervnc-standalone-server

# 配置VNC
ENV USER root
COPY xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

# 安装SSH
RUN apt install -y openssh-server

# 配置SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN ssh-keygen -A
RUN mkdir -p /run/sshd

# 安装JupyterLab
RUN pip install jupyterlab

# 配置JupyterLab
ENV JUPYTER_CONFIG_DIR /root/.jupyter/config
ENV JUPYTER_DATA_DIR /root/.jupyter/data
ENV JUPYTER_RUNTIME_DIR /root/.jupyter/runtime
RUN jupyter lab --generate-config
RUN sed -i "602a c.ServerApp.allow_root = True" /root/.jupyter/config/jupyter_lab_config.py
RUN sed -i "755a c.ServerApp.ip = '0.0.0.0'" /root/.jupyter/config/jupyter_lab_config.py
RUN sed -i "971a c.ServerApp.token = ''" /root/.jupyter/config/jupyter_lab_config.py

# 安装PaddlePaddle
RUN python3 -m pip install paddlepaddle-gpu==2.4.2.post117 -f https://www.paddlepaddle.org.cn/whl/linux/mkl/avx/stable.html

# 解决SSH连接缺失环境变量的问题
COPY profile /etc/profile

# 声明端口号
EXPOSE 5901
EXPOSE 22
EXPOSE 8888

# 设置启动程序
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
