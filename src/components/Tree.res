module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}

module Group = {
  @module("@visx/group") @react.component
  external make: (~top: float, ~left: float, ~children: React.element) => React.element = "Group"
}

module Math = {
  @val @scope("Math")
  external pi: float = "PI"

  @val @scope("Math") @variadic
  external min: array<float> => float = "min"
}

module Colors = {
  type t = [
    | #peach
    | #pink
    | #blue
    | #green
    | #plum
    | #lightpurple
    | #strawberry
    | #white
    | #blueGray
    | #background
  ]
  let hex = (name: t): string => {
    switch name {
    | #peach => "#d54c4c"
    | #pink => "#fe6e9e"
    | #blue => "#03c0dc"
    | #green => "#26deb0"
    | #plum => "#71248e"
    | #strawberry => "#ff9191"
    | #lightpurple => "#374469"
    | #white => "#ffffff"
    | #blueGray => "#272b4d"
    | #background => "#ffffff"
    }
  }
}

module LinearGradient = {
  @module("@visx/gradient") @react.component
  external make: (~id: string, ~from: string, ~to: string) => React.element = "LinearGradient"
}

module D3 = {
  type rec treeNode = {
    name: string,
    children?: array<treeNode>,
  }

  type rec hierarchyNode = {
    x: float,
    y: float,
    depth: int,
    data: treeNode,
    parent: hierarchyNode,
  }

  type link = {
    x: float,
    y: float,
    source: hierarchyNode,
    target: hierarchyNode,
  }

  type coordinates = (float, float)

  @module("d3-shape")
  external pointRadial: (float, float) => coordinates = "pointRadial"

  @module("@visx/hierarchy")
  external hierarchy: treeNode => hierarchyNode = "hierarchy"

  @send external links: hierarchyNode => array<link> = "links"
  @send external descendants: hierarchyNode => array<hierarchyNode> = "descendants"
}

let rawTree: D3.treeNode = {
  name: "paper",
  children: [
    {
      name: "cites",
      children: [{name: "content"}, {name: "paper"}],
    },
    {name: "content"},
    {
      name: "cites",
      children: [{name: "content"}, {name: "paper"}],
    },
  ],
}

module Tree = {
  type size = (float, float)

  @module("@visx/hierarchy") @react.component
  external make: (
    ~root: D3.hierarchyNode,
    ~size: size,
    ~separation: (D3.hierarchyNode, D3.hierarchyNode) => float,
    ~children: D3.hierarchyNode => React.element,
  ) => React.element = "Tree"
}

module Event = {
  type point = {x: float, y: float}
  @module("@visx/event")
  external localPoint: ReactEvent.Mouse.t => point = "localPoint"
}

module Tooltip = {
  type data = {
    tooltipLeft: float,
    tooltipTop: float,
    tooltipData?: D3.link,
  }
  type t = {
    tooltipOpen: bool,
    tooltipLeft: float,
    tooltipTop: float,
    hideTooltip: unit => unit,
    showTooltip: data => unit,
    tooltipData: D3.link,
  }

  @module("@visx/tooltip")
  external use: unit => t = "useTooltip"

  @module("@visx/tooltip") @react.component
  external make: (~left: float, ~top: float, ~children: React.element) => React.element = "Tooltip"
}

module LinkHorizontal = {
  @module("@visx/shape") @react.component
  external make: (
    ~key: string,
    ~data: D3.link,
    ~stroke: string,
    ~strokeWidth: string,
    ~fill: string,
  ) => React.element = "LinkHorizontal"
}

module LinkRadial = {
  @module("@visx/shape") @react.component
  external make: (
    ~key: string,
    ~data: D3.link,
    ~stroke: string,
    ~strokeWidth: string,
    ~fill: string,
    ~onMouseLeave: ReactEvent.Mouse.t => unit=?,
    ~onMouseMove: ReactEvent.Mouse.t => unit=?,
  ) => React.element = "LinkRadial"
}

module PopulationNode = {
  @react.component
  let make = (~node: D3.hierarchyNode) => {
    let (left, top) = D3.pointRadial(node.x, node.y)
    let top = top +. 25.0
    <Group top left>
      <circle r="25" fill="url('#population-gradient')" />
      <text
        dy=".33em"
        fontSize="9"
        fontFamily="Arial"
        textAnchor="middle"
        style={{pointerEvents: "none"}}
        fill={Colors.hex(#white)}>
        {node.data.name->React.string}
      </text>
    </Group>
  }
}

module PeripheralNode = {
  @react.component
  let make = (~node: D3.hierarchyNode, ~height, ~width, ~x, ~y) => {
    let (left, top) = D3.pointRadial(node.x, node.y)
    <Group top left>
      // <circle r="25" fill={Colors.hex(#white)} stroke={Colors.hex(#peach)} strokeWidth="1" />
      <rect
        height
        width
        y
        x
        fill={Colors.hex(#background)}
        stroke={Colors.hex(#peach)}
        strokeWidth="1"
        rx="12"
        onClick={_ => {
          Window.alert(`clicked: ${node.data.name}`)
        }}
      />
      <text
        dy=".33em"
        fontSize="9"
        fontFamily="Arial"
        textAnchor="middle"
        style={{pointerEvents: "none"}}
        fill={Colors.hex(#blueGray)}>
        {node.data.name->React.string}
      </text>
    </Group>
  }
}

module Node = {
  let widthRaw = 40.0
  let heightRaw = 25.0
  let x = -.(widthRaw /. 2.0)->Float.toString
  let y = -.(heightRaw /. 2.0)->Float.toString
  let width = widthRaw->Float.toString
  let height = heightRaw->Float.toString

  @react.component
  let make = (~node: D3.hierarchyNode) => {
    if node.depth == 0 {
      <PopulationNode node />
    } else {
      <PeripheralNode node height width x y />
    }
  }
}

module Margin = {
  type t = {top: float, left: float, right: float, bottom: float}
  let default = {top: 0.0, left: 0.0, right: 0.0, bottom: 30.0}
}

module Example = {
  // let data = React.useMemo(_ => D3.hierarchy(rawTree))
  type origin = {x: float, y: float}
  let data = D3.hierarchy(rawTree)

  @react.component
  let make = (~width, ~height, ~margin=Margin.default) => {
    let innerHeight = height->Int.toFloat -. margin.top -. margin.bottom
    let innerWidth = width->Int.toFloat -. margin.left -. margin.right

    let origin = {
      x: innerWidth /. 2.0,
      y: innerHeight /. 2.0,
    }
    let sizeWidth = 2.0 *. Math.pi
    let sizeHeight = Math.min([innerWidth, innerHeight]) /. 2.0

    let height = height->Int.toString
    let width = width->Int.toString

    let {
      tooltipOpen,
      tooltipLeft,
      tooltipTop,
      tooltipData,
      hideTooltip,
      showTooltip,
    } = Tooltip.use()

    let (tooltipTimeout, setTooltipTimeout) = React.useState(_ => None)
    <div className="">
      <svg width={width} height={height}>
        <LinearGradient id="population-gradient" from={Colors.hex(#peach)} to={Colors.hex(#plum)} />
        // <rect width height rx="14" fill={Colors.hex(#background)} />
        <Tree
          root=data
          size=(sizeWidth, sizeHeight)
          separation={(a, b) => (a.parent == b.parent ? 1.0 : 2.0) /. a.depth->Int.toFloat}>
          {tree =>
            <Group top={origin.y} left={origin.x}>
              {D3.links(tree)
              ->Array.mapWithIndex((link, i) => {
                let key = i->Int.toString
                <Group top={link.y} left={link.x} key>
                  <LinkRadial
                    data=link stroke={Colors.hex(#lightpurple)} strokeWidth="1" fill="none"
                  />
                  <LinkRadial
                    data=link
                    stroke="transparent"
                    strokeWidth="10"
                    fill="none"
                    onMouseLeave={_ => {
                      let tooltipTimeout = setTimeout(() => {
                        hideTooltip()
                      }, 300)
                    }}
                    onMouseMove={event => {
                      switch tooltipTimeout {
                      | Some(timeout) => clearTimeout(timeout)
                      | None => ()
                      }
                      let eventSvgCoords = Event.localPoint(event)
                      showTooltip({
                        tooltipData: link,
                        tooltipTop: eventSvgCoords.y,
                        tooltipLeft: eventSvgCoords.x,
                      })
                    }}
                  />
                </Group>
              })
              ->React.array}
              {D3.descendants(tree)
              ->Array.mapWithIndex((node, i) => {
                let key = i->Int.toString
                <Node node key />
              })
              ->React.array}
            </Group>}
        </Tree>
      </svg>
      {tooltipOpen
        ? {
            let parent = tooltipData.source
            let child = tooltipData.target
            <Tooltip top={tooltipTop} left={tooltipLeft}>
              <div className="mb-3">
                {`${parent.data.name} → ${child.data.name}`->React.string}
              </div>
              <div> {"on: "->React.string} </div>
            </Tooltip>
          }
        : React.null}
    </div>
  }
}
