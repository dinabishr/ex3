#! /bin/bash

DRV_PKG_NAME="e1000e-3.1.0.2"
DRV_PKG_URL="https://cdn.oc.tc/${DRV_PKG_NAME}.tar.gz"

# Function declaration
error_action () {
    echo "Failed!"
    exit 1
}

echo "Downloading and extracting driver package..."
wget ${DRV_PKG_URL} && tar zxf ${DRV_PKG_NAME}.tar.gz || error_action

echo "Installing build dependencies..."
apt-get install -y build-essential linux-headers-$(uname -r) || error_action

# Going into the driver source directory
cd ${DRV_PKG_NAME}/src/

echo "Building module and updating initramfs..."
{ make install && update-initramfs -u; } || error_action

if grep --quiet e1000e /etc/modules; then
  echo "e1000e is already defined"
else
  echo "Adding e1000e to modules file"
  echo e1000e >> /etc/modules
fi

echo "Restarting iface..."
{ ifdown eth0  && ifup eth0; } || error_action
{ ifdown eth1  && ifup eth1; } || error_action

# Checking installed driver version
if [[ $(modinfo -F version e1000e) == "3.1.0.2-NAPI" ]]; then
    echo "Driver successfully installed!"
else
    echo "Something went wrong..."
    exit 1
fi

exit 0
