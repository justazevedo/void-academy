var circle = 1

setTimeout(
    function() {
        switchT(circle)
    }, 100
)

function buttonClick() {
    const nextButton = document.getElementById("next").textContent;

    if (nextButton == 'Próximo') {
        clickCircle(circle + 1)
    } else if (nextButton == "Fechar") {
        clickCircle('close')
    }
}

function clickCircle(theCircle) {
    if (isNaN(theCircle)) {
        const main = document.getElementById("main");
        main.style.opacity = 0;
        mta.triggerEvent('va.endTutorial');
    } else {
        const oldCircle = document.getElementById(circle);
        oldCircle.classList.remove("selected")
        circle = theCircle
        const newCircle = document.getElementById(circle)
        newCircle.classList.add('selected');
        switchT(circle)
        return
    }
};

tutoriais = [
    [ texto = 'Compras, que tal fazer algumas comprinhas, para abrir o painel de compras basta aperta "F2" e selecionar o item que deseja mas, lembre gaste com moderação.', imagem = "./imagens/compras.png" ],
    [ texto = 'Radinho, nosso radio tem uma cobertura por todo o mapa de San Andreas então que tal combinar uma frequência com seus amigos e trocar uma ideia mas, cuidado com a sua frequência pois qualquer jogador pode entrar nela.', imagem = "./imagens/radio.png" ],
    [ texto = 'Territórios, cuidado ao entrar em um território inimigo. Os inimigos não costumam ser tão amigaveis mais se você tiver coragem e quiser arriscar basta ir em um território e usar /dominar que iniciara uma dominação mais cuidado todo o servidor sera alertado. Dica: Melhor chamar amigos para isso', imagem = "./imagens/dominacoes.png" ],
    [ texto = 'Energetico, que tal correr um pouco mais rapido, nosso energetico está disponivel na loja só não beba muito para não ficar com dor de barriga.', imagem = "./imagens/energetico.png" ],
    [ texto = 'Configurações, para uma experencia sem confusão nossa equipe liberou algumas opções de teclas para você jogador conseguir alterar nas configurações.', imagem = "./imagens/configuracoes.png" ],
]

function switchT(toCircle) {
    if (toCircle >= 6) {
        return console.log('fudeu'), clickCircle()
    } else {
        const text = document.getElementById("text");
        const Image = document.getElementById("image");
        //for(var i = 0; i < tutoriais.length; i ++) {    
            text.innerHTML = tutoriais[toCircle-1][0];
            Image.src = tutoriais[toCircle-1][1];
            console.log(tutoriais[toCircle-1][0])
            console.log(tutoriais[toCircle-1][1])
        //}
    }
    if (toCircle == 5) {
        const nextButton = document.getElementById("next");
        nextButton.innerHTML = "Fechar";
    } else {
        const nextButton = document.getElementById("next");
        nextButton.innerHTML = "Próximo";
    }
}