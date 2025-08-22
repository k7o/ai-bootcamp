#!/usr/bin/env bash
set -eu

# start-jupyter.sh: idempotent launcher for JupyterLab inside the 'dev' conda env
LOG_FILE="/workspace/jupyter.log"

echo "start-jupyter.sh: starting JupyterLab, logging to ${LOG_FILE}"

# Start Jupyter in a way that survives the parent shell exiting. Use nohup + setsid.
# Use full conda path to avoid PATH issues.
nohup setsid /opt/conda/bin/conda run -n dev jupyter lab \
	--ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' --allow-root \
	>> "${LOG_FILE}" 2>&1 < /dev/null &

newpid=$!
echo "start-jupyter.sh: JupyterLab started (PID ${newpid})"

# Quick health check: wait a few seconds for process and check it's running
sleep 2
if kill -0 "${newpid}" >/dev/null 2>&1; then
	echo "start-jupyter.sh: process ${newpid} is running"
else
	echo "start-jupyter.sh: process ${newpid} is not running, see ${LOG_FILE} for details"
	exit 1
fi
