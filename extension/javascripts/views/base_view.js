// Generated by CoffeeScript 1.3.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  BH.Views.BaseView = (function(_super) {

    __extends(BaseView, _super);

    BaseView.name = 'BaseView';

    function BaseView() {
      return BaseView.__super__.constructor.apply(this, arguments);
    }

    BaseView.prototype.template = function(json) {
      return Mustache.render($('#' + this.templateId).html(), json);
    };

    return BaseView;

  })(Backbone.View);

}).call(this);