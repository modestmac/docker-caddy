#!/bin/bash
default="--conf /caddy/Caddyfile --log stdout -agree"
args=${RUN_ARGS:-$default}

/usr/bin/caddy $args
