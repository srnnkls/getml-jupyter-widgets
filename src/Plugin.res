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

@module external widget: Widget.t = "./Widget.bs"

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
      "exports": widget,
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
