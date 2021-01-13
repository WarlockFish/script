#!/bin/bash
#
# FILE: kvm-clone-v2.sh
# getopts学习
# DESCRIPTION: Clone a RHEL5.4/RHEL6 kvm guest on ubuntu14.04 host superv.
#     This shell is used for cloning RHEL5.4 or RHEL6.x KVM guest.
#     Note this shell is only tested for host OS Ubuntu14.04 and RHEL6.4.
#
#     KVM is short for Kernel-based Virtual Machine and makes use of
#     hardware virtualization. You need a CPU that supports hardware
#     virtualization, e.g. Intel VT or AMD-V.
#
# NOTES: This requires GNU getopt.
#        I do not issue any guarantee that this will work for you!
#
# COPYRIGHT: (c) 2015-2016 by the ZhangLiang
#
# LICENSE: Apache 2.0
#
# ORGANIZATION: PepStack (pepstack.com)
#
# CREATED: 2015-05-22 12:34:00
#
#=======================================================================
_file=$(readlink -f $0)
_dir=$(dirname $_file)
. $_dir/common.sh

# Treat unset variables as an error
set -o nounset

__ScriptVersion="2015.05.22"
__ScriptName="kvm-clone-v2.sh"


#-----------------------------------------------------------------------
# FUNCTION: usage
# DESCRIPTION:  Display usage information.
#-----------------------------------------------------------------------
usage() {
    cat << EOT

Usage :  ${__ScriptName} CFGFILE [OPTION] ...
  Create a virtual machine from given options.

Options:
  -h, --help                    Display this message
  -V, --version                 Display script version
  -v, --verbose
  -o, --origver=ORIGVER         Origin vm name with version: rhel5_4 | rhel6_4
  -D, --disksize=DISKSIZE       Origin vm disk size: compact|medium|large
  -p, --path-prefix=PATH        Path prefix of vm
  -m, --memsize=SIZEMB          Memory size of vm by MB: 8192
  -c, --vcpus=VCPUS             Number of virtual cpu cores: 4
  -n, --vmname=VMNAME           Given name of vm
  -H, --domain<DOMAIN>          Optional hostname suffix of vm
  -i, --ipv4=IPADDR             Static ipv4 addr of vm if used
  -S, --supervisor=SUPERVISOR   Supervisor of vm: rhel6.4 or ubuntu14.04
  -G, --gateway=GATEWAY         Gateway ipv4 address
  -T, --iftype=IFTYPE           Network type: bridge or default
  -B, --broadcast=BCAST         Broadcast inet addr
  -M, --netmask=MASK            Net mask address, default: 255.255.255.0

Exit status:
  0   if OK,
  !=0 if serious problems.

Example:
  1) Use short options to create vm:
    $ sudo $__ScriptName ../conf/kvm-origin.cfg -o rhel6_4 -D compact -p el6 -m 2048 -c 2 -n vm-test2 -H pepstack.com -i 192.168.122.61 -S ubuntu14.04 -G 192.168.122.1 -B 192.168.122.255 -M 255.255.255.0

  2) Use long options to create vm:
    $ sudo $__ScriptName ../conf/kvm-origin.cfg --origver=rhel6_4 --disksize=compact --path-prefix=el6 --memsize=2048 --vcpus=2 --vmname=vm-test3 --domain=pepstack.com --ipv4=192.168.122.63 --supervisor=ubuntu14.04 --gateway=192.168.122.1 --broadcast=192.168.122.255 --netmask=255.255.255.0

Report bugs to 350137278@qq.com

EOT
}   # ----------  end of function usage  ----------

if [ $# -eq 0 ]; then usage; exit 1; fi

ABSDIR=$(real_path $(dirname $0))

CFGFILE=
VMNAME=
DOMAIN=
IPADDR=
PATHPREFIX=
GATEWAY=
BDCAST=
NETMASK="255.255.255.0"
VERBOSE=false
SIZEMB=8192
VCPUS=4
ORIGVER="rhel6_4"
DISKSIZE="compact"
VMORIG="$ORIGVER:$DISKSIZE"
SUPERVISOR="ubuntu14.04"

# parse options:
RET=`getopt -o hVvo:D:p:m:c:n:H::i:S:G:T:B:M: \
--long help,version,verbose,origver:,disksize:,path-prefix:,memsize:,\
vcpus:,vmname:,domain::,ipv4:,supervisor:,gateway:,\
iftype:,broadcast:,netmask:\
  -n ' * ERROR' -- "$@"`

if [ $? != 0 ] ; then echoerror "$__ScriptName exited with doing nothing." >&2 ; exit 1 ; fi

# Note the quotes around $RET: they are essential!
eval set -- "$RET"

# set option values
while true; do
    case "$1" in
        -h | --help ) usage; exit 1;;
        -v | --verbose ) VERBOSE=true; shift ;;
        -V | --version ) echoinfo "$(basename $0) -- version $__ScriptVersion"; exit 1;;

        -o | --origver ) ORIGVER=$2
            echoinfo "origin: $ORIGVER"
            shift 2 ;;

        -D | --disksize ) DISKSIZE=$2
            echoinfo "origin size: $DISKSIZE"
            shift 2 ;;

        -p | --path-prefix ) PATHPREFIX=$2
            echoinfo "subdir: $PATHPREFIX"
            shift 2 ;;

        -n | --vmname) VMNAME=$2
            echoinfo "new vm name: $VMNAME"
            shift 2 ;;

        -H | --domain)
            # domain-suffix has an optional argument. as we are in quoted mode,
            # an empty parameter will be generated if its optional argument is not found.
            case "$2" in
                    "" ) echowarn "--domain, no argument"; shift 2 ;;
                    * )  DOMAIN="$2" ; echoinfo "domain: $DOMAIN"; shift 2 ;;
            esac ;;

        -i | --ipv4) IPADDR=$2
            echoinfo "static ipv4: $IPADDR"
            shift 2 ;;

        -m | --memsize ) SIZEMB=$2
            echoinfo "memory: $SIZEMB mb"
            shift 2 ;;

        -c | --vcpus ) VCPUS=$2
            echoinfo "cpu cores: $VCPUS"
            shift 2 ;;

        -S | --supervisor ) SUPERVISOR=$2
            echoinfo "supervisor: $SUPERVISOR"
            shift 2;;

        -G | --gateway ) GATEWAY=$2
            echoinfo "gateway: $GATEWAY"
            shift 2 ;;

        -T | --iftype ) IFTYPE=$2
            echoinfo "network type: $IFTYPE"
            shift 2 ;;

        -B | --broadcast ) BDCAST=$2
            echoinfo "broad cast: $BDCAST"
            shift 2 ;;

        -M | --netmask) NETMASK=$2
            echoinfo "netmask: $NETMASK"
            shift 2 ;;

        -- ) shift; break ;;
        * ) echoerror "internal error!" ; exit 1 ;;
     esac
done

# config file must provided with remaining argument
for arg do
    CFGFILE=$(real_path $(dirname $arg))'/'$(basename $arg)
done

if [ -f $CFGFILE ]; then
    echoinfo "Config file: $CFGFILE"
else
    echoerror "Config file not found: $CFGFILE"
    exit 3
fi

##################### THIS IS ONLY A TEMPLATE SHELL FILE ##################### 
