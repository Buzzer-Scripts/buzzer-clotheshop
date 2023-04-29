
const FiveM = {
  eventHandler : {},
  send : function (action, data, callback) {
    "use strict";
    action= action || ""
    data = data || {};
    callback = callback || function() {}
    GetParentResourceName = GetParentResourceName || function() {return "localhost"}
    $.post(`http://${GetParentResourceName()}/${action}`, JSON.stringify(data), (d) => callback(d));
  }, 
  get: function (action, callback)  {
    "use strict";
    
    if (!this.eventHandler[action]) this.eventHandler[action] = []
    this.eventHandler[action].push(callback)
  },
  trigger: function(action, data) {
    "use strict";
    data = data || {}
    data.action = action
    if (FiveM.eventHandler[action]) 
      for (let i = 0; i <  FiveM.eventHandler[action].length; i++) 
      try { 
        FiveM.eventHandler[action][i](data);
      }
      catch(err) {
        console.log(`Event Handler Error (${action}): err`)
      }
  }
  
}



$(document).ready(() => {
  window.addEventListener("message", function(event) {
    let data = event.data
    let action = data.action
    FiveM.trigger(action, data)
  })  
});


