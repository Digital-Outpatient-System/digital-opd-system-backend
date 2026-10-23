# Express route example

Import a controller and assign its handler to an Express route:

```js
const express = require('express');
const opdController = require('../controllers/opdController');

const router = express.Router();

router.get('/appointments', opdController.getAppointments);

module.exports = router;
```
