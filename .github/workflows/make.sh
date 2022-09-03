#!/bin/bash

npx npx redoc-cli build -t template.hbs iwine_openapi.yaml && \
mv redoc-static.html index.html