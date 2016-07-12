@app.service 'WorkTime', class
  constructor: (@$http, @$filter) ->

  get: (params = {}) ->
    @$http
      method: 'GET'
      url: '/api/work_time'
      params: params
    .then (response) =>

      # Remove all days after last checked in day
      # (that is a last non-missing day)
      missings = response.data.days.map('is_missing')

      response.data.days = response.data.days[0..(missings.lastIndexOf(false))]
      response.data.days.forEach (day) =>
        day.editableIntervals = angular.copy(day.intervals).map (interval) =>
          interval.dateIn = moment(interval.time_in)
          if interval.time_out
            interval.dateOut = moment(interval.time_out)

          interval.time_in = @$filter('time')(interval.time_in)
          if interval.time_out
            interval.time_out = @$filter('time')(interval.time_out)
          interval

      response.data

  check: (date, timeIn, timeOut) ->
    @$http
      method: 'GET'
      url: '/api/work_time/check'
      params:
        date: date
        time_in: @_timeToUtc(timeIn)
        time_out: @_timeToUtc(timeOut)

  updateInterval: (interval) ->
    id = interval.id

    # Get times in utc
    if time_in = interval.time_in
      time_in = @_timeToUtc(time_in)

    if time_out = interval.time_out
      time_out = @_timeToUtc(time_out)

    if date_out = interval.dateOut
      date_out = interval.dateOut.format('YYYY-MM-DD')

    interval = {id, time_in, time_out, date_out}
    @$http.put('/api/work_time/update', interval: interval)

  _timeToUtc: (time) ->
    if time
      moment(time, 'HH:mm').utc().format('HH:mm')
    else
      null
