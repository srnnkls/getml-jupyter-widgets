@module("@jupyter-widgets/base")
type t

@module("@jupyter-widgets/base") @new external make: unit => t = "WidgetModel"
@get external getName: t => string = "name"
@set external setName: (t, string) => unit = "name"
@send external get: (option<t>, string) => 'values = "get"
@send external set: (option<t>, string, string, 'values) => unit = "set"
@send external on: (option<t>, string, unit => unit) => unit = "on"
@send external unbind: (option<t>, string, unit => unit) => unit = "unbind"
@send external saveChanges: option<t> => unit = "save_changes"

module Context = {
  let context = React.createContext(None)

  module Provider = {
    let make = React.Context.provider(context)
  }
}

let use = () => {
  React.useContext(Context.context)
}

let useEvent = (~event, ~callback, ~deps: option<array<string>>=?, ()) => {
  let model = use()

  let dependencies = switch deps {
  | Some(deps) => (model, Some(deps))
  | None => (model, None)
  }

  React.useEffect2(() => {
    let callbackWrapper = _ => {
      callback(model)
    }

    on(model, event, callbackWrapper)

    let cleanup = () => unbind(model, event, callbackWrapper)

    Some(cleanup)
  }, dependencies)
}

let useState = name => {
  let model = use()
  let (state, setState) = React.useState(_ => get(model, name))

  let callback = model => setState(_ => get(model, name))
  useEvent(~event=`change:${name}`, ~callback, ~deps=[name], ())

  let updateModel = (val, options) => {
    set(model, name, val, options)
    saveChanges(model)
  }

  (state, updateModel)
}
