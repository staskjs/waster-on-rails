@app = angular.module('Waster', [
  'ngRoute'
  'pascalprecht.translate'
])
.config ($routeProvider, $httpProvider, $translateProvider, $locationProvider) ->

  $locationProvider.html5Mode(true)

  $httpProvider.interceptors.push('railsAssetsInterceptor')

  $translateProvider.useLoader('railsLocalesLoader')
  $translateProvider.preferredLanguage('ru')

  $routeProvider
    .when('/',
      templateUrl: 'pages/index.html'
      controller: 'WorkTimeCtrl'
    )
    .when('/about',
      templateUrl: 'pages/about.html'
      controller: 'AboutCtrl'
    )
    .when('/users/sign_in',
      templateUrl: 'pages/users/sessions/new.html'
      controller: 'SignInCtrl'
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
