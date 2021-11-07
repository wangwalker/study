require 'socket'
require_relative '../common_handler'

module FTP
    CRLF = "\r\n"

    class ProcessPerConnection
        def initialize(port = 21)
            @control_socket = TCPServer.new(port)
            trap(:INT) {exit}
        end

        def gets
            @client.gets(CRLF)
        end

        def respond(message)
            @client.write(message)
            @client.write(CRLF)
        end

        def run
            loop do
                @client = @control_socket.accept
                
                pid = fork do
                    respond "220 OHAI with new subprocess"

                    handler = CommonHandler.new(self)

                    loop do
                        request = gets

                        if request
                            respond handler.handle(request)
                        else
                            @client.close
                            break
                        end
                    end
                end

                Process.detach(pid)
            end
        end
    end
end

server = FTP::ProcessPerConnection.new(4481)
server.run
