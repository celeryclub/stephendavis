$(function() {

  $sortable = $('.sortable');
  // $sortable.disableSelection();
  $sortable.find('td').each(function() {
    $(this).width($(this).width())
    // $(this).css('cursor', 'move')
    // $(this).attr('id', "#{pluralized_model}_#{$(this).find('.show_member_link').find('a').attr('href').split('/').pop()}")
    // $(this).find('td').each( ->
    //   $(this).width($(this).width())
    // )
  });
  var url = $sortable.attr('data-url');
  $sortable.sortable({
    axis: 'y',
    handle: '.handle',
    create: function() {
      $(this).closest('form').each(function() {
        $(this).height($(this).find('td').outerHeight());
      });
    },
    update: function(e, ui) {
      var positions = $(this).sortable('serialize');
      $.ajax({
        type: 'put',
        url: url,
        data: positions
      });
    }
  });

  $(document).on('keydown', function(e) {
    if (e.which == 27) { $sortable.sortable('cancel'); }
  });

  $('.btn-danger').on('click', function() {
    if (!confirm('Are you sure?')) {
      return false;
    }
  });

});
