#!/bin/sh

KEYS=$(rpm --query gpg-pubkey --queryformat "%{NAME}-%{VERSION}-%{RELEASE} %{PACKAGER}\n")

# rpm -e gpg
