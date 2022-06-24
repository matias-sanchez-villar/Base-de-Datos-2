use sales

/*
**  Recuperar informacion de la tabla de sales
**  1-A)  Filtrar las storeLocation de "San Diego"
**  
**  1-B)  Mostrar los siguientes datos:

            * saleDate

            * items

            * storeLocation

            * customer

            * purchaseMethod
**  
**  1-C)  Ocultar el campo _id
**  
**  1-D)  Ordenar en forma ascendente por metodo de compra
*/
db.sales.find(
    {
        storeLocation:"San Diego"
    },
    {
        _id: 0,
        saleDate:1,
        items: 1,
        storeLocation: 1,
        customer: 1,
        purchaseMethod: 1
    }).sort({
        purchaseMethod: 1
    })


/*
**  Recuperar informacion de la tabla de sales
**  2-A)  Filtrar las storeLocation de "New York", "London" y "Denver"
**  
**  2-B)  Filtrar registros completos que contengan los items de "/backpack/" o "/laptop/" para toda la compra.
**  
**  2-C) Mostrar los siguientes datos:

        * saleDate

        * items

        * storeLocation

        * customer

        * purchaseMethod
**  
**  2-D) Ocultar el campo _id
** 
**  2-E) Ordenar en forma descendente por fecha de venta
*/
db.sales.find(
    {
        storeLocation: { $in: ["New York", "London", "Denver"] },
        "items.name": {
            $in : [/backpack/, /laptop/]
        }
    },
    {
        _id: 0,
        saleDate:1,
        items: 1,
        storeLocation: 1,
        customer: 1,
        purchaseMethod: 1
    }).sort({
        saleDate: -1
    })


/*
**  Recuperar informacion de la tabla de sales
**  3-A)  Filtrar customer

        * En un rango de 20 a 30 años

        * Que hayan indicado en la "satisfaction", un puntaje menor a 3

        * De sexo masculino
**  
**  3-B) Que hayan usado cupones de descuento.
**  
**  3-C) Mostrar los siguientes datos:

        * saleDate

        * items (solo los atributos "name" y "tags")

        * storeLocation

        * customer

        * purchaseMethod

        * couponUsed
**  
**  3-D) Ocultar el campo _id
**  
**  3-E) Ordenar en forma descendente por fecha de venta
*/
db.sales.find(
    {
        "customer.age" : { $lt: 30, $gt: 20 },
        "customer.satisfaction" : { $lt: 3 },
        "customer.gender" :  'M',
        couponUsed: true
    },
    {
        _id: 0,
        saleDate:1,
        items: {
            name: 1,
            tags: 1
        },
        storeLocation: 1,
        customer: 1,
        purchaseMethod: 1,
        couponUsed: 1
    }).sort({
        saleDate: -1
    })


/*
**  Recuperar informacion de la tabla de sales
**  4-A) Filtrar las ciudades de London o New York
**  
**  4-B) Recuperar solo las 10 ventas con mejor satisfaccion del customer
**  
**  4-C) Mostrar los siguientes datos:

        * saleDate

        * items (solo los atributos "name" y "tags")

        * storeLocation

        * customer

        * purchaseMethod

        * couponUsed
**  
**  4-D) Ocultar el campo _id
*/
db.sales.find(
    {
        $or : [
            { storeLocation: "London" },
            { storeLocation: "New York" }
        ]
    },
    {
        _id: 0,
        saleDate: 1,
        items: {
            name: 1,
            tags: 1
        },
        storeLocation: 1,
        customer: 1,
        purchaseMethod: 1,
        couponUsed: 1
    }).sort({
        "customer.satisfaction": -1
    }).limit(10)

/*
**  Recuperar informacion de la tabla de sales
**  5-A) Filtrar las ciudades de London o Austin
**
**  5-B) Filtrar registros completos que NO contengan items de "/envelopes/" para la compra.
**
**  5-C) Filtrar a compradoras com metodo de compra "In store".
**
**  5-D). Mostrar los siguientes datos:

        * saleDate

        * items (solo los atributos "name" y "tags")

        * storeLocation

        * customer

        * purchaseMethod

        * couponUsed
**
**  5-E) Ocultar el campo _id
**
**  5-F) Ordenar por satisfaccion del cliente en forma descenciente
**
*/
db.sales.find(
    {
        $or : [
            { storeLocation: "London" },
            { storeLocation: "Austin" }
        ],
        "items.name":{
            $nin : [/envelopes/]
        },
        "purchaseMethod": "In store"
    },
    {
        _id: 0,
        saleDate: 1,
        items: {
            name: 1,
            tags: 1
        },
        storeLocation: 1,
        customer: 1,
        purchaseMethod: 1,
        couponUsed: 1
    }
).sort({
    "customer.satisfaction": -1
})
