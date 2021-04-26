#!/bin/bash
apt-get update
apt-get install -y default-jre curl
curl -s https://get.nextflow.io | bash