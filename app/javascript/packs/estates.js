// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
import $ from 'jquery';

import initImageCropper from './angle/modules/forms/imagecrop';
import initSelect2 from './angle/modules/forms/select2';
import initWizard from './angle/modules/forms/wizard';
import initXEditable from './angle/modules/forms/xeditable';

$(function () {

    initImageCropper();
    initSelect2();
    initWizard();
    initXEditable();
});

$(function() {

    $('#pictureInput').on('change', function(event) {
        $('#target').empty();
    });
});