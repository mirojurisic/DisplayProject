# used for configuration of our local terminal settings for ssh
# this is used by vscode Remote-SSH 
cat << EOF >> /home/mimo/.ssh/config

Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityFile}
EOF