#!/bin/bash

# Parsing command-line arguments
while [ $# -gt 0 ]; do
    if [[ $1 = "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done

# Detecting user and setting port and home directory based on user
USER=$(whoami)

case "$USER" in
    "root")
        export PORT=2121
        export HOME_DIR=/root
        export STORE=/root/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit1")
        export PORT=2122
        export HOME_DIR=/home/nubit1
        export STORE=/home/nubit1/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit2")
        export PORT=2123
        export HOME_DIR=/home/nubit2
        export STORE=/home/nubit2/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit3")
        export PORT=2124
        export HOME_DIR=/home/nubit3
        export STORE=/home/nubit3/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    # Add cases for nubit4 to nubit20
    "nubit4")
        export PORT=2125
        export HOME_DIR=/home/nubit4
        export STORE=/home/nubit4/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit5")
        export PORT=2126
        export HOME_DIR=/home/nubit5
        export STORE=/home/nubit5/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit6")
        export PORT=2127
        export HOME_DIR=/home/nubit6
        export STORE=/home/nubit6/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit7")
        export PORT=2128
        export HOME_DIR=/home/nubit7
        export STORE=/home/nubit7/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit8")
        export PORT=2129
        export HOME_DIR=/home/nubit8
        export STORE=/home/nubit8/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit9")
        export PORT=2130
        export HOME_DIR=/home/nubit9
        export STORE=/home/nubit9/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit10")
        export PORT=2131
        export HOME_DIR=/home/nubit10
        export STORE=/home/nubit10/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit11")
        export PORT=2132
        export HOME_DIR=/home/nubit11
        export STORE=/home/nubit11/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit12")
        export PORT=2133
        export HOME_DIR=/home/nubit12
        export STORE=/home/nubit12/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit13")
        export PORT=2134
        export HOME_DIR=/home/nubit13
        export STORE=/home/nubit13/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit14")
        export PORT=2135
        export HOME_DIR=/home/nubit14
        export STORE=/home/nubit14/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit15")
        export PORT=2136
        export HOME_DIR=/home/nubit15
        export STORE=/home/nubit15/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit16")
        export PORT=2137
        export HOME_DIR=/home/nubit16
        export STORE=/home/nubit16/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit17")
        export PORT=2138
        export HOME_DIR=/home/nubit17
        export STORE=/home/nubit17/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit18")
        export PORT=2139
        export HOME_DIR=/home/nubit18
        export STORE=/home/nubit18/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit19")
        export PORT=2140
        export HOME_DIR=/home/nubit19
        export STORE=/home/nubit19/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    "nubit20")
        export PORT=2141
        export HOME_DIR=/home/nubit20
        export STORE=/home/nubit20/.nubit-${NODE_TYPE}-${NETWORK}/
        ;;
    *)
        echo "Unsupported user $USER"
        exit 1
        ;;
esac

# Setting architecture-specific variables
if [ "$(uname -m)" = "arm64" -a "$(uname -s)" = "Darwin" ]; then
    ARCH_STRING="darwin-arm64"
    MD5_NUBIT="d89c8690ff64423d105eab57418281e6"
    MD5_NKEY="bbbed6910fe99f3a11c567e49903de58"
elif [ "$(uname -m)" = "x86_64" -a "$(uname -s)" = "Darwin" ]; then
    ARCH_STRING="darwin-x86_64"
    MD5_NUBIT="fc38a46c161703d02def37f81744eb5e"
    MD5_NKEY="f9bcabe82b0cbf784dae023a790efc8e"
elif [ "$(uname -m)" = "aarch64" -o "$(uname -m)" = "arm64" ]; then
    ARCH_STRING="linux-arm64"
    MD5_NUBIT="a32e3e09c3ae2ff0ad8d407da416c73f"
    MD5_NKEY="2e5ce663ada28c72119397fe18dd82d3"
elif [ "$(uname -m)" = "x86_64" ]; then
    ARCH_STRING="linux-x86_64"
    MD5_NUBIT="c8ec369419ee0bbb38ac0ebe022f1bc9"
    MD5_NKEY="d767aba44ac22e5b59bad568524156c2"
fi

if [ -z "$ARCH_STRING" ]; then
    echo "Unsupported architecture $(uname -s) - $(uname -m)"
else
    cd $HOME_DIR
    FOLDER=nubit-node
    FILE=$FOLDER-$ARCH_STRING.tar
    FILE_NUBIT=$FOLDER/bin/nubit
    FILE_NKEY=$FOLDER/bin/nkey
    if [ -f $FILE ]; then
        rm $FILE
    fi
    OK="N"
    if [ "$(uname -s)" = "Darwin" ]; then
        if [ -d $FOLDER ] && [ -f $FILE_NUBIT ] && [ -f $FILE_NKEY ] && [ $(md5 -q "$FILE_NUBIT" | awk '{print $1}') = $MD5_NUBIT ] && [ $(md5 -q "$FILE_NKEY" | awk '{print $1}') = $MD5_NKEY ]; then
            OK="Y"
        fi
    else
        for cmd in tar ps bash md5sum awk sed; do
            if ! command -v $cmd &> /dev/null; then
                echo "Command $cmd is not available. Please install and try again"
                exit 1
            fi
        done
        if [ -d $FOLDER ] && [ -f $FILE_NUBIT ] && [ -f $FILE_NKEY ] && [ $(md5sum "$FILE_NUBIT" | awk '{print $1}') = $MD5_NUBIT ] && [ $(md5sum "$FILE_NKEY" | awk '{print $1}') = $MD5_NKEY ]; then
            OK="Y"
        fi
    fi
    echo "Starting Nubit node on port $PORT..."
    if [ $OK = "Y" ]; then
        echo "MD5 checking passed. Start directly"
    else
        echo "Installation of the latest version of nubit-node is required to ensure optimal performance and access to new features."
        URL=https://nubit.sh/nubit-bin/$FILE
        echo "Upgrading nubit-node ..."
        echo "Download from URL, please do not close: $URL"
        if command -v curl >/dev/null 2>&1; then
            curl -sLO $URL
        elif command -v wget >/dev/null 2>&1; then
            wget -q $URL
        else
            echo "Neither curl nor wget are available. Please install one of these and try again"
            exit 1
        fi
        tar -xvf $FILE
        if [ ! -d $FOLDER ]; then
            mkdir $FOLDER
        fi
        if [ ! -d $FOLDER/bin ]; then
            mkdir $FOLDER/bin
        fi
        mv $FOLDER-$ARCH_STRING/bin/nubit $FOLDER/bin/nubit
        mv $FOLDER-$ARCH_STRING/bin/nkey $FOLDER/bin/nkey
        rm -rf $FOLDER-$ARCH_STRING
        rm $FILE
        echo "Nubit-node update complete."
    fi
    curl -sL https://raw.githubusercontent.com/NodeInter/Nubit/main/start.sh -o start.sh && chmod +x start.sh && ./start.sh
fi
