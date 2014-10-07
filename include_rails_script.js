jQuery(function() {
  window.$this = new (App.#{ controller_path.split(/\/|_/).map(&:capitalize).join('') } || App.Base)();
  if (typeof $this.#{ action_name } === 'function') {
    return $this.#{ action_name }.call();
  }
});

jQuery(document).on('page:before-change', function() {
  var element, handler, handlers, type, _i, _len, _ref, _results;
  _ref = [window, document];
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    element = _ref[_i];
    _results.push((function() {
      var _ref2, _results2;
      _ref2 = jQuery._data(element, 'events');
      _results2 = [];
      for (type in _ref2) {
        handlers = _ref2[type];
        _results2.push((function() {
          var _j, _len2, _results3;
          _results3 = [];
          for (_j = 0, _len2 = handlers.length; _j < _len2; _j++) {
            handler = handlers[_j];
            if (handler == null) {
              continue;
            }
            _results3.push(handler.namespace === '' ? $(element).off(type, handler.handler) : void 0);
          }
          return _results3;
        })());
      }
      return _results2;
    })());
  }
  return _results;
});