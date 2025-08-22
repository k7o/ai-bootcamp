# Python Jupyter Devcontainer

This repository contains a VS Code devcontainer configured for Python development with JupyterLab.


How to use

- Install the VS Code Remote - Containers extension (Dev Containers).
- Open this folder in VS Code.
- Reopen in Container (use the Command Palette "Dev Containers: Reopen in Container").
- Once built, JupyterLab will be available at `http://localhost:8888` inside the container; use the forwarded port from VS Code or copy the token URL from the container logs.

Files added

- `.devcontainer/devcontainer.json` — devcontainer configuration.
- `.devcontainer/Dockerfile` — Dockerfile used to build the container image.
- `environment.yml` — Conda environment specification used to create the `dev` environment.
