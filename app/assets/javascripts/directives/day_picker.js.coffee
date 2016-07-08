@app.directive 'dayPicker', ->
  restrict: 'E'

  replace: true

  scope:
    interval: '='
    onSelectPrevDate: '&'

  template: '
    <div class="day-picker" click-outside="close()" outside-if-not="icon-day-picker, day-picker-popover"
        ng-show="interval.different_days">
      <span class="icon icon-day-picker" ng-click="togglePopover()"></span>
      <div class="day-picker-popover" ng-show="popoverVisible">
        <div class="popover bottom" role="tooltip">
          <div class="arrow"></div>
          <div class="popover-content">
            <div><a href="" ng-click="choosePrevDate()">{{ prevDate | shortDate }}</a></div>
            <div><a href="" ng-click="close()">{{ interval.dateOut | shortDate }}</a></div>
          </div>
        </div>
      </div>
    </div>
  '

  link: (scope, element, attrs) ->
    scope.popoverVisible = false

    return unless scope.interval.dateOut?

    scope.prevDate = scope.interval.dateOut.clone().subtract(1, 'day')

    scope.togglePopover = ->
      scope.popoverVisible = not scope.popoverVisible

    scope.choosePrevDate = ->
      scope.onSelectPrevDate(interval: scope.interval, prevDate: scope.prevDate)
      scope.close()

    scope.close = ->
      scope.popoverVisible = false
