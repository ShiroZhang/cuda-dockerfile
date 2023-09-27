FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# 解决nvidia镜像源not signed问题
RUN apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

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

# 安装Pytorch
RUN pip install torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu118

# 解决SSH连接缺失环境变量的问题
COPY profile /etc/profile

# 安装openmpi4.0.7
COPY openmpi-4.0.7.tar.gz /root/tools/
RUN cd /root/tools/;tar -xzvf openmpi-4.0.7.tar.gz
RUN cd /root/tools/openmpi-4.0.7;./configure --prefix=/usr/local/openmpi;make -j16;make install

ENV MPI_HOME /usr/local/openmpi
ENV PATH ${MPI_HOME}/bin:$PATH
ENV LD_LIBRARY_PATH ${MPI_HOME}/lib:$LD_LIBRARY_PATH
ENV MANPATH ${MPI_HOME}/share/man:$MANPATH
ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1

# 安装NCCL
RUN apt install -y --allow-change-held-packages libnccl2=2.16.5-1+cuda11.8 libnccl-dev=2.16.5-1+cuda11.8

# 安装horovod
RUN apt install -y libpython3.8-dev
RUN HOROVOD_GPU_OPERATIONS=NCCL pip install --no-cache-dir horovod

# 声明端口号
EXPOSE 5901
EXPOSE 22
EXPOSE 8888

# 设置启动程序
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
