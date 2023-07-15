from flask import Flask, Response, abort
from typing import Any, Generator
import docker

app = Flask(__name__)
client = docker.from_env()

# "Streams" the logs via a generator
# @app.route('/service/<name>/logs')
# def logs(name: str) -> Response:
#     try:
#         container: Any = client.containers.get(name)
#     except docker.errors.NotFound:
#         abort(404)

#     def generate() -> Generator[str, None, None]:
#         for line in container.logs(stream=True):
#             yield line

#     return Response(generate(), mimetype='text/plain')


@app.route('/service/<name>/logs')
def logs(name: str) -> Response:
    try:
        container: Any = client.containers.get(name)
    except docker.errors.NotFound:
        abort(404)
    except docker.errors.APIError as e:
        return Response(f"An error occurred: {str(e)}", status=500)
    except Exception as e:
        return Response(f"An unexpected error occurred: {str(e)}", status=500)

    logs = container.logs().decode('utf-8')  # Get all logs and decode them as a UTF-8 string
    return Response(logs, mimetype='text/plain')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)