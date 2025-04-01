# Solarus Documentation

Source code for the **documentation** of the [Solarus game engine](https://www.solarus-games.org/), built with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

## Setup

First, install `mkdocs` and plugins:

```bash
pip install -r requirements.txt
```

To run the website locally, go to the website directory, then type:

```bash
mkdocs serve
```

## Build

To build the website to the `/public` directory, ready to be deployed:

```bash
rm -rf ./public
mkdocs build --site-dir public
```

## Thanks

Thanks to [S2009](https://s2009.fr) and [PenTaist](https://pentaist.fr) who helped carrying out the migration of the documentation from Doxygen to MkDocs.
