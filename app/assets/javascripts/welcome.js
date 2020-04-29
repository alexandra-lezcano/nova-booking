//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es
let options = {

    url: "/welcome/resources.json",
  
    getValue: "name",
    
    list: {
      match: {
        enabled: true
      }
    },
  
    theme: "blue-light"
  };
  $(function () {
      $("#with_search_home").easyAutocomplete(options);
      $("#with_search_results").easyAutocomplete(options);
  });