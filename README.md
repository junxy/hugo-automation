# hugo-automation

- 开箱即用，运行 `./hugow` 自动检测下载 `hugo`

```bash
./hugow new site blog

cd blog

## Download the theme
# git init
# git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
# echo 'theme = "ananke"' >> config.toml

## preview
./hugow serve -D

## writer
# ../hugow new posts/my-first-post.md

## install hugo to system -> (/usr/local/bin/hugo) then gen autocomplete
sudo ./hugow install
```

## deploy

```bash
# init branch first time
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "Initializing gh-pages branch"
git push origin gh-pages  # upstream -> origin
git checkout master

# push
./publish_to_ghpages.sh

```
