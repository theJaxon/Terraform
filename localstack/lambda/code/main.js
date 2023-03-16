module.exports.handler = async (event, context) => {
	return {
		statusCode: 200,
		headers: { "Content-Type": "text/html", },
		body: "Hello world!",
	}
};