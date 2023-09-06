// Initialize the backlogs after DOM is loaded
RB.$(function() {
  // Initialize each backlog
  RB.BacklogOptionsInstance = RB.Factory.initialize(RB.BacklogOptions, this);
  RB.Factory.initialize(RB.BacklogMultilineBtn, RB.$('#multiline'));
  RB.$('.backlog').each(function(index){
    RB.Factory.initialize(RB.Backlog, this);
  });
  // RB.$("#project_info").bind('click', function(){ RB.$("#velocity").dialog({ modal: true, title: "Project Info"}); });
  RB.BacklogsUpdater.start();

  // hold down alt when clicking an issue id to open it in the current tab
  RB.$('#backlogs_container').delegate('li.story > .id a', 'click', function(e) {
    if (e.shiftKey) {
      location.href = this.href;
      return false;
    }
  });

  // show closed sprints
  RB.$('#show_completed_sprints').click(function(e) {
    e.preventDefault();
    RB.$('#closed_sprint_backlogs_container').
      html('Loading...').
      show().
      load(RB.routes.closed_sprints, function(){ //success callback
        var csbc = RB.$('#closed_sprint_backlogs_container');
        if (!RB.$.trim(csbc.html())) csbc.html(RB.constants.locale._('No data to show'));
        else RB.util.initToolTip(); //refreshToolTip requires a model scope.
        csbc.find('.closedbacklog').each(function(index) {
          //Display menu of closed sprints
          var menu = $(this).find('ul.items');
          var sprint = $(this).find(".sprint").first();
          var id = sprint.find('.id .v').text();
          var ajaxdata = { sprint_id: id };
          var createMenu = function(data, list) {
            list.empty();
            if (data) {
              for (var i = 0; i < data.length; i++) {
                li = RB.$('<li class="item"><a href="#"></a></li>');
                a = RB.$('a', li);
                a.attr('href', data[i].url).text(data[i].label);
                if (data[i].classname) { a.attr('class', data[i].classname); }
                if (data[i].warning) {
                  a.data('warning', data[i].warning);
                  a.click(function(e) {
                    if (e.button > 1) return;
                    return confirm(RB.$(this).data('warning').replace(/\\n/g, "\n"));
                  });
                }
                list.append(li);
              }
            }
          }
          RB.ajax({
            url: RB.routes.backlog_menu,
            data: ajaxdata,
            dataType: 'json',
            success   : function(data,t,x) {
              createMenu(data, menu);
              // Loop through all the <li> elements to see if
              // one of them has a submenu
              menu.find('li').each(function(i, element) {
                if(data[i].sub) {
                  // Add an arrow
                  RB.$(element).append('<div class="icon ui-icon ui-icon-carat-1-e"></div>');
                  // Add a sublist
                  RB.$(element).append('<ul></ul>');
                  createMenu(data[i].sub, RB.$('ul', element));
                }
              });
              var url = window.location.origin + this.url;
              var sprint_id = (new URL(url)).searchParams.get('sprint_id');
              // capture 'click' instead of 'mouseup' so we can preventDefault();
              menu.find('.show_burndown_chart').bind('click', function(ev){ RB.Backlog.showBurndownChart(ev, sprint_id); });
            }
          });
        });
      });
    RB.$('#show_completed_sprints').hide();
  });
});
