const webpack = require('webpack')
const path = require('path')

const config = env => {
  return {
    entry: {
      index: './src/renderer/index.ts'
    },
    target: 'electron-renderer',
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: '[name].bundle.js',
      publicPath: '/'
    },
    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            {
              loader: 'elm-webpack-loader',
              options: env && env.production ? {} : { debug: false }
            }
          ]
        },
        { test: /\.ts$/, loader: 'ts-loader' }
      ]
    }
  }
}

module.exports = config
