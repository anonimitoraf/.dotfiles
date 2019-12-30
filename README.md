# linux-config-files
Stuff like bashrc, vimrc, tmux.conf, etc.

```
ls -al | awk '$0=$9' | egrep "^\.[a-zA-Z]+" | xargs -I{} sh -c 'sudo mv ~/{} ~/{}-backup; sudo ln -s ~/.linux-config-files/{} ~/{}
```
