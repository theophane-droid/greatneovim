#!/usr/bin/env bash
set -euo pipefail

NAME=greatneovim
IMAGE=localhost/greatneovim:latest

# Socket unique par run (évite les conflits)
SOCK="$(mktemp -u "/tmp/nvim-host-${UID}.XXXXXX.sock")"
SOCAT_PID=""

cleanup() {
  # stop socat
  if [[ -n "${SOCAT_PID}" ]] && kill -0 "${SOCAT_PID}" 2>/dev/null; then
    kill "${SOCAT_PID}" 2>/dev/null || true
    wait "${SOCAT_PID}" 2>/dev/null || true
  fi
  rm -f "${SOCK}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

# Vérif dépendance host
command -v socat >/dev/null 2>&1 || {
  echo "Erreur: socat n'est pas installé sur l'hôte."
  echo "Installez-le: sudo apt install socat"
  exit 1
}

# Démarre le serveur shell host (un nouveau bash par connexion)
rm -f "${SOCK}"
socat UNIX-LISTEN:"${SOCK}",fork EXEC:"bash -li",pty,setsid,stderr,sigint,sane &
SOCAT_PID=$!

# Attendre que le socket soit prêt
for _ in $(seq 1 50); do
  [[ -S "${SOCK}" ]] && break
  sleep 0.05
done
[[ -S "${SOCK}" ]] || { echo "Erreur: socket non créé: ${SOCK}"; exit 1; }

# Lance le conteneur en montant le socket vers /host.sock
podman run --rm -it \
  --name "${NAME}" \
  -v "${PWD}:/workspace" \
  -v "${SOCK}:/host.sock" \
  "${IMAGE}" "$@"

