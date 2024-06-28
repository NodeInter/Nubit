#!/bin/bash

echo "

███    ██  ██████  ██████  ███████ ██ ███    ██ ████████ ███████ ██████  
████   ██ ██    ██ ██   ██ ██      ██ ████   ██    ██    ██      ██   ██ 
██ ██  ██ ██    ██ ██   ██ █████   ██ ██ ██  ██    ██    █████   ██████  
██  ██ ██ ██    ██ ██   ██ ██      ██ ██  ██ ██    ██    ██      ██   ██ 
██   ████  ██████  ██████  ███████ ██ ██   ████    ██    ███████ ██   ██ 

"

# Function to detect user and set paths and ports
set_user_paths_and_ports() {
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
        # Add cases for nubit3 to nubit20
        "nubit3")
            export PORT=2124
            export HOME_DIR=/home/nubit3
            export STORE=/home/nubit3/.nubit-${NODE_TYPE}-${NETWORK}/
            ;;
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

    export PATH=$HOME_DIR/go/bin:$PATH
    BINARY="$HOME_DIR/nubit-node/bin/nubit"
    BINARYNKEY="$HOME_DIR/nubit-node/bin/nkey"
}

# Set paths and ports based on user
set_user_paths_and_ports

if ps -ef | grep -v grep | grep -w "nubit $NODE_TYPE" > /dev/null; then
    echo "There is already a Nubit light node process running in your environment. The startup process has been stopped. To shut down the running process, please:"
    echo "  Close the window/tab where it's running, or"
    echo "  Go to the exact window/tab and press Ctrl + C (Linux) or Command + C (MacOS)"
    exit 1
fi

dataPath=$STORE
binPath=$HOME_DIR/nubit-node/bin
if [ ! -f $binPath/nubit ] || [ ! -f $binPath/nkey ]; then
    echo "Please run \"curl -sL1 https://nubit.sh | bash\" first!"
    exit 1
fi
cd $HOME_DIR/nubit-node
if [ ! -d $dataPath ] || [ ! -d $dataPath/transients ] || [ ! -d $dataPath/blocks ] || [ ! -d $dataPath/data ] || [ ! -d $dataPath/index ] || [ ! -d $dataPath/inverted_index ]; then
    rm -rf $dataPath/transients
    rm -rf $dataPath/blocks
    rm -rf $dataPath/data
    rm -rf $dataPath/index
    rm -rf $dataPath/inverted_index
    URL=https://nubit.sh/nubit-data/lightnode_data.tgz
    echo "Download light node data from URL: $URL"
    if command -v curl >/dev/null 2>&1; then
        curl -sLO $URL
    elif command -v wget >/dev/null 2>&1; then
        wget -q $URL
    else
        echo "Neither curl nor wget are available. Please install one of these and try again."
        exit 1
    fi
    mkdir -p $dataPath
    echo "Extracting data. PLEASE DO NOT CLOSE!"
    tar -xvf lightnode_data.tgz -C $dataPath
    rm lightnode_data.tgz
fi
if [ ! -d $dataPath/keys ]; then
    echo "Initing keys..."
    $BINARY $NODE_TYPE init --p2p.network $NETWORK > output.txt
    mnemonic=$(grep -A 1 "MNEMONIC (save this somewhere safe!!!):" output.txt | tail -n 1)
    echo $mnemonic > mnemonic.txt
    cat output.txt
    rm output.txt
elif [ ! -f $dataPath/config.toml ]; then
    URL=https://nubit.sh/config.toml
    echo "Recovering config file from URL: $URL"
    if command -v curl >/dev/null 2>&1; then
        curl -s $URL -o $dataPath/config.toml
    elif command -v wget >/dev/null 2>&1; then
        wget -q $URL -O $dataPath/config.toml
    else
        echo "Neither curl nor wget are available. Please install one of these and try again."
        exit 1
    fi
fi

sleep 1
$BINARYNKEY list --p2p.network $NETWORK --node.type $NODE_TYPE > output.txt
publicKey=$(sed -n 's/.*"key":"\([^"]*\)".*/\1/p' output.txt)
echo "** PUBKEY **"
echo $publicKey
echo ""
rm output.txt

export AUTH_TYPE
echo "** AUTH KEY **"
$BINARY $NODE_TYPE auth $AUTH_TYPE --node.store $dataPath
echo ""
sleep 10

chmod a+x $BINARY
chmod a+x $BINARYNKEY
$BINARY $NODE_TYPE start --p2p.network $NETWORK --core.ip $VALIDATOR_IP --metrics.endpoint otel.nubit-alphatestnet-1.com:4318 --rpc.skip-auth --p2p.port $PORT
