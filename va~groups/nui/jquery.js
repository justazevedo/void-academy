$(document).ready( function( ) {
    window.addEventListener('message', ( event ) =>  {
        const item = event.data

        addGroup( item.id, item.name )
        groups()
    });
});

gangs = []

const addGroup = (id, name) => {
    gangs.push( { id : id, name : name } )
}

const groups = () => {
    let i = 0;
    const nameList = gangs.sort( ( a, b ) => ( a.id > b.id ) ? 1: -1 );
    $('.groups').html( `
    ${ nameList.map(( gangs ) => (`<div id="group" class="group ${gangs.name}">
        <div class="players">0/20</div>
        <button onclick='enterSkin( ${gangs.id}, "${gangs.name}" )' class="joingroup">Entrar</button>
    </div>`)).join('')}
    `);
};

var gangsID = 0
var skinSelected = 0

const enterSkin = ( id, name ) => {
    gangsID = id
    const groupsMenu = document.getElementById('groups');
    const skinMenu = document.getElementById('skins');
    const textSkin = document.getElementById('textSkin');

    textSkin.innerHTML = name.replace("_", " ");
    document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow: hidden; overflow-x: hidden; background: transparent !important;';
    groupsMenu.style.marginTop = "200%";
    setTimeout( () => {
        groupsMenu.style.display = "none";
        skinMenu.style.display = "block";
        skinMenu.style.marginTop = "10%"
        document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow: auto; overflow-x: hidden; background: transparent !important;';
    }, 1000 );
};

const backSkin = () => {
    gangsID = 0
    skinSelected = 0
    const groupsMenu = document.getElementById('groups');
    const skinMenu = document.getElementById('skins');

    skinMenu.style.marginTop = "200%";
    document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow: hidden; overflow-x: hidden; background: transparent !important;';
    setTimeout( () => {
        skinMenu.style.display = "none";
        groupsMenu.style.display = "grid";
        groupsMenu.style.marginTop = "10%"
        document.getElementsByTagName('body')[0].style = 'margin: auto; padding: auto; overflow: auto; overflow-x: hidden; background: transparent !important;';
    }, 1000 );
};

const setSkin = ( id ) => {
    skinSelected = id
    mta.triggerEvent( 'va.setSkin', gangsID, id )
}

const selectedSkin = () => {
    mta.triggerEvent( 'va.selectedSkin', gangsID, skinSelected )
}