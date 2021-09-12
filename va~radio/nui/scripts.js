function submitFrequency() {
    var frequencyInput = document.getElementById('frequency').value;
    var buttonJoin = document.getElementById('join');
    if (frequencyInput == "") {
        mta.triggerEvent( 'va.sendFrequency', 0 );
        return
    }

    if (buttonJoin.innerHTML == 'Sair') {
        buttonJoin.innerHTML = 'Entrar'
        mta.triggerEvent( 'va.sendFrequency', frequencyInput );
        frequencyInput = "";
    } else {
        mta.triggerEvent( 'va.toggleRadio', frequencyInput );
        mta.triggerEvent( 'va.sendFrequency', frequencyInput );
        buttonJoin.innerHTML = 'Sair'
    }
};

$(document).ready(function() {
    window.addEventListener( 'message', (event) => {
        let item = event.data

        $("#frequency").val(item.frequency)
    });
});