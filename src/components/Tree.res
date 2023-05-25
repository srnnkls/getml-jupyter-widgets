open Visx

module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}

module Math = {
  @val @scope("Math")
  external pi: float = "PI"

  @val @scope("Math") @variadic
  external min: array<float> => float = "min"
}

module XMLSerializer = {
  type t

  @new external make: unit => t = "XMLSerializer"
  @send external serializeToString: (t, Dom.element) => string = "serializeToString"
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

module PopulationNode = {
  @react.component
  let make = (~node: D3.hierarchyNode) => {
    let (left, top) = D3.pointRadial(node.x, node.y)
    let top = top +. 25.0
    <Group top left>
      <circle r="30" fill="url('#population-gradient')" />
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
  let widthRaw = 45.0
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

module Link = {
  @react.component
  let make = (~data: D3.link, ~stroke, ~strokeWidth, ~fill, ~onMouseLeave, ~onMouseMove) => {
    <Group top=data.y left=data.x>
      <LinkRadial data stroke strokeWidth fill />
      <LinkRadial data stroke="transparent" strokeWidth="10" fill="none" onMouseLeave onMouseMove />
    </Group>
  }
}

module Margin = {
  type t = {top: int, left: int, right: int, bottom: int}
  let default = {top: 0, left: 0, right: 0, bottom: 30}
}

type origin = {x: float, y: float}

@react.component
let make = (~data, ~width, ~height, ~margin=Margin.default) => {
  let data = D3.hierarchy(data)

  let innerHeight = (height - margin.top - margin.bottom)->Int.toFloat
  let innerWidth = (width - margin.left - margin.right)->Int.toFloat

  let origin = {
    x: innerWidth /. 2.0,
    y: innerHeight /. 2.0,
  }
  let sizeWidth = 2.0 *. Math.pi
  let sizeHeight = Math.min([innerWidth, innerHeight]) /. 2.0

  let height = height->Int.toString
  let width = width->Int.toString

  let {tooltipOpen, tooltipLeft, tooltipTop, tooltipData, hideTooltip, showTooltip} = Tooltip.use()
  let (tooltipTimeout, setTooltipTimeout) = React.useState(_ => None)

  let svgEl = React.useRef(Nullable.null)

  let (_, setSerializedSvg) = WidgetModel.useState("serialized_svg")

  React.useEffect1(() => {
    // serialize svg
    let serializer = XMLSerializer.make()
    switch svgEl.current->Nullable.toOption {
    | Some(el) =>
      let serialized = XMLSerializer.serializeToString(serializer, el)
      setSerializedSvg(serialized, ())
    | _ => ()
    }

    Some(_ => ())
  }, [data])

  <div>
    <svg width={width} height={height} ref={ReactDOM.Ref.domRef(svgEl)}>
      <LinearGradient id="population-gradient" from={Colors.hex(#peach)} to={Colors.hex(#plum)} />
      <Tree
        root=data
        size=(sizeWidth, sizeHeight)
        separation={(a, b) => (a.parent == b.parent ? 1.0 : 2.0) /. a.depth->Int.toFloat}>
        {tree =>
          <Group top={origin.y} left={origin.x}>
            {D3.links(tree)
            ->Array.mapWithIndex((link, i) => {
              let key = i->Int.toString
              <Link
                data=link
                stroke={Colors.hex(#lightpurple)}
                strokeWidth="1"
                fill="none"
                key
                onMouseLeave={_ => {
                  setTooltipTimeout(_ => Some(
                    setTimeout(
                      () => {
                        hideTooltip()
                      },
                      300,
                    ),
                  ))
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
          <Tooltip top={tooltipTop} left={tooltipLeft} style=Tooltip.styles>
            <div className="mb-3 text-[11px]">
              {`${parent.data.name} → ${child.data.name}`->React.string}
            </div>
            <div className="text-[10px]">
              {switch child.data.on {
              | Some(join) => `on: ${join}`->React.string
              | None => React.null
              }}
            </div>
          </Tooltip>
        }
      : React.null}
  </div>
}
