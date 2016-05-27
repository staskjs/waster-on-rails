@app = angular.module('Waster', [
  'ngRoute'
  'pascalprecht.translate'
])
.config ($routeProvider, $httpProvider, $translateProvider) ->

  $httpProvider.interceptors.push('railsAssetsInterceptor')

  $translateProvider.useLoader('railsLocalesLoader')
  $translateProvider.preferredLanguage('en')

  $routeProvider
    .when('/',
      templateUrl: 'pages/index.html'
      controller: 'WorkTimeCtrl'
    )

.factory 'railsAssetsInterceptor', (Rails) ->
  request: (config) ->
    if assetUrl = Rails.assets[config.url]
      config.url = assetUrl
    config

.factory 'railsLocalesLoader', ($http) ->
  (options) ->
    $http.get("locales/#{options.key}.json").then (response) ->
      response.data
    .catch (error) ->
      throw "Translations for #{options.key} could not be loaded"
