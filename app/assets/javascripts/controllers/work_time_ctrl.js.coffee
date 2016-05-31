@app.controller 'WorkTimeCtrl', ($scope, WorkTime) ->
  WorkTime.get().then (workTimes) ->
    $scope.workTimes = workTimes
