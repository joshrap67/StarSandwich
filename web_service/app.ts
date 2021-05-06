import {APIGatewayProxyEvent, APIGatewayProxyResult} from "aws-lambda";
import StarService from "./services/starService";
import MakeStarSandwichModel from "./models/requests/makeStarSandwichModel";

sandwich();

async function sandwich() {
	const starService = new StarService();
	const result = await starService.makeStarSandwich({
		coordinates: {
			latitude: -10.39725,
			longitude: 14.43625
		}
	});
	console.log(result);
}

export const lambdaHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
	const route = event.path;
	let response = null;
	try {
		if (route === "makeStarSandwich") {
			const starService = new StarService();
			const request = JSON.parse(event.body) as MakeStarSandwichModel;
			response = await starService.makeStarSandwich(request);
		}

		return {
			statusCode: 200,
			body: JSON.stringify(response)
		};
	} catch (e) {
		return {
			statusCode: 400,
			body: JSON.stringify(response) // todo handle errors
		};
	}

};
