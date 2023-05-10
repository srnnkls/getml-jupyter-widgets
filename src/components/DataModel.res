module WidgetPane = {
  @react.component
  let make = () => {
    let (tree: Visx.D3.treeNode, _) = WidgetModel.useState("tree")
      <Tree data=tree width=600 height=500 />
  }
}

@react.component
let default = (~model) => {
  <ModelContext model>
    <WidgetPane />
  </ModelContext>
}
