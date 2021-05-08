import {APIGatewayProxyEvent, APIGatewayProxyResult} from "aws-lambda";
import StarService from "./services/starService";
import MakeStarSandwichModel from "./models/requests/makeStarSandwichModel";
import mongoose from "mongoose";
import {ErrorResponse} from "./models/responses/errorResponse";

const dbURL = process.env.StarSandwichDbURL;
let mongooseConnection = null;

const acceptedActions = ["makeStarSandwich"];

export const lambdaHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
	const route = event.path.split("/")[1];
	if (!acceptedActions.includes(route)) {
		return {
			statusCode: 404,
			body: JSON.stringify({
				message: "Invalid route"
			})
		};
	}
	let response = null;
	if (mongooseConnection == null) {
		mongooseConnection = mongoose.connect(dbURL, {
			bufferCommands: false,
			bufferMaxEntries: 0,
			useNewUrlParser: true,
			useUnifiedTopology: true
		});
		await mongooseConnection;
	}

	try {
		if (route === "makeStarSandwich") {
			const request = JSON.parse(event.body) as MakeStarSandwichModel;
			response = await StarService.makeStarSandwich(request);
		}

		return {
			statusCode: 200,
			body: JSON.stringify(response)
		};
	} catch (e) {
		console.log(e);
		return {
			statusCode: 400,
			body: JSON.stringify({message: e.message} as ErrorResponse)
		};
	}
}
