// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as WidgetModel from "./hooks/WidgetModel.bs.js";
import * as JsxRuntime from "react/jsx-runtime";

function ReactWidget$Widget(props) {
  var match = WidgetModel.useState("value");
  var setName = match[1];
  var name = match[0];
  var handleChange = function ($$event) {
    var target = $$event.currentTarget;
    Curry._2(setName, target.value, undefined);
  };
  return JsxRuntime.jsxs("div", {
              children: [
                JsxRuntime.jsx("div", {
                      children: "Hello " + name + ".",
                      className: "mb-2 text-4xl font-bold tracking-tight"
                    }),
                JsxRuntime.jsx("input", {
                      className: "block w-full rounded-md py-1.5 pl-2 pr-20 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-1 focus:ring-inset focus:ring-sky-500",
                      type: "text",
                      value: name,
                      onChange: handleChange
                    })
              ]
            });
}

var Widget = {
  make: ReactWidget$Widget
};

function ReactWidget$ModelContext(props) {
  return JsxRuntime.jsx(WidgetModel.Context.Provider.make, {
              value: props.model,
              children: props.children
            });
}

var ModelContext = {
  make: ReactWidget$ModelContext
};

function ReactWidget$default(props) {
  return JsxRuntime.jsx(ReactWidget$ModelContext, {
              model: props.model,
              children: JsxRuntime.jsx(ReactWidget$Widget, {})
            });
}

var $$default = ReactWidget$default;

export {
  Widget ,
  ModelContext ,
  $$default ,
  $$default as default,
}
/* WidgetModel Not a pure module */
