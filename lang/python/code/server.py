import socket, select, queue

def simple():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(("localhost", 50000))
    server.listen(1)
    while True:
        conn, address = server.accept()
        data = conn.recv(1024)
        conn.sendall(data)
        conn.close()

def complex():
    host_port = ('localhost', 50000)
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setblocking(0) # nonblocking
    server.bind(host_port)
    server.listen(5)
    inputs = [server]
    ouputs = []
    message_queues = {}
    print("launch server at %s: %d" % host_port)

    while inputs:
        readable, writeable, exceptional = select.select(
            inputs, ouputs, [])
        for s in readable:
            if s is server:
                conn, _ = s.accept()
                conn.setblocking(0)
                inputs.append(conn)
                message_queues[conn] = queue.Queue()
            else:
                data = s.recv(1024)
                if data:
                    message_queues[s].put(data)
                    if s not in ouputs:
                        ouputs.append(s)
                    inputs.remove(s)
                    s.close()
                    del message_queues[s]
        
        for s in writeable:
            try:
                next_message = message_queues[s].get_nowait()
            except:
                ouputs.remove(s)
            else:
                s.send(next_message)
        
        for s in exceptional:
            inputs.remove(s)
            if s in ouputs:
                ouputs.remove(s)
            s.close()
            del message_queues[s]

if __name__ == "__main__":
    complex()