@app.controller 'CommonCtrl', ($rootScope, Auth, $http) ->

  $rootScope.currentUser = null

  $rootScope.Auth = Auth

  $rootScope.setLocale = (locale) ->
    $http.get("/api/users/locale/#{locale}").then ->
      location.reload()

  # Simple wrapping on routeChangeSuccess event, that generates custom event
  # with previous and current paths
  $rootScope.$on '$routeChangeSuccess', (e, current) ->
    $rootScope.previousPath = $rootScope.currentPath ? ''
    $rootScope.currentPath = current.$$route?.originalPath?.remove(/^\//)
    $rootScope.$broadcast 'currentPathChange', $rootScope.previousPath, $rootScope.currentPath

  $rootScope.$on 'devise:logout', (e, oldCurrentUser) ->
    location.reload()

  Auth.currentUser().then (user) ->
    $rootScope.currentUser = user

  .catch (response) ->
    console.log 'User is not authorized'
