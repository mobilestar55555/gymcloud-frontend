path = require('path')
webpack = require('webpack')
ExtractTextPlugin = require('extract-text-webpack-plugin')

require('dotenv').load()

module.exports =

  cache: true
  devtool: 'source-map'

  context: path.resolve('app')

  entry:
    main: 'app'
    pre: 'pre'

  output:
    path: path.resolve('build')
    publicPath: 'build/'
    filename: '[name].js'
    chunkFilename: '[id].js'

  resolve:

    descriptionFiles: ['package.json', 'bower.json']

    mainFields: ['main', 'browser']

    modules: [
      path.join(__dirname, 'app')
      path.join(__dirname, '.')
      'bower_components'
      'node_modules'
    ]

    alias:
      'config':
        path.join(__dirname, 'config', process.env.NODE_ENV || 'test')
      'numeric':
        'app/deps/vendor/jquery.numeric.js'
      'selectize':
        'app/deps/vendor/selectize.js'
      'spinner':
        'bower_components/spin.js/spin.js'
      'datetimepicker':
        'bower_components/eonasdan-bootstrap-datetimepicker' +
          '/src/js/bootstrap-datetimepicker'
      'messenger':
        'bower_components/messenger/build/js/messenger.js'
      'bootstrap':
        'bower_components/bootstrap/dist/js/bootstrap.js'
      'underscore_original': 'node_modules/underscore/underscore.js'
      'underscore': 'app/deps/bundles/underscore/original'
      'backbone_original':
        'node_modules/backbone/backbone.js'
      'marionette': 'app/deps/bundles/marionette/bundle'
      'jquery_original': 'node_modules/jquery/dist/jquery.js'
      'moment_original': 'node_modules/moment/moment.js'
      'moment': 'deps/bundles/moment/original'
      'jquery.ui.widget':
        'bower_components/blueimp-file-upload' +
          '/js/vendor/jquery.ui.widget.js'
      'jquery-iframe-transport':
        'bower_components/blueimp-file-upload' +
          '/js/jquery.iframe-transport.js'
      'load-image': 'bower_components/blueimp-load-image/js/load-image.js'
      'tmpl': 'bower_components/blueimp-tmpl/js/tmpl.min.js'
      'jquery-file-upload':
        'bower_components/blueimp-file-upload/js/jquery.fileupload.js'
      'jquery-file-upload-process':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-process.js'
      'jquery-file-upload-video':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-video.js'
      'jquery-file-upload-validate':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-validate.js'
      'jquery-file-upload-ui':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-ui.js'
      'owl-carousel':
        'node_modules/owlcarousel-pre/owl-carousel/owl.carousel.js'
      'custom-scroll': 'node_modules/jquery.nicescroll/jquery.nicescroll.js'

    extensions: [
      '.webpack.js'
      '.web.js'
      '.js'
      '.json'
      '.coffee'
      '.jade'
      '.hbs'
      '.scss'
      '.styl'
      '.css'
    ]

  module:

    noParse: /\.min\.js/

    rules: [
      {
        test: /\.js$/
        exclude: /(node_modules|bower_components)/
        use: 'babel-loader?presets[]=es2015'
      }
      {
        test: /\.coffee$/
        use: 'coffee-loader'
      }
      {
        test: /\.hbs$/
        use: [
          {
            loader: 'handlebars-loader'
            options:
              # runtime: 'handlebars/runtime'
              #inlineRequires: 'app/images/'
              helperDirs: [
                __dirname + '/app/handlers/handlebars'
              ]
          }
        ]
      }
      {
        test: /\.jade$/
        use: 'jade-loader'
      }
      {
        test: /\.css$/
        use: ExtractTextPlugin.extract(
          fallback: 'style-loader?sourceMap'
          use: 'css-loader?sourceMap'
          publicPath: ''
        )
        # [ # will load as inline css
        #   'style-loader'
        #   'css-loader'
        #   {
        #     loader: 'postcss-loader'
        #     options:
        #       plugins: -> [
        #         autoprefixer({browsers: ['last 3 versions', '> 1%']})
        #       ]
        #   }
        # ]

      }
      {
        test: /\.styl$/
        use: ExtractTextPlugin.extract(
          fallback: 'style-loader?sourceMap'
          use: [
              loader: 'css-loader'
              options:
                sourceMap: true
                localIdentName: (process.env.NODE_ENV is 'production' and
                  '[hash:base64:5]') or
                  '[local]_[hash:base64:5]'
            ,
              loader: 'postcss-loader'
              options: sourceMap: true
            ,
              loader: 'stylus-loader'
              options: sourceMap: true
          ]
          publicPath: ''
        )
      }
      {
        test: /\.scss$/
        use: [
          'style-loader'
          'css-loader'
          'sass-loader?outputStyle=expanded&includePaths[]=' + \
            (path.resolve('node_modules'))# ('bower_components')) + '&' + \
        ]
      }
      {
        test: /\.otf/
        use: 'file-loader?prefix=font/&mimetype=application/x-font-opentype'
      }
      {
        test: /\.eot/
        use: 'file-loader?prefix=font/&mimetype=application/vnd.ms-fontobject'
      }
      {
        test: /\.ttf/
        use: 'file-loader?prefix=font/&mimetype=application/x-font-truetype'
      }
      {
        test: /\.svg/
        use: 'file-loader?prefix=font/&mimetype=image/svg+xml'
      }
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/
        use: 'file-loader?prefix=font/&mimetype=application/font-woff'
      }
      {
        test: /\.png$/
        use: 'file-loader?prefix=img/&mimetype=image/png'
      }
      {
        test: /\.jpg$/
        use: 'file-loader?prefix=img/&mimetype=image/jpg'
      }
      {
        test: /\.gif$/
        use: 'file-loader?prefix=img/&mimetype=image/gif'
      }
    ]

  externals: {}

  plugins: [
      new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
    ,
      new webpack.ProvidePlugin(
        $:
          'deps/bundles/jquery/original'
        jQuery:
          'deps/bundles/jquery/original'
        'window.jQuery':
          'deps/bundles/jquery/original'
        _:
          'deps/bundles/underscore/bundle'
        Backbone:
          'deps/bundles/backbone/original'
        Marionette:
          'deps/bundles/marionette/original'
        moment:
          'deps/bundles/moment/bundle'
        can:
          'deps/bundles/can'
        feature:
          'features/feature/factory'
      )
    ,
      new webpack.optimize.ModuleConcatenationPlugin()
    ,
      new ExtractTextPlugin
        filename: '[name].css'
  ]

  node:
    fs: 'empty'

  stats:
    colors: true
    children: false
