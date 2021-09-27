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
        $('.radio').html(hud.frequency + '.0MHz')

        if (hud.voice == "Gritando") {
            $('.voz').html('Gritando');
            $('.microphone').css('color','rgb(255, 49, 49)')
        } else if (hud.voice == "Falando") {
            $('.voz').html('Falando');
            $('.microphone').css('color','rgb(0, 199, 0)');
        } else if (hud.voice == "Susurrando") {
            $('.voz').html('Susurrando');
            $('.microphone').css('color','rgb(255, 152, 17)');
        }
        
        if (hud.talking) {
            $('.voz').addClass('speaking');
        } else {
            $('.voz').removeClass('speaking');
        }

        if (hud.talkingRadio) {
            $('.radio').addClass('speaking');
        } else {
            $('.radio').removeClass('speaking');
        }

        if (hud.frequency == false) {
            $('.radio').css('display', 'none');
            $('.space').css('display', 'none');
        } else {
            $('.radio').css('display', 'inline-block');
            $('.space').css('display', 'inline-block');
        }

        if (hud.ammo == false) {
            $('.ammo').css('display', 'none');
        } else {
            $('.ammo').css('display', 'block');
        }
        
        if (hud.energy == false) {
            $(".energy").css("opacity", 0)
            setTimeout( function() {
                $('.armor').css('marginLeft', '25%');
                $('.energy').css('display', 'none');
            }, 300 )
        } else {
            $('.energy').css('display', 'inline-block');
            $('.armor').css('marginLeft', '2%');
            setTimeout( function() {
                $(".energy").css("opacity", 1)
            }, 300 )
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
            $('.energy').css('marginLeft', '25%');
            setTimeout( function() {
                $(".armor").css("display", "none")
            }, 300 )
        } else {
            $(".armor").css("display", "inline-block")
            setTimeout( function() {
                $('.energy').css('marginLeft', '0%');
                $(".armor").css("opacity", 1)
            }, 300 )
        }
    });

});