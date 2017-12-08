(($) ->
  TransloaditUploader = ->
  TransloaditUploader::init = ($form) ->
    @$form = $form
    @$files = @$form.find("input[type=file]")
    @uploadBound = false
    @errorTimeout = 15000
    @gotStartEvent = false
    @uploadFinished = false
    @bindValidate()
    return

  TransloaditUploader::bindValidate = ->
    self = this
    
    # add our validation rules
    @$form.validate
      rules:
        name:
          required: true
          minlength: 2

        test_file:
          required: true
          minlength: 2

      submitHandler: (form) ->
        
        # this is the most important part
        # if the upload wasn't finished yet, we just trigger the upload,
        # otherwise we submit the form directly and have previously unbound
        # the transloadit submit handler
        unless self.uploadFinished
          self.triggerUpload()
        else
          form.submit()
        return

    
    # if the user chooses a file, remove the error message
    # for that file input field
    self.$files.change ->
      unless $(this).val() is ""
        $parent = $(this).parent()
        $parent.removeClass "error"
        $parent.find("label.error").remove()
      return

    return

  TransloaditUploader::triggerUpload = ->
    self = this
    
    # now bind our transloadit jquery plugin
    @bindUpload()
    
    # only trigger the Transloadit upload, no other submit event
    @$form.trigger "submit.transloadit"
    
    # if the upload wasn't started within a certain time
    # then we have a connection problem and should show that
    setTimeout (->
      self.uploadError()  unless self.gotStartEvent
      return
    ), self.errorTimeout
    return

  TransloaditUploader::bindUpload = ->
    @uploadBound = true
    assemblyId = null
    self = this
    @$form.transloadit
      wait: false
      onStart: (obj) ->
        self.gotStartEvent = true
        assemblyId = obj.assembly_id
        return

      onError: (obj) ->
        self.uploadError()
        return

      onSuccess: (step, result, assembly) ->
        
        # when we are done uploading unbind transloadit's submit handler
        self.uploadFinished = true
        self.$form.unbind "submit.transloadit"
        self.$form.find("input[type=file]").parents(".control-group").remove()
        return

      onCancel: (step, result, assembly) ->
        
        # when we are done uploading, stop all transloadit actions
        # and, important, unbind its submit handler!
        self.uploadFinished = false
        self.$form.transloadit "stop"
        self.$form.unbind "submit.transloadit"
        return

    return

  TransloaditUploader::uploadError = ->
    
    # if we have an upload error stop all transloadit processing
    # and trigger an alert
    @$form.transloadit "stop"
    alert "Upload error"
    return

  $.fn.transloaditUpload = ->
    @each ->
      upload = new TransloaditUploader()
      upload.init $(this)
      return

    this

  return
) jQuery