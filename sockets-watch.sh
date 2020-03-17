#!/usr/bin/env bash
netstat -ultpan |& grep -v 'thunderbird' | grep -v 'firefox' | awk 'NR > 2 {print}'
