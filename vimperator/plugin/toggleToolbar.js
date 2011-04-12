/**
 * toggleToolbar
 *
 * @author halt feits <halt.feits@gmail.com>
 * @version 0.6.0
 */

(function() {

liberator.commands.addUserCommand(["toggleToolbar"], 'toggleToolbar',
    function ()
    {
      var guioptions = liberator.options.get('guioptions');

      if (guioptions.value == '') {
        guioptions.value = liberator.options.getPref('guioptions');

        var toolbar = document.getElementById("webdeveloper-toolbar");
        if (toolbar) {
            toolbar.collapsed = false;
            //document.persist("webdeveloper-toolbar", "collapsed");
        }

      } else {
        liberator.options.setPref('guioptions', guioptions.value);
        guioptions.value = '';

        var toolbar = document.getElementById("webdeveloper-toolbar");
        if (toolbar) {
            toolbar.collapsed = true;
            //document.persist("webdeveloper-toolbar", "collapsed");
        }

      }

      guioptions.setter(guioptions.value);
    },
    {
        shortHelp:'toggle toolbar'
    }
);

liberator.execute('toggleToolbar');
})();
