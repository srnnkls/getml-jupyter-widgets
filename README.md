# getml-jupyter-widgets

Jupyter widgets for getML

## Installation

You can install using `pip`:

```bash
pip install -e getml_jupyter_widgets
```

## Development Installation

TBD.

### How to see your changes

#### Rescript

If you use JupyterLab to develop then you can watch the source directory and run JupyterLab at the same time in different
terminals to watch for changes in the extension's source and automatically rebuild the widget.

```bash
# Watch the source directory in one terminal, automatically rebuilding when needed
npm run watch
# Run JupyterLab in another terminal
jupyter lab
```

After a change wait for the build to finish and then refresh your browser and the changes should take effect.

#### Python:

If you make a change to the python code then you will need to restart the notebook kernel to have it take effect.
