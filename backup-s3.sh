#!/usr/bin/env zsh

VAULT="${HOME}/Vault"
S3_URI="s3://${USER}/"

if [[ $# -eq 0 ]]; then
    echo
    echo "Please provide a command: upload | download"
    exit 1
fi

if ! command -v isengardcli &> /dev/null
then
    echo
    echo "❗ Please install isengardcli"
    exit 1;
fi

eval $(isengardcli credentials ${USER})
if [[ $? -ne 0 ]]; then
    echo
    echo "🔐 Please re-authenticate with Midway"
    exit 1
fi

case $1 in

    d*|download)
        echo
        echo "🔍 Comparing changes from S3…"
        echo
        aws s3 sync ${S3_URI} ${VAULT} --delete --exclude="**/.DS_Store" --exclude "Music/*" --dryrun
        echo
        echo
        read "REPLY?📚 Apply these changes (Y/N/P)? "
        if [[ $REPLY =~ "^[Yy]" || $REPLY =~ "^[Pp]" ]]; then
            if [[ $REPLY =~ "^[Pp]" ]]; then
                echo
                echo "📙 Downloading partial changes from S3…"
                echo
                aws s3 sync ${S3_URI} ${VAULT} --exclude="**/.DS_Store" --exclude "Music/*"
            else
                echo
                echo "📘 Downloading full changes from S3…"
                echo
                aws s3 sync ${S3_URI} ${VAULT} --delete --exclude="**/.DS_Store" --exclude "Music/*"
            fi
        fi
        echo
        ;;

    u*|upload)
        echo
        echo "🔎 Comparing changes to S3…"
        echo
        aws s3 sync ${VAULT} ${S3_URI} --delete --exclude="**/.DS_Store" --exclude "Music/*" --dryrun
        echo
        read "REPLY?📚 Apply these changes (Y/N/P)? "
        if [[ $REPLY =~ "^[Yy]" || $REPLY =~ "^[Pp]" ]]; then
            if [[ $REPLY =~ "^[Pp]" ]]; then
                echo
                echo "📙 Uploading partial changes to S3…"
                echo
                aws s3 sync ${VAULT} ${S3_URI} --exclude="**/.DS_Store" --exclude "Music/*"
            else
                echo
                echo "📗 Uploading full changes to S3…"
                echo
                aws s3 sync ${VAULT} ${S3_URI} --delete --exclude="**/.DS_Store" --exclude "Music/*"
            fi
        fi
        echo
        ;;
esac
