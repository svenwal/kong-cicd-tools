#!/bin/bash
exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"