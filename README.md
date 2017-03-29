### Usage

```sh
$ git clone <path-to-repo>/dotfiles.git
$ cd dotfiles
$ git submodule update --init --recursive
$ ./setup.sh
$ source ~/.profile
```

### Supported configurations with dependencies:
- i3 window manager config
  - <b>Packages needed for i3 config files to work</b>
    - amixer
      - Keyboard volume button scripts may need to be altered depending on available sound devices (defaults: Master, Speaker, Headphone, PCM)
    - awk
    - gnome-screensaver
    - xautolock
