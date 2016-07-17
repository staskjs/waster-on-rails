@app = angular.module('Waster', [
  'ngRoute'
  'pascalprecht.translate'
  'Devise'
  'angular-click-outside'
  'ee.$http.CaseConverter.request.camelToSnake'
  'ee.$http.CaseConverter.response.snakeToCamel'
])
.config ($httpProvider, $translateProvider, $locationProvider, Rails, eeHttpCaseConverterProvider) ->

  $locationProvider.html5Mode(true)

  $httpProvider.interceptors.push('railsAssetsInterceptor')

  $translateProvider.useLoader('railsLocalesLoader')
  $translateProvider.preferredLanguage(window.locale)

  eeHttpCaseConverterProvider.responseUrlFilter = (url) ->
    return not url.has('assets')

.config ($routeProvider) ->

  authResolver = (Auth, $location) ->
    'ngInject'
    Auth.currentUser().catch ->
      $location.path '/users/sign_in'

  mainPageResolver = (Auth, $location) ->
    'ngInject'
    Auth.currentUser().then (user) ->
      if user?
        $location.path '/work_time'
    .catch(angular.noop)

  dailyHoursResolver = (Auth, $location) ->
    'ngInject'
    Auth.currentUser().then (user) ->
      if user? and (not user.dailyHours? or user.dailyHours is 0)
        $location.path '/profile/ask'
    .catch(angular.noop)

  $routeProvider
    .when('/',
      templateUrl: 'pages/index.html'
      controller: 'MainCtrl'
      resolve: {mainPageResolver}
    )
    .when('/profile',
      templateUrl: 'pages/users/profile/index.html'
      controller: 'ProfileCtrl'
      resolve: {authResolver}
    )
    .when('/profile/account',
      templateUrl: 'pages/users/profile/account.html'
      controller: 'AccountCtrl'
      resolve: {authResolver}
    )
    .when('/profile/ask',
      templateUrl: 'pages/users/profile/ask.html'
      controller: 'ProfileCtrl'
      resolve: {authResolver}
    )
    .when('/work_time',
      templateUrl: 'pages/work_time.html'
      controller: 'WorkTimeCtrl'
      reloadOnSearch: false
      resolve: {authResolver, dailyHoursResolver}
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
