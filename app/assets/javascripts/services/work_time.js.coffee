@app.service 'WorkTime', class
  constructor: (@$http) ->

  get: ->
    @$http.get('/api/work_time').then (response) ->

      # Remove all days after last checked in day
      # (that is a last non-missing day)
      missings = response.data.days.map('is_missing')

      response.data.days = response.data.days[0..(missings.lastIndexOf(false))]
      response.data

  check: ->
    @$http.get('/api/work_time/check')
