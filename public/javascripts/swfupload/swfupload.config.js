/* Options object
 *   -postParams
 *   -buttonImageUrl
*/
function imageUploaderConfig(uploadUrl,options){
  var settings ={
    flash_url : "/flash/swfupload.swf",
    upload_url: uploadUrl,
    post_params: options.postParams,
    ile_size_limit : "100 MB",
    file_types : "*.jpg;*.jpeg;*.gif;*.png",
    file_types_description : "Web Image Files",
    file_size_limit: "2048",
    file_upload_limit : 100,
    file_queue_limit : 0,
    custom_settings : {
      progressTarget : "fsUploadProgress",
      cancelButtonId : "btnCancel",
      imageContainer : "imageThumbs",
      imageHiddenField: "product_image_ids"

    },
    debug: false,

    // Button settings
    button_image_url: options.buttonImageUrl,
    button_width: "65",
    button_height: "29",
    button_placeholder_id: "spanButtonPlaceHolder",
    button_text: '<span class="theFont green">Upload</span>',
    button_text_style: ".theFont { font-size: 16; }",
    button_text_left_padding: 12,
    button_text_top_padding: 3,

    // The event handler functions are defined in handlers.js
    file_queued_handler : fileQueued,
    file_queue_error_handler : fileQueueError,
    file_dialog_complete_handler : fileDialogComplete,
    upload_start_handler : uploadStart,
    upload_progress_handler : uploadProgress,
    upload_error_handler : uploadError,
    upload_success_handler : uploadSuccess,
    upload_complete_handler : uploadComplete,
    queue_complete_handler : queueComplete	// Queue plugin event
  }
  return  new SWFUpload(settings)
}