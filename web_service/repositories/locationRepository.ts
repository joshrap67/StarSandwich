import axios from "axios";
import {GeocodeResponse} from "../models/documents/geocodeResponse";
import {geocodeApiKey} from "../app";
import {GeocodedLocationResponse} from "../models/responses/geocodedLocationResponse";

export default class LocationRepository {

	static BASE_URL = "https://api.geocod.io/v1.6";

	static async getCoordinatesFromLocation(location: string): Promise<GeocodedLocationResponse> {
		// failures will be caught higher up and just returned as a blanket 400
		const rawResponse = await axios.get(`${this.BASE_URL}/geocode`,
			{params: {q: location, api_key: geocodeApiKey}});
		const decoded = rawResponse.data as GeocodeResponse;

		return {
			coordinates: {
				latitude: decoded.results[0].location.lat,
				longitude: decoded.results[0].location.lng
			},
			formattedAddress: decoded.results[0].formatted_address
		};
	}
}