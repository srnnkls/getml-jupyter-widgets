// Generated by ReScript, PLEASE EDIT WITH CARE


import './main.css';
;

import { DOMWidgetModel } from '@jupyter-widgets/base';
import { MODULE_NAME, MODULE_VERSION } from './version';


export class ExampleWidgetModel extends DOMWidgetModel {
  defaults() {
    return {
      ...super.defaults(),
      _model_name: metaData.modelName,
      _model_module: MODULE_NAME,
      _model_module_version: MODULE_VERSION,
      _view_name: metaData.viewName,
      _view_module: MODULE_NAME,
      _view_module_version: MODULE_VERSION,
      ...defaultModelProperties
    };
  }

}
;

import { DOMWidgetView } from '@jupyter-widgets/base';
import Example from "./components/Example.bs"
import React from 'react';
import ReactDOM from 'react-dom';

export class ExampleWidgetView extends DOMWidgetView {
  render() {
    const component = React.createElement(Example, {
      model: this.model,
    });
    ReactDOM.render(component, this.el);
  }
}
;

var metaData = {
  modelName: "ExampleWidgetModel",
  viewName: "ExampleWidgetView"
};

var defaultModelProperties = {
  value: "Hello World"
};

export {
  metaData ,
  defaultModelProperties ,
}
/*  Not a pure module */
