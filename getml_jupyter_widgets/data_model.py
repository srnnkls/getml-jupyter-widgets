"""
Kernel-level representation of a getML datamodel.
"""

from ipywidgets import DOMWidget
from IPython.display import display, publish_display_data
from ipywidgets.widgets.widget import _put_buffers, _show_traceback
from traitlets import Unicode, Dict
from ._frontend import module_name, module_version


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

    @_show_traceback
    def _handle_msg(self, msg):
        """Called when a msg is received from the front-end"""
        data = msg["content"]["data"]
        method = data["method"]

        if method == "update":
            self._update_outputs(
                {
                    "text/html": data["state"]["serialized_svg"],
                }
            )

            if "state" in data:
                state = data["state"]
                if "buffer_paths" in data:
                    _put_buffers(state, data["buffer_paths"], msg["buffers"])
                self.set_state(state)

        # Handle a state request.
        elif method == "request_state":
            self.send_state()

        # Handle a custom msg from the front-end.
        elif method == "custom":
            if "content" in data:
                self._handle_custom_msg(data["content"], msg["buffers"])

    def _update_outputs(self, display_data):
        for out in self._output_cell_refs:
            out.update({**super()._repr_mimebundle_(), **display_data}, raw=True)

    def _ipython_display_(self):
        ref = display(super()._repr_mimebundle_(), raw=True, display_id=True)
        self._output_cell_refs.add(ref)

    def _repr_mimebundle_(self, **kwargs):
        pass
