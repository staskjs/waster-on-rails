@app.service 'WorkTime', class
  constructor: (@$http) ->

  get: ->
    @$http.get('/api/work_time').then (response) ->
      response.data
