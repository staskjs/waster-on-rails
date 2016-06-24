@app = angular.module('Waster', [
  'ngRoute'
  'pascalprecht.translate'
  'Devise'
])
.config ($httpProvider, $translateProvider, $locationProvider, Rails) ->

  $locationProvider.html5Mode(true)

  $httpProvider.interceptors.push('railsAssetsInterceptor')

  $translateProvider.useLoader('railsLocalesLoader')
  $translateProvider.preferredLanguage(Rails.locale)

.config ($routeProvider) ->

  authResolver =
    auth: (Auth, $location) ->
      Auth.currentUser().catch ->
        $location.path '/users/sign_in'

  mainPageResolver =
    main: (Auth, $location) ->
      Auth.currentUser().then (user) ->
        if user?
          $location.path '/work_time'
      .catch(angular.noop)

  $routeProvider
    .when('/',
      templateUrl: 'pages/index.html'
      controller: 'MainCtrl'
      resolve: mainPageResolver
    )
    .when('/profile',
      templateUrl: 'pages/users/profile.html'
      controller: 'ProfileCtrl'
      resolve: authResolver
    )
    .when('/work_time',
      templateUrl: 'pages/work_time.html'
      controller: 'WorkTimeCtrl'
      resolve: authResolver
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
