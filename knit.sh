#!/bin/bash
# knit
# add >>>export PATH="$PATH:/usr/lib/rstudio/bin/pandoc"<<< to your PATH in order for knitting to work

# first, find out OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# terminate if neither Linux nor Mac
if [ "$machine" != "Linux" -a "$machine" != "Mac" ]; then
  echo "ERROR: Your OS is not supported, terminating."
  exit 1
fi

# package versions are no longer pinned via a checkpoint/MRAN snapshot date,
# so there's no per-date library path to compute or export here anymore --
# main.Rmd's "Install packages" chunk calls renv::restore(project = here::here())
# itself, which restores the exact versions recorded in renv.lock into this
# project's own private library (renv/library/...).
#
# for that private library to actually be used (rather than silently
# falling back to your global R library), R needs to source this project's
# .Rprofile at startup -- that's what activates renv and points .libPaths()
# at the right place. so, unlike the old checkpoint-era version of this
# script, we deliberately do NOT pass --no-init-file below.
R -e 'library(rmarkdown); rmarkdown::render("analysis/main.Rmd", "html_document")' --no-site-file --no-restore --no-save || { echo "ERROR: knitting failed."; exit 1; }

# open browser
# TODO should probably be adapted for Mac OS
# xdg-open analysis/main.html
