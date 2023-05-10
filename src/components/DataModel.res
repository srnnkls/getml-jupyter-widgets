module WidgetPane = {
  @react.component
  let make = () => {
    let (tree: Tree.D3.treeNode, _) = WidgetModel.useState("tree")

    // let population = tree.name
    // let peripherals = switch tree.children {
    // | Some(children) => Array.map(children, child => child.name)
    // | None => [""]
    // }

    // <div> {"Hello you"->React.string} </div>

    <>
      // <div> {`Population: ${population}`->React.string} </div>
      // <div> {`Peripherals: `->React.string} </div>
      // {Array.map(peripherals, perph => <li key=perph> {perph->React.string} </li>)->React.array}
      <Tree.Example data=tree width=1000 height=500 />
    </>
  }
}

@react.component
let default = (~model) => {
  <ModelContext model>
    <WidgetPane />
  </ModelContext>
}
