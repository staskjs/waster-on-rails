@app.controller 'AccountCtrl', ($scope, $location, $http, Auth) ->
  getProviders = ->
    $http
      method: 'GET'
      url: '/api/users/providers'
    .then (response) ->
      $scope.providers = response.data
      $scope.connectedCount = Object.values(response.data).compact(true).length


  $scope.disconnect = (providerName) ->
    $http
      method: 'DELETE'
      url: '/api/users/providers'
      params:
        provider: providerName
    .then(getProviders)

  getProviders()
