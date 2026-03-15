#!/bin/bash
sudo apt update &&
sudo apt install avahi-utils

avahi-browse --version
