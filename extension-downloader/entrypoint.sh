#!/bin/bash

unset $(compgen -v | grep "^YARN_")

yarn start:dev $*