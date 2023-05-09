module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}

module Group = {
  @module("@visx/group") @react.component
  external make: (~top: int, ~left: int, ~children: React.element) => React.element = "Group"
}

module Colors = {
  type t = [
    | #peach
    | #pink
    | #blue
    | #green
    | #plum
    | #lightpurple
    | #white
    | #blueGray
    | #background
  ]
  let hex = (name: t): string => {
    switch name {
    | #peach => "#fd9b93"
    | #pink => "#fe6e9e"
    | #blue => "#03c0dc"
    | #green => "#26deb0"
    | #plum => "#71248e"
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

  type hierarchyNode = {
    x: int,
    y: int,
    depth: int,
    data: treeNode,
  }

  type linkHorizontal

  @module("@visx/hierarchy")
  external hierarchy: treeNode => hierarchyNode = "hierarchy"

  @send external links: hierarchyNode => array<linkHorizontal> = "links"
  @send external descendants: hierarchyNode => array<hierarchyNode> = "descendants"
}

let rawTree: D3.treeNode = {
  name: "Population",
  children: [
    {
      name: "Peripheral 1",
      children: [
        {name: "A1"},
        {name: "A2"},
        {name: "A3"},
        {
          name: "C",
          children: [
            {
              name: "C1",
            },
            {
              name: "D",
              children: [
                {
                  name: "D1",
                },
                {
                  name: "D2",
                },
                {
                  name: "D3",
                },
              ],
            },
          ],
        },
      ],
    },
    {name: "Z"},
    {
      name: "Peripheral 2",
      children: [{name: "B1"}, {name: "B2"}, {name: "B3"}],
    },
  ],
}

module Tree = {
  type size = (int, int)

  @module("@visx/hierarchy") @react.component
  external make: (
    ~root: D3.hierarchyNode,
    ~size: size,
    ~children: D3.hierarchyNode => React.element,
  ) => React.element = "Tree"
}

module LinkHorizontal = {
  @module("@visx/shape") @react.component
  external make: (
    ~key: string,
    ~data: D3.linkHorizontal,
    ~stroke: string,
    ~strokeWidth: string,
    ~fill: string,
  ) => React.element = "LinkHorizontal"
}

module RootNode = {
  @react.component
  let make = (~node: D3.hierarchyNode) => {
    <Group top={node.x} left={node.y}>
      <circle r="33" fill="url('#lg')" />
      <text
        dy=".33em"
        fontSize="9"
        fontFamily="Arial"
        textAnchor="middle"
        style={{pointerEvents: "none"}}
        fill={Colors.hex(#plum)}>
        {node.data.name->React.string}
      </text>
    </Group>
  }
}

module ParentNode = {
  @react.component
  let make = (~node: D3.hierarchyNode, ~height, ~width, ~x, ~y) => {
    <Group top={node.x} left={node.y}>
      <rect
        height
        width
        y
        x
        fill={Colors.hex(#background)}
        stroke={Colors.hex(#blue)}
        strokeWidth="1"
        rx="5"
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

module LeafNode = {
  @react.component
  let make = (~node: D3.hierarchyNode, ~height, ~width, ~x, ~y) => {
    <Group top={node.x} left={node.y}>
      <rect
        height
        width
        y
        x
        fill={Colors.hex(#background)}
        stroke={Colors.hex(#blue)}
        strokeWidth="1"
        strokeDasharray="2,2"
        strokeOpacity="0.6"
        rx="10"
        onClick={_ => {
          Window.alert(`clicked: ${node.data.name}`)
        }}
      />
      <text
        dy=".33em"
        fontSize="9"
        fontFamily="Arial"
        textAnchor="middle"
        fill={Colors.hex(#green)}
        style={{pointerEvents: "none"}}>
        {node.data.name->React.string}
      </text>
    </Group>
  }
}

module Node = {
  let widthRaw = 80.0
  let heightRaw = 30.0
  let x = -.(widthRaw /. 2.0)->Float.toString
  let y = -.(heightRaw /. 2.0)->Float.toString
  let width = widthRaw->Float.toString
  let height = heightRaw->Float.toString

  @react.component
  let make = (~node: D3.hierarchyNode) => {
    if node.depth == 0 {
      <RootNode node />
    } else {
      switch node.data.children {
      | Some(_children) => <ParentNode node height width x y />
      | None => <LeafNode node height width x y />
      }
    }
  }
}

module Margin = {
  type t = {top: int, left: int, right: int, bottom: int}
  let default = {top: 10, left: 80, right: 80, bottom: 10}
}

module Example = {
  // let data = React.useMemo(_ => D3.hierarchy(rawTree))
  let data = D3.hierarchy(rawTree)
  @react.component
  let make = (~width, ~height, ~margin=Margin.default) => {
    let yMax = height - margin.top - margin.bottom
    let xMax = width - margin.left - margin.right
    let height = height->Int.toString
    let width = width->Int.toString
    <svg width={width} height={height}>
      <LinearGradient id="lg" from={Colors.hex(#peach)} to={Colors.hex(#pink)} />
      // <rect width height rx="14" fill={Colors.hex(#background)} />
      <Tree root=data size=(yMax, xMax)>
        {tree =>
          <Group top={margin.top} left={margin.left}>
            {D3.links(tree)
            ->Array.mapWithIndex((link, i) => {
              <LinkHorizontal
                key={`link${i->Int.toString}`}
                data=link
                stroke={Colors.hex(#lightpurple)}
                strokeWidth="1"
                fill="none"
              />
            })
            ->React.array}
            {D3.descendants(tree)
            ->Array.mapWithIndex((node, i) => {
              <Node key={`link${i->Int.toString}`} node />
            })
            ->React.array}
          </Group>}
      </Tree>
    </svg>
  }
}
