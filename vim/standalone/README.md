This is deprecated by the install instrutions at https://github.com/burnettk/dotfiles, a fork of
skwp's dotfiles, but I wanted to preserve the vim setup I had collaboratively developed with some hot people,
since skwp's setup is mac-centric. 

To install the non-dotfiles vim setup, do this:

    # backup stuff:
    mv ~/.vim /tmp
    mv ~/.vimrc /tmp
    
    # install the vim environment:
    git clone git://github.com/burnettk/dotfiles.git /tmp/dotfiles
    mv /tmp/dotfiles/vim/standalone ~/.vim
    rm -rf /tmp/dotfiles
    cd ~/.vim
    cp vimrc.sample ~/.vimrc
    ./update_bundles

NOTE: if you use this vim setup, you can override anything you want in ~/.vimrc.local, which is loaded by the stock vimrc.sample
