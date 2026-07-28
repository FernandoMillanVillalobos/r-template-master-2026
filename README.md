# Disclaimer

*This template is based almost enterely on the rddj-template created by Timo Grossenbacher. The test files, test.csv, abc.csv and xyx.csv, from input and output folders as well as myscript.R from scripts were erased. As a general purpose template for all kind of R projects, it may include some other new scripts files and custom modifications.*

*What follows it´s the original content of the README.md file include in the template, updated to reflect the project's move from `checkpoint`/MRAN to `renv`, from `setwd()` to `here()`, and from R Markdown to [Quarto](https://quarto.org/).*

# rddj-template

*A template for bootstrapping reproducible Quarto documents for data journalistic purposes.*

## Features

* Comes with cutting-edge, tried-and-tested packages for efficient data journalism with R, such as the `tidyverse`
* *Full* **reproducibility** with pinned package versions (thanks to the `renv` package)
* Runs out of the box and in one go, user doesn't have to have anything pre-installed (except R, Quarto, and maybe RStudio or Positron)
* Automatic deployment to **GitHub pages** via Quarto's built-in `quarto publish gh-pages`, see [this example](https://grssnbchr.github.io/rddj-template)
* Code **linting** according to the `tidyverse` style guide
* Preconfigured `.gitignore` which ignores shadow files, access tokens and the like per default
* Working directory is set "automagically" (thanks to the [`here`](https://here.r-lib.org/) package)

*For more information please see the [accompanying blog post](https://timogrossenbacher.ch/2017/07/a-truly-reproducible-r-workflow/), which describes the original `checkpoint`/R Markdown-based approach this template has since moved on from.*

## Setup

First, clone and *reset* git repository.

```
git clone https://github.com/grssnbchr/rddj-template.git
cd rddj-template
   rm -rf .git
git init
```

If you have a remote repository, you can add it like so: 

```
git remote add origin https://github.com/user/repo.git
```

You'll also need [Quarto](https://quarto.org/docs/get-started/) installed (a separate command-line tool, not an R package) -- both RStudio and Positron bundle a recent version, or you can install it standalone.

## How to run

0. The main document `main.qmd` lies in the folder `analysis`. This is where most of your code resides.

1. Set config variables in the very first chunk, specifically:
  * `r_version`: The R version this project was built with. On render, `main.qmd` checks this against the R version you actually have installed and stops with a clear error if they don't match, so version mismatches surface immediately instead of as confusing downstream package errors. Package version reproducibility itself is handled separately, by `renv` (see "Package management with `renv`" below) — you don't need a package snapshot date anymore.
  * `options(Ncpus = x)`: People with multi-core machines can get a performance boost by specifying more than one core here. If you don't know the number of cores on your machine, set `x` to `1`.

2. **Run the script**: The individual R chunks can be run interactively in RStudio or Positron (`Run > Run All`, or run chunk-by-chunk). Be advised that some packages, like `rgdal`, need additional third party libraries installed. Watch out for compiler/installation messages in the R console.

3. **Rendering the Quarto document**: Both RStudio's and Positron's "Render" button work directly and reliably here -- there's no more session-restart dance to work around, since this project uses `renv` instead of `checkpoint`. The "Install packages" chunk in `main.qmd` calls `renv::restore(project = here::here(), prompt = FALSE)` automatically, which restores the exact package versions recorded in `renv.lock` into this project's own library before anything else runs, regardless of what your working directory happens to be during the render. From the command line, the equivalent is:

   ```
   quarto render analysis/main.qmd
   ```

   This produces `analysis/main.html`. Quarto bundles its own Pandoc, so the old `PATH`/Pandoc-location workarounds from the R Markdown days no longer apply.

## Working with Positron

This project needs nothing extra to work in [Positron](https://positron.posit.co/): open the folder (or the `.Rproj` file) as you would in RStudio, and Positron picks up the R interpreter and activates `renv` the same way. Its Console, Variables, and Plots panes behave like RStudio's, and it has native Quarto support built in -- open `analysis/main.qmd` and use the **Render** button, or run `quarto preview analysis/main.qmd` in the terminal for a live-reloading preview while you edit.

## Branches *(historical)*

There used to be four branches, each pinning a different R version + CRAN snapshot date via `checkpoint`:

* master: R 3.6.x and packages as of 2020-01-01
* r-3.5: R 3.5.3 and packages as of 2019-03-01
* r-3.4: R 3.4.4 and packages as of 2018-04-01
* r-3.3: R 3.3.3 and packages as of 2017-01-01

That branch-per-snapshot-date scheme was a workaround for how `checkpoint` pinned packages. With `renv`, a single branch's `renv.lock` already pins exact package versions, so a separate branch per R-version/date combination generally isn't needed anymore — one branch, one lockfile. This list is kept here for historical reference; feel free to prune these branches if your repo still carries them and you don't rely on them.

## OS support

`renv`, Quarto, and current-generation `tidyverse` packages install cleanly on recent Windows, macOS, and Linux without special handling. The compiler and package-compatibility caveats that used to live here were specific to the old `checkpoint`-pinned R 3.3–3.6 branches above (mostly around `rgdal`/`libcurl`/`devtools` on older systems) and no longer apply if you're on a current branch. If you do resurrect one of those historical branches, expect to run into that generation's package-compilation quirks and consult R/package-specific resources for the OS you're on.

## Package management with `renv`

This project uses [renv](https://rstudio.github.io/renv/) instead of `checkpoint`/MRAN to keep an isolated, reproducible package library. This isn't just a style preference: Microsoft retired MRAN and the CRAN Time Machine snapshot service on July 1, 2023, and `checkpoint` itself stopped being able to fetch snapshots shortly before that — so the old approach no longer works at all, regardless of preference.

### First time cloning this repo (renv.lock already exists)

1. Open the project's `.Rproj` file in RStudio or Positron (or otherwise make sure your working directory is the project root). This triggers `.Rprofile`, which auto-loads `renv`.
2. Run:

   ```r
   renv::restore()
   ```

   This reads `renv.lock` and installs the exact package versions this project was built with, into a project-local library — it won't touch your other R installations. (Rendering `main.qmd` also does this automatically, so this step is optional but useful if you want packages ready before you start poking around interactively.)
3. Render `analysis/main.qmd`.

### If this is a brand-new project (no `renv.lock` yet)

1. Make sure all packages listed in `main.qmd`'s `Define packages` chunk are installed.
2. Open the project via its `.Rproj` file and run `renv::init()` once, from the console — not by rendering. This scans the project for packages in use and creates `renv.lock`, `renv/activate.R`, and adds the `.Rprofile` hook.
3. Commit `renv.lock`, `renv/activate.R`, `renv/settings.json`, and `.Rprofile`.

### Adding or updating a package

1. Add it to the `packages` vector in the `Define packages` chunk of `main.qmd`.
2. Install it as usual (`install.packages("pkgname")`).
3. Run `renv::snapshot()` to record the new version in `renv.lock`.
4. Commit the updated `renv.lock`.

## Deployment to GitHub pages

Deployment no longer goes through custom `deploy.sh`/`knit.sh` scripts — Quarto has this built in. `deploy.sh` and `knit.sh` have been removed from this template; you can delete your own copies too.

1. Make sure there **are no unstaged changes** in your working directory. Either `git commit` them or `git stash` them before continuing.
2. Make sure you're in the root folder of your project (the one above `analysis`), and that you are **not** on the `gh-pages` branch.
3. Add `/.quarto/` to your `.gitignore` if it isn't there already (Quarto's local render cache; it shouldn't be committed).
4. Run:

   ```
   quarto publish gh-pages analysis/main.qmd
   ```

That's it. On first run, this automatically creates the `gh-pages` branch (locally and on the remote) if it doesn't already exist, renders `analysis/main.qmd`, publishes the result to the root of that branch (so it shows up as `https://user.github.io/repo/`), and pushes. For every subsequent deploy, just re-run the same command from your normal working branch.

A few things worth knowing:

* The first run also creates a `_publish.yml` file recording your publish target — commit that alongside your other files.
* If your repository is a *user/organization* site (`https://username.github.io`, not a project site), GitHub's default publishing source is the `main` branch rather than `gh-pages`; Quarto will print a direct link to the **Settings → Pages** screen where you switch that manually, the first time this applies to you.
* Use `quarto publish gh-pages --no-browser` if you don't want a browser tab opened automatically once the site is live (handy for headless/CI environments).
* `deploy.sh` used to also bundle `main.Rmd`, `scripts`, `input`, and `output` into a downloadable `rscript.zip` for people who don't use Git. That's gone now, but GitHub's own **Code → Download ZIP** button on the repo page already covers the same need, so nothing is really lost.
* If you want deployment to run automatically on every push instead of manually from your machine, Quarto also supports a GitHub Action for this — see the [Quarto GitHub Pages guide](https://quarto.org/docs/publishing/github-pages.html#github-action) for a ready-made workflow file, including a `renv`-aware example.

## Linting / styleguide

Code is automatically *linted* with `lintr`, i.e. checked for good style and syntax errors according to the [tidyverse style guide](http://style.tidyverse.org/). `lintr` supports `.qmd` files out of the box, so this carries over unchanged from the R Markdown days. When being rendered, the `lintr` output is at the very end of the document. When being interpreted interactively, the `lintr` output appears in a new `Markers` pane at the bottom of RStudio (or the Problems pane in Positron). Linting is commented out by default in `main.qmd`'s last chunk — uncomment the relevant lines there if you want it to run.

## Other stuff / more features

### Versioning of input and output

`input` and `output` files are not ignored by default. This has the advantage that output can be monitored for change when (subtle) details of the R code are changed. 

If you want to ignore (big) input or output files, put them into the respective `ignore` folders. GitHub only allows a maximum file size of 100MB as of summer 2017.

### Ability to outsource code to script files

If you want to keep your `main.qmd` as tidy and brief as possible, you have the possibility to put separate functions and other code into script files that reside in the `analysis/scripts` folder. An example of this is provided in `main.qmd`.

### Multiple CPU cores for faster package installation

By default, more than one core is used for package installation (via `options(Ncpus = ...)`), which significantly speeds up both `install.packages()` calls and `renv::restore()`.

### Optimal RStudio / Positron settings

It is recommended to disable workspace saving (in RStudio: *Tools > Global Options > General*, uncheck "Restore .RData into workspace at startup" and set "Save workspace to .RData on exit" to "Never"; Positron has the equivalent under its own settings). Starting each session from a clean slate makes it much more obvious when your script actually reproduces its own results, rather than quietly depending on leftover objects from a previous session.

## Installation of older R versions *(historical)*

The instructions below come from the old branch-per-R-version scheme described above. With `renv` pinning package versions per-project, most people won't need to juggle multiple parallel R installations just to reproduce a given branch — but the advice is kept here in case you do need to install a specific older R version for some other reason.

### Debian (tested on Ubuntu 16.04 and higher)

Compiled with information from [here](http://r.789695.n4.nabble.com/Installing-different-versions-of-R-simultaneously-on-Linux-td879536.html), [here](https://cloud.r-project.org/doc/FAQ/R-FAQ.html#How-can-R-be-installed-_0028Unix_002dlike_0029) and [here](http://spartanideas.msu.edu/2015/06/19/alternative-versions-of-r/).

* Download the required archive from [here](https://cloud.r-project.org/src/base/)
* Untar and move it to the `/opt/src` directory with `sudo tar -xvf R-x.y.z.tar.gz -C /opt/src`, this will create a new directory
* Change into that new directory and run `sudo ./configure --enable-R-shlib --with-cairo=yes --prefix=/opt/R/R-x.y.z` (**change placeholders!**)
* Install some graphics dependencies `sudo apt-get install libcairo2-dev libgtk2.0-dev libtiff5-dev libx11-dev` if not already done.
* Compile it with `sudo make`
* Optionally run `sudo make check`
* Install it with `sudo make install`
* There should be an executable binary in `/opt/R/R-x.y.z/bin` now.
* In order to let your system know of that new R version and to be able to switch between alternatives, do this:
  * Run `update-alternatives --list R` to see whether R is already registered with alternative versions
  * If not, make a default alternative `sudo rm -rf /usr/bin/R && sudo update-alternatives --install /usr/bin/R R /usr/lib/R/bin/R 1000` (this is probably the newest R version from the Debian package management system)
  * Add the newly installed R version as alternative `sudo update-alternatives --install /usr/bin/R R /opt/R/R-x.y.z/bin/R 100`
  * Check with `update-alternatives --display R`.
  * From now on, you can easily switch between R versions doing `sudo update-alternatives --config R`. Do this before you start RStudio (RStudio always uses the symlink in `/usr/bin/R`). If there's a problem with a "broken" group, you can "force" the switch with the `--force` flag right after `update-alternatives`.
  * If the `update-alternatives` switch does not work for some reason, manually set a link with `sudo ln -sf /opt/R/R-x.y.z/bin/R /usr/bin/R` to switch to version `x.y.z`.
  
### macOS X (tested on High Sierra and higher)

* First of all, you need to have at least one R version installed (probably the latest one).
* Navigate to r.research.att.com and download/install the so-called [RSwitch GUI](http://r.research.att.com/RSwitch-1.2.dmg).
* Download the patched versions of the branch you want to install (earliest available branch is 3.3.) under [this section](http://r.research.att.com/#nightly).
* Extract the downloaded `*.tar.gz` file and move the folder `Library/Frameworks/R.framework/Versions/x.y` to `/Library/Frameworks/R.framework/Versions/`.
* Launch "RSwitch GUI" and switch between R versions (change is effective immediately, no need to restart RStudio, only R).

### Windows 10

* Install all desired R binaries directly from [r-project.org](https://cloud.r-project.org/bin/windows/base/old/).
* RStudio (tested with 1.1.463) has a very convenient switch for R versions that can be found under *Tools > Global Options > General > R version*. After switching, restart RStudio. 
