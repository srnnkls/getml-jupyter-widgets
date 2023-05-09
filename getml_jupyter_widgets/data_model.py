"""
Kernel-level representation of a getML datamodel.
"""

from ipywidgets import DOMWidget
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

    # the tree that represents a data model in d3.hieratchy format
    # https://github.com/d3/d3-hierarchy/blob/main/README.md#hierarchy
    tree = Dict({"name": "population", "children": [{"name": "peripheral"}]}).tag(
        sync=True
    )
