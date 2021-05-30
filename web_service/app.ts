import {APIGatewayProxyEvent, APIGatewayProxyResult} from "aws-lambda";
import StarService from "./services/starService";
import MakeStarSandwichRequest from "./models/requests/makeStarSandwichRequest";
import mongoose from "mongoose";
import {ErrorResponse} from "./models/responses/errorResponse";
import {GetGeocodedLocationRequest} from "./models/requests/getGeocodedLocationRequest";
import LocationService from "./services/locationService";

const dbURL = process.env.StarSandwichDbURL;
export const geocodeApiKey = process.env.GeocodeApiKey;
let mongooseConnection = null;

const acceptedRoutes = ["makeStarSandwich", "getGeocodedLocation"];

export const lambdaHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
	const route = event.path.split("/")[1];
	if (!acceptedRoutes.includes(route)) {
		return {
			statusCode: 404,
			body: JSON.stringify({message: "Invalid route"} as ErrorResponse)
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
			const request = JSON.parse(event.body) as MakeStarSandwichRequest;
			response = await StarService.makeStarSandwich(request);
		} else if (route === "getGeocodedLocation") {
			const request = JSON.parse(event.body) as GetGeocodedLocationRequest;
			response = await LocationService.getCoordinatesFromLocation(request.address);
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
