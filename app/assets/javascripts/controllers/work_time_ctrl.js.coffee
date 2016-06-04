@app.controller 'WorkTimeCtrl', ($scope, WorkTime) ->
  load = ->
    WorkTime.get().then (workTimes) ->
      $scope.workTimes = workTimes

  $scope.check = ->
    WorkTime.check().then(load)

  load()
