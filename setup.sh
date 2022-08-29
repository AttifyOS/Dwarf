#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/indygreg/python-build-standalone/releases/download/20220802/cpython-3.9.13+20220802-x86_64-unknown-linux-gnu-install_only.tar.gz -O $APM_TMP_DIR/cpython-3.9.13.tar.gz
  tar xf $APM_TMP_DIR/cpython-3.9.13.tar.gz -C $APM_PKG_INSTALL_DIR
  rm $APM_TMP_DIR/cpython-3.9.13.tar.gz

  $APM_PKG_INSTALL_DIR/python/bin/pip3.9 install dwarf-debugger==1.1.3

  ln -s $APM_PKG_INSTALL_DIR/python/bin/dwarf $APM_PKG_BIN_DIR/
  ln -s $APM_PKG_INSTALL_DIR/python/bin/dwarf-creator $APM_PKG_BIN_DIR/
  ln -s $APM_PKG_INSTALL_DIR/python/bin/dwarf-injector $APM_PKG_BIN_DIR/
  ln -s $APM_PKG_INSTALL_DIR/python/bin/dwarf-trace $APM_PKG_BIN_DIR/
  ln -s $APM_PKG_INSTALL_DIR/python/bin/dwarf-strace $APM_PKG_BIN_DIR/

  echo "This package adds the commands:"
  echo " - dwarf"
  echo " - dwarf-creator"
  echo " - dwarf-injector"
  echo " - dwarf-trace"
  echo " - dwarf-strace"
}

uninstall() {
  rm -rf $APM_PKG_BIN_DIR/python
  rm $APM_PKG_BIN_DIR/dwarf
  rm $APM_PKG_BIN_DIR/dwarf-creator
  rm $APM_PKG_BIN_DIR/dwarf-injector
  rm $APM_PKG_BIN_DIR/dwarf-trace
  rm $APM_PKG_BIN_DIR/dwarf-strace
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1