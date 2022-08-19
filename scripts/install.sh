#!/usr/bin/env bash

set -e

main() {
    local what="${1}"
    local script_dir
    script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    if [[ -z "${what}" || "${what}" == "server" ]]; then
        local args="-e"
        pushd "${script_dir}/../grizzly-ls" &> /dev/null
        touch setup.cfg
        if [[ -n "${*}" && "${*}" == *"+e"* ]]; then
            args=""
        fi
        python3 -m pip install $args .[dev] || { rm setup.cfg; exit 1; }
        rm setup.cfg
        popd &> /dev/null
    fi

    if [[ -z "${what}" || "${what}" == "client/"* ]]; then
        if [[ -z "${what}" ]]; then
            what="client/vscode"
        fi
        pushd "${script_dir}/../${what}" &> /dev/null
        npm install
        popd &> /dev/null
    fi

    return 0
}

main "$@"
exit $?
