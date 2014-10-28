# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('[data-provide=datepicker]').datepicker();
  $('.timepicker').timepicker({
    template: false,
    showInputs: false,
    minuteStep: 5});


$(document).ready(ready)
$(document).on('page:load', ready)