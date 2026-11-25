"""Run the hydrogen Git library in Chaos Lab. Requires Git and Python 3.9+."""
import argparse
import base64
import functools
import json
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import subprocess
import tempfile
import webbrowser

ROOT = Path(__file__).resolve().parent
STUDIO_REV = "762789c127828d9c62ded5e4c1e0ce785ea2f9a4"
STUDIO_REPO = "https://github.com/wa200508/chaos_lab.git"


def git(*args, data=None):
    return subprocess.check_output(["git", "-C", str(ROOT), *args], input=data)


def library():
    refs = {}
    # A fresh clone has only main locally. Include the other origin heads.
    for prefix in ("refs/remotes/origin/", "refs/heads/"):
        for line in git("for-each-ref", "--format=%(refname) %(objectname)", prefix).decode().splitlines():
            ref, oid = line.split()
            branch = ref[len(prefix):]
            if branch != "HEAD":
                refs[branch] = oid
    revisions = ("\n".join(set(refs.values()))+"\n").encode()
    pack = git("pack-objects", "--stdout", "--revs", data=revisions)
    return json.dumps(dict(refs=refs, pack=base64.b64encode(pack).decode())).encode()


def run():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dashboard", type=Path, help="Local Chaos Lab dist directory")
    parser.add_argument("--port", type=int, default=4174)
    parser.add_argument("--no-open", action="store_true")
    args=parser.parse_args()
    dist=args.dashboard
    if dist is None:
        cache=Path(git("rev-parse","--absolute-git-dir").decode().strip())/"chaos-studio"/STUDIO_REV
        dist=cache/"dist"
        if not (dist/"index.html").exists():
            cache.parent.mkdir(parents=True,exist_ok=True)
            with tempfile.TemporaryDirectory(dir=cache.parent) as tmp:
                checkout=Path(tmp)/"checkout"
                subprocess.run(["git","init","-q",str(checkout)],check=True)
                subprocess.run(["git","-C",str(checkout),"fetch","-q","--depth=1",STUDIO_REPO,STUDIO_REV],check=True)
                subprocess.run(["git","-C",str(checkout),"checkout","-q","FETCH_HEAD","--","dist"],check=True)
                cache.mkdir(exist_ok=True)
                (checkout/"dist").rename(dist)
    snapshot=library()

    class Handler(SimpleHTTPRequestHandler):
        def do_GET(self):
            if self.path == "/model-library.json":
                self.send_response(200)
                self.send_header("Content-Type","application/json")
                self.send_header("Cache-Control","no-store")
                self.send_header("Content-Length",str(len(snapshot)))
                self.end_headers()
                self.wfile.write(snapshot)
            else:
                super().do_GET()

    server=ThreadingHTTPServer(("127.0.0.1",args.port),functools.partial(Handler,directory=str(dist)))
    url=f"http://127.0.0.1:{server.server_port}/?library=hydrogen_wavefunction"
    print(url,flush=True)
    if not args.no_open: webbrowser.open(url)
    try: server.serve_forever()
    except KeyboardInterrupt: pass
    finally: server.server_close()


if __name__ == "__main__": run()
