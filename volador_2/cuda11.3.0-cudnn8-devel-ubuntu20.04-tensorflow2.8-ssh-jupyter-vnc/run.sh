#!/bin/bash

# 设置账户密码
echo "root:$USER_PASSWD" | chpasswd
# 设置jupyterlab密码
echo c.ServerApp.password =\'`python3 -c "from jupyter_server.auth import passwd; print(passwd('$USER_PASSWD'),end='')"`\' >> /root/.jupyter/config/jupyter_lab_config.py

# 设置VNC密码
echo $USER_PASSWD | vncpasswd -f > /root/.vnc/passwd

# 启动 jupyter-lab、vnc、sshd
nohup jupyter lab &

vncserver -kill :1
rm -rf /tmp/.X1-lock /tmp/.X11-unix
vncserver -geometry 1920x1080 :1

/usr/sbin/sshd -D
