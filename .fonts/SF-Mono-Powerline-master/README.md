Originally from https://github.com/Twixes/SF-Mono-Powerline.

This is Apple's SF Mono font, patched with [the Nerd Fonts patcher](https://github.com/ryanoasis/nerd-fonts#font-patcher) for Powerline support.

Powerline glyphs allow for pretty and practical statuslines, as seen in [the original vim plugin](https://github.com/powerline/powerline) or in enhanced shell prompts like [Shellder](https://github.com/simnalamburt/shellder) (shown above) or [Starship](https://starship.rs).

Works on macOS, Linux and Windows. For personal use only.

---------------------------------------------------


To load this font into system font cache on Debian/Ubuntu (as of 2019/11):

    $ fc-cache -f -v

To verify that it was loaded:

    $ fc-list | grep "SF-Mono"


