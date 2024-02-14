#!/usr/bin/env bash

set -e

# ------------------------------------------------------------------------------

if [[ $# -eq 0 ]]; then
    echo
    echo "Please provide a command: upload | download"
    exit 1
fi

if command -v gum &> /dev/null
then
    GO_BIN=1
fi

USER="mkgz"
export AWS_PROFILE=${USER}
if [[ $? -ne 0 ]]; then
    echo
    echo "🔐 Verify authentication profile"
    exit 1
fi

# ------------------------------------------------------------------------------

VAULT="${HOME}/vault"
S3_URI="s3://${USER}/"

MSG_CFM="📚 Apply these changes?"
OPT_CFM="    Y)es\n    P)reserve Files\n    N)o\n"
OPT_GUM=("Full Sync" "Preserve Files" "No Action")

MSG_DL_C="🔍 Comparing changes from S3…"
MSG_DL_P="📗 Downloading new changes from S3…"
MSG_DL_F="📘 Downloading full changes from S3…"
MSG_UL_C="🔎 Comparing changes to S3…"
MSG_UL_P="📗 Uploading new changes to S3…"
MSG_UL_F="📙 Uploading full changes to S3…"
PRE_X="Syncing"
SYM_DL_X="🔷"
SYM_UL_X="🔶"


info () {
    echo
    echo $1
    echo
}

confirm () {
    if [[ $GO_BIN ]]; then
        info $MSG_CFM
        REPLY=$(gum choose ${OPT_GUM[@]})
    else
        info $MSG_CFM
        echo $OPT_CFM
        read -p " " REPLY
        echo
    fi
}

toggle_msg () {
    METHOD=$1
    TYPE=$2

    case $TYPE in
        c*|C*|check)
            # [[ $METHOD =~ ^[Dd] ]] && info $MSG_DL_C || info $MSG_UL_C
            ;;
        f*|F*|y*|Y*|full)
            [[ $METHOD =~ ^[Dd] ]] && info $MSG_DL_F || info $MSG_UL_F
            PRE_X="Full"
            ;;
        p*|P*|partial)
            [[ $METHOD =~ ^[Dd] ]] && info $MSG_DL_P || info $MSG_UL_P
            PRE_X="Preserve"
            ;;
        e*|E*|execute)
            [[ $METHOD =~ ^[Dd] ]] && \
                info "${SYM_DL_X} ${PRE_X} Download" || \
                info "${SYM_UL_X} ${PRE_X} Upload"
            ;;
    esac
}

run_cmd () {
    echo
    if [[ $GO_BIN ]]; then
        [[ ! $COLOR ]] && COLOR="#FFF"
        gum spin --spinner points \
                 --spinner.foreground $COLOR \
                 --title "" \
                 --show-output \
                 -- $@
    else
        $@
    fi
}

process () {
    ARGS=(
        --exclude "**/.DS_Store"
        --exclude "Music/*"
        --exclude "Videos/*"
    )
    METHOD=$1
    REPLY=$2

    if [[ ! $REPLY || $REPLY =~ ^[Nn] ]] ; then
        echo "❌ Sync Aborted"
        return
    fi

    toggle_msg $METHOD $REPLY
    if [[ $REPLY == "check" ]]; then
        # dryrun
        ARGS=(${ARGS[@]} --delete --dryrun)
    elif [[ $REPLY =~ ^[FfYy] ]]; then
        # full
        ARGS=(${ARGS[@]} --delete)
    elif [[ $REPLY =~ ^[Pp] ]]; then
        # partial
        ARGS=(${ARGS[@]})
    fi

    toggle_msg $METHOD "execute"
    if [[ $METHOD =~ ^[Dd] ]]; then
        COLOR="#08F"
        ARGS=(aws s3 sync ${S3_URI} ${VAULT} ${ARGS[@]})
    else
        COLOR="#F80"
        ARGS=(aws s3 sync ${VAULT} ${S3_URI} ${ARGS[@]})
    fi

    CMD=(${ARGS[@]})
    # echo "🔨 ${CMD[@]}"
    run_cmd ${CMD[@]}
}

# ------------------------------------------------------------------------------

clear
echo
case $1 in

    d*|download)
        process "download" "check"
        confirm
        clear
        echo
        process "download" $REPLY
        ;;

    u*|upload)
        process "upload" "check"
        confirm
        clear
        echo
        process "upload" $REPLY
        ;;
esac
echo
