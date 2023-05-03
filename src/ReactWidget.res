module Widget = {
  @react.component
  let make = () => {
    let (name, setName) = WidgetModel.useState("value")

    let handleChange = event => {
      let target = ReactEvent.Form.currentTarget(event)
      setName(target["value"], ())
    }

    <div>
      <div className="mb-2 text-4xl font-bold tracking-tight">
        {`Hello ${name}.`->React.string}
      </div>
      <input
        className="block w-full rounded-md py-1.5 pl-2 pr-20 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-1 focus:ring-inset focus:ring-sky-500"
        type_="text"
        value=name
        onChange=handleChange
      />
    </div>
  }
}

module ModelContext = {
  @react.component
  let make = (~model, ~children) => {
    <WidgetModel.Context.Provider value={model}> children </WidgetModel.Context.Provider>
  }
}

@react.component
let default = (~model) => {
  <ModelContext model>
    <Widget />
  </ModelContext>
}
