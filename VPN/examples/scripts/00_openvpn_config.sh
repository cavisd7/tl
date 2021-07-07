#!/bin/bash

echo "Changing openvpn user password..."
echo -e "changethispassword\nchangethispassword" | (passwd --stdin openvpn)

echo "Done"