#!/bin/sh
apt-get update
apt-get install bash curl -y

#!/bin/bash

if [ ! -e "$SAWTOOTH_HOME/logs" ]; then
    mkdir -p $SAWTOOTH_HOME/logs
fi

if [ ! -e "$SAWTOOTH_HOME/keys" ]; then
    mkdir -p $SAWTOOTH_HOME/keys
fi

if [ ! -e "$SAWTOOTH_HOME/policy" ]; then
    mkdir -p $SAWTOOTH_HOME/policy
fi

if [ ! -e "$SAWTOOTH_HOME/data" ]; then
    mkdir -p $SAWTOOTH_HOME/data
fi

if [ ! -e "$SAWTOOTH_HOME/etc" ]; then
    mkdir -p $SAWTOOTH_HOME/etc
fi

if [ ! -e "$SAWTOOTH_HOME/etc/validator.toml" ]; then
    echo "[CREATING] Creating the validator.toml file"
    touch $SAWTOOTH_HOME/etc/validator.toml
    echo "opentsdb_url = \"http://metrics.propschain.propsproject.io:8086\"" >> $SAWTOOTH_HOME/etc/validator.toml
    echo "opentsdb_db = \"metrics\"" >> $SAWTOOTH_HOME/etc/validator.toml
    echo "opentsdb_username = \"lrdata\"" >> $SAWTOOTH_HOME/etc/validator.toml
    echo "opentsdb_password = \"${OPENTSDB_PW}\"" >> $SAWTOOTH_HOME/etc/validator.toml        
    cat $SAWTOOTH_HOME/etc/validator.toml
fi


if [ ! -e "$SAWTOOTH_HOME/logs/validator-debug.log" ]; then
    echo "[CREATING] Creating the validator-debug.log file"
    touch $SAWTOOTH_HOME/logs/validator-debug.log
fi

if [ ! -e "$SAWTOOTH_HOME/keys/validator.priv" ]; then
    echo "[CREATING] Creating validator priv/pub keys"
    sawadm keygen;
fi

if [ ! -e "$SAWTOOTH_HOME/config-genesis.batch" ]; then
    echo "[CREATING] No config-genesis.batch file"
    sawset genesis -k $SAWTOOTH_HOME/keys/validator.priv -o $SAWTOOTH_HOME/config-genesis.batch;
fi

if [ ! -e /root/.sawtooth/keys/root.priv ]; then
    echo "No private key was found"
    if [ -e $SAWTOOTH_HOME/root.priv ]; then
        echo "Fetching the key from $SAWTOOTH_HOME"
        mkdir -p /root/.sawtooth/keys
        cp $SAWTOOTH_HOME/root.priv /root/.sawtooth/keys/root.priv
        cp $SAWTOOTH_HOME/root.pub /root/.sawtooth/keys/root.pub
    else
        echo "Generating a new key and adding the key to identity allowed keys"
        sawtooth keygen root
        cp /root/.sawtooth/keys/root.priv $SAWTOOTH_HOME/root.priv
        cp /root/.sawtooth/keys/root.pub $SAWTOOTH_HOME/root.pub
    fi
fi

if [ ! -e $SAWTOOTH_HOME/config.batch ]; then
    echo "[CREATING] Creating a config.batch file"
    sawset proposal create \
    -k $SAWTOOTH_HOME/keys/validator.priv \
    sawtooth.consensus.algorithm.name=pbft \
    sawtooth.consensus.algorithm.version=1.0 \
    sawtooth.consensus.pbft.block_publishing_delay=2000 \
    sawtooth.publisher.max_batches_per_block=200 \
    sawtooth.gossip.time_to_live=1 \
    sawtooth.consensus.pbft.members='["'$(cat ~/.sawtooth/keys/root.pub)'","'$(cat /opt/sawtooth/keys/validator.pub)'","0365a68ddcaeb5be58de09806667e3deb8f736fa4f705d02697a352dd7aaaa60df","02a7e0b9399f3b410a6842693baf56d24aa7ea178278f369e1e8bbc9f1736045ea","0249785b8ada0b8489d78c0273ec31505fa58acc63f0c2c99e21260792d2254b8f","03c383f6fea4128cfdc5f1202de072d2c7afdd8263a7296baa12a59ca49831f0a3"]' \
    sawtooth.settings.vote.authorized_keys=$(cat ~/.sawtooth/keys/root.pub),$(cat /opt/sawtooth/keys/validator.pub),,0365a68ddcaeb5be58de09806667e3deb8f736fa4f705d02697a352dd7aaaa60df,02a7e0b9399f3b410a6842693baf56d24aa7ea178278f369e1e8bbc9f1736045ea,0249785b8ada0b8489d78c0273ec31505fa58acc63f0c2c99e21260792d2254b8f,03c383f6fea4128cfdc5f1202de072d2c7afdd8263a7296baa12a59ca49831f0a3 \
    sawtooth.identity.allowed_keys=$(cat /opt/root.pub),$(cat /opt/sawtooth/keys/validator.pub),0365a68ddcaeb5be58de09806667e3deb8f736fa4f705d02697a352dd7aaaa60df,02a7e0b9399f3b410a6842693baf56d24aa7ea178278f369e1e8bbc9f1736045ea,0249785b8ada0b8489d78c0273ec31505fa58acc63f0c2c99e21260792d2254b8f,03c383f6fea4128cfdc5f1202de072d2c7afdd8263a7296baa12a59ca49831f0a3 \
    sawtooth.validator.transaction_families='[{"family": "pending-earnings", "version": "1.0"},{"family":"sawtooth_settings","version":"1.0"},{"family":"sawtooth_identity","version":"1.0"},{"family":"sawtooth_validator_registry","version":"1.0"}]' \
    -o $SAWTOOTH_HOME/config.batch

    sawadm genesis $SAWTOOTH_HOME/config-genesis.batch $SAWTOOTH_HOME/config.batch    
fi


SH="$SAWTOOTH_HOME"
env="$ENVIRONMENT"
cat <<EOF > $SAWTOOTH_HOME/etc/log_config.toml
version = 1
disable_existing_loggers = false

[formatters.simple]
format = "[%(asctime)s.%(msecs)03d [%(threadName)s] %(module)s %(levelname)s] %(message)s"
datefmt = "%H:%M:%S"

[formatters.json]
format = "{\"timestamp\":\"%(asctime)s.%(msecs)03d\",\"app\":\"propschain\",\"env\":\"production\",\"name\":\"validator\",\"module\":\"%(module)s\",\"levelname\":\"%(levelname)s\",\"message\":\"%(message)s\"}"
datefmt = "%Y-%m-%dT%H:%M:%S"

[formatters.newformat]
format = "[%(asctime)s.%(msecs)03d] [%(levelname)s] [sidechain] [%(module)s] [production] %(message)s"
datefmt = "%Y-%m-%dT%H:%M:%S"

[handlers.debugrotate]
level = "DEBUG"
formatter = "newformat"
class = "logging.handlers.RotatingFileHandler"
filename = "/var/log/sawtooth/validator-debug.log"
maxBytes = 50000000
backupCount=20

[handlers.debug]
level = "DEBUG"
formatter = "json"
class = "logging.StreamHandler"
stream = "ext://sys.stdout"

[root]
level = "DEBUG"
propagate = true
handlers = [ "debug"]
EOF

# function join_by { local IFS="$1"; shift; echo "$*"; }
# IFS=',' read -r -a my_array <<< "$(cat $SAWTOOTH_HOME/peers)"
# peers_array=()
# for element in "${my_array[@]}"
# do
# if [[ $element != *"${PUBLIC_IP_ADDRESS}"* ]]; then
#   echo "Added peer $element"
#   peers_array+=($element)
# fi
# done

# PEERS_STR=$(cat $SAWTOOTH_HOME/join_by , "${peers_array[@]}")
PEER_STR=$(cat $SAWTOOTH_HOME/peers)
echo "calculated PEER_STR=$PEERS_STR my ip $PUBLIC_IP_ADDRESS" >> $SAWTOOTH_HOME/logs/setup-logs

sawtooth-validator  \
    --endpoint tcp://$PUBLIC_IP_ADDRESS:8800 \
    --bind component:tcp://eth0:4004 \
    --bind network:tcp://eth0:8800 \
    --bind consensus:tcp://eth0:5050 \
    --scheduler parallel \
    -P static \
    --peers $PEERS_STR \
    --opentsdb-url http://metrics.propschain.propsproject.io:8086 \
    --opentsdb-db metrics
