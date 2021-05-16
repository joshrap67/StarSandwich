import CoordinateModel from "../coordinateModel";

export interface GeocodedLocationResponse{
	coordinates: CoordinateModel;
	formattedAddress: string;
}