#!/usr/bin/env python3

from __future__ import annotations

import html
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import subprocess
import sys
from urllib.parse import urlparse


STATE = Path(sys.argv[1]).resolve()
DOCUMENT_ROOT = Path(sys.argv[2]).resolve()

STYLE = """
<style>
:root { color-scheme: light dark; }
body { max-width: 900px; margin: 2rem auto; padding: 0 1.5rem;
       font: 17px/1.65 system-ui, sans-serif; }
pre, code { font-family: ui-monospace, monospace; }
pre { overflow-x: auto; padding: 1rem; background: color-mix(in srgb, CanvasText 8%, Canvas); }
img { max-width: 100%; }
table { border-collapse: collapse; }
th, td { border: 1px solid color-mix(in srgb, CanvasText 25%, Canvas); padding: .35rem .65rem; }
blockquote { border-left: .25rem solid #888; margin-left: 0; padding-left: 1rem; color: #888; }
</style>
"""

RELOAD = """
<script>
let helixPreviewVersion = null;
setInterval(async () => {
  try {
    const next = await (await fetch('/version', {cache: 'no-store'})).text();
    if (helixPreviewVersion === null) helixPreviewVersion = next;
    else if (next !== helixPreviewVersion) location.reload();
  } catch (_) {}
}, 400);
</script>
"""


def render() -> bytes:
	try:
		result = subprocess.run(
			[
				"pandoc",
				"--from",
				"markdown",
				"--to",
				"html5",
				"--standalone",
				"--mathjax",
				str(STATE),
			],
			cwd=DOCUMENT_ROOT,
			check=True,
			capture_output=True,
			text=True,
		)
		page = result.stdout
	except (OSError, subprocess.CalledProcessError) as error:
		text = STATE.read_text(encoding="utf-8", errors="replace")
		page = f"<!doctype html><html><head></head><body><pre>{html.escape(text)}</pre><!-- {html.escape(str(error))} --></body></html>"
	page = page.replace("</head>", f"{STYLE}</head>")
	page = page.replace("</body>", f"{RELOAD}</body>")
	return page.encode()


class Handler(SimpleHTTPRequestHandler):
	def __init__(self, *args, **kwargs):
		super().__init__(*args, directory=str(DOCUMENT_ROOT), **kwargs)

	def log_message(self, _format: str, *_args: object) -> None:
		pass

	def do_GET(self) -> None:  # noqa: N802 - stdlib handler API
		path = urlparse(self.path).path
		if path == "/version":
			try:
				version = str(STATE.stat().st_mtime_ns).encode()
			except FileNotFoundError:
				version = b"missing"
			self.send_response(200)
			self.send_header("Content-Type", "text/plain")
			self.send_header("Cache-Control", "no-store")
			self.send_header("Content-Length", str(len(version)))
			self.end_headers()
			self.wfile.write(version)
			return
		if path in {"/", "/index.html"}:
			page = render()
			self.send_response(200)
			self.send_header("Content-Type", "text/html; charset=utf-8")
			self.send_header("Cache-Control", "no-store")
			self.send_header("Content-Length", str(len(page)))
			self.end_headers()
			self.wfile.write(page)
			return
		super().do_GET()


server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
print(f"http://127.0.0.1:{server.server_port}/", flush=True)
server.serve_forever()
