// Generated by CoffeeScript 1.4.0

jQuery(function() {
  var BetterCollapse;
  BetterCollapse = (function() {

    function BetterCollapse(element, options) {
      var href;
      this.$element = $(element);
      this.$collapse = $(options['target'] || (href = this.$element.attr("href")) && href.replace(/.*(?=#[^\s]+$)/, ""));
      this.$parent = $(options['parent']);
      this.settings = $.extend({}, this.defaults, options);
      this.open_element = this.$element.find(this.settings.hideOnCollapsed);
      this.closed_element = this.$element.find(this.settings.hideOnExpanded);
      this.render();
    }

    BetterCollapse.prototype.render = function() {
      if (this.is_open()) {
        return this.show();
      } else {
        return this.hide();
      }
    };

    BetterCollapse.prototype.show = function() {
      this.$parent.find(this.settings.hideOnCollapsed).addClass('hide');
      this.$parent.find(this.settings.hideOnExpanded).removeClass('hide');
      this.open_element.removeClass('hide');
      return this.closed_element.addClass('hide');
    };

    BetterCollapse.prototype.hide = function() {
      this.closed_element.removeClass('hide');
      return this.open_element.addClass('hide');
    };

    BetterCollapse.prototype.is_open = function() {
      if (this.$collapse.parent().find(".collapse.in").filter(":visible").length > 0) {
        return true;
      }
      return false;
    };

    return BetterCollapse;

  })();
  BetterCollapse.prototype.defaults = {
    hideOnCollapsed: '[data-hide-on=collapsed]',
    hideOnExpanded: '[data-hide-on=expanded]'
  };
  return $.fn.better_collapse = function(options) {
    return this.each(function() {
      var $this, plugin, settings;
      $this = $(this);
      plugin = $this.data('better_collapse');
      if (plugin === void 0) {
        settings = $.extend({}, $this.data(), options);
        plugin = new BetterCollapse(this, settings);
        $this.data('better_collapse', plugin);
      }
      if ($.type(options) === 'string') {
        return plugin[options]();
      }
    });
  };
});

$(document).on("click.collapse.data-api", "[data-toggle=collapse]", function(e) {
  var $this;
  $this = $(this);
  return $this.better_collapse('render');
}).ready(function() {
  return $("[data-toggle=collapse]").better_collapse();
});