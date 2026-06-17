#!/usr/bin/env python3
from http.server import HTTPServer, SimpleHTTPRequestHandler
import sys


class Godot4RequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        super().end_headers()


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    server_address = ("localhost", port)
    httpd = HTTPServer(server_address, Godot4RequestHandler)
    httpd.serve_forever()
