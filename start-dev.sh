#!/bin/sh
exec erl \
    -pa ebin deps/*/ebin \
    -boot start_sasl \
    -sname erlangChat_dev \
    -s erlangChat \
    -s reloader
