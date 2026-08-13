export GRADLE_HOME=/usr/local/opt/gradle/libexec
export PATH=$GRADLE_HOME/bin:$PATH
alias g='gradle'
alias gw='./gradlew'
alias v='nvim'
alias l='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
parse_git_branch() {
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\] /'
}
PS1="\[\033[32m\]\$(parse_git_branch)\[\033[00m\]\w\$ "

# Set JAVA_HOME system environment variable value.
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
# Add java bin folder in PATH system environment variable value.
export PATH=$PATH:$JAVA_HOME/bin

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/fgonzalez/.sdkman"
[[ -s "/Users/fgonzalez/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/fgonzalez/.sdkman/bin/sdkman-init.sh"
