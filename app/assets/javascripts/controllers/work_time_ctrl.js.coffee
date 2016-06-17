@app.controller 'WorkTimeCtrl', ($scope, WorkTime) ->
  load = ->
    WorkTime.get().then (data) ->
      $scope.data = data

  $scope.check = ->
    WorkTime.check().then(load)

  $scope.updateInterval = (interval) ->
    WorkTime.updateInterval(interval).then(load)

  load()
