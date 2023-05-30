"""
Kernel-level representation of a getML datamodel.
"""

from ipywidgets import DOMWidget
from IPython.display import display, display_html, publish_display_data
from ipywidgets.widgets.widget import _put_buffers, _show_traceback
from traitlets import Unicode, Dict
import traitlets
from ._frontend import module_name, module_version

import logging

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


class DataModelWidget(DOMWidget):
    """
    DataModelWidget. Holds a Dict traitlet with the tree.
    """

    _model_name = Unicode("DataModelWidgetModel").tag(sync=True)
    _model_module = Unicode(module_name).tag(sync=True)
    _model_module_version = Unicode(module_version).tag(sync=True)
    _view_name = Unicode("DataModelWidgetView").tag(sync=True)
    _view_module = Unicode(module_name).tag(sync=True)
    _view_module_version = Unicode(module_version).tag(sync=True)

    _output_cell_refs = set()

    # the tree that represents a data model in d3.hieratchy format
    # https://github.com/d3/d3-hierarchy/blob/main/README.md#hierarchy
    tree = Dict({"name": "population", "children": [{"name": "peripheral"}]}).tag(
        sync=True
    )
    serialized_svg = Unicode("").tag(sync=True)

    # hook into serialized_svg trait updates
    @traitlets.observe("serialized_svg")
    def _update_outputs(self, change):
        text_html = {
            "text/html": change["new"],
        }
        mimebundle = {**self._repr_mimebundle_(), **text_html}
        for ref in self._output_cell_refs:
            ref.update(mimebundle, raw=True)

    def _ipython_display_(self):
        text_html = {"text/html": self.serialized_svg}
        mimebundle = {**self._repr_mimebundle_(), **text_html}
        ref = display(mimebundle, raw=True, display_id=True)
        if ref not in self._output_cell_refs:
            self._output_cell_refs.add(ref)
