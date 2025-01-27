#!/bin/bash
if [ ! -f "/ok" ]; then
    echo "Some installations" && \
    touch /ok && \
    echo "Entrypoint successfull init"
fi
echo "Entrypoint already init"
echo "Add running what you want after this" 
