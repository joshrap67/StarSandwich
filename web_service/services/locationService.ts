import LocationRepository from "../repositories/locationRepository";
import {GeocodedLocationResponse} from "../models/responses/geocodedLocationResponse";

export default class LocationService {

	static async getCoordinatesFromLocation(location: string): Promise<GeocodedLocationResponse> {
		return await LocationRepository.getCoordinatesFromLocation(location);
	}
}