// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
// Turbolinks.start()
window.$ = $;
ActiveStorage.start()



import $ from 'jquery';
import 'select2';
import "chartkick/chart.js"




document.addEventListener('shown.bs.modal', function () {
  $('.js-multiple-select').select2({
    placeholder: 'Select users',
    allowClear: true,
    tags: true,
    width: 'resolve',
    dropdownParent: $('#addUserModal') 
  });
});




// document.addEventListener('turbolinks:load', () => {
//   var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
//   var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
//     return new bootstrap.Dropdown(dropdownToggleEl);
//   });
// });

document.addEventListener("DOMContentLoaded", function() {
  var selectElements = document.querySelectorAll('.js-multiple-select');
  
  selectElements.forEach(function(selectElement) {
    $(selectElement).select2({
      placeholder: "Select user",
      allowClear: true,
      tags: false, // Disable adding new tags
      width: '100%', // Adjust width
      dropdownCssClass: 'custom-dropdown', // Custom dropdown class
      templateResult: formatState,
      templateSelection: formatSelection
    });
    
    // Handle unselect event
    $(selectElement).on('select2:unselect', function(e) {
      var unselected_id = e.params.data.id;
      $(this).find('option[value="'+unselected_id+'"]').remove();
    });
  });
  
  // Custom template for options
  function formatState(state) {
    if (!state.id) {
      return state.text;
    }
    return $('<span>' + state.text + '</span>');
  }

  // Custom template for selected options
  function formatSelection(data) {
    return $('<span class="selected-user">' + data.text + '</span>');
  }
});


let debounceTimer;

$(document).on('keyup', '#search-input', function(e) {
  const searchInput = $(this);
  const query = searchInput.val();

  // Clear the previous timeout
  clearTimeout(debounceTimer);

  // Set a new timeout
  debounceTimer = setTimeout(function() {
    $.ajax({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      url: searchInput.data('url'),
      type: "GET",
      data: { search: query },
      dataType: "script",
      success: function(response) {
        eval(response);
        $('#search-input').val(query);
        $('#search-input').focus();
      }
    });
  }, 500);
});




