module WidgetRegistry = {
  @module("@jupyter-widgets/base")
  type t

  @module("@jupyter-widgets/base") @val external registry: t = "IJupyterWidgetRegistry"
  @send external registerWidget: (t, 'regEntity) => unit = "registerWidget"
}

module Lumino = {
  module App = {
    @module("@lumino/application")
    type t<'a>
  }

  module Widget = {
    @module("@lumino/widget")
    type t
  }
}

module JsPackage = {
  @module("./version")
  external version: string = "MODULE_VERSION"

  @module("./version")
  external name: string = "MODULE_NAME"
}

@module("./ExampleWidget.bs") external exampleWidgetModel: DOMWidget.model = "ExampleWidgetModel"
@module("./ExampleWidget.bs") external exampleWidgetView: DOMWidget.view = "ExampleWidgetView"
@module("./DataModelWidget.bs")
external dataModelWidgetModel: DOMWidget.model = "DataModelWidgetModel"
@module("./DataModelWidget.bs")
external dataModelWidgetView: DOMWidget.view = "DataModelWidgetView"

// @module external dataModelWidget: Dict.t<'a> = "./DataModelWidget.bs"
// @module external exampleModelWidget: Dict.t<'a> = "./ExampleModelWidget.bs"

type plugin = {
  id: string,
  requires: array<WidgetRegistry.t>,
  activate: (Lumino.App.t<Lumino.Widget.t>, WidgetRegistry.t) => unit,
  autoStart: bool,
}

let extensionId = `${JsPackage.name}:plugin`

let activateWidgetExtension = (_app, registry) => {
  WidgetRegistry.registerWidget(
    registry,
    {
      "name": JsPackage.name,
      "version": JsPackage.version,
      // "exports": dataModelWidget,
      "exports": {
        "DataModelWidgetModel": dataModelWidgetModel,
        "DataModelWidgetView": dataModelWidgetView,
        "ExampleWidgetModel": exampleWidgetModel,
        "ExampleWidgetView": exampleWidgetView,
      },
    },
  )
}

let examplePlugin = {
  id: extensionId,
  requires: [WidgetRegistry.registry],
  activate: activateWidgetExtension,
  autoStart: true,
}

let default = examplePlugin
