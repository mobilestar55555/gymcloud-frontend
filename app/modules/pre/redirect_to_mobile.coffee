define [
  'mobile-detect'
  './template'
], (
  MobileDetect
  template
) ->

  class RedirectToMobile

    constructor: (options) ->
      @path = options.appPath
      @url = options.appUrl
      @hash = window.location.hash
      @agent = window.navigator.userAgent
      @md = new MobileDetect(@agent)
      @check()
      @

    check: ->
      @redirect() if @isMobile() and @shouldRedirect()

    redirect: ->
      id = setTimeout (->
        document.write(template())
        document.close()
      ), 3000
      clear = -> clearTimeout(id)
      document.addEventListener('visibilitychange', clear)
      window.addEventListener('pagehide', clear)

      window.location.replace(@path + @hash)

    isMobile: ->
      !! @md.mobile()

    shouldRedirect: ->
      allowed = [
        '#payments/info'
        '#signup-role'
        '#signup'
        '#signup?is_pro=false'
        '#signup?is_pro=false&promo_code=free_fitness_assessment'
        '#signup?is_pro=true'
      ]
      !! @path and !(@hash in allowed)
