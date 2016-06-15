@app.controller 'CommonCtrl', ($rootScope, Auth) ->

  $rootScope.currentUser = null

  $rootScope.Auth = Auth

  # Simple wrapping on routeChangeSuccess event, that generates custom event
  # with previous and current paths
  $rootScope.$on '$routeChangeSuccess', (e, current) ->
    previousPath = currentPath ? ''
    currentPath = current.$$route?.originalPath?.remove(/^\//)
    $rootScope.$broadcast 'currentPathChange', previousPath, currentPath

  $rootScope.$on 'devise:logout', (e, oldCurrentUser) ->
    location.reload()

  Auth.currentUser().then (user) ->
    $rootScope.currentUser = user

  .catch (response) ->
    console.log 'User is not authorized'
