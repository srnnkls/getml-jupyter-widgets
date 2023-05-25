%%raw(`import './main.css';`)

type t

type metaData = {
  modelName: string,
  viewName: string,
}

type rec tree = {
  name: string,
  children?: array<tree>,
}

type modelProps = {tree: tree, serialized_svg: string}

let metaData = {
  modelName: "DataModelWidgetModel",
  viewName: "DataModelWidgetView",
}

let defaultModelProperties = {
  tree: {name: "population", children: [{name: "peripheral"}]},
  serialized_svg: "",
}

// model
%%raw(`
import {DOMWidgetModel} from '@jupyter-widgets/base';
import { MODULE_NAME, MODULE_VERSION } from './version';


export class DataModelWidgetModel extends DOMWidgetModel {
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
import DataModel from "./components/DataModel.bs"
import React from 'react';
import ReactDOM from 'react-dom';

export class DataModelWidgetView extends DOMWidgetView {
  render() {
    const component = React.createElement(DataModel, {
      model: this.model,
    });
    ReactDOM.render(component, this.el);
  }
}
`)
