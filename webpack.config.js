const path = require('path');
const version = require('./package.json').version;

// Custom webpack rules
const rules = [
  { test: /\.js$/, loader: 'source-map-loader' },
  { test: /\.css$/, use: ['style-loader', 'css-loader', 'postcss-loader'] },
];

// Packages that shouldn't be bundled but loaded at runtime
const externals = ['@jupyter-widgets/base'];

const resolve = {
  extensions: ['.webpack.js', '.bs.js', '.js'],
};

module.exports = [
  /**
   * Notebook extension
   *
   * This bundle only contains the part of the JavaScript that is run on load of
   * the notebook.
   */
  {
    entry: './src/extension.js',
    output: {
      filename: 'index.js',
      path: path.resolve(__dirname, 'getml_jupyter_widgets', 'nbextension'),
      libraryTarget: 'amd',
      publicPath: '',
    },
    module: {
      rules: rules,
    },
    devtool: 'source-map',
    externals,
    resolve,
  },

  /**
   * Embeddable getml-jupyter-widgets bundle
   *
   * This bundle is almost identical to the notebook extension bundle. The only
   * difference is in the configuration of the webpack public path for the
   * static assets.
   *
   * The target bundle is always `dist/index.js`, which is the path required by
   * the custom widget embedder.
   */
  {
    entry: './src/index.js',
    output: {
      filename: 'index.js',
      path: path.resolve(__dirname, 'dist'),
      libraryTarget: 'amd',
      library: 'getml-jupyter-widgets',
      publicPath:
        'https://unpkg.com/getml-jupyter-widgets@' + version + '/dist/',
    },
    devtool: 'source-map',
    module: {
      rules: rules,
    },
    externals,
    resolve,
  },

  // /**
  //  * Documentation widget bundle
  //  *
  //  * This bundle is used to embed widgets in the package documentation.
  //  */
  // {
  //   entry: './src/index.js',
  //   output: {
  //     filename: 'embed-bundle.js',
  //     path: path.resolve(__dirname, 'docs', 'source', '_static'),
  //     library: 'getml-jupyter-widgets',
  //     libraryTarget: 'amd',
  //   },
  //   module: {
  //     rules: rules,
  //   },
  //   devtool: 'source-map',
  //   externals,
  //   resolve,
  // },
];
