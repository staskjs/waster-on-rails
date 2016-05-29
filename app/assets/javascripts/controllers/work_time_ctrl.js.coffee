@app.controller 'WorkTimeCtrl', ($scope, WorkTime) ->
  WorkTime.get()
