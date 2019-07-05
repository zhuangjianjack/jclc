import socket,time

def sent_msg(msg):
    # 创建 socket 对象
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 获取本地主机名
    #host = 'localhost'#socket.gethostname()

    # 设置端口号
    #port = 6666

    # 连接服务，指定主机和端口
    s.connect(('localhost', 6666))
    time.sleep(0.2)

    s.send(msg.encode("utf-8"))

    s.close()
