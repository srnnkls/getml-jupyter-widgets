%%raw(`import './main.css';`)

type t

type metaData = {
  modelName: string,
  viewName: string,
}

type modelProps = {value: string}

let metaData = {
  modelName: "ExampleModel",
  viewName: "ExampleView",
}

let defaultModelProperties = {
  value: "Hello World",
}

// model
%%raw(`
import {DOMWidgetModel} from '@jupyter-widgets/base';
import { MODULE_NAME, MODULE_VERSION } from './version';


export class ExampleModel extends DOMWidgetModel {
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
`)

// view
%%raw(`
import {DOMWidgetView} from '@jupyter-widgets/base';
import ReactWidget from "./ReactWidget.bs"
import React from 'react';
import ReactDOM from 'react-dom';

export class ExampleView extends DOMWidgetView {
  render() {
    const component = React.createElement(ReactWidget, {
      model: this.model,
    });
    ReactDOM.render(component, this.el);
  }
}
`)
