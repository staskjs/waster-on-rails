@app.controller 'CommonCtrl', ($rootScope) ->

  # Simple wrapping on routeChangeSuccess event, that generates custom event
  # with previous and current paths
  $rootScope.$on '$routeChangeSuccess', (e, current) ->
    previousPath = currentPath ? ''
    currentPath = current.$$route?.originalPath?.remove(/^\//)
    $rootScope.$broadcast 'currentPathChange', previousPath, currentPath
