(function() {
  "use strict";
  App.SDGRelatedListSelector = {
    initialize: function() {
      if ($(".sdg-related-list-selector").length) {
        var amsify_suggestags = new AmsifySuggestags($(".sdg-related-list-selector .input"));

        amsify_suggestags.getItem = function(value) {
          var item_key = this.getItemKey(value);
          return this.settings.suggestions[item_key];
        };

        amsify_suggestags.getTag = function(value) {
          if (this.getItem(value) !== undefined) {
            return this.getItem(value).display_text;
          } else {
            return value;
          }
        };

        amsify_suggestags._settings({
          suggestions: $(".sdg-related-list-selector .input").data("suggestions-list"),
          whiteList: true,
          afterRemove: function(value) {
            var keep_goal = $(amsify_suggestags.selector).val().split(",").some(function(selected_value) {
              return App.SDGRelatedListSelector.goal_code(value) === App.SDGRelatedListSelector.goal_code(selected_value);
            });
            App.SDGRelatedListSelector.goal_element(value).attr("aria-checked", keep_goal);
            App.SDGRelatedListSelector.manage_remove_help(amsify_suggestags, value);
          },
          afterAdd: function(value) {
            App.SDGRelatedListSelector.goal_element(value).attr("aria-checked", true);
            App.SDGRelatedListSelector.manage_add_help(amsify_suggestags, value);
          },
          keepLastOnHoverTag: false,
          checkSimilar: false
        });
        amsify_suggestags.classes.focus = ".sdg-related-list-focus";
        amsify_suggestags.classes.sTagsInput = ".sdg-related-list-selector-input";
        amsify_suggestags._init();
        App.SDGRelatedListSelector.manage_icons(amsify_suggestags);
      }
    },
    manage_icons: function(amsify_suggestags) {
      $("[role='checkbox']").on("click keydown", function(event) {
        var goal_id = this.dataset.code;

        if (event.type === "click" || (event.type === "keydown" && [13, 32].indexOf(event.keyCode) >= 0)) {
          if (amsify_suggestags.isPresent(goal_id)) {
            amsify_suggestags.removeTag(goal_id, false);
          } else {
            amsify_suggestags.addTag(goal_id, false);
          }

          event.preventDefault();
          event.stopPropagation();
        }
      });
    },
    goal_element: function(value) {
      return $("li[data-code=" + App.SDGRelatedListSelector.goal_code(value) + "]");
    },
    goal_code: function(value) {
      return value.toString().split(".")[0];
    },
    manage_add_help: function(amsify_suggestags, value) {
      var title = amsify_suggestags.getItem(value).title;
      var html = '<li data-id="' + value + '">' + "<strong>" + value + "</strong> " + title + "</li>";
      $(".sdg-related-list-selector .help-section").removeClass("hide");
      $(".sdg-related-list-selector .selected-info").append(html);
    },
    manage_remove_help: function(amsify_suggestags, value) {
      $('[data-id="' + value + '"]').remove();
      if ($(amsify_suggestags.selector).val() === "") {
        $(".sdg-related-list-selector .help-section").addClass("hide");
      }
    }
  };
}).call(this);
