import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("localhost", 50000))
while True:
    data = input("please input your words:")
    client.sendall(bytearray(data, 'utf-8'))
    data = client.recv(1024)
    client.close()
    print("recieve: %s" % data)
