# linux-config-files

```
git clone https://github.com/anonimitoraf/linux-config-files.git ~/.linux-config-files
cd ~/.linux-config-files

ls -al | awk '$0=$9' | egrep "^\.[a-zA-Z]+" | grep -v "\.git" | grep -v "i3" | xargs -I{} sh -c 'sudo mv ~/{} ~/{}-backup; sudo ln -s ~/.linux-config-files/{} ~/{}'
sudo ln -s ~/.linux-config-files/i3 ~/.config/i3/config
```
