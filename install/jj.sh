#!/bin/bash
set -euo pipefail

cargo install --locked --bin jj jj-cli

jj --version
