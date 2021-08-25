function submitFrequency() {
    var frequencyInput = document.getElementById('frequency').value;
    var buttonJoin = document.getElementById('join');
    if (frequencyInput == "") {
        mta.triggerEvent( 'va.sendFrequency', false );
        return
    }

    if (buttonJoin.innerHTML == 'Sair') {
        buttonJoin.innerHTML = 'Entrar'
    } else {
        buttonJoin.innerHTML = 'Sair'
    }
    mta.triggerEvent( 'va.sendFrequency', frequencyInput );
};

$(document).ready(function() {
    window.addEventListener( 'message', (event) => {
        let item = event.data

        $(".frequency").innerHTML = item.frequency;
    });
});