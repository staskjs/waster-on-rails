@app = angular.module('Waster', [
  'ngRoute'
  'pascalprecht.translate'
])
.config ($routeProvider, $httpProvider) ->

  $httpProvider.interceptors.push('railsAssetsInterceptor')

  $routeProvider
    .when('/',
      templateUrl: 'pages/index.html'
      controller: 'WorkTimeCtrl'
    )

.factory 'railsAssetsInterceptor', (Rails) ->
  request: (config) ->
    if assetUrl = Rails.templates[config.url]
      config.url = assetUrl

    config

# .factory 'railsLocalesLoader', ($http) ->
  # (options) ->
    # $http.get("locales/#{options.key}.json").then (response) ->
      # response.data
    # .catch (error) ->
      # throw options.key
