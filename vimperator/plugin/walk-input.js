// Vimperator plugin: 'Walk Input'
// Last Change: 2008-05-22.
// License: BSD
// Version: 1.0
// Maintainer: Takayama Fumihiko <tekezo@pqrs.org>

// ------------------------------------------------------------
// The focus walks <input> & <textarea> elements.
// If you type M-i first, the focus moves to "<input name='search' />".
// Then if you type M-i once more, the focus moves to "<input name='name' />".
//
// <html><body>
//     <input name="search" />
//     <a href="xxx">xxx</a>
//     <a href="yyy">yyy</a>
//     <a href="zzz">zzz</a>
//     <input name="name" />
//     <textarea name="comment" />
//  </body></html>


var walkinput = function(forward) {
    var win = document.commandDispatcher.focusedWindow;
    var d = win.document;
    var xpath = '//input[@type="text" or @type="password" or @type="search" or not(@type)] | //textarea';
    var list = d.evaluate(xpath, d, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    if (list.snapshotLength == 0) return;

    var focused = document.commandDispatcher.focusedElement;
    var current = null;
    var next = null;
    var prev = null;
    for (var i = 0; i < list.snapshotLength; ++i) {
        var e = list.snapshotItem(i);
        if (e == focused) {
            current = e;
        } else if (current && next == null) {
            next = e;
        } else if (current == null) {
            prev = e;
        }
    }
    if (forward == true && next) {
        next.focus();
    } else if (forward == false && prev) {
        prev.focus();
    } else {
        if (forward == true) {
            list.snapshotItem(0).focus();
        } else {
            list.snapshotItem(list.snapshotLength - 1).focus();
        }
    }
};

liberator.mappings.add([liberator.modes.NORMAL], ['<M-i>'], 'Walk Input Fields', function() { walkinput(true); });
liberator.mappings.add([liberator.modes.INSERT], ['<M-i>'], 'Walk Input Fields', function() { walkinput(true); });
liberator.mappings.add([liberator.modes.NORMAL], ['<A-i>'], 'Walk Input Fields', function() { walkinput(true); });
liberator.mappings.add([liberator.modes.INSERT], ['<A-i>'], 'Walk Input Fields', function() { walkinput(true); });
liberator.mappings.add([liberator.modes.NORMAL], ['<M-I>'], 'Walk Input Fields', function() { walkinput(false); });
liberator.mappings.add([liberator.modes.INSERT], ['<M-I>'], 'Walk Input Fields', function() { walkinput(false); });
liberator.mappings.add([liberator.modes.NORMAL], ['<A-I>'], 'Walk Input Fields', function() { walkinput(false); });
liberator.mappings.add([liberator.modes.INSERT], ['<A-I>'], 'Walk Input Fields', function() { walkinput(false); });
