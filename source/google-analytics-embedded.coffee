###!
# google-analytics-embedded 1.0.5 | https://github.com/yivo/google-analytics-embedded | MIT License
###

initialize = do ->
  initialized = false

  (trackingID) ->
    unless initialized
      unless trackingID
        throw new TypeError('[Google Analytics Embedded] Tracking ID is required')

      window.GoogleAnalyticsObject         = 'ga'
      window[window.GoogleAnalyticsObject] = ->
        args = []
        len  = arguments.length
        idx  = -1
        args.push(arguments[idx]) while ++idx < len
        (ga.q ?= []).push(args)
        return
  
      ga.l = Date.now?() ? +new Date()
  
      ga('create', trackingID, 'auto')
  
      pageview = -> ga('send', 'pageview', location.href.split('#')[0]); return
  
      if Turbolinks?.supported
        $(document).on('page:change', pageview)
      else
        pageview()
        $(document).on('pjax:end', pageview) if $.support.pjax

      analyticsJS()
      
      initialized = true
    return

analyticsJS = ->
  try ```
    /* analytics.js */
  ```
  return # Explicit return statement
    
if (head = document.getElementsByTagName('head')[0])?
  for el in head.getElementsByTagName('meta')
    if el.getAttribute('name') is 'ga:tracking_id'
      initialize(trackingID) if trackingID = el.getAttribute('content')
      break
