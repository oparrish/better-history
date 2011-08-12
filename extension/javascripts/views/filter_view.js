FilterView = Backbone.View.extend({
  initialize: function() {
    $(this.el).html('').hide();
  },

  render: function(results) {
    var self = this;
    $('#filterViewTemplate').tmpl(this.model.toJSON()).appendTo($(this.el));
    $(this.el).fadeIn("fast", function() {
      PageVisit.search(self.model.options(), function(results) {
        dateVisits = groupResults(results);
        $('.content', self.el).html('').hide();
        $.each(dateVisits.models, function(i, dateVisit) {
          var dateVisitView = new DateVisitView({model: dateVisit});
          $('.content', self.el).append(dateVisitView.render().el).fadeIn("fast");
        });
        self.stickHeaders($('.content', self.el));
      });
    });
  },

  stickHeaders: function(container) {
    $(container).find('.date').stickySectionHeaders({
      stickyClass:'date_interval', padding:48
    });
    $(container).find('.time').stickySectionHeaders({
      stickyClass:'time_interval', padding:48
    });
    $(window).scrollTop(40);
  }
});
