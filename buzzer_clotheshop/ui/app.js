var componentData = [];
var group = "";
var component = "";
var value_1 = 0;
var value_2 = 0;
$("document").ready(function() {

    $("#container").hide();
    $("body").show();

    FiveM.get("show", function (data) {
        $("#container").fadeIn(200);
        $("._slot").eq(0).click()
    });

    FiveM.get("hide", function (data) {
        $("#container").fadeOut(200);
    });

    $("body").on("keyup", function (event) {
        if (event.which == 27) {
          FiveM.send("close");
        };
    });


    FiveM.get("set_component_data", function (data) {
        componentData = data.data
        group = data.group
        component = data.component
        for (let value_1 in componentData) {
            for (let value_2 in componentData[value_1]) {
                SelectComponent(value_1, value_2)
                break
            }
            break
        }
    });

    FiveM.get("set_price", function (data) {
        $(".footer").find("#price").html(MoneyFormat(data.price))
    });

    $("._center").on("click", "#prev", function (event) {
        SelectComponent(parseInt(value_1) - 1, value_2)
    })


    $("._center").on("click", "#next", function (event) {
        SelectComponent(parseInt(value_1) + 1, value_2)
    })

    $(".footer").on("click", "#prev", function (event) {
        SelectComponent(value_1, parseInt(value_2) - 1)
    })

    $(".footer").on("click", "#next", function (event) {
        SelectComponent(value_1, parseInt(value_2) + 1)
    })

    $(".footer").on("click", "#buy", function (event) {
        FiveM.send("buy_component", {group : group, component : component, value_1 : value_1, value_2 : value_2})
    })

    $("._slot").on("click", function (event) {
        let component = $(this).attr("id")
        if (component) {
            $("._slot").removeClass("active")
            $(this).addClass("active")
            FiveM.send("request_component", { component : component})
            FiveM.send("set_cam", { focus : $(this).data("focus")})
        }

    })

    $(document).keydown(function(event){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '37') {
            FiveM.send("rot_cam", {rot_z : -2});
            FiveM.send("play_sound", {sound : "panelbuttonclick"});
        };
        if (keycode == '39') {
            FiveM.send("rot_cam", {rot_z : 2});
            FiveM.send("play_sound", {sound : "panelbuttonclick"});
        };
    });

})

function SelectComponent(v1, v2) {
    if (!componentData[`${v1}`] || !componentData[`${v1}`][`${v2}`]) return; 
    value_1 = v1 
    value_2 = v2
    let data = componentData[`${value_1}`][`${value_2}`]
    
    $(".footer").find("#index").html(value_2)
    $(".footer").find("#label").html(data.Localized)
    FiveM.send("set_component", { group : group, component : component, value_1 : value_1, value_2 : value_2})
}
MoneyFormat =  function(number, n, x) {
    var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\,' : '$') + ')';
    return  "$ " + parseFloat(number).toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&.');
};
