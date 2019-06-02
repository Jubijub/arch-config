#Path
typeset -U path
path=( 
    /bin
    /usr/bin
    /usr/local/bin
    /usr/lib/ccache/bin
    /opt/cuda/bin
    $HOME/.npm-packages/bin
    .
    $path[@])

#Environment variables
export LANG=en_US.UTF-8
export EDITOR=vim
export MAKEFLAGS="-j17 -l16"   # Update accordingly for number of logical cores on your machine (j = logical core +1, l = logical cores)
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/cuda/lib64
export JDK_HOME=/usr/lib/jvm/default/
export JAVA_HOME=/usr/lib/jvm/default/
