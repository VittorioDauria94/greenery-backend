# Greenery Backend

Backend REST API per **Greenery**, un aggregatore sostenibile / e-commerce fittizio dedicato a prodotti eco-friendly selezionati da partner credibili.

Il backend gestisce prodotti, categorie, partner sostenibili e ordini, con calcolo del totale lato server e aggiornamento dello stock prodotti.

## Tecnologie utilizzate

- Node.js
- Express
- MySQL
- mysql2
- CORS
- Multer
- Slugify

## Nome database

```txt
greenery_db
```

## Struttura progetto

```txt
greenery-backend/
├── app.js
├── config/
│   └── db.js
├── controllers/
│   ├── productController.js
│   ├── categoryController.js
│   ├── partnerController.js
│   └── orderController.js
├── routes/
│   ├── productRoutes.js
│   ├── categoryRoutes.js
│   ├── partnerRoutes.js
│   └── orderRoutes.js
├── middlewares/
│   ├── notFound.js
│   └── errorsHandler.js
├── database/
│   └── schema.sql
├── public/
├── .env.example
├── package.json
└── README.md
```

## Funzionalità

- Connessione a database MySQL
- API prodotti
- API categorie
- API partner sostenibili
- Creazione ordini
- Validazione base dei dati ordine
- Controllo prodotti esistenti
- Controllo stock disponibile
- Calcolo totale ordine lato backend
- Creazione righe ordine in `order_items`
- Aggiornamento stock prodotti
- Transazioni MySQL per la creazione ordine
- Middleware per rotte non trovate
- Middleware per gestione errori
- Gestione messaggi di errore diversa tra development e production

## Tabelle principali

```txt
categories
partners
products
orders
order_items
```

## Setup progetto

Installare le dipendenze:

```bash
npm install
```

Creare un file `.env` partendo da `.env.example`.

Esempio `.env`:

```env
NODE_ENV=development

PORT=3000

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=greenery_db
DB_PORT=3306

FRONTEND_URL=http://localhost:5173
```

Avviare il server in development:

```bash
npm run dev
```

Avviare il server in produzione:

```bash
npm start
```

Il server sarà disponibile su:

```txt
http://localhost:3000
```

## Database

Per creare il database e le tabelle, eseguire il file:

```txt
database/schema.sql
```

Da MySQL Workbench:

```txt
File > Open SQL Script
```

Poi selezionare `schema.sql` ed eseguire lo script completo.

Da terminale, se il comando `mysql` è disponibile:

```bash
mysql -u root -p < database/schema.sql
```

## API disponibili

### Health check

```txt
GET /api/health
```

Risposta esempio:

```json
{
  "status": "ok",
  "message": "Greenery backend is running"
}
```

---

## Products

### Lista prodotti

```txt
GET /api/products
```

Restituisce tutti i prodotti con categoria e partner associati.

Query supportate:

```txt
?category=igiene-personale
?search=bamboo
?featured=true
```

Esempi:

```txt
GET /api/products
GET /api/products?category=igiene-personale
GET /api/products?search=bamboo
GET /api/products?featured=true
```

---

### Dettaglio prodotto

```txt
GET /api/products/:slug
```

Esempio:

```txt
GET /api/products/spazzolino-in-bamboo
```

Risposta errore se il prodotto non esiste:

```json
{
  "message": "Product not found"
}
```

---

## Categories

### Lista categorie

```txt
GET /api/categories
```

Restituisce tutte le categorie con il numero di prodotti associati.

---

### Prodotti per categoria

```txt
GET /api/categories/:slug/products
```

Esempio:

```txt
GET /api/categories/igiene-personale/products
```

Risposta errore se la categoria non esiste:

```json
{
  "message": "Category not found"
}
```

---

## Partners

### Lista partner

```txt
GET /api/partners
```

Restituisce tutti i partner sostenibili con il numero di prodotti associati.

---

### Dettaglio partner

```txt
GET /api/partners/:slug
```

Esempio:

```txt
GET /api/partners/bamboolife
```

Restituisce i dati del partner e i prodotti collegati.

Risposta errore se il partner non esiste:

```json
{
  "message": "Partner not found"
}
```

---

## Orders

### Creazione ordine

```txt
POST /api/orders
```

Crea un nuovo ordine.

Esempio body:

```json
{
  "customer_name": "Mario Rossi",
  "customer_email": "mario@email.com",
  "customer_address": "Via Roma 10",
  "customer_city": "Cagliari",
  "customer_phone": "3331234567",
  "items": [
    {
      "product_id": 1,
      "quantity": 2
    },
    {
      "product_id": 5,
      "quantity": 1
    }
  ]
}
```

Risposta esempio:

```json
{
  "message": "Order created successfully",
  "data": {
    "order_id": 1,
    "total_price": 22.88
  }
}
```

Il totale viene calcolato lato backend usando i prezzi presenti nel database.

Il backend controlla anche:

- che i dati obbligatori siano presenti
- che i prodotti esistano
- che la quantità richiesta sia valida
- che lo stock sia sufficiente
- che lo stock venga aggiornato dopo l’ordine

## Gestione errori

In development vengono mostrati dettagli utili per il debug.

In production gli errori interni restituiscono un messaggio generico:

```json
{
  "message": "Internal Server Error"
}
```

Questo evita di esporre dettagli tecnici sensibili.

## Script disponibili

```bash
npm run dev
```

Avvia il server in modalità development con `--watch`.

```bash
npm start
```

Avvia il server normalmente.

## Stato progetto

### Completato

- Setup Express
- Connessione MySQL
- Database schema
- Seed iniziale prodotti, categorie e partner
- API prodotti
- API categorie
- API partner
- API creazione ordine
- Middleware not found
- Middleware error handler
- Gestione errori basata su ambiente

### Da fare

- Upload immagini prodotti con Multer
- Eventuale area admin
- Validazioni più avanzate
- Autenticazione admin
- Deploy backend
