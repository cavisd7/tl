#!/bin/bash

echo "Changing openvpn user password..."
chpasswd <<< "openvpn:changethispass"

echo "Done"