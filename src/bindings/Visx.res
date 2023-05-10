module Group = {
  @module("@visx/group") @react.component
  external make: (~top: float, ~left: float, ~children: React.element) => React.element = "Group"
}

module LinearGradient = {
  @module("@visx/gradient") @react.component
  external make: (~id: string, ~from: string, ~to: string) => React.element = "LinearGradient"
}

module D3 = {
  type rec treeNode = {
    name: string,
    on?: string,
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
  @module("@visx/tooltip") @val external defaultStyles: ReactDOMStyle.t = "defaultStyles"
  let styles = {
    ...defaultStyles,
    minWidth: "60",
    borderRadius: "0.25rem",
    backgroundColor: "rgba(0,0,0,0.7)",
    color: "white",
  }
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
  external make: (
    ~left: float,
    ~top: float,
    ~className: string=?,
    ~style: 'style=?,
    ~children: React.element,
  ) => React.element = "Tooltip"
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
