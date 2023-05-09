@react.component
let make = (~model, ~children) => {
  <WidgetModel.Context.Provider value={model}> children </WidgetModel.Context.Provider>
}
