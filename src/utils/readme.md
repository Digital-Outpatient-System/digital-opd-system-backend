## Standardized JSON responses

Use shared helpers in route handlers so every API response follows the same shape.

```js
const sendSuccess = (res, {
	message = 'Success',
	data = null,
	statusCode = 200,
} = {}) =>
	res.status(statusCode).json({
		success: true,
		message,
		data,
	});

const sendError = (res, {
	message = 'Internal server error',
	errors = null,
	statusCode = 500,
} = {}) =>
	res.status(statusCode).json({
		success: false,
		message,
		errors,
	});

module.exports = { sendSuccess, sendError };
```

Place these helpers in a JavaScript utility module and import them in controllers:

```js
sendSuccess(res, {
	message: 'Patient retrieved successfully',
	data: patient,
});

sendError(res, {
	message: 'Patient not found',
	statusCode: 404,
});
```

Success responses use `{ success, message, data }`; errors use `{ success, message, errors }`.
Do not return stack traces or other internal exception details to clients.
