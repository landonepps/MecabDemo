# MeCab Demo for iOS 15 and SPM

Sample project for MeCab, a Japanese tokenizer/morphological analyzer. Updated for iOS 15 and SPM.

Successor to [landonepps/mecab-ios-sample](https://github.com/landonepps/mecab-ios-sample)  
<img src=https://user-images.githubusercontent.com/1572318/136677292-40df577f-f7dc-412c-bd73-10c67d50b0d6.png width=250>

## UniDic and Git LFS
This project recenlty switched from ipadic to UniDic.

UniDic is a more modern dictionary, but it's also significantly larger and cannot be hosted on GitHub directly.  
To download all the files, use [Git LFS](https://git-lfs.github.com/).

Install Git LFS with Homebrew
```bash
brew install git-lfs
```
Then, run the fetch command inside the repo
```bash
git lfs fetch
```

## Swift Package Manager

Uses [landonepps/mecab](https://github.com/landonepps/mecab) SPM package to make setup easier.  
See the package repo for instructions on setting up MeCab in your own project.
