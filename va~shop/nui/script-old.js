$(document).ready( function( ) {
    window.addEventListener('message', ( event ) =>  {
        const item = event.data
        if (item.close == false) {
            addItems( item.name, item.description, item.price, item.itemImg, item.itemID )
            items()
        } else {
            close()
        };
    });
});

itens = []

const addItems = ( name, description, price, itemImg, itemID ) => {
    itens.push( { id : itens.length + 1, name : name, description : description, price : price, itemImg : itemImg, itemID : itemID } )
}

const items = () => {
    const itemList = itens.sort( ( a, b ) => ( a.id > b.id ) ? 1: -1 );
    $('.shop').html( `
    ${ itemList.map(( item ) => (`<div class="theItem">
        <img src="http://mta/va~inventory/files/items/${item.itemImg}.png" alt="Item Image" class="item">
        <div class="name">${item.name}</div>
        <div class="price">V$${item.price},00</div>
        <div class="description">${item.description}</div>
        <input type="text" style="text-align:center;" maxlength="3" onkeypress="return event.charCode >= 48 && event.charCode <= 57" id="${item.itemID}" class="amount" placeholder="Quantidade">
        <button onclick="buyItem( ${item.itemID}, ${item.price} )" class="buy">COMPRAR</button>
    </div>`)).join('')}
    `);
}

const close = () => {
    document.location.reload(true);
}

const buyItem = ( itemID, itemPrice ) => {
    const amount = document.getElementById(itemID).value;
    mta.triggerEvent( 'va.requestBuy', itemID, itemPrice * amount, amount );
}