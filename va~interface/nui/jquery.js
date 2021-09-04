$(document).ready(function() {

    window.addEventListener( "message", (event) => {
        const hud = event.data
        $(".healthBox").css("width", hud.health + "%");
		$(".armorBox").css("width", hud.armour + "%");
        $('.energyBox').css("width", hud.energy + "%")
        $(".moneyBox").text(hud.money);
        $(".container").css("opacity", hud.opacity);
        $(".logo").css("opacity", hud.opacity);
        $('.ammo').html(hud.ammo + "/∞")
        $('.money').html('V$' + hud.money + ',00')

        if (hud.ammo == false) {
            $('.ammo').css('display', 'none');
        } else {
            $('.ammo').css('display', 'block');
        }
        
        if (hud.energy == false) {
            $('.energy').css('display', 'none');
        } else {
            $('.energy').css('display', 'block');
        }

        if (hud.health == 0) {
            $(".death").css("display", "inline-block");
            $(".healthImg").css("display", "none");
        } else {
            $(".death").css("display", "none");
            $(".healthImg").css("display", "inline-block");
        }

        if (hud.health <= 14) {
            $(".healthBox").css("background-color", "rgba(187, 0, 0, 0.753)");
            $(".healthBox").addClass("healthLow");
        } else {
            $(".healthBox").css("background-color", "rgba(255, 145, 0, 0.753)");
            $(".healthBox").removeClass("healthLow");
        }
        
        if (hud.armour == 0) {
            $(".armor").css("opacity", 0)
            setTimeout( function() {
                $('.energy').css('marginLeft', '0%');
                $(".armor").css("display", "none")
            }, 300 )
        } else {
            $(".armor").css("display", "inline-block")
            setTimeout( function() {
                $('.energy').css('marginLeft', '-2%');
                $(".armor").css("opacity", 1)
            }, 300 )
        }
    });

});