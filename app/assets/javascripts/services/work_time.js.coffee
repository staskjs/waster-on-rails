@app.service 'WorkTime', class
  constructor: (@$http, @$filter) ->

  get: ->
    @$http.get('/api/work_time').then (response) =>

      # Remove all days after last checked in day
      # (that is a last non-missing day)
      missings = response.data.days.map('is_missing')

      response.data.days = response.data.days[0..(missings.lastIndexOf(false))]
      response.data.days.forEach (day) =>
        day.editableIntervals = angular.copy(day.intervals).map (interval) =>
          interval.time_in = @$filter('time')(interval.time_in)
          if interval.time_out
            interval.time_out = @$filter('time')(interval.time_out)
          interval

      response.data

  check: ->
    @$http.get('/api/work_time/check')

  updateInterval: (interval) ->
    id = interval.id

    # Get times in utc
    if time_in = interval.time_in
      time_in = moment(interval.time_in, 'HH:mm').utc().format('HH:mm')

    if time_out = interval.time_out
      time_out = moment(interval.time_out, 'HH:mm').utc().format('HH:mm')

    interval = {id, time_in, time_out}
    @$http.put('/api/work_time/update', interval: interval)
