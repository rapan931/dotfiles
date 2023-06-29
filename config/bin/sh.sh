gcd() {
  cd $(ghq list -p | fzf)
}

nv_make() {
  cd /usr/local/src/neovim/ && sudo git pull && sudo make distclean && sudo make CMAKE_BUILD_TYPE=Release && sudo make install
}

nv_plugin() {
  cd $(find ~/.local/share/nvim/site/pack/p/ -mindepth 2 -maxdepth 2 -type d | fzf)
}

git_root() {
  local d=$(git rev-parse --show-toplevel)
  if [ $? -eq 0 ]; then
    cd ${d}
  fi
}

sumneko_make() {
  cd ~/repos/github.com/sumneko/lua-language-server
  git pull
  git submodule update --depth 1 --init --recursive
  cd 3rd/luamake
  ./compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
}

